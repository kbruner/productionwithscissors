---
layout: post
title: 'Adventures in Freebernetes: More Linux bhyve-iour Plus CBSD'
date: 2020-11-05 17:15:04.000000000 -08:00
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
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/11/05/adventures-in-freebernetes-more-linux-bhyve-iour-plus-cbsd/"
excerpt: 'Part 4 of experiments in FreeBSD and Kubernetes: UEFI Booting + Installing CBSD'
thumbnail: /assets/images/2020/11/screenshot-2020-11-05-at-08.55.48-01.jpeg
---

_Part 4 of experiments in FreeBSD and Kubernetes: UEFI Booting + Installing CBSD_

[_See all posts in this series_](/freebsd-virtualization-series/)

At the end of the previous post, I hit an issue while trying to create a Debian guest backed by a ZFS volume on the FreeBSD hypervisor. Installation from a virtual CD ISO onto the ZFS volume went fine, but when trying to boot from the ZFS virtual disk using `grub-bhyve`, the FreeBSD kernel panicked.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I&#39;m trying to create a bhyve Debian guest using a ZFS drive and FreeBSD keeps crashing... Oops.<br><br>How&#39;s your Saturday?</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1322617187400511488?ref_src=twsrc%5Etfw">October 31, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Booting with UEFI

After spending half a day waiting for the `sysutils/bhyve-firmware` port and its missing dependencies, which include the past-its-expiration-date Python 2.7, to compile, I try to boot the Debian guest using UEFI, but after a few failed attempts and more reading, it looks like converting an existing BIOS disk is iffy, especially as UEFI requires disk space of its own, which I didn't preserve.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I&#39;m still not wrong in thinking UEFI was just a plot fueled by Microsoft to increase the pain of installing OSS operating systems on PCs, right?</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1323092341628887041?ref_src=twsrc%5Etfw">November 2, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

So I boot from the installer image again, but adding UEFI bootrom. (Note that UEFI boot does not require running `bhyveload` or `grub-bhyve` first.)

<script src="https://gist.github.com/kbruner/0be1bbcbce8e4250c351e108241f6327.js"></script>

And install. And then run the same command, but without the ISO virtual device. And success!

<script src="https://gist.github.com/kbruner/52ba7d67d6d261712f71b098a9c2e5c0.js"></script>

Ok, the terminal is messed up because UEFI assumes a graphical output, so I effectively have a 3-line display. (Not joking.) So I get the IP address with `ip addr show | grep inet` (after cursing the lack of `ifconfig`) and ssh in.

So, yes, using a ZFS volume as the root disk for a Linux VM works (and should provide some disk I/O performance benefits, which I am not benchmarking), but you have to use UEFI instead of BIOS.

## Grub Booting ZFS Redux

Meanwhile, on FreeBSD Twitter, I was connected with [Chuck Tuffli](https://twitter.com/ctuffli), who gave me access to an update development version of `grub-hyve` to test with the grub-based Debian ZFS volume. Before I had overwritten my original Debian ZFS volume for UEFI booting, I had created a clone:

<script src="https://gist.github.com/kbruner/e3085004775b77a85f63da8d5825eed5.js"></script>

<script src="https://gist.github.com/kbruner/acbcc6df2c9a4a5b0f13d05b49f8845c.js"></script>

<script src="https://gist.github.com/kbruner/705729f4a9584f050ac2340cbfa9f95d.js"></script>

This time `grub-bhyve` read the ZFS volume without making FreeBSD panic, and I was able to load and boot the kernel for Debian.

Hopefully this updated `grub-bhyve` version, which also adds XFS support, will get pushed to the ports tree soon.

## Getting Ready for CBSD

The last two posts and change have demonstrated some of the permutations of possible bhyve guests and the amount of effort even simple proofs-of-concept involve.

The [CBSD](https://cbsd.io/) project exists to help manage that complexity. While it also supports FreeBSD jails and Xen VMs, I'm going to focus on bhyve. I'm building it from the `sysutil/cbsd` port, so now, among other packages, I now have `sudo` installed.

After the port finishes compiling, it reminds the user to finish installation by running `env workdir="/usr/cbsd" /usr/local/cbsd/sudoexec/initenv` and interactively fed it the following values:

<script src="https://gist.github.com/kbruner/2e469cf22bfdacf0e318eae103be5258.js"></script>

## Running CBSD

With that installed, I reboot the host to clear the network interfaces and VMs I had created and then try to start bhyve.

```
root@nucklehead:~ # cbsd bconstruct-tui
No kldloaded module: vmm
Please add vmm_load="YES" to /boot/loader.conf and
put kld_list="vmm if_tuntap if_bridge nmdm" into your /etc/rc.conf then reboot the host.
Press any key...
```

Given then the CBSD had added entries to both files, I'm assuming it skipped these because they had been loaded in the running kernel when I ran `initenv`, but it did not or could not test for cross-boot persistence.

After adding the entries and rebooting, I try again.

```
root@nucklehead:~ # cbsd bconstruct-tui
The current version requires tmux
Please run pkg install tmux or make -C /usr/ports/sysutils/tmux install it.
```

<script src="https://gist.github.com/kbruner/e23839d8ce507c965be32615a6cd4144.js"></script>

That did not require installing half the ports tree this time, so when I ran `cbsd bconstruct-tui` again, it opened the text UI. Third time's a charm.

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-05-at-08.55.48-01.jpeg"
alt="Screen shot of CBSD's text-based user interface showing menu options for creating a new bhyve virtual machine">
<br>
<i><small>
Yes, I need to find a better terminal type for these menus in my Chrome OS Linux terminal. Suggestions welcome.
</small></i>
</div>
<br>

* * *

[The next post](/2020/11/09/adventures-in-freebernetes-vm-management-with-cbsd/) will focus on experiments with CBSD.

## Sources / References

* [https://cbsd.io/](https://cbsd.io/)
* [https://cbsd.io/cbsd/docs/Quick-start/](https://cbsd.io/cbsd/docs/Quick-start/ )
* [https://www.freebsd.org/doc/en\_US.ISO8859-1/books/handbook/virtualization-host-bhyve.html](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/virtualization-host-bhyve.html)

