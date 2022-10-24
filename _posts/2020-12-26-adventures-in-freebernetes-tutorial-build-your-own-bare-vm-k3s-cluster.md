---
layout: post
title: 'Adventures in Freebernetes Tutorial: Build Your Own Bare-VM k3s Cluster'
date: 2020-12-26 08:38:07.000000000 -08:00
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
permalink: "/2020/12/26/adventures-in-freebernetes-tutorial-build-your-own-bare-vm-k3s-cluster/"
excerpt: Step-by-step tutorial for deploying a Kubernetes cluster with k3s on FreeBSD bhyve VMs
---

**Note**: there is [an updated version of this
post](/2022/10/24/fun-with-freebsd-k3s-cluster-tutorial/) which you should use
instead. This version is outdated.


_Step-by-step tutorial for deploying a Kubernetes cluster with k3s on FreeBSD bhyve VMs_

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

In [the last tutorial](/2020/12/08/adventures-in-freebernetes-tutorial-build-your-own-bare-vm-kubernetes-cluster-the-hard-way/) in this series, we went through the steps of creating a Kubernetes cluster on FreeBSD `bhyve` VMs, adapting the completely manual process in Kelsey Hightower's [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way/tree/1.18.6). This tutorial will also build a Kubernetes cluster on `bhyve`, but it will install a lightweight `k3s` control plane using the [`k3sup`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) tool, which automates much of the process.

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
* VM OS: Ubuntu Server 20.04
* Kubernetes version: 1.19
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
  * FreeBSD: 13.0-CURRENT. It may work with 12.0-RELEASE, but it has not been tested
  * File system: ZFS

### My Test System

* Hardware
  * CPUs: Intel(R) Core(TM) i5-6260U: 4 CPUs, 2 cores each
  * RAM: 32Gb
* Operating system
  * FreeBSD 13.0-HEAD-f659bf1d31c

<!--nextpage-->  

<a id="part-1"/>
## Part 1: Required Tools

We're going to install the tools needed on the FreeBSD hypervisor. [You can compile from the](https://www.freebsd.org/doc/handbook/ports.html)[`ports`](https://www.freebsd.org/doc/handbook/ports.html)[tree or install from packages](https://www.freebsd.org/doc/handbook/ports.html), whichever you prefer. The tutorial assumes you have already installed all these ports. When additional post-installation configuration is required, we will walk through it at the appropriate point in the tutorial.

We need to build `k3sup` locally, so this list includes the build tools for compiling from source.

Here is the full list of required packages, including the versions, with the `ports` section in parentheses:

* Build tools
  * git 2.29.2 (`devel`)

  * go 1.15.6.1 (`lang`)
* K8s tools
  * kubectl 1.19.4 (`sysutils`)
* FreeBSD system tools
  * `CBSD` 12.2.4 (`sysutils`)
  * `nsd` 4.3.4 (`dns`)
* Misc tools
  * `wget` 1.20.3_1 (`ftp`)


<!--nextpage-->  

<a id="part-2"/>
## Part 2: Build k3sup

