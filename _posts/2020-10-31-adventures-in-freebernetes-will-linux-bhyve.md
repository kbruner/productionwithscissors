---
layout: post
title: 'Adventures in Freebernetes: Will Linux bhyve?'
date: 2020-10-31 20:38:50.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- FreeBSD Virtualization
tags:
- freebsd
- linux
- virtualization
- zfs
meta:
permalink: "/2020/10/31/adventures-in-freebernetes-will-linux-bhyve/"
excerpt: 'Part 3 of experiments in FreeBSD and Kubernetes: Linux guests'
thumbnail: /assets/images/2020/10/screenshot-2020-10-30-at-21.59.40-01.jpeg
---

_Part 3 of experiments in FreeBSD and Kubernetes: Linux guests_

[_See all posts in this series_](/freebsd-virtualization-series/)

## Prep Work

In the [previous post](/2020/10/29/adventures-in-freebernetes-bhyve-my-guest/), we started compiling the [`sysutils/grub2-bhyve`](https://svnweb.freebsd.org/ports/head/sysutils/grub2-bhyve/pkg-descr) port, required for running Linux guests with bhyve. We also need the ISO 9660 image for a Linux installer (I'm using [Arch Linux](https://www.archlinux.org/)).

`grub-bhyve` is the bhyve boot loader for Linux images. Just like we realized in the previous post that we needed to run `bhyveload` before we could run a FreeBSD guest, we need `grub-bhyve` so we can boot Linux guests.

We're assuming you've already created the virtual network interfaces (see the previous post) and no other VMs currently exist.

## Booting Linux... Maybe

<script src="https://gist.github.com/kbruner/a3c9700459bbfe73f868f1adfb343d24.js"></script>

This should bring up the [GRand Unified Bootloader (grub)](https://www.gnu.org/software/grub/) menu. Now we need to figure out where Arch Linux hides the `vmlinuz` kernel and load that.

<script src="https://gist.github.com/kbruner/7882399675642f51db3efd178d4a823f.js"></script>

And now we can boot the loaded kernel.

<script src="https://gist.github.com/kbruner/70a169cc7ea9f9f9124f322a195bc78e.js"></script>

Hmmm, that didn't work. Some searching turns up the fix: add the ISO image's label to the kernel arguments. I also made grub-bhyve barf at least once before I got it all working. (Arch names its ISOs `ARCH_YYYYMM` with the datestamp of the release version.)

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I MISSED YOU SOOOO MUCH, FREEBSD CORE FILES!!!! ❤️🔥 <a href="https://t.co/ORmzIRqrLi">pic.twitter.com/ORmzIRqrLi</a></p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1322348545064644608?ref_src=twsrc%5Etfw">October 31, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<script src="https://gist.github.com/kbruner/534d59bf84f66f7285292796ee0b7309.js"></script>

And again run the `bhyve` command to try to boot. Victory!

<script src=".js"></script>
https://gist.github.com/kbruner/1a9bac1d62d250d88eec4829f0c71524

I just gave the whole disk to the root partition because lazy.

Next we format and mount the root partition, and because the network interface was configured via DHCP at boot, we can start installing.

<script src="https://gist.github.com/kbruner/1d6176ed47802e03447f81b878ff1041.js"></script>

Ohai perl.

<script src="https://gist.github.com/kbruner/cb24ca2cc39c8983fa183e3ee2d6233e.js"></script>

Then set up time zone, locale, network configuration, etc., and power off the VM.

I take the `cd0` entry out of the `device.map` file and run `grub-bhyve` again, giving it `hd0` as the root device: `grub-bhyve -m device.map -M 1024M -r hd0 arch`

<script src="https://gist.github.com/kbruner/9e47a563830220ec7e8d96b28d6bcda1.js"></script>

Tada!

## A Guest on ZFS

Now that I have reacquainted myself with exactly how minimal Arch Linux actually is (`-bash: which: command not found` -- really???), I'll use Debian to test giving a VM its own ZFS volume instead of using a `img` file for its virtual disk.

<script src="https://gist.github.com/kbruner/f8b1ae98915f43b79292f92a7dc0de5a.js"></script>

The Debian image already has grub installed and pre-configured, so all we have to do is choose "Install."

<script src="https://gist.github.com/kbruner/26d7c45b4ebc84a5ec85ae24b2cdcf41.js"></script>

That option only loads the kernel with the installer arguments. We still have to boot it, which should drop us immediately into the interactive installer.

<script src="https://gist.github.com/kbruner/ca8d3c89858c9d0e3e20782444589dc7.js"></script>

<div align="center">
<img
src="/assets/images/2020/10/screenshot-2020-10-30-at-21.59.40-01.jpeg"
alt="Screen shot of the text-based Debian installer">
</div>
<br>


## Nobody Panic, But...

When the Debian installation finished, I exited and ran `grub-bhyve -m debian-device.map -M 1024M -r hd0 debian` and then at the grub menu, run `ls` ... FreeBSD panicked. I rebooted tried again, same outcome.

Fortunately `dmesg` was capturing the error.

<script src="https://gist.github.com/kbruner/cb7d6ec280100f7129e738b0b3b85829.js"></script>

Some searching turned up [this FAQ](https://www.freebsd.org/doc/en_US.ISO8859-1/books/faq/book.html#idp44219512), which explains that the `witness(4)` lock diagnostic watches for potential deadlocks in the kernel. (After reading _[The Design and Implementation of the FreeBSD Operating System](https://books.google.com/books/about/The_Design_and_Implementation_of_the_Fre.html?id=4vhfQgAACAAJ)_ about 10 years ago, the word "mutex" immediately makes me think of the FreeBSD kernel.)

`witness(4)` is enabled by default in `CURRENT` kernels for development and debugging purposes, and as I'm running a build of FreeBSD 13.0-CURRENT from last week, that fits.

Anyway, I am now down the FreeBSD maintainers rabbit hole, so I will throw this post out there for now. The next post should have resolution.

* * *

[The next post in this series](/2020/11/05/adventures-in-freebernetes-more-linux-bhyve-iour-plus-cbsd/), as we work toward, yes, someday actually running Kubernetes on FreeBSD, will hopefully show a working Linux-with-ZFS-disk VM and then look at [CBSD](https://cbsd.io/), which helps manage your bhyve VMs.

## Sources / References

* [https://wiki.archlinux.org/index.php/installation_guide](https://wiki.archlinux.org/index.php/installation_guide)
* [https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html](https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html)

