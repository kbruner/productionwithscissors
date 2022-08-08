---
layout: post
title: 'Adventures in Freebernetes: Certs, Certs, DNS, More Certs'
date: 2020-11-26 00:36:37.000000000 -08:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- FreeBSD Virtualization
tags:
- dns
- freebsd
- ipv4
- kubernetes
- linux
- virtualization
meta:
  _last_editor_used_jetpack: block-editor
  _thumbnail_id: '0'
  _wpcom_is_markdown: '1'
  _oembed_783ce91522136c3d54332a75c68a3c32: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I
    won&#39;t give out and do not want the root password on a Linux host ever again,
    but I cannot bring myself to install sudo on my personal FreeBSD machines.<br><br>wheel
    group and su -<br><br>That is the way.</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1330424565772791813?ref_src=twsrc%5Etfw">November
    22, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_783ce91522136c3d54332a75c68a3c32: '1606352564'
  _oembed_311a6887ab54a78898d38aead43f2a87: "{{unknown}}"
  _oembed_b888abc0a2e55f0924270ac6641252a1: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">I
    won&#39;t give out and do not want the root password on a Linux host ever again,
    but I cannot bring myself to install sudo on my personal FreeBSD machines.<br><br>wheel
    group and su -<br><br>That is the way.</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1330424565772791813?ref_src=twsrc%5Etfw">November
    22, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _publicize_job_id: '51484384475'
  timeline_notification: '1606351001'
  _oembed_b9ac78fe259d186745598ed987c7c824: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I
    won&#39;t give out and do not want the root password on a Linux host ever again,
    but I cannot bring myself to install sudo on my personal FreeBSD machines.<br><br>wheel
    group and su -<br><br>That is the way.</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1330424565772791813?ref_src=twsrc%5Etfw">November
    22, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_b9ac78fe259d186745598ed987c7c824: '1606351002'
  _oembed_08738dfc3379ca8621d3cfd6a78cc361: "{{unknown}}"
  _oembed_ed377b4ee7a4a1c1e1e187d0337ee590: "{{unknown}}"
  _oembed_eede1259dba14115ceefc08f839775bf: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I
    won&#39;t give out and do not want the root password on a Linux host ever again,
    but I cannot bring myself to install sudo on my personal FreeBSD machines.<br><br>wheel
    group and su -<br><br>That is the way.</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1330424565772791813?ref_src=twsrc%5Etfw">November
    22, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_eede1259dba14115ceefc08f839775bf: '1606351003'
  _oembed_47dd70901e633fddc5b0e07d29a3d68e: "{{unknown}}"
  _oembed_256d503276b280fbf7ce1d36e53bace2: "{{unknown}}"
  _oembed_time_b888abc0a2e55f0924270ac6641252a1: '1606351029'
  _oembed_e98d1ddcc9f99d0b1f2fb783e0777d88: "{{unknown}}"
  _oembed_b7609a4484ea122d55bb0a30ba192ea6: "{{unknown}}"
  _oembed_666fce4c34941abfc64b27d737474292: "{{unknown}}"
  _oembed_a7eca547f30f78bdfe25e56c17761eff: "{{unknown}}"
  _oembed_e79b32b4db433d4ec4c67ae22a10d41c: "{{unknown}}"
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/"
excerpt: 'Part 10 of experiments in FreeBSD and Kubernetes: More Net Work Plus Initial
  Cluster Creation Tasks'
---
<!-- wp:paragraph {"fontSize":"medium"} -->

_Part 10 of experiments in FreeBSD and Kubernetes: More Net Work Plus Initial Cluster Creation Tasks_

<!-- /wp:paragraph -->

<!-- wp:paragraph {"fontSize":"normal"} -->

