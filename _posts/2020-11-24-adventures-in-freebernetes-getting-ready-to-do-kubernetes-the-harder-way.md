---
layout: post
title: 'Adventures in Freebernetes: Getting Ready to do Kubernetes the Harder Way'
date: 2020-11-24 02:11:33.000000000 -08:00
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
- linux
- virtualization
meta:
permalink: "/2020/11/24/adventures-in-freebernetes-getting-ready-to-do-kubernetes-the-harder-way/"
excerpt: 'Part 9 of experiments in FreeBSD and Kubernetes: Prep Work for Creating a VM Kubernetes Cluster'
thumbnail: assets/images/2020/11/screenshot-2020-11-22-at-15.31.52-01.jpeg
---

_Part 9 of experiments in FreeBSD and Kubernetes: Prep Work for Creating a VM Kubernetes Cluster_

[_See all posts in this series_](/freebsd-virtualization-series/)

#### Table of Contents

1. [Overview](#overview)
2. [Make the Net Work](#make-the-net-work)
3. [Great Image Bake-Off Season 2](#great-image-bake-off-season-2)
4. [It Doesn't Work On My Machine](#it-doesnt-work)
5. [Cookie Cutters](#cookie-cutters)
6. [Command and Ctl](#command-and-ctl)
7. [NAT Done Yet](#nat-done-yet)
8. [Sources / References](#sources-references)

## Overview

Even though I said this series was about the possibilities of mixing [Kubernetes](http://kubernetes.io) and FreeBSD when I started, I have been examining the state of virtualization, focused on [bhyve](https://bhyve.org/) and mainly Linux VMs and not really talking about Kubernetes, until now.

FreeBSD supports several x86 or OS-level virtualization options, including [Xen](https://xenproject.org/) and [VirtualBox](https://www.virtualbox.org/), plus the venerable FreeBSD `jail(2)` system (which I plan to work with in later posts), not to mention the fact that FreeBSD supports [Linux binary compatibility](https://www.freebsd.org/doc/handbook/linuxemu.html), and let me tell you, I have not-so-warm memories chasing down all the Linux libraries I needed to run dynamically-linked binaries. However, for the experiments in this series using full virtualization of OS environments, I've focused on bhyve, part of the FreeBSD base system, both because it's pretty powerful and it doesn't require installing third-party software to use. Also, bhyve has never sparked [a forced reboot](https://www.networkworld.com/article/2687998/why-amazon-is-rebooting-10-of-its-cloud-servers.html) of what really seemed like half of all AWS EC2 instances.

Unfortunately, no way currently exists to run Kubernetes nodes natively on the FreeBSD operating system, without use of Linux or Windows emulation or virtualization. You can still build a Kubernetes node (or cluster!) on top of a FreeBSD system, but you need to pull in another operating system somewhere to get it running.

I plan on following [Kelsey Hightower](https://twitter.com/kelseyhightower)'s [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) tutorial for creating a Kubernetes cluster manually, without any sophisticated Kubernetes installation tools. Instead of installing on Google Compute Engine, I will be creating the entire Kubernetes cluster on my FreeBSD host, using Ubuntu VMs in bhyve, managed with CBSD, for the individual nodes. (CBSD is a third-party package, but as I demonstrated in earlier posts in this series, managing bhyve VMs requires a lot of manual steps, which CBSD greatly simplifies.)

I'm following the Kubernetes the Hard Way tutorial in part to enhance my understanding of the myriad interlocked components of a cluster, but also to see what, if any, adaptations may be required to get a functional cluster up in this bhyve virtualized environment.

### Version List

* FreeBSD host/hypervisor: 13.0-CURRENT, build Oct 22 _(I should probably update this)_
* CBSD: 12.2.3
* Ubuntu Server: 20.04
* Kubernetes: 1.18.6

## Make the Net Work

Networking is going to be the biggest difference from the tutorial, which relies on the particular networking capabilities in Google Cloud Project. A few things I will need to figure out:

* hostname resolution. I'll be giving the nodes static IP addresses, but they still need to be able to resolve to hostnames. I could hardcode each hostname into `/etc/hosts` everywhere, which I may end up doing anyway, but I'll check if there's an obvious, simple solution I can run on FreeBSD.
* load balancing: I don't really want to run my own load balancer on the hypervisor. Fortunately, FreeBSD supports the Common Address Redundancy Protocol, which allows multiple hosts to share a virtual IP address for service load balancing and failover. I just need to load the `carp(4)` (yes, I keep typing "crap") kernel module and configure it.
* Kubernetes CNI (Container Network Interface): I think the standard `kubenet` plugin will work in my little VLAN, but I'll have to see when I get to that point.

Once again, I'll be using the FreeBSD `bridge(4)` (since [I'm practically an expert now](/2020/11/13/adventures-in-freebernetes-a-bridge-not-far-enough/#rabbit-hole)) (not really) and a private `RFC1918` IPv4 block for all the cluster networks.

## Great Image Bake-Off Season 2

CBSD already has support for cloud-booting Ubuntu Server 20.04, but I decide to build my own disk image locally. I worked out the steps while creating the [CBSD cloud configuration for Alpine Linux](/2020/11/19/adventures-in-freebernetes-cloudy-with-a-chance-of-rain/), which took a lot of trial and error to get working, so I may as well put that experience to use.

As I did with Alpine, I start by creating a VM from the Ubuntu installation ISO image. CBSD has a VM profile for a manual install of Ubuntu Server 20.04, so that simplifies things. I run `cbsd bconstruct-tui` and configure my VM.

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-22-at-15.31.52-01.jpeg"
alt="Screenshot of CBSD UI to create Ubuntu VM">
</div>
<br>


<script src="https://gist.github.com/kbruner/508377f691534c7c5ca1ffded60b7fd2.js"></script>

I use all the Ubuntu installer defaults, with the exception of disabling LLVM. The VM has a 10Gb virtual hard drive, and other than the EFI partition, it all goes to the root file system, with no swap space. I also enable `sshd`.

After the installation finishes, I restart the VM via CBSD, which automatically unmounts the installation medium, and I check to make sure that `cloud-init` will actually run at boot. [Not going to fool me twice!](/2020/11/19/adventures-in-freebernetes-cloudy-with-a-chance-of-rain/#cloud-seeding-round-2) (The Ubuntu installer had already installed it and configured it to run at boot.)

I stop the VM and `dd` the virtual hard drive image into `~cbsd/src/iso`.

Next I need to create the CBSD profile. I copy the CBSD-distributed cloud configuration file in `~cbsd/etc/defaults` for Ubuntu Server and update it to use my image.

The profile uses the `centos7` `cloud-init` templates because most of the CBSD-distributed profiles use it, so who am I to argue? Alpine Linux did have some incompatibility issues with this template. If Ubuntu also has issues, I'll have to debug that.

## It Doesn't Work On My Machine

I should test the image and configuration. Oh, right. Thus far, I've been creating VMs by using the CBSD text UI. I should probably figure out the command-line method, right?

It turns out that `cbsd bconstruct-tui` will output a configuration file if you opt not to create the VM immediately, which I'd been doing. I run `cbsd bconstruct-tui`, configure my VM, and opt not to create the VM immediately. It creates a `.jconf` file for me, which I copy for later use. Then I create the VM.

<script src="https://gist.github.com/kbruner/c9afdf940dfa55ca6fd5ba599e2d6395.js"></script>

CBSD imports my raw disk image and starts the VM. But when my VM boots up, it still has the `ubuntu-base` hostname from the disk image. It looks like cloud-init did run, but my values for this VM did not get passed in.

### Fixing cloud-init

I dig in a bit. [CBSD uses](https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/) the [NoCloud data source](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html) for passing the generated cloud-init files through a mounted ISO image into the VM at creation time. I assume that CBSD created the image and mount, as I've had no problems with booting other cloud images. Even though my installation of Ubuntu had automatically installed and enabled `cloud-init` (remember, [I checked](#great-image-bake-off-season-2)!), it does not seem to read the configuration on the mounted image.

It looks like I need to add a [`NoCloud` block](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html) to the configuration in `/etc/cloud/cloud.cfg`. I destroy this VM and start my `ubuntu-base` VM to update my reference image. Then I generate a new raw image and create a new cloud VM from that. Yay, that has my new hostname, but it is still using DHCP to configure the network interface, instead of using the static IP assigned to the VM.

It turns out the Ubuntu installer disables network configuration by `cloud-init`, hinted at by the log entry `network config disabled by system_cfg` in `/var/log/cloud-init.log`. I remove the files `/etc/cloud/cloud.cfg.d/99_installer.cfg`, `/etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg` and `/etc/netplan/00-installer-config.yaml`, then generate a new disk image yet again. This time, it boots successfully with the static IP address I configured in CBSD.

### Bridge Redux

Ok, great. Now I go to ssh into the new VM (up until now, I had been connecting to the console via VNC), but... it hangs. I double check the `bridge1` interface, and yes, it has the 10.0.0.0 `inet` alias. From the `ubuntu-test1` console, I can ssh to the hypervisor's 192.168.0.0/24 IP address just fine.

This one was a head scratcher, but finally I realized `ubuntu-test1` would not let me add the bridge's `10.0.0.0` address as the default route: `Network is unreachable`. ~~This same address had totally worked with my Debian VM.~~ _(Never mind, I had actually been setting the VM's own IP as the gateway, which did work. I still need to reread Stevens Vol 1.)_ Finally I try to give the bridge a different IP address in the 10.0.0.0/8 block, and lo, that worked. Ok, whatever.

## Cookie Cutters

I want to test one more thing: whether I can use a single `.jconf` template for creating multiple VMs in CBSD. The `jconf` file I had generated and used for `ubuntu-test1` had all the values hardcoded into it, but I need something more convenient for passing the handful of settings that need per-VM values, like the VM name and the static IP address. I edit my file, commenting out all the values that have the VM's name (some of these are derived, such as local paths for VM state). Then I create the VM from the template, passing the unique values on the command-line.

<script src="https://gist.github.com/kbruner/160f1fbe95e51e53f17715e96b473aef.js"></script>

## Command and Ctl

Doing Kubernetes the Hard Way requires several command-line tools. Fortunately, people have already contributed the FreeBSD ports for all of them, so I start compiling. (I did not check if there were pre-compiled packages.)

* `sysutils/tmux`
* `security/cfssl` (includes `cfssl` and `cfssljson` utilities)
* `sysutils/kubectl` -- As I'm building this on FreeBSD `13.0-CURRENT` the port defaults to version 1.19.4, but that probably won't pose a problem
* `devel/etcd34` -- We don't need to run the `etcd` service on the hypervisor, but I do need the `etcdctl` tool. (`etcdctl` isn't listed in the prerequisites, but I read ahead. Yes, I was That Kid.)

## NAT Done Yet

Oh, there's just one small detail. My VMs on the 10.0.0.0/8 network can connect to the hypervisor and vice versa, but my router doesn't know about that private network or how to route it. I could add a static route to FreeBSD's "public" IP, but I would rather find a more portable and FreeBSD-centric solution. I need a NAT (Network Address Translation) service. I can use FreeBSD's firewall, `ipfw(4)`, to create an in-kernel NAT service.

The `ipfw` module's defaults make it pretty easy to shoot yourself in the foot, because it automatically blocks all traffic when you load it, which would include, say, your ssh connection. I need to disable deny-all behavior, load the kernel modules, and then add the NAT and its routing rules.

<script src="https://gist.github.com/kbruner/bcf8f1a43642fc19b31bd6c655d2e93f.js"></script>

Now my VMs can make connections to the Internet, which is useful for installing stuff and that sort of thing.

* * *

With that list of tasks done, I should be ready to start creating my Kubernetes cluster from the (virtual) machine up. My [next post](/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/) will start from there.

## Sources / References

* [https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/](https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/)
* [https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)
* [https://cloudinit.readthedocs.io/en/latest/topics/examples.html](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
* [https://github.com/kelseyhightower/kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
* [https://www.bsdstore.ru/en/12.x/wf_bcreate_ssi.html](https://www.bsdstore.ru/en/12.x/wf_bcreate_ssi.html)
* [https://www.freebsd.org/doc/handbook/carp.html](https://www.freebsd.org/doc/handbook/carp.html)
* [https://www.freebsd.org/doc/handbook/firewalls-ipfw.html](https://www.freebsd.org/doc/handbook/firewalls-ipfw.html)