* [2.1 Setup Your Go Environment](#2-1)
* [2.2 Check Out and Build k3sup](#2-2)

We'll need to build `k3sup` for our FreeBSD hypervisor.

<a id="2-1"/>
### 2.1 Setup Your Go Environment

If you already have a working `golang` build environment on your FreeBSD hypervisor, you can skip this section.

First, create your `go` workspace. This tutorial will assume you are using the path `${HOME}/go`.

<script src="https://gist.github.com/kbruner/b7aa00bad106287d90453e487b23145b.js"></script>

<a id="2-2"/>
### 2.2 Check Out and Build k3sup

<script src="https://gist.github.com/kbruner/663ba195adef9a7e8d99704c8ce5982a.js"></script>

You should copy this `k3sup` binary somewhere in your `PATH`.


<!--nextpage-->  

<a id="part-3"/>
## Part 3: Create VMs

* [3.1 Choose Your Network Layout](#3-1)
* [3.2 Create the Linux VMs](#3-2)

<a id="3-1"/>
### 3.1 Choose Your Network Layout

#### 3.1.1 Select Subnets

My FreeBSD hypervisor has a 192.168.0.0/24 address on its physical network interface. I'm going to use a VLAN in 10.0.0.0/8 for the cluster and its pods and services. You can use another block, but you will have to adjust commands throughout the tutorial.

* 10.0.0.1/32 - VLAN gateway on bridge interface
* 10.0.0.2/32 - Virtual IP for Kubernetes API endpoint
* 10.0.10.0/24 - VM block
  * 10.0.10.1[1-3] - K3s servers
  * 10.0.10.2[1-3] - K3s agents (nodes)
* 10.1.0.0/16 - pod network
* 10.2.0.0/16 - service network

#### 3.1.2 Pick a `.local` Zone for DNS

This zone just needs to resolve locally on the FreeBSD host. I'm going with `k3s.local` because I'm too lazy to think of a clever pun right now.

<a id="3-2"/>
### 3.2 Create the Linux VMs

#### 3.2.1 Initialize CBSD

If you haven't run [CBSD](https://cbsd.io/) on your FreeBSD host before, you will need to set it up. You can use [this seed file](https://github.com/kbruner/freebernetes/blob/main/k3s/cbsd/initenv.conf). Edit it first to set `node_name` to your FreeBSD host's name and to change `jnameserver` and `nodeippool` if you are using a private network other than `10.0.0.0/8`.

<script src="https://gist.github.com/kbruner/c4cf17fd603d55c5ef03925a161051b2.js"></script>

#### 3.2.2 Create VMs

Copy [this `instance.jconf` VM template file](https://github.com/kbruner/freebernetes/blob/main/k3s/cbsd/instance.jconf) and update `ci_gw4`, `ci_nameserver_search`, and `ci_nameserver_address` fields as needed. If you want to set a password for the `ubuntu` user in case you want to log in on the console via VNC, you can assign it to `cw_user_pw_user`, but note this is a plain-text field.

When you run `cbsd bcreate`, if CBSD does not have a copy of the installation ISO image, it will prompt you asking to download it. After the first time, it will re-use the local image.

<script src="https://gist.github.com/kbruner/73d227a5b78e5c5f56f6584259357141.js"></script>


<!--nextpage-->  

<a id="part-4"/>
## Part 4: Configure Networking

* [4.1 Add Bridge Gateways](#4-1)
* [4.2 Configure NAT](#4-2)
* [4.3 Configure Local DNS](#4-3)

You cannot connect to the new VMs yet. CBSD creates a `bridge` interface the first time you create a VM. We need to add gateways for our cluster VLANs to that interface so we can route from the hypervisor to the VMs and vice versa. In most cases, CBSD will use the `bridge1` interface.

<a id="4.1"/>
### 4.1 Add Bridge Gateways

Note that these changes will not survive across reboots. I have not tested if adding a persistent entry for `bridge1` in `/etc/rc.conf` would work as expected with CBSD, as it manages the `bridge1` interface.

<script src="https://gist.github.com/kbruner/63d892a4922bb2da6c60c55a1fb610d7.js"></script>

<a id="4-2"/>
### 4.2 Configure NAT

We can reach our VM just fine from the host, but the VMs can't talk to the Internet because only the FreeBSD host can route to this `10.0.0.0/8` block. We will use `ipfw` as a NAT (Network Address Translation) service. These steps will enable `ipfw` with open firewall rules and then configure the NAT. These changes will take effect immediately. The service and kernel settings will persist across reboots, but the `ipfw` firewall rules will not. See [the `ipfw` chapter](https://www.freebsd.org/doc/handbook/firewalls-ipfw.html) about how to create and enable a firewall script.

Note that my host's physical interface is named `em0`. You may have to alter some commands if yours has a different name.

<script src="https://gist.github.com/kbruner/a6570bf7345f63353d2307e4f6acae77.js"></script>

<a id="4-3"/>
### 4.3 Configure Local DNS

We need a way to resolve our VM host names. We need to pick a private `.local` DNS domain, configure an authoritative server for the domain, and then set up a local caching server that knows about our domain but can also still resolve external addresses for us. We will follow [this `nsd`/`unbound` tutorial](https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html) closely.

#### 4.3.1 Enable `unbound` for recursive/caching DNS

FreeBSD has a caching (lookup-only) DNS service called `unbound` in the base system. It will use the configured nameservers for external address lookups and the local `nsd` service (configured next) for lookups to our private zone. Copy `unbound.conf` and make any edits as necessary to IP addresses or your local zone name.

You will also want to update the FreeBSD host's `/etc/resolv.conf` to add your local domain to the `search` list and add an entry for `nameserver 127.0.0.1`.

<script src="https://gist.github.com/kbruner/0b7032c60bc1e980e398e9ed761ebc3e.js"></script>

#### 4.3.2 Configure the Authoritative DNS Service

We will use `nsd`, a lightweight, authoritative-only service, for our local zone. After copying the files, you can edit/rename the copied files before proceeding to make changes as necessary to match your local domain or IP addresses.

<script src="https://gist.github.com/kbruner/4c823a16a775138464977479c8756765.js"></script>


<!--nextpage-->  

<a id="part-5"/>
## Part 5: Create the Cluster

* [5.1 Install Servers](#5-1)
* [5.2 Install Agents](#5-2)
* [5.3 Set Up Service Load Balancing](#5-3)

<a id="5-1"/>
### 5.1 Install Servers

We'll create the control plane by creating the cluster on `server-0`, then adding `server-1` and `server-2` to the cluster.

We want to load balance requests to the Kubernetes API endpoint across the three server VMs. For true high-availability, we would want to use a load balancer with liveness health checks. For this tutorial, though, we will just use a simple round-robin method using `ipfw` rules for a virtual IP address, `10.0.0.2`.

We will use the virtual IP for the Kubernetes API endpoint as we build out the cluster. This method allows us to configure K3s to use that endpoint for connections to the API endpoint without hitting a host which has not yet been bootstrapped.

We also have to add the virtual IP address to the primary interface on each server VM so it will accept traffic for the VIP. This change won't persist over reboots unless you add the second IP address to `/etc/netplan/50-cloud-init.yaml` on each server VM.

Note that the `ipfw` firewall rules we're adding will not persist across reboots. See [the `ipfw` chapter](https://www.freebsd.org/doc/handbook/firewalls-ipfw.html) about how to create and enable a firewall script.

<script src="https://gist.github.com/kbruner/1ad917dc4d39dbe0821bcfb782c14c17.js"></script>

<a id="5-2"/>
### 5.2 Install Agents

<script src="https://gist.github.com/kbruner/dde0b5716aaa586d684f598827312ad9.js"></script>

<a id="5-3"/>
### 5.3 Set Up Service Load Balancing

Generally, if you want to expose a Kubernetes application endpoint on an IP address outside the cluster's network, you would create a `Service` object of type `LoadBalancer`. However, because load balancer options and implementations are unique for each cloud provider and self-hosted environment, Kubernetes expects you to have a controller running in your cluster to manage service load balancers. We have no such controller for our FreeBSD hypervisor, but we have a couple basic alternatives.

#### 5.3.1 Routing to `NodePort Services`

For `Services` of type `NodePort`, we can route directly to the `Service`'s virtual IP, which will be in our `10.2.0.0/16` service network block. Each service VIP is routeable by every node, so if we set up round-robin forwarding rules on the hypervisor's firewall, we should be able to reach `NodePort` endpoints.

Note that the `ipfw` firewall rules we're adding will not persist across reboots. See [the `ipfw` chapter](https://www.freebsd.org/doc/handbook/firewalls-ipfw.html) about how to create and enable a firewall script.

<script src="https://gist.github.com/kbruner/2518f044108c0bdab14394c013022250.js"></script>

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

<script src="https://gist.github.com/kbruner/ddd7eb49ff38df546f3785d2e531ab43.js"></script>

<!--nextpage-->  

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
* [https://k3s.io/](https://k3s.io/ )
* [https://kubernetes.io/](https://kubernetes.io/)
* [https://kubernetes.io/docs/concepts/services-networking/service/](https://kubernetes.io/docs/concepts/services-networking/service/ )
* [https://www.freebsd.org/doc/handbook/firewalls-ipfw.html](https://www.freebsd.org/doc/handbook/firewalls-ipfw.html)
* [https://www.freebsd.org/doc/handbook/network-bridging.html](https://www.freebsd.org/doc/handbook/network-bridging.html )
* [https://www.freebsd.org/doc/handbook/ports.html](https://www.freebsd.org/doc/handbook/ports.html)


