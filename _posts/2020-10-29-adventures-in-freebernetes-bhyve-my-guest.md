---
layout: post
title: 'Adventures in Freebernetes: bhyve My Guest'
date: 2020-10-29 20:51:16.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- FreeBSD Virtualization
tags:
- freebsd
- virtualization
meta:
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/10/29/adventures-in-freebernetes-bhyve-my-guest/"
excerpt: 'Part 2 of experiments in FreeBSD and Kubernetes: Creating your first guest'
thumbnail: /assets/images/2020/10/screenshot-2020-10-28-at-21.27.23-01.jpeg
---

_Part 2 of experiments in FreeBSD and Kubernetes: Creating your first guest_


[_See all posts in this series_]({{ site.baseurl }}//freebsd-virtualization-series/)


## bhyve Background


[bhyve](https://wiki.freebsd.org/bhyve) (pronounced as "beehive"), FreeBSD's type 2 (software) virtualization hypervisor, is pretty cool. It supports a number of operating systems as guest virtual machines (VMs), including not only the \*BSD family, but also Linux, Illumos, and even Windows NT.


<blockquote class="twitter-tweet"><p lang="en" dir="ltr">TIL MacOS&#39;s HyperKit is built on xhyve, a port of FreeBSD bhyve. Which doesn&#39;t surprise me, but cool.<br><br>You can run Docker on your Mac thanks to FreeBSD. Of course, you can run your Mac thanks to FreeBSD, too.</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1320831517497511936?ref_src=twsrc%5Etfw">October 26, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

_Apropos reminder of Mac OS X's FreeBSD roots, which are still tangled with its parent's_


[CBSD](https://cbsd.io/) will simplify managing your bhyve VMs, but first I want to create some manually, more or less, to get a taste of what goes on under the hood.


## My First Guest


First, I'm going to create a simple FreeBSD 11.4 guest. I've downloaded the 11.4 ISO image. The standard FreeBSD 13.0-CURRENT `userworld` installation has the [`bhyve` command-line interface (CLI)](https://www.freebsd.org/cgi/man.cgi?query=bhyve&sektion=8) in `/usr/sbin` and also ships with a wrapper script, `/usr/share/examples/bhyve/vmrun.sh`.


<script src="https://gist.github.com/kbruner/524520af3d507987d4e546c56de5714c.js"></script>


At this point, it should boot the FreeBSD installer/LiveCD image. If you let it go, it starts the installer or it may ask for console type first. (FYI, `cons25w` works best when I ssh to the FreeBSD host from my Chromebook Linux terminal.)


`nucklehead` gets its network configuration from my router's DHCP service. `bridge0` will also need an IP address. I ran `dhclient bridge0` to get another IP address on my LAN from router via DHCP. `em0` is the NUC's ethernet interface.


<div align="center">
<img
src="{{ site.baseurl }}/assets/images/2020/10/screenshot-2020-10-28-at-21.27.23-01.jpeg"
alt="Screen shot of FreeBSD installer progress meter">
<br>
</div>
<br>



Once the installation finishes, you can use the `Shell` option to exit the VM so you can boot off the disk image.


<script src="https://gist.github.com/kbruner/531df9737589f23374e91a43949825b1.js"></script>


…


<script src="https://gist.github.com/kbruner/370983780fdc99d939a43d0d4d66ebe2.js"></script>


The `vmm` kernel driver keeps a device file for each running VM:


<script src="https://gist.github.com/kbruner/921b4cef9f99a750dcec5ffe5900cc50.js"></script>


If I shut down the VM, the `vmm` driver should remove it. If the device file persists after you think you have shut down the VM or `bhyve` exited with an error, you can remove the running VM with `bhyvectl --destroy --vm=MYVMNAME`. If no VMs remain, `vmm.ko` should also remove the directory `/dev/vmm`.


<script src="https://gist.github.com/kbruner/449ee0e2cb3df6cbf66e66ba5d6b5473.js"></script>


## Linux Guest


bhyve also supports Linux for guest VMs.

Note that Linux VMs require the `grub-bhyve` utility from the `sysutils/grub2-bhyve` [port](https://www.freebsd.org/ports/). If you just installed FreeBSD on your hypervisor and have not installed any ports yet, you will probably need to wait awhile (all night) while the dependencies compile. Plan accordingly.


## High-Maintenance FreeBSD Guest


While we wait for the `grub-bhyve` port and its dependencies to compile, let's see what it takes to run a FreeBSD guest without the `vmrun.sh` helper script.

If we haven't rebooted since our first experiment and don't have any other VMs running, we shouldn't need to (re)create the network interfaces. We will create a new `img` file, though.

I tried to create a FreeBSD VM building off the `bhyve(8)` man page but I kept getting errors like `virtual machine cannot be booted`. So I figured the `vmrun.sh` wrapper script was responsible for more magic than just the `bhyve` command line. I made a copy, added `set -x` to capture the actual commands it was running, and then spent 15 minutes trying to figure out why my file handle redirects weren't working as intended. Oh. I forgot `root` defaults to `/bin/csh` on FreeBSD.


<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Oh, since when did root&#39;s shell default to csh on FreeBSD?<br><br>(For all I know, it&#39;s been &quot;forever,&quot; but I forgot. But wondering why my patently-Bourne shell multi-file handle redirection wasn&#39;t working was making me nuts, until I finally thought to check...)</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1321867141587570695?ref_src=twsrc%5Etfw">October 29, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


Anyway, yes, the script was doing more. There's this thing called a boot loader, see…


<script src="https://gist.github.com/kbruner/460b5f2aa34cba61dda8adfe8850497d.js"></script>


The loader menu appears…


<script src="https://gist.github.com/kbruner/57e1066e27a09ce2fd3bcf86b9446d09.js"></script>


And if all goes well, it should boot the installer/live cd image and off you go.


A couple tips:


* When creating FreeBSD guests, you will always need to run the `bhyveload` command first.
* Make sure the RAM size in the `bhyveload` and `bhyve` `-m` arguments match, or you will get the error `Unable to setup memory (22)`. (Ask me how I know.)
* When you're done with the VM, you may have to clean up manually with `bhyvectl --destroy --vm=highmaintenance`.


The `-s #,...` options are my favorite. They create virtual PCI slots. (Be sure to check out the [`bhyve` man page](https://www.freebsd.org/cgi/man.cgi?query=bhyve&sektion=8).) I am now having flashbacks to setting up CD burners on my home FreeBSD desktop a bazillion years ago.


* * *

[The next post]({{ site.baseurl }}//2020/10/31/adventures-in-freebernetes-will-linux-bhyve/) in this series will cover creating your Linux guest manually with `bhyve`. By then, with luck, your `/usr/ports` tree should have finished compiling.


## Sources / References


* [http://empt1e.blogspot.com/2016/10/bhyve-networking-options.html](http://empt1e.blogspot.com/2016/10/bhyve-networking-options.html)
* [https://en.wikipedia.org/wiki/Bhyve](https://en.wikipedia.org/wiki/Bhyve)
* [https://wiki.freebsd.org/bhyve](https://wiki.freebsd.org/bhyve)
* [https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html](https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html)