[_See all posts in this series_](https://productionwithscissors.run/freebsd-virtualization-series/)

<!-- /wp:paragraph -->

<!-- wp:heading {"level":4} -->

#### Table of Contents

<!-- /wp:heading -->

<!-- wp:html -->

1. [Provisioning Compute Resources](#provisioning-compute-resources)

- [Rabbit Hole #1: DNS](#rabbit-hole-1-dns)
- [Creating Instances](#creating-instances)
- [Generating the Certificate Authority and Certs](#generating-certificate-authority)

- [Rabbit Hole #2: Fake Load Balancing](#rabbit-hole-2-fake-load-balancing)
- [Back to the Certificates](#back-to-certificates)
- [Generating Kubernetes Configuration Files for Authentication](#generating-kubernetes-configuration-files)
- [Generating the Data Encryption Config and Key](#generating-data-encryption-config)
- [Sources / References](#sources-references)

<!-- /wp:html -->

<!-- wp:paragraph -->

In [the previous post](https://productionwithscissors.run/2020/11/24/adventures-in-freebernetes-getting-ready-to-do-kubernetes-the-harder-way/) in this series, I had finished creating [a raw image of Ubuntu Server 20.04](https://productionwithscissors.run/2020/11/24/adventures-in-freebernetes-getting-ready-to-do-kubernetes-the-harder-way/#great-image-bake-off-season-2) with cloud-init configured for use with CBSD to create `bhyve` virtual machines. I also [installed the tools](https://productionwithscissors.run/2020/11/24/adventures-in-freebernetes-getting-ready-to-do-kubernetes-the-harder-way/#command-and-ctl) I would need to work through the [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) tutorials to create a Kubernetes cluster completely manually, and [I configured `ipfw`](https://productionwithscissors.run/2020/11/24/adventures-in-freebernetes-getting-ready-to-do-kubernetes-the-harder-way/#nat-done-yet) on my FreeBSD hypervisor to act as a NAT (Network Address Translation service) so my VMs, which have their own private network, can still reach sites on the Internet. I will still have [a few details to work out](https://productionwithscissors.run/2020/11/24/adventures-in-freebernetes-getting-ready-to-do-kubernetes-the-harder-way/#make-the-net-work), mainly around Kubernetes cluster networking, but I should be ready to start.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

A few details for reference:

<!-- /wp:paragraph -->

<!-- wp:list -->

- My hypervisor is named `nucklehead` (it's an Intel NUC) and is running FreeBSD 13.0-CURRENT
- My home network, including the NUC, is in the 192.168.0.0/16 space
- The Kubernetes cluster will be in the 10.0.0.0/8 block, which exists solely on my FreeBSD host
- Yes, I am just hanging out in a root shell on the hypervisor.

<!-- /wp:list -->

<!-- wp:embed {"url":"https:\/\/twitter.com\/fuzzyKB\/status\/1330424565772791813","type":"rich","providerNameSlug":"twitter","responsive":true,"className":""} -->

https://twitter.com/fuzzyKB/status/1330424565772791813

<!-- /wp:embed -->

<!-- wp:heading -->

## [Provisioning Compute Resources](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/03-compute-resources.md)

<!-- /wp:heading -->

<!-- wp:paragraph -->

I've already done the relevant initial steps and skipped those that are specific to GCP, so now I need to [create the VMs](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/03-compute-resources.md#compute-instances) for the cluster. In the previous post, I generated a VM settings file to use with CBSD in order to make consistent creation simpler from the command-line.

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Rabbit Hole #1: DNS

<!-- /wp:heading -->

<!-- wp:paragraph -->

I started creating VMs before I remembered one [network detail](https://productionwithscissors.run/2020/11/24/adventures-in-freebernetes-getting-ready-to-do-kubernetes-the-harder-way/#make-the-net-work) I had punted in the previous post: hostname resolution. I could just do low-initial-friction-but-potentially-annoying-later-on solution of hardcoding the cluster members into `/etc/hosts` on all the VMs and the hypervisor, but that solution, while perfectly serviceable, would not be _the harder way_ of solving my resolution issues. Yes, I need to set up a DNS server locally on FreeBSD.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

FreeBSD offers the recursive-only server `Unbound` in its base system. However, I need an authoritative server for my `.local` domain. NSD (Name Server Daemon) can only operate as an authoritative server, so between the two, my DNS resolution problems would be solved. I install the `dns/nsd` port and start configuring.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I follow [this Unbound/NSD tutorial](https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html) for setting up the two services on FreeBSD to serve a private domain. I name my domain `something.local` because I just can't think of anything clever right now. I get both services configured and now I can resolve stuff from the host.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/c11447a56157bbf6c2d72a03827ceea8","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/c11447a56157bbf6c2d72a03827ceea8

_I don't know why WordPress forces http:// on "www.google.com" but, no, it's not in the gist, and yes, it's annoying the crap out of me_

<!-- /wp:embed -->

<!-- wp:heading {"level":3} -->

### Creating Instances

<!-- /wp:heading -->

<!-- wp:paragraph -->

[The Kubernetes the Hard Way tutorial](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/03-compute-resources.md#kubernetes-controllers) uses the GCE [`e2-standard-2` GCE machine type](https://cloud.google.com/compute/docs/machine-types#e2_standard_machine_types), which have 2 virtual CPUs and 8Gb RAM. I need three VMs for the control plane and three for the worker nodes.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Apparently I also need to pass the pod CIDR for each node (they can't share address ranges) in via the VM metadata. I will quickly try to accomplish this by creating a new cloud-init template for CBSD (by copying the `centos7` template I'm currently using) in `/usr/local/cbsd/modules/bsdconf.d/cloud-tpl` and add a field for called `pod-cidr` in the `meta-data` file. If it works, great. If not, I may try to find another way to inject/distribute the value. Oh, who am I kidding. I will fiddle with it endlessly until I find a way to shove that value through cloud-init.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

It turns out I also needed to update the default cloud-init template's network configuration format from version 1 to version 2, because some settings, such as the default gateway, were not getting applied.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/93a74c451370cd28f5b35dd86fe7b55d","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/93a74c451370cd28f5b35dd86fe7b55d

<!-- /wp:embed -->

<!-- wp:paragraph -->

I add the `ci_pod_cidr` field to my VM settings file and update my VM template in `/usr/cbsd/etc/defaults` to use the new cloud-init template. I also have to add the new variable to the script `/usr/cbsd/modules/cloudinit` so it will be interpolated in the generated files.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

For reference, here are the values I am using when creating my cluster instances:

<!-- /wp:paragraph -->

<!-- wp:list -->

- VM size: 2 CPUs, 8 Gb RAM
- Node network CIDR block: 10.10.0.0/24
- Pod network CIDR block: 10.100.0.0/16
- Root disk: 10Gb _Ok, the tutorial uses 200Gb root disks, but that's the size of my entire ZFS pool, so no. If I regret this later, I should be able to resize the underlying ZFS volumes. Theoretically._

<!-- /wp:list -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/6ebc18605892ef2a234c76f8699b0524","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/6ebc18605892ef2a234c76f8699b0524

<!-- /wp:embed -->

<!-- wp:paragraph -->

Then I do the same thing again, except the hostnames have the prefix `worker-` and I also pass the `ci_pod_cidr` key-value pair to `cbsd bcreate`.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/fae8c4ff65731ec9ea9ecbebaf9dc087","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/fae8c4ff65731ec9ea9ecbebaf9dc087

_My cluster VMs, plus the ubuntu-base VM, which is turned off_

<!-- /wp:embed -->

<!-- wp:paragraph -->

The instances are all running with the correct hostnames and IP addresses, and DNS resolves properly on the host and in the VMs. CBSD sets the SSH key for the `ubuntu` user in the VM, so everything is ready for the next step.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## [Generating the Certificate Authority and Certs](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/04-certificate-authority.md)

<!-- /wp:heading -->

<!-- wp:paragraph -->

This section is mostly pretty straightforward, other than replacing the `gcloud` commands with appropriate calls and omitting the non-existent external IP address. Since I setup DNS, I could just do this to look up the instance IP addresses: `INTERNAL_IP=$(host $instance | awk '{print $4}')`

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Rabbit Hole #2: Fake Load Balancing

<!-- /wp:heading -->

<!-- wp:paragraph -->

However, when it comes time to generate the API server certificate, I need to supply the IP address for the endpoint, which, in the tutorial, is a Google Cloud load balancer. As I mentioned in [the previous post](https://productionwithscissors.run/2020/11/24/adventures-in-freebernetes-getting-ready-to-do-kubernetes-the-harder-way/#make-the-net-work), I don't really want to run my own load balancer service for this experiment. I thought I could use FreeBSD's `carp(4)` module to simulate basic load balancer functionality, but it doesn't quite work that way.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

However, I _can_ use `ipfw(4)` module. I'm already using `ipfw` to handle Network Address Translation for my cluster network.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/978b281eaaf2e7ebf282d7125bd024e0","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/978b281eaaf2e7ebf282d7125bd024e0

<!-- /wp:embed -->

<!-- wp:paragraph -->

Here I create forwarding rules, one for each of the three controller hosts. Each rule matches traffic from any source to 10.10.0.1, the IP address I chose for the `kube-apiserver`. However, they each forward to a different controller host. The `prob` argument assigns a 1/3 chance of matching rule 200, a 1/2 chance (as rule 200 would already have failed to match) of matching rule 201, and rule 202 has a 100% chance of matching if the previous two rules failed. This effectively gives each backend a 33% chance of receiving a given connection that was made to 10.10.0.1. The `keep-state` argument ensures that all the packets in a TCP stream go to the same backend server.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Perhaps not so coincidentally, [`kube-proxy` in `iptables`](https://kubernetes.io/docs/concepts/services-networking/service/#proxy-mode-iptables) mode uses an analogous version of round-robin load balancing traffic to a [`Service`'s virtual IP address](https://www.stackrox.com/post/2020/01/kubernetes-networking-demystified/) across the backend pods for that service.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Anyway, I also add the `kube-apiserver`'s 10.10.0.1 virtual IP to each of the controllers so they will accept traffic to that IP. And, as you can see above, if I `ssh` (the only TCP service the VMs had running at this point) to 10.10.0.1, I get a different host when I connect.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I also add an `A` record for `kubernetes` and the new IP to my `something.local` zone.

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Back to the Certificates

<!-- /wp:heading -->

<!-- wp:paragraph -->

Now that I have the virtual endpoint set up, I can use its IP address to generate the `kube-apiserver` certificate.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## [Generating Kubernetes Configuration Files for Authentication](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/05-kubernetes-configuration-files.md)

<!-- /wp:heading -->

<!-- wp:paragraph -->

This section is very straightforward. The only modifications necessary involved replacing a couple `gcloud` commands.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## [Generating the Data Encryption Config and Key](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/06-data-encryption-keys.md)

<!-- /wp:heading -->

<!-- wp:paragraph -->

This section requires swapping the Linux standard `base64` command with FreeBSD's `b64encode`: `ENCRYPTION_KEY=$(head -c 32 /dev/urandom | b64encode -r -)`

<!-- /wp:paragraph -->

<!-- wp:separator -->

* * *
<!-- /wp:separator -->

<!-- wp:paragraph -->

Now that my cluster has all the certificates and other cluster authentication files, the [next post](https://productionwithscissors.run/2020/11/28/adventures-in-freebernetes-my-out-of-control-plane/) will pick up at the next step: bootstrapping `etcd`.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Sources / References

<!-- /wp:heading -->

<!-- wp:list -->

- [https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html](https://blog.socruel.nu/freebsd/how-to-implement-unbound-and-nsd-on-freebsd.html)
- [https://github.com/kelseyhightower/kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [https://www.freebsd.org/doc/handbook/firewalls-ipfw.html](https://www.freebsd.org/doc/handbook/firewalls-ipfw.html)
- [https://www.freebsd.org/doc/handbook/network-dns.html](https://www.freebsd.org/doc/handbook/network-dns.html)

<!-- /wp:list -->

<!-- wp:paragraph -->

<!-- /wp:paragraph -->

