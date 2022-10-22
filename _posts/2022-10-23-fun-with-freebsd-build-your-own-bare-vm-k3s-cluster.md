---
layout: post
title: 'Fun with FreeBSD: Build Your Own Bare-VM k3s Cluster'
date: 
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- FreeBSD Virtualization
tags:
- freebsd
- kubernetes
- tutorial
- virtualization
- linux
meta:
permalink: ""
excerpt: Step-by-step tutorial for deploying a Kubernetes cluster with k3s on FreeBSD bhyve VMs
---

_Step-by-step tutorial for deploying a Kubernetes cluster with k3s on FreeBSD bhyve VMs_

*Note* this is an updated version of [this original k3s tutorial](http://productionwithscissors.run/2020/12/26/adventures-in-freebernetes-tutorial-build-your-own-bare-vm-k3s-cluster/)

[See all posts in the FreeBSD Virtualization Series](/freebsd-virtualization-series/)

1. [Overview](#overview)

* [Intended Audience](#intended-audience)
* [Technical Specs](#technical-specs)
   * [Kubernetes Cluster Specs](#kubernetes-cluster-specs)
   * [Host Requirements](#host-requirements)
   * [My Test System](#my-test-system)
* [Part 1: Required Tools](#part-1)
* [Part 2: Building k3sup](#part-2)
* [Part 3: Creating VMs](#part-3)
* [Part 4: Configure Networking](#part-4)
* [Part 5: Create the Cluster](#part-5)
* [Part 6: Test the Cluster](#part-6)
* [Part 7: Clean Up](#part-7)
* [Sources / References](#sources-references)

## Overview

This tutorial will build a Kubernetes cluster on FreeBSD's `bhyve`
virtualization platform, by installing a lightweight `k3s` control plane
using the [`k3sup`](https://github.com/alexellis/k3sup) tool, which automates
much of the process.

Topics covered:

* Compiling `k3sup` on FreeBSD
* Configuring CBSD to create and manage `bhyve` VMs
* Running `k3sup` to bring up a `k3s` cluster on `bhyve` VMs
* Configuring the FreeBSD firewall, DNS, and routing for cluster networking

While this tutorial builds a cluster with a redundant control plane, all the VMs are on a single hypervisor, making it suitable for testing and experimentation, but it is not production grade.

This tutorial only covers creating a cluster. For Kubernetes basics and terminology, you should start with the [official Kubernetes documentation](https://kubernetes.io/).

### Intended Audience

For this tutorial, you don't need to know anything about Kubernetes. You do need to have a host with FreeBSD installed; an understanding of basic FreeBSD system administration tasks, such as installing software from FreeBSD ports or packages, and loading kernel modules; and familiarity with `csh` or `sh`. Experience with FreeBSD `bhyve` virtual machines and the CBSD interface is useful but not required.

## Technical Specs

### Kubernetes Cluster Specs

We will use these targets for the Kubernetes cluster we're building. Most of these settings can be adjusted.

* Control plane ("K3s servers")
  * 3 VMs: 2 CPU cores, 2Gb RAM, 20Gb virtual disk each
  * If you plan on creating more than 10 worker nodes, increase the control plane VM sizes
* Worker nodes ("K3s agents")
  * 3 VMs: 2 CPU cores, 2Gb RAM, 10Gb virtual disk each
* VM OS: Ubuntu Server 22.04
* Kubernetes version: 124.
* Control plane backing database: embedded `etcd`
  * K3s also supports using an external datastore, such as MySQL

<a id="host-requirements"/>
### Host (FreeBSD Hypervisor) Requirements

* Hardware, physical or virtual
  * CPU
    * CPUs must support FreeBSD bhyve virtualization (see [the FreeBSD Handbook page on bhyve](https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html) for compatible CPUs)
    * CPU core allocations for `bhyve` VMs are completely virtual, so you can have VMs running with a total virtual core count greater than your host system's. You should use the suggested core count for VMs, as Kubernetes will use those for scheduling. You can increase the cores if you have a larger host.

  * RAM: Minimum 2Gb per VM. You can use less for the agent VMs if necessary.

  * Free disk space: 100Gb
* Operating system
  * FreeBSD: tested on 13.1-CURRENT
  * File system: ZFS


<a id="part-1"/>
## Part 1: Required Tools

We're going to install the tools needed on the FreeBSD hypervisor. [You can compile from the](https://www.freebsd.org/doc/handbook/ports.html)[`ports`](https://www.freebsd.org/doc/handbook/ports.html)[tree or install from packages](https://www.freebsd.org/doc/handbook/ports.html), whichever you prefer. The tutorial assumes you have already installed all these ports. When additional post-installation configuration is required, we will walk through it at the appropriate point in the tutorial.

We need to build `k3sup` locally, so this list includes the build tools for compiling from source.

Here is the full list of required packages, including the versions, with the `ports` section in parentheses:

* Build tools
  * `git` (`devel`)
  * `go` (`lang`)
* K8s tools
  * `kubectl` (`sysutils`)
* FreeBSD system tools
  * `CBSD` (`sysutils`)
  * `nsd` (`dns`)
* Misc tools
  * `wget` (`ftp`)

If you want to use the `pkg` system, you can run `pkg install git go kubectl cbsd nsd wget`

<a id="part-2"/>
## Part 2: Build k3sup

* [2.1 Setup Your Go Environment](#2-1)
* [2.2 Check Out and Build k3sup](#2-2)

We'll need to build `k3sup` for our FreeBSD hypervisor.

<a id="2-1"/>
### 2.1 Setup Your Go Environment

If you already have a working `golang` build environment on your FreeBSD hypervisor, you can skip this section.

First, create your `go` workspace. This tutorial will assume you are using the path `${HOME}/go`.

```shell
export GOPATH="${HOME}/go"
mkdir -p $GOPATH ${GOPATH}/bin ${GOPATH}/pkg ${GOPATH}/src ${GOPATH}/src/k8s.io ${GOPATH}/src/github.com
```


<a id="2-2"/>
### 2.2 Check Out and Build k3sup

```shell
cd $GOPATH/src/github.com
git clone https://github.com/alexellis/k3sup/
cd k3sup
git checkout 0.12.8
go build -ldflags="-X github.com/alexellis/k3sup/cmd.Version=0.12.8"
```

You should copy this `k3sup` binary somewhere in your `PATH`.


<a id="part-3"/>
## Part 3: Configure Networking

* [3.1 Choose Your Network Layout](#3-1)
* [3.2 Load Kernel Modules](#3-2)
* [3.3 Add Bridge Gateways](#3-3)
* [3.4 Configure NAT Gateway](#3-4)
* [3.5 Configure Local DNS](#3-5)

<a id="3-1"/>
### 3.1 Choose Your Network Layout

#### 3.1.1 Select Subnets

I'm going to use a VLAN in 10.0.0.0/8 for the cluster and its pods and
services. You can use another block, but you will have to adjust commands
throughout the tutorial.

* 10.0.0.1/32 - VLAN gateway on bridge interface
* 10.0.10.0/24 - VM block
  * 10.0.10.1[1-3] - K3s servers
  * 10.0.10.2[1-3] - K3s agents (nodes)
* 10.1.0.0/16 - pod network
* 10.2.0.0/16 - service network

#### 3.1.2 Pick a `.local` Zone for DNS

This zone just needs to resolve locally on the FreeBSD host. I'm going with `k3s.local` because I'm too lazy to think of a clever pun right now.
You cannot connect to the new VMs yet. CBSD creates a `bridge` interface the first time you create a VM. We need to add gateways for our cluster VLANs to that interface so we can route from the hypervisor to the VMs and vice versa. In most cases, CBSD will use the `bridge1` interface.

<a id="3.2"/>
#### 3.2 Load kernel modules

We need to load the virtualization and networking kernel modules. The `sysrc`
command adds the entries to `/etc/rc.conf` so the modules will get loaded at
boot time.

```shell
sysrc kld_list+="vmm if_tuntap if_bridge nmdm"
service kld restart
```

<a id="3.3"/>
### 3.3 Add Bridge Gateway

CBSD creates and uses the `bridge1` network interface for connecting to the
VM network. We will pre-create it and configure it to route our selected
subnets.


```shell
ifconfig bridge1
ifconfig bridge1 alias 10.0.0.1/32
ifconfig bridge1 alias 10.0.10.1/24
ifconfig bridge1 alias 10.1.0.1/16
ifconfig bridge1 alias 10.2.0.1/16
```

For persistence across reboots:

```shell
sysrc cloned_interfaces="bridge1"
sysrc ifconfig_bridge1="up"
sysrc ifconfig_bridge1_alias0="inet 10.0.0.1/32"
sysrc ifconfig_bridge1_alias1="inet 10.0.10.1/24"
sysrc ifconfig_bridge1_alias2="inet 10.1.0.1/16"
sysrc ifconfig_bridge1_alias3="inet 10.2.0.1/16"
```

<a id="3-4"/>
### 3.4 Configure NAT Gateway

We can reach our VMs just fine from the host, but the VMs can't talk to the
Internet because only the FreeBSD host can route to this `10.0.0.0/8` block.
We will use [`ipfw`](https://docs.freebsd.org/en/books/handbook/firewalls/#firewalls-ipfw) as a NAT (Network Address Translation) gateway service. These
steps will enable `pf` with open firewall rules and then configure the NAT.
These changes will take effect immediately.


```shell
# Set internet-facing interface
net_if=wlan0
kenv net.inet.ip.fw.default_to_accept=1
sysrc firewall_type="open"
sysctl net.inet.tcp.tso=0
sysctl net.inet.ip.fw.enable=1
sysctl net.inet.ip.forwarding=1
sysctl net.inet6.ip6.forwarding=1
sysctl net.inet.tcp.tso=0
kldload ipfw_nat ipdivert
service ipfw onestart
ipfw disable one_pass
ipfw -q nat 1 config if "$net_if" same_ports unreg_only reset
ipfw add 1 allow ip from any to any via lo0 
ipfw add 200 reass all from any to any in
ipfw add 201 check-state
ipfw add 205 nat 1 ip from 10.0.0.0/8 to any out via "$net_if" 
ipfw add 210 nat 1 ip from any to any in via "$net_if"
```

For persistence:

```shell
echo net.inet.ip.fw.default_to_accept=1 >> /boot/loader.conf
echo net.inet.tcp.tso="0" >> /etc/sysctl.conf
echo net.inet.ip.fw.enable=1 >> /etc/sysctl.conf
echo net.inet.ip.forwarding=1 >> /etc/sysctl.conf
echo net.inet6.ip6.forwarding=1 >> /etc/sysctl.conf
sysrc firewall_enable="YES"
sysrc firewall_nat_enable="YES"
sysrc gateway_enable="YES"
sysrc kld_list+="ipfw_nat ipdivert"
echo net.inet.tcp.tso="0" >> /etc/sysctl.conf
```

<a id="3-5"/>
### 3.5 Configure Local DNS

We need a way to resolve our VM host names. We need to pick a private `.local` DNS domain, configure an authoritative server for the domain, and then set up a local caching server that knows about our domain but can also still resolve external addresses for us. We will follow [this `nsd`/`unbound` tutorial](https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html) closely.

#### 3.5.1 Enable `unbound` for recursive/caching DNS

FreeBSD has a caching (lookup-only) DNS service called `unbound` in the base system. It will use the configured nameservers for external address lookups and the local `nsd` service (configured next) for lookups to our private zone. Copy `unbound.conf` and make any edits as necessary to IP addresses or your local zone name.

You will also want to update the FreeBSD host's `/etc/resolv.conf` to add your local domain to the `search` list and add an entry for `nameserver 127.0.0.1`.

```shell
wget https://raw.githubusercontent.com/kbruner/freebernetes/main/k3s/dns/unbound/unbound.conf -O /etc/unbound/unbound.conf
sysrc local_unbound_enable="YES"
service local_unbound onestart
```

`/etc/resolve.conf`:

```
search k3s.local
nameserver 127.0.0.1
```

#### 3.5.2 Configure the Authoritative DNS Service

We will use `nsd`, a lightweight, authoritative-only service, for our local zone. After copying the files, you can edit/rename the copied files before proceeding to make changes as necessary to match your local domain or IP addresses.

```shell
mkdir -p /var/nsd/var/db/nsd /var/nsd/var/run /var/nsd/var/log /var/nsd/tmp
chown -R nsd:nsd /var/nsd
cd /var/nsd
wget -q https://raw.githubusercontent.com/kbruner/freebernetes/main/k3s/dns/nsd/nsd.conf
wget -q https://raw.githubusercontent.com/kbruner/freebernetes/main/k3s/dns/nsd/zone.10
wget -q https://raw.githubusercontent.com/kbruner/freebernetes/main/k3s/dns/nsd/zone.k3s.local
nsd-control-setup -d /var/nsd
nsd-control -c /var/nsd/nsd.conf start
```

To start the service at boot:

```shell
sysrc nsd_enable="YES"
sysrc nsd_config="/var/nsd/nsd.conf"
```


<a id="part-4"/>
## Part 4: Create VMs

#### 4.1 Initialize CBSD

If you haven't run [CBSD](https://cbsd.io/) on your FreeBSD host before, you will need to set it up. You can use [this seed file](https://github.com/kbruner/freebernetes/blob/main/k3s/cbsd/initenv.conf). Edit it first to set `node_name` to your FreeBSD host's name and to change `jnameserver` and `nodeippool` if you are using a private network other than `10.0.0.0/8`.

```shell
sysrc cbsd_workdir="/usr/cbsd"
wget https://raw.githubusercontent.com/kbruner/freebernetes/main/k3s/cbsd/initenv.conf
vi initenv.conf
/usr/local/cbsd/sudoexec/initenv inter=0 `pwd`/initenv.conf
service cbsdrsyncd stop
sysrc -x cbsdrsyncd_enable
sysrc -x cbsdrsyncd_flags
```


#### 4.2 Create VMs

Copy [this `instance.jconf` VM template file](https://github.com/kbruner/freebernetes/blob/main/k3s/cbsd/instance.jconf) and update `ci_gw4`, `ci_nameserver_search`, and `ci_nameserver_address` fields as needed. If you want to set a password for the `ubuntu` user in case you want to log in on the console via VNC, you can assign it to `cw_user_pw_user`, but note this is a plain-text field.

When you run `cbsd bcreate`, if CBSD does not have a copy of the installation ISO image, it will prompt you asking to download it. After the first time, it will re-use the local image.

```shell
# create server VMs
for i in 0 1 2; do
  jconf="/tmp/server-${i}.jconf"
  cp instance.jconf "$jconf"
  cbsd bcreate jconf="$jconf" jname="server-$i" \
  ci_ip4_addr="10.0.10.1${i}/24" ci_jname="server-$i" \
  ci_fqdn="server-${i}.k3s.local" ip_addr="10.0.10.1${i}" \
  imgsize="20g" vm_cpus="2" vm_ram="2g"
done
# start server VMs
for i in 0 1 2; do cbsd bstart jname="server-$i"; done
# create agent VMs
for i in 0 1 2; do
  jconf="/tmp/agent-${i}.jconf"
  cp instance.jconf "$jconf"
  cbsd bcreate jconf="$jconf" jname="agent-$i" \
  ci_ip4_addr="10.0.10.2${i}/24" ci_jname="agent-$i" \
  ci_fqdn="agent-${i}.k3s.local" ip_addr="10.0.10.2${i}" \
  imgsize="10g" vm_cpus="2" vm_ram="2g"
done
# start agent VMs
for i in 0 1 2; do cbsd bstart jname="agent-$i"; done
```


<a id="part-5"/>
## Part 5: Create the Cluster

* [5.1 Install Servers](#5-1)
* [5.2 Install Agents](#5-2)
* [5.3 Set Up Service Load Balancing](#5-3)

<a id="5-1"/>
### 5.1 Install Servers

We'll create the control plane by creating the cluster on `server-0`, then adding `server-1` and `server-2` to the cluster.

We want to load balance requests to the Kubernetes API endpoint across the three server VMs. For true high-availability, we would want to use a load balancer with liveness health checks. For this tutorial, though, we will just use a simple round-robin DNS entry for `kubernetes.k3s.local`.


*Note*: This assumes Ubuntu configured each VM's network interface as `enp0s6`.
You may need to change the arguments in the `ssh` commands if that interface
does not exist.


```shell
# Add our VIP route
ipfw add 300 fwd 10.0.10.10 ip from any to 10.0.0.2 keep-state
# Create VIP on server-0
ssh -o StrictHostKeyChecking=no -i ~cbsd/.ssh/id_rsa ubuntu@10.0.10.10 sudo ip address add 10.0.0.2/32 dev enp0s6:1
k3sup install \
  --host server-0 \
  --user ubuntu \
  --cluster \
  --k3s-channel stable \
  --ssh-key ~cbsd/.ssh/id_rsa \
  --tls-san 10.0.0.2 \
  --k3s-extra-args '--cluster-cidr 10.1.0.0/16 --service-cidr 10.2.0.0/16 --cluster-dns 10.2.0.10'
k3sup join \
  --host server-1 \
  --user ubuntu \
  --server \
  --server-host kubernetes.k3s.local \
  --server-user ubuntu \
  --k3s-channel stable \
  --ssh-key ~cbsd/.ssh/id_rsa \
  --k3s-extra-args '--cluster-cidr 10.1.0.0/16 --service-cidr 10.2.0.0/16 --cluster-dns 10.2.0.10'
k3sup join \
  --host server-2 \
  --user ubuntu \
  --server \
  --server-host kubernetes.k3s.local \
  --server-user ubuntu \
  --k3s-channel stable \
  --ssh-key ~cbsd/.ssh/id_rsa \
  --k3s-extra-args '--cluster-cidr 10.1.0.0/16 --service-cidr 10.2.0.0/16 --cluster-dns 10.2.0.10'
# Create VIPs on server-1 and server-2
ssh -o StrictHostKeyChecking=no -i ~cbsd/.ssh/id_rsa ubuntu@10.0.10.11 sudo ip address add 10.0.0.2/32 dev enp0s6:1
ssh -o StrictHostKeyChecking=no -i ~cbsd/.ssh/id_rsa ubuntu@10.0.10.12 sudo ip address add 10.0.0.2/32 dev enp0s6:1
export KUBECONFIG=/root/kubeconfig
kubectl config set-context default
# In case the server endpoint is set to localhost, we'll change it to our VIP
sed -I "" -e 's/server: .*$/server: https:\/\/10.0.0.2:6443/' $KUBECONFIG
kubectl get nodes -o wide
```

<a id="5-2"/>
### 5.2 Install Agents

```shell
for i in 0 1 2; do
k3sup join \
  --host agent-$i \
  --user ubuntu \
  --server-host kubernetes.k3s.local \
  --server-user ubuntu \
  --k3s-channel stable \
  --ssh-key ~cbsd/.ssh/id_rsa
done
# Remove temporary firewall rule
ipfw delete 300
# Create round-robin firewall rules
ipfw add 300 prob 0.33 fwd 10.0.10.10 ip from any to 10.0.0.2 keep-state
ipfw add 301 prob 0.5 fwd 10.0.10.11 ip from any to 10.0.0.2 keep-state
ipfw add 302 fwd 10.0.10.12 ip from any to 10.0.0.2 keep-state
kubectl get nodes -o wide
```


<a id="5-3"/>
### 5.3 Set Up Service Load Balancing

Generally, if you want to expose a Kubernetes application endpoint on an IP address outside the cluster's network, you would create a `Service` object of type `LoadBalancer`. However, because load balancer options and implementations are unique for each cloud provider and self-hosted environment, Kubernetes expects you to have a controller running in your cluster to manage service load balancers. We have no such controller for our FreeBSD hypervisor, but we have a couple basic alternatives.

#### 5.3.1 Routing to `NodePort Services`

For `Services` of type `NodePort`, we can route directly to the `Service`'s virtual IP, which will be in our `10.2.0.0/16` service network block. Each service VIP is routeable by every node, so if we set up round-robin forwarding rules on the hypervisor's firewall, we should be able to reach `NodePort` endpoints.

```script
ipfw add 350 prob 0.333 fwd 10.0.10.20 ip from any to 10.2.0.0/16 keep-state
ipfw add 351 prob 0.5 fwd 10.0.10.21 ip from any to 10.2.0.0/16 keep-state
ipfw add 352 fwd 10.0.10.22 ip from any to 10.2.0.0/16 keep-state
```

#### 5.3.1 K3s Service Load Balancer

K3s has its own option for load balancer services. You can read [the documentation](https://rancher.com/docs/k3s/latest/en/networking/#service-load-balancer) for details. The service IP address will share the IP address of a node in the cluster. We will see a demonstration in the next section, when we test our cluster.

Note that with the K3s service load balancer, you run the risk of being unable to create a `LoadBalancer`-type service because of a high risk of port collisions, which are not usually a problem with most Kubernetes `LoadBalancer` implementations.


<!--nextpage-->  

<a id="part-6"/>
## Part 6: Test the Cluster

We'll run the following tests:

1. Create `nginx` deployment
2. Port-forward to `nginx` pod
3. Check `nginx` pod's logs
4. Expose `nginx NodePort Service`
5. Expose `nginx LoadBalancer Service` on port 8080
6. Test pod-to-pod connectivity


```shell
# Create deployment
kubectl create deployment nginx --image=nginx
kubectl get pods 
# Port-forward to pod
POD=$(kubectl get pods -l app=nginx -ojsonpath="{.items[0].metadata.name}")
PID="$(kubectl port-forward $POD 8080:80 >/dev/null 2>&1 & echo $!)"
curl http://localhost:8080/
kill "$PID"
# Check pod logs
kubectl logs $POD
# Create NodePort service
kubectl expose deployment nginx --port 80 --type NodePort
kubectl get svc 
CLUSTERIP="$(kubectl get svc nginx -ojsonpath='{.spec.clusterIP}')"
curl -I http://${CLUSTERIP}/
kubectl delete svc nginx
# Create LoadBalancer Service
kubectl expose deployment nginx --port 8080 --target-port 80 --type LoadBalancer
kubectl get svc
LBIP="$(kubectl get svc nginx -ojsonpath='{.status.loadBalancer.ingress[0].ip}')"
curl -I http://${LBIP}:8080/
kubectl delete svc nginx
# Test pod-to-pod connectivity
PODIP="$(kubectl get pod "$POD" -ojsonpath='{.status.podIP}')"
kubectl run -it busybox --image busybox --rm=true --restart=Never -- wget -q -S -O /dev/null "http://${PODIP}"
```


<a id="part-7"/>
## Part 7: Clean Up

To clean up:

* Stop and remove the VMs
  * `cbsd bstop agent-0` # etc
  * `cbsd bremove agent-0` # etc
* Edit `/etc/rc.conf` to remove any settings that were added
* Edit `/etc/sysctl.conf` to remove any settings that were added
* Reboot

* * *

Please let me know if you have questions or suggestions either in the comments or [on Twitter](https://twitter.com/fuzzyKB).

<a id="sources-references"/>
## Sources and References

* [https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html](https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html)
* [https://cbsd.io/](https://cbsd.io/)
* [https://github.com/alexellis/k3sup/](https://github.com/alexellis/k3sup/ )
* [https://k3s.io/](https://k3s.io/)
* [https://kubernetes.io/](https://kubernetes.io/)
* [https://kubernetes.io/docs/concepts/services-networking/service/](https://kubernetes.io/docs/concepts/services-networking/service/)
* [https://www.freebsd.org/doc/handbook/firewalls-ipfw.html](https://www.freebsd.org/doc/handbook/firewalls-ipfw.html)
* [https://www.freebsd.org/doc/handbook/network-bridging.html](https://www.freebsd.org/doc/handbook/network-bridging.html)
* [https://www.freebsd.org/doc/handbook/ports.html](https://www.freebsd.org/doc/handbook/ports.html)


