---
layout: post
title: 'Adventures in Freebernetes Tutorial: Build Your Own Bare-VM Kubernetes Cluster the Hard Way'
date: 2020-12-08 09:38:45.000000000 -08:00
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
meta:
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/12/08/adventures-in-freebernetes-tutorial-build-your-own-bare-vm-kubernetes-cluster-the-hard-way/"
excerpt: Step-by-step tutorial for manually deploying a Kubernetes cluster on FreeBSD bhyve VMs
---

_Step-by-step tutorial for manually deploying a Kubernetes cluster on FreeBSD bhyve VMs_


[See all posts in the FreeBSD Virtualization Series]({{ site.baseurl }}/freebsd-virtualization-series/)


1. [Overview](#overview)

* [Caveats](#caveats)
* [Intended Audience](#intended-audience)
* [Host Requirements](#host-requirements)
* [Test System](#test-system)
* [Page 1: Prerequisites](#page-1)
* [Page 2: Installing Client Tools](#page-2)
* [Page 3: Compute Resources](#page-3)
* [Page 4: Provisioning a CA and Generating TLS Certificates](#page-4)
* [Page 5: Generating Kubernetes Configuration Files for Authentication](#page-5)
* [Page 6: Generating the Data Encryption Config and Key](#page-6)
* [Page 7: Bootstrapping the etcd Cluster](#page-7)
* [Page 8: Bootstrapping the Kubernetes Control Plane](#page-8)
* [Page 9: Bootstrapping the Kubernetes Worker Nodes](#page-9)
* [Page 10: Configuring kubectl for Remote Access](#page-10)
* [Page 11: Provisioning Pod Network Routes](#page-11)
* [Page 12: Deploying the DNS Cluster Add-on](#page-12)
* [Page 13: Smoke Test](#page-13)
* [Page 14: Cleaning Up](#page-14)
* [Sources / References](#sources-references)


## Overview


This tutorial will take you step-by-step through setting up a fully-functional Kubernetes cluster installed on `bhyve` virtual machines (VMs) on a single FreeBSD host/hypervisor. We'll be following Kelsey Hightower's [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way/tree/1.18.6) tutorial based on Kubernetes version 1.18.6, adapting it for the FreeBSD environment. While the VM guests that make up the Kubernetes cluster run Ubuntu Linux, we will use native FreeBSD functionality and tools as much as possible for the virtual infrastructure underneath, such as the virtualization platform, but also the cluster's virtual network and support services.


Topics covered:


* Setting up `bhyve` virtualization
* Creating a custom CBSD configuration for creating our cluster's VMs
* Configuring the FreeBSD firewall, DNS, and routing for cluster networking


You can find custom files and examples in [my `freebernetes` repo](https://github.com/kbruner/freebernetes).


This tutorial is based on a series of meandering posts I wrote about my original experiments working through the tutorial on top of FreeBSD. You can read them starting [here]({{ site.baseurl }}/2020/11/24/adventures-in-freebernetes-getting-ready-to-do-kubernetes-the-harder-way/).


### Caveats


Note that Kubernetes the Hard Way is one of the most manual ways to create a Kubernetes cluster, so while it's great for understanding what all the piece are in a cluster and how they fit together, it's not the most practical method for most users.


This tutorial covers installing the cluster on a single FreeBSD host. You will end up with a fully-functional cluster, suitable for learning how to use Kubernetes, testing applications, running your containers, etc. However, it's not suitable for most production uses, because of a lack of redundancy and security hardening.


This tutorial is not a Kubernetes user tutorial. It won't spend time defining terms or providing deep explanations of concepts. For that, you should start with the [official Kubernetes documentation](https://kubernetes.io/).


### Intended Audience


For this tutorial, you don't need to know anything about Kubernetes. You do need to have a host with FreeBSD installed; an understanding of basic FreeBSD system administration tasks, such as installing software from FreeBSD ports or packages, and loading kernel modules; and familiarity with `csh` or `sh`. Experience with FreeBSD `bhyve` virtual machines and the CBSD interface is useful but not required.


### Host (FreeBSD Hypervisor) Requirements


* Hardware, physical or virtual
  * CPU
    * The guest VMs have a shared total of 12 "CPUs" between them, but these do not have to map to actual host CPUs. My system has a total of 8 cores, for example
    * CPUs must support FreeBSD bhyve virtualization (see [the FreeBSD Handbook page on bhyve](https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html) for compatible CPUs)
  * RAM: at least 18Gb; 30Gb+ preferred
  * Free disk space: at least 100Gb
* Operating system
  * FreeBSD: 13.0-CURRENT. It may work with 12.0-RELEASE, but it haas not been tested
  * File system: ZFS. It could work with UFS with user modifications


### Test System


* Hardware
  * CPUs: Intel(R) Core(TM) i5-6260U: 4 CPUs, 2 cores each
  * RAM: 32Gb
* Operating system
  * FreeBSD 13.0-HEAD-f659bf1d31c


<a id="page-1"></a>
## [Page 1: Prerequisites](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/01-prerequisites.md)


You can skip this section in Kubernetes the Hard Way.

<!--nextpage-->  

<a id="page-2"></a>
## [Page 2: Installing the Client Tools](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/02-client-tools.md)


We're going to install both the tools listed in original, plus additional software that we will need on the FreeBSD host. You don't need to follow any specific steps listed in the original.


[You can compile from the `ports` tree or install from packages](https://www.freebsd.org/doc/handbook/ports.html), whichever you prefer. The tutorial assumes you have already installed all these ports. When additional post-installation configuration is required, we will walk through it at the appropriate point in the tutorial.


Here is the full list of required packages, including the versions, with the `ports` section in parentheses:


* [`CBSD` 12.2.3](https://svnweb.freebsd.org/ports/head/sysutils/cbsd/) (`sysutils`)
* [`cfssl` 1.5.0](https://svnweb.freebsd.org/ports/head/security/cfssl) (`security`)
* [`etcd` 3.4.14](https://svnweb.freebsd.org/ports/head/devel/etcd34) (package name: `coreos-etcd34`, port: `devel/etcd34`)
* [`kubectl` 1.19.4](https://svnweb.freebsd.org/ports/head/sysutils/kubectl) (`sysutils`)
* [`nsd` 4.3.3](https://svnweb.freebsd.org/ports/head/dns/nsd) (`dns`)
* [`tmux` 3.1c](https://svnweb.freebsd.org/ports/head/sysutils/tmux) (`sysutils`)
* [`wget` 1.20.3\_1](https://svnweb.freebsd.org/ports/head/ftp/wget) (`ftp`)

<!--nextpage-->  

<a id="page-3"></a>
## [Page 3: Compute Resources](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/03-compute-resources.md)


* [3.0 Clone the Freebernetes Repo](#3-0)
* [3.1 Choose Your Virtual Network Layout](#3-1)
* [3.2 Create the Linux VMs](#3-2)
* [3.3 Configure Networking](#3-3)
* [3.4 Configure Local DNS](#3-4)


In this section, we will perform the bulk of our FreeBSD-specific infrastructure configurations. You won't need to follow any specific steps in the original.


There are a bunch of steps here, but with few exceptions, most of the FreeBSD customization work happens here.


<a id="3-0"></a>
### 3.0 Clone the Freebernetes Repo


You can find most of the custom files used here in [https://github.com/kbruner/freebernetes](https://github.com/kbruner/freebernetes). This tutorial assumes you've cloned it to `~/src/freebernetes`.


<a id="3-1"></a>
### 3.1 Choose Your Virtual Network Layout


This tutorial will use the private ([RFC1918](https://tools.ietf.org/html/rfc1918)) IPv4 CIDR blocks and addresses from the original tutorial, where appropriate. These are all in the `10.0.0.0/8` block; if you have a collision in your existing network, you can use another block. **Note:** If you do use different IP blocks, you will need to make a number of changes to files and commands.


* `10.32.0.0/24` - [The Kubernetes `Service` network](https://kubernetes.io/docs/concepts/services-networking/service/), for the virtual IP endpoints in the cluster
* `10.200.0.0/16` - [The Kubernetes `pod` network](https://kubernetes.io/docs/concepts/cluster-administration/networking/)
* `10.240.0.0/24` - Cluster VMs and "external" endpoints (those you will need to reach from the FreeBSD host)


I very strongly recommend using these network allocations if at all possible, both to avoid having to make frequent edits and because it will be less confusing if something does not work in the cluster.


#### 3.1.1 Pick a `.local` Zone for DNS


This zone just needs to resolve locally on the FreeBSD host. I'm going with `hardk8s.local` because who doesn't like a bad pun?


<a id="3-2"></a>
### 3.2 Create the Linux VMs


#### 3.2.1 Initialize CBSD


If you haven't run [CBSD](https://cbsd.io/) on your FreeBSD host before, you will need to set it up. You can use the seed file at `~/src/freebernetes/harder-way/cbsd/initenv.conf`. Edit it first to set `node_name` to your FreeBSD host's name and to change `jnameserver` and `nodeippool` if you are using a private network other than `10.0.0.0/8`.


<script src="https://gist.github.com/kbruner/2f0db56ee4c7beefd41984ca25e824b8.js"></script>


Note that CBSD version 12.2.3 seems to have a bug where it enables `cbsdrsyncd` even if you configure it for one node and one SQL replica only. That's why we are disabling it and stopping the service. (Not critical, but I get annoyed by random, unused services hanging around.)


#### 3.2.2 Configure VM Profile


We will use the existing CBSD cloud image for Ubuntu Linux 20.04, but we want to create our own profile (VM configuration settings and options). Copy `~/src/freebernetes/harder-way/cbsd/usr.cbsd/etc/defaults/vm-linux-cloud-ubuntuserver-kubernetes-base-amd64-20.04.conf` to `/usr/cbsd/etc/defaults/vm-linux-cloud-ubuntuserver-kubernetes-base-amd64-20.04.conf`


This profile uses a custom `cloud-init` field, `ci_pod_cidr`, to pass a different address block to each worker node, which they will use to assign unique IP addresses to pods. As CBSD does not know about this setting and does not support ad-hoc parameters, we're going to update the `bhyve` VM creation script and use our own `cloud-init` template.


<script src="https://gist.github.com/kbruner/1ec1c74f746a7d01850719d822572a5b.js"></script>


#### 3.2.3 Create VMs


Copy `~/src/freebernetes/harder-way/cbsd/instance.jconf` and update `ci_gw4`, `ci_nameserver_search`, and `ci_nameserver_address` as needed. If you want to set a password for the `ubuntu` user in case you want to log in on the console via VNC, you can assign it to `cw_user_pw_user`, but note this is a plain-text field.


When you run `cbsd bcreate`, if CBSD does not have a copy of the installation ISO image, it will prompt you asking to download it. After the first time, it will re-use the local image.


<script src="https://gist.github.com/kbruner/d3c5adb7050f9db561194addb4c51cbb.js"></script>


<a id="3-3"></a>
### 3.3 Configure Networking


Note that you cannot yet connect to the VMs. CBSD creates a `bridge` interface the first time you create a VM, and we need to add our gateways to that interface. In most cases, CBSD will use the `bridge1` interface.


The `10.0.0.1/32` does not act as a gateway for any of the subnets, but we're using it as the DNS server endpoint for the virtual networks.


#### 3.3.1 Add Bridge Gateways


<script src="https://gist.github.com/kbruner/57363aaff423e768cbef5042f76cf023.js"></script>


Note that these changes will not survive across reboots. I have not tested if adding a persistent entry for `bridge1` in `/etc/rc.conf` would work as expected with CBSD.


#### 3.3.2 Configure NAT


We can reach our VM just fine from the host, but the VMs can't talk to the Internet because only the FreeBSD host can route to this `10.0.0.0/8` block. We will use `ipfw` as a NAT (Network Address Translation) service. These steps will enable `ipfw` with open firewall rules and then configure the NAT. These changes will take effect immediately and persist across reboots.


Note that my host's physical interface is named `em0`. You may have to alter some commands if yours has a different name.


<script src="https://gist.github.com/kbruner/a6570bf7345f63353d2307e4f6acae77.js"></script>


<a id="3-4"></a>
### 3.4 Configure Local DNS


We need a way to resolve our VM host names. We need to pick a private `.local` DNS domain, configure an authoritative server for the domain, and then set up a local caching server that knows about our domain but can also still resolve external addresses for us. We will follow [this `nsd`/`unbound` tutorial](https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html) closely.


#### 3.4.1 Enable `unbound` for recursive/caching DNS


FreeBSD has a caching (lookup-only) DNS service called `unbound` in the base system. It will use the nameservers configured in the local `/etc/resolv.conf` for external address lookups and the local `nsd` service (configured next) for lookups to our private zone. Copy `unbound.conf` and make any edits as necessary to IP addresses or your local zone name.


You will also want to update the FreeBSD host's `/etc/resolv.conf` to add your local domain to the `search` list and add an entry for `nameserver 127.0.0.1`.


<script src="https://gist.github.com/kbruner/c38ec65350211472e17a1e422f9bdc8b.js"></script>


#### 3.4.2 Configure the Authoritative DNS Service


We will use `nsd`, a lightweight, authoritative-only service, for our local zone. After copying the files, you can edit/rename the copied files before proceeding to make changes as necessary to match your local domain or IP addresses.


<script src="https://gist.github.com/kbruner/32320b63e6a044386c26b7ab6a4fea71.js"></script>

<!--nextpage-->  

<a id="page-4"></a>
## [Page 4: Provisioning a CA and Generating TLS Certificates](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/04-certificate-authority.md)


You can follow all the original steps in this section, with a few exceptions.


Note: You can use any common names, locations, etc., in the JSON certificate signing request (CSR) files, as long as they are consistent and match your CA (certificate authority).


In [The Kubelet Client Certificates](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/04-certificate-authority.md#the-kubelet-client-certificates) section:


<script src="https://gist.github.com/kbruner/9fb1fa5a88812c02356f5fd6c44afdd1.js"></script>


[The Kubernetes API Server Certificate](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/04-certificate-authority.md#the-kubernetes-api-server-certificate) section:


<script src="https://gist.github.com/kbruner/2711d1c793596fd73bb5da75f17968c8.js"></script>


[Distribute the Client and Server Certificates](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/04-certificate-authority.md#distribute-the-client-and-server-certificates) section:


<script src="https://gist.github.com/kbruner/e8be56da8738f3ac035dfc894123e614.js"></script>

<!--nextpage-->  

<a id="page-5"/>
## [Page 5: Generating Kubernetes Configuration Files for Authentication](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/05-kubernetes-configuration-files.md)


You only need to make two changes to this section: at the very beginning, set `KUBERNETES_PUBLIC_ADDRESS=10.240.0.2` instead of using the `gcloud` command shown, and at the very end when copying files to the VMs. Otherwise, follow the rest of the steps in the original.


<script src="https://gist.github.com/kbruner/0cc263d4786bc8372916707c401e9119.js"></script>

<!--nextpage-->  

<a id="page-6"/>
## [Page 6: Generating the Data Encryption Config and Key](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/06-data-encryption-keys.md)


FreeBSD's Base64 tool differs from Linux's, so we need to use


`ENCRYPTION_KEY=$(head -c 32 /dev/urandom | b64encode -r -)`


at the beginning. The config file generation is the same, but we need to use our `scp -i ~cbsd/.ssh/id_rsa` command instead of `gcloud`'s to copy the file to the controllers.

<!--nextpage-->  

<a id="page-7"/>
## [Page 7: Bootstrapping the etcd Cluster](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/07-bootstrapping-etcd.md)


For this section, use `ssh -i ~cbsd/.ssh/id_rsa ...` instead of the `gcloud` command to log in to the controllers.


Replace the `INTERNAL_IP` setter:


`INTERNAL_IP=$(dig @10.0.0.1 +short `hostname`.hardk8s.local)`


If you are using your own IP address ranges, you will need to make some additional changes.


After that, all commands are executed on each of the controllers. As the tutorial recommends, using `tmux` synchronization makes this section much easier.


If you're on a slow Internet connection, you may also want to download the tarball once and copy it from your FreeBSD host to the controller VMs.


The commands on the next page also need to be executed on each controller, so you can leave your `tmux` session open.

<!--nextpage-->  

<a id="page-8"/>
## [Page 8: Bootstrapping the Kubernetes Control Plane](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/08-bootstrapping-kubernetes-controllers.md)


Most of this section should be executed as written, with the following exceptions:


* Set `INTERNAL_IP` as we did on the previous page
* If you're on a slow Internet connection, you may also want to download the tarballs once and copy them from your FreeBSD host to the controller VMs.
* If you are using your own IP address ranges, you will need to make some additional changes.
* In place of the last section, The Kubernetes Frontend Load Balancer, follow these instructions:


### The (Replacement) Kubernetes Frontend Load Balancer


We have three control plane servers, each running the Kubernetes API service. In a production system, we would want to use a load balancer that could also perform service health checks and avoid sending requests to unavailable servers, like the Google Cloud load balancing service in the original, but for this experimental cluster, we can just use a simple round-robin method using `ipfw` rules by creating a virtual IP address, `10.240.0.2`.


First we create the rules, then we need to configure the three controllers to accept traffic for the virtual IP address. Note this second IP address will not persists across VM reboots. You will need to add `10.240.0.2/`32 to the `addresses` field in `/etc/netplan/50-cloud-init.yaml` if you want to save the configuration.


<script src="https://gist.github.com/kbruner/0bf3aec5548386e0ef266c9ca32cb46b.js"></script>


These rules look odd, but each of the three controllers should get 1/3 of the requests over time. (Rules are evaluated in numerical order.)


* Rule 300 gives `10.240.0.10` a 1/3 probability
* Rule 301 gives `10.240.0.11` a .5 probability, but that's half of the remaining two of the original three slots, so it has a 1/2 \* 2/3 = 1/3 chance overall
* Rule 302 gives `10.240.0.12` a 100% probability of being the final 1/3 hosts selected.


After this section, we can exit the controller `tmux `session.

<!--nextpage-->  

<a id="page-9"/>
## [Page 9: Bootstrapping the Kubernetes Worker Nodes](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/09-bootstrapping-kubernetes-workers.md)


We'll need a new `tmux` session with panes for each worker, similar to the one we used to configure the controllers.


We'll follow all of the source tutorial, with a one exception, setting the `POD_CIDR` value on each worker:


`POD_CIDR=$(cat /run/cloud-init/instance-data.json | python3 -c 'import sys, json; print(json.load(sys.stdin)["ds"]["meta_data"]["pod-cidr"])')`


If you are using your own IP address ranges, you will need to make some additional changes.


Once this part is done, you can close the worker `tmux` session.

<!--nextpage-->  

<a id="page-10"/>
## [Page 10: Configuring kubectl for Remote Access](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/10-configuring-kubectl.md)


To generate the `admin` `kubeconfig` file on your FreeBSD host, set `KUBERNETES_PUBLIC_ADDRESS=10.240.0.2` (the VIP we have configured on our `bridge1` interface), then follow the rest of the steps in the original.

<!--nextpage-->  

<a id="page-11"/>
## [Page 11: Provisioning Pod Network Routes](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/11-pod-network-routes.md)


Configure `ipfw` to handle the pod network routing:


<script src="https://gist.github.com/kbruner/9a5ac6c5e33ad1e7192c2a08f4d4b995.js"></script>

<!--nextpage-->  

<a id="page-12"/>
## [Page 12: Deploying the DNS Cluster Add-on](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/12-dns-addon.md)


Follow these instructions without modification. If you are using custom network ranges, you will need to download the `coredns-1.7.0.yaml` file first and make some edits before running `kubectl apply -f coredns-1.7.0.yaml`

<!--nextpage-->  

<a id="page-13"/>
## [Page 13: Smoke Test](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/13-smoke-test.md)


Most of these tests can be run as described in the original, with a few exceptions.


* In the Data Encryption section, you will have to use `ssh ~cbsd/.ssh/id_rsa` instead of the `gcloud ssh` command to log in to a controller.
* In the Services section:
  - Skip the `gcloud` command to create a firewall rule
  - The worker nodes' "external" IPs are the same as their internal IPs from the point-of-view of the FreeBSD host. You can set `EXTERNAL_IP=10.240.0.20` (or another of the worker node IP addresses)

<!--nextpage-->  

<a id="page-14"/>
## [Page 14: Cleaning Up](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/14-cleanup.md)


To clean up:


* Stop and remove the VMs
  - `cbsd bstop worker-0` # etc
  - `cbsd bremove worker-0` # etc
* Edit `/etc/rc.conf` to remove any settings that were added
* Edit /etc/sysctl.conf to remove any settings that were added
* Reboot


* * *

Please let me know if you have questions or suggestions either in the comments or [on Twitter](https://twitter.com/fuzzyKB).

<a id="sources-references"/>
## Sources and References


* [https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html](https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html)
* [https://cbsd.io/](https://cbsd.io/)
* [https://github.com/kelseyhightower/kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
* [https://kubernetes.io/](https://kubernetes.io/)
* [https://www.freebsd.org/doc/handbook/firewalls-ipfw.html](https://www.freebsd.org/doc/handbook/firewalls-ipfw.html)
* [https://www.freebsd.org/doc/handbook/network-bridging.html](https://www.freebsd.org/doc/handbook/network-bridging.html )
* [https://www.freebsd.org/doc/handbook/ports.html](https://www.freebsd.org/doc/handbook/ports.html)


