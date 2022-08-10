---
layout: post
title: 'Adventures in Freebernetes: A Bridge Not Far Enough'
date: 2020-11-13 23:29:04.000000000 -08:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- FreeBSD Virtualization
tags:
- freebsd
- ipv4
- linux
- virtualization
meta:
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/11/13/adventures-in-freebernetes-a-bridge-not-far-enough/"
excerpt: 'Part 6 of experiments in FreeBSD and Kubernetes: Automated VM installation with CBSD and falling down the network rabbit hole'
thumbnail: /assets/images/2020/11/screenshot-2020-11-11-at-22.01.30-01.jpeg
---

_Part 6 of experiments in FreeBSD and Kubernetes: Automated VM installation with CBSD and falling down the network rabbit hole_


[_See all posts in this series_]({{ site.baseurl }}freebsd-virtualization-series/)


## Automated CBSD VMs with Cloud-Init


In the previous post, we cloned a VM by using a snapshot of the ZFS volume of an Arch Linux volume we had installed from (virtual) CD. You can also automate OS bootstrapping in CBSD by using [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html#).


I speed through `cbsd bconstruct-tui`, use all the defaults (except changing the default VNC address to the NUC's network interface card (NIC)), and hit go. Except then it tells me I need to set `cloud_options` so I go back and do that, using all the defaults except user password. (I took the screenshot before changing that.)


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-13-at-13.04.33-01.jpeg"
alt="Screenshot of the cloud-init options menu in cbsd">
<br>
<i><small>
cloud-init options menu
</small></i>
</div>
<br>


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-11-at-22.01.30-01.jpeg"
alt="Main cbsd bhyve menu with everything filled out">
<br>
<i><small>
Ok, ready to go
</small></i>
</div>
<br>


<script src="https://gist.github.com/kbruner/4285179f1bc58f31bbd07af39d018cfb.js"></script>


It boots up and everything on the console (viewed via VNC) looks ok.


Ok, great, except... the new VM's IP defaulted to 10.0.0.1. And my NUC and LAN subnet are in the 192.168.0.0/24 space, sooooo.... that's not good. Or is it?


I try `ssh debian@10.0.0.1` and it fails to connect. Ok, so now we enter...


## The Rabbit Hole


So, ok, the VM virtual NICs are all members of the same [bridge](https://www.freebsd.org/doc/handbook/network-bridging.html), so shouldn't I be able to route to the VM's virtual NIC?


<script src="https://gist.github.com/kbruner/f7c39e1215ca4b983cb89e4a9f259557.js"></script>


Oh, hey, there's no entry for 10.0.0.0/8 or specifically 10.0.0.1, so traffic to it goes through the default gateway, which is the physical NIC (`em0`) connected to my router. My router doesn't know about 10.0.0.1 because it's not configured to.


So, I could try adding a static route in my router, or I could try adding a local route on the NUC, right?


Well, CBSD didn't give `bridge1` an IP address. FreeBSD's `route(8)` command requires an IP address rather than an interface for a route's gateway. Hrm, ok. First I'll give it the IP address for `em0` since that's a member of `bridge1` along with `tap5`.


<script src="https://gist.github.com/kbruner/908361b9a613629c315b76e70e1c1e97.js"></script>


Ok, that didn't work. What if we give `bridge1` an IP address?


<script src="https://gist.github.com/kbruner/77d4a54067724db92a84e42f1f266d27.js"></script>


That didn't help.


To try to trace whether the connection is even trying to send packets through `bridge1`, I fire up `tcpdump -i bridge1 'host 10.0.0.1'` and get nothing. I try watching on the `em0` interface, nothing. I remove the 10.0.0.0/8 rule and try again. Ah, yes, without a route entry for 10.0.0.0/8, it does send the packets out on `em0`. (Of course, we never get a reply.)


<script src="https://gist.github.com/kbruner/06d71cc68a8d41b2c53480ecabeb3595.js"></script>


By now I've read everything about FreeBSD bridging and my google-fu isn't picking up anything which seems like an obvious answer to my issue. However, I did not RTFM very _well_.


Bridges bridge _networks_. While `dhclient` had assigned a IP address to `bridge1`, it was effectively treated as a /32 subnet. I had this a-ha moment re-reading the [handbook page on bridging](https://www.freebsd.org/doc/handbook/network-bridging.html), looking at the examples like `ifconfig bridge0 inet 192.168.0.1/24`. It's not assigning a single IP address; it's assigning the class C network 192.168.0.0/24 (not a typo; 192.168.0.0/24 and 192.168.0.1/24 are equivalent) to the bridge interface.


And at this point I start to wonder how much IPv4 knowledge my brain has lost and if I should re-read Stevens Vol 1 instead of using it as a stepping stool when I can't reach the top shelf of the bookcase.


Ok. so I kill the `dhclient` process for `bridge1`, remove the 192.168.0.14/32 IP, add 10.0.0.0/8, and...


<script src="https://gist.github.com/kbruner/5e1effc7c4c6b39207f5db72b6c0520b.js"></script>


Yay! Ok, we can now exit that rabbit hole.


## Still in the Rabbit Hole


Ok, that's great, except even though I can make a successful bi-directional connection _to_ my 10.0.0.1 VM, the VM itself has no idea how to get out.


<script src="https://gist.github.com/kbruner/410746d4f9a0d4ac3320a99dbcb0567c.js"></script>


Ok, so I need to add a default route. I assume it should use the VM's interface as the gateway, as it's a member of the NUC's bridge and, well, nothing else has a 10.0.0.0/8 address to act as a gateway.


<script src="https://gist.github.com/kbruner/3eef5e071a053ea81d401feb3eeadc11.js"></script>


Success! I'm not sure why the attempts to read the routing table seemed to hang (I only gave them a few seconds before interrupting, but normally they return quickly), but enough of this networking rabbit hole.


* * *

Ok, that was very exciting, We booted and installed a VM without additional human intervention, I remembered that I used to know more about IPv4 without necessarily remembering what I used to know, and we can now put our VMs on arbitrary subnets and still route back and forth. Ideally, though, we'd want to add to the default gateway the `cloud-init` setup.


In the next part of this series, I may or may not look at configuring a Linux distro installation from scratch in CBSD, depending on whether I fall into another rabbit hole along the way


## Sources / References


* [https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/](https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/)
* [https://www.freebsd.org/doc/handbook/network-bridging.html](https://www.freebsd.org/doc/handbook/network-bridging.html)


