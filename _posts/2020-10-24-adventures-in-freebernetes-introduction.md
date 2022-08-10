---
layout: post
title: 'Adventures in Freebernetes: Introduction'
date: 2020-10-24 22:49:23.000000000 -07:00
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
- virtualization
meta:
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/10/24/adventures-in-freebernetes-introduction/"
excerpt: Introduction to a series of experiments with FreeBSD and Kubernetes
thumbnail: assets/images/2020/10/5680040477_3796979f90_o.jpg
---

_Introduction to a series of experiments with FreeBSD and Kubernetes_


[_See all posts in this series_]({{ site.baseurl }}/freebsd-virtualization-series/)


For various reasons, some of which are far too scary even for this blog, I haven't felt really excited or motivated to hack on tech in a long time.


I've worked a lot around Kubernetes recently, but, while Windows support is emerging, I wondered where it stood for [FreeBSD](https://www.freebsd.org/). I worked with FreeBSD for years and miss it.


<div align="center">
<img
src="{{ site.baseurl }}/assets/images/2020/10/5680040477_3796979f90_o.jpg"
alt="Picture of a crocheted doll of the FreeBSD daemon, the operating system's mascot.">
<br>
<i><small>
My crocheted interpretation of the BSD Daemon
</small></i>
</div>
<br>




As it stands, two main approaches for running Kubernetes on FreeBSD exist: running Docker using FreeBSD's Linux compatibility layer, or using [bhyve](https://wiki.freebsd.org/bhyve), a virtualization hypervisor for FreeBSD which can support various \*BSD and Linux guests, with [CBSD](https://cbsd.io/) as the management layer. bhyve became standard after I stopped working with FreeBSD, but as what seems to be like the natural progression along the lines of FreeBSD's [jail](https://wiki.freebsd.org/Jails) system, I'm down with that.


And all of a sudden, I was getting excited about tinkering with something again.


## Getting Started


All my work the last number of years has been in the cloud, and I'm not a PC gamer anymore, so the only hardware I have at home is either really old or a Chromebook. (I spent a long time working in or near machine rooms and data centers, and I'm hardly afraid of hardware, but it's not how I generally want to fill my spare time or my home.) While it's possible to get FreeBSD running on the virtual machine offerings on most? all? cloud providers, trying to do that in conjunction with tinkering through new stuff seemed less appealing to me, so I decided to look for a low-cost hardware option. I don't need a lot of power, but bhyve in particular has [CPU requirements for virtualization](https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html).


My friend Brad offered his old [NUC](https://www.intel.com/content/www/us/en/products/boards-kits/nuc/mini-pcs.html) which had been collecting dust. It has a compatible CPU (Intel Core i5 blahblahblah), so golden!


### The Installer


I grabbed the latest USB drive installer image for FreeBSD 13.0-CURRENT. FreeBSD 12 is the current release version, and it supports bhyve, but bleeding edge, or whatever.


The FreeBSD installer .img file needs to be copied bytewise to the USB stick. Drop'n'drag to any file system type, let alone `FATxx`, is not an option. However, even though Chrome OS's native Linux support/emulation/whatever-they-want-to-call-it has improved dramatically, it's hardly seamless, and it doesn't support direct USB device access, so no `dd`. (I used my ancient Linux laptop instead, which makes scary noises whenever I try to open the lid with the broken hinge.)


### The Setup


I have one HDMI-compatible display: my TV. (I've decided to get an inexpensive HDMI capture interface to make future efforts like this easier, but I wasn't going to wait for one to show up.) So I set up the NUC, at least for now, in front of my TV, stringing a 20' Ethernet cable to the router in the next room for Internet, although that was probably unnecessary. Again, it had been so long since I installed FreeBSD from scratch, I couldn't remember if any options required a network connection, even with the installation drive. (Note: nothing I did during the installation process hit the network.)


* * *

In [Part 1]({{ site.baseurl }}/2020/10/25/adventures-in-freebernetes-installing-freebsd/), I'll write up step-by-step how I (eventually) successfully installed FreeBSD 13.0-CURRENT with ZFS-on-root.


