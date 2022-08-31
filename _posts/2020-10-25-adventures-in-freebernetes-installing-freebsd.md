---
layout: post
title: 'Adventures in Freebernetes: Installing FreeBSD'
date: 2020-10-25 07:59:17.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- FreeBSD Virtualization
tags:
- freebsd
- zfs
- virtualization
meta:
permalink: "/2020/10/25/adventures-in-freebernetes-installing-freebsd/"
excerpt: Part 1 of experiments in FreeBSD and Kubernetes
thumbnail: /assets/images/2020/10/pxl_20201023_210133887-01.jpeg
---

_Part 1 of experiments in FreeBSD and Kubernetes_

[_See all posts in this series_](/freebsd-virtualization-series/)

[Read the introduction to this series](/2020/10/24/adventures-in-freebernetes-introduction/) for background. This post documents getting a working, bootable installation of FreeBSD 13.0-CURRENT on an older NUC PC.

This post is roughly divided into two parts: the rather-chatty story version and then the actual step-by-step instructions for how I finally got a successful installation.

[Skip straight to the step-by-step instructions for a custom, manual FreeBSD 13.0-CURRENT ZFS-on-root + EFI boot install](#zfs-on-root)

## Day 1: The Adventure Begins
<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Ok, I got the FreeBSD 13.0-CURRENT memstick image, used my ancient Linux laptop to dd it onto the USB drive.<br><br>My only HDMI display is my TV, sooooo I&#39;m currently sitting on the floor in front of it (don&#39;t have an HDMI cable + USB elongator for the keyboard to reach the couch).</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1319742463527940097?ref_src=twsrc%5Etfw">October 23, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

_The adventure begins on Twitter. And on my floor._

CBSD strongly recommends using a [ZFS](https://www.freebsd.org/doc/handbook/zfs.html) filesystem. My experience with FreeBSD also mostly predates widespread production use of ZFS. And of course, modern UEFI booting is always super-fun when you're not Windows. Brad had made the NUC dual-boot Linux along with the original Windows 10 installation. Even though I avoid Windows whenever possible, for some weird, OS-pack-rat reason, I decided I would try to preserve the Windows installation if possible.

<div align="center">
<img
src="/assets/images/2020/10/pxl_20201023_202719424.jpg"
alt="Picture of the FreeBSD installer's text-based UI with blue background, asking if you want to install, run a shell, or launch the Live CD">
<br>
<i><small>
The FreeBSD installer: The happiest blue screen
</small></i>
</div>
<br>

The only option in the FreeBSD installer for a custom ZFS installation is via shell and use gpart. (The stalwart FreeBSD fdisk is available, but none of the guides I saw recommended using it. I'm not sure if it has to do with UEFI support or what, but I didn't dig.)

<div align="center">
<img
src="/assets/images/2020/10/pxl_20201023_210133887-01.jpeg"
alt="Image of screen with an interactive shell running gpart commands to create and view disk partitions">
<br>
<i><small>
Fun with gpart, said no one ever
</small></i>
</div>
<br>

I went through one guide and the installation seemingly completed successfully but... it wouldn't boot. I messed with the efi stuff a bit; nothing. Trying to bypass UEFI and use the boot loader from the USB stick; even though the boot loader could read the ZFS pool that I had installed just fine, I couldn't get it to boot. It failed with "unknown file system." Not sure if I missed some settings to enable ZFS-on-root that would normally be passed in `/boot/loader.conf`.

At this point, based on bits of what I'd seen in search results and the age of the NUC's BIOS (4+ years), it seemed like a good idea to upgrade that, so I did. Still, no dice. I decided to sleep on it and if I still couldn't boot, try a fresh install in the morning.

Even though I didn't have a successful boot, I had gotten reacquainted with gpart and I had messed around with ZFS enough to get familiar with some of the basic commands.

## Day 1, The Sequel: The Adventure Begins Again

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Day 2 of Operation Free BSD<br><br>I updated the BIOS last night. Now trying to see I can manually boot from the ZFS-on-root partition, except Ziggy and George are having their 11AM zoomies so I keep getting distracted and miss the menu to exit into the boot loader.</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1320067211864621058?ref_src=twsrc%5Etfw">October 24, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

The BIOS upgrade didn't cure the problem, so I decided to start from scratch with a different guide. I ended up working from [this how-to](https://wiki.freebsd.org/MasonLoringBliss/ZFSandGELIbyHAND), even though it uses a ZFS pool on mirrored disks with [geli](https://www.freebsd.org/cgi/man.cgi?geli(8)) encryption.. I only have one disk (which is partitioned), and I'm not interested in geli for the time being, so I just stripped out the mirroring- and encryption-specific steps.

I restarted the installer, used the shell option for disk partition, deleted the partitions I had previously created, and ended up with this partition table:

<script src="https://gist.github.com/kbruner/b5705fab6c1dc77374f2604a2284e3eb.js"></script>

One important change: I did have to increase the source example's sizes for the `efi` and `freebsd-boot` partitions, presumably because they were too small for the files I had to copy in. No big deal. The `freebsd-boot` partition went in there in case I kept having issues with UEFI and tried to make legacy boot work instead.

Fortunately, the how-to also warned about this little potential issue with `/dev/null`:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">That&#39;s not good. <a href="https://t.co/HmX92ta1SI">pic.twitter.com/HmX92ta1SI</a></p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1320096641840394241?ref_src=twsrc%5Etfw">October 24, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

But this time around, success!

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Woohoo! Success! Booting from the ZFS root with no human intervention! <a href="https://t.co/Glj4WaJiHn">pic.twitter.com/Glj4WaJiHn</a></p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1320104084183994368?ref_src=twsrc%5Etfw">October 24, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

I still didn't figure out how to boot from ZFS-on-root from the boot loader (I tried that before letting UEFI go) so I'm sure I'm missing something. It's been years since I've had to spend any time with the FreeBSD loader, and the ZFS and UEFI stuff in it is all new to me. I may go back to figure it out later, or not.

Anyway, my FreeBSD 13.0-CURRENT PC is all humming. Next I'll work on getting bhyve (probably via CBSD) up and running. I've never touched bhyve before, so I'm curious to see what that looks like.

<a id="zfs-on-root"/>
## Step-by-Step Manual ZFS-on-root FreeBSD Install

_USE AT YOUR OWN RISK_. Seriously, I have no idea what I'm doing.

Derived from [this how-to](https://wiki.freebsd.org/MasonLoringBliss/ZFSandGELIbyHAND), which also includes geli disk encryption and mirrored disks.

My system and use case (if yours differs you may have to make alterations or use a different tutorial completely):

* a single drive with existing partitions I didn't want to delete (no second disk so no mirroring)
* no geli encryption
* disk already uses GPT partitioning. If it uses Master Boot Record and you want to keep the existing partitions, you'll need to find another tutorial!
* x64 CPU

For reference, my PC's disk device is `nvd0` and I named my ZFS pool `zroot`.

   1. Boot the FreeBSD installer as usual
   1. When you get to the disk partition menu, choose the `Shell` option
   1. Using gpart, _carefully_ delete any partitions you no longer want
   1. Create the new FreeBSD partitions and ZFS file system
<script src="https://gist.github.com/kbruner/852949efb55b34c26b895132f4781b6b.js"></script>
   1. Proceed as normal. At the end of the installation, when the installer asks if you want to reboot or exit to a shell, choose `Shell` to finish the efi configuration.
<script src="https://gist.github.com/kbruner/312dfdabfd57c171a62c1add88a511b6.js"></script>

Let the system reboot. Remove the installer media or manually select the disk for the boot device. With luck, it will boot on its own, through to your login prompt!

* * *

[Part 2](/2020/10/29/adventures-in-freebernetes-bhyve-my-guest/) covers creating my first FreeBSD bhyve guest.

## Sources / References

* [https://wiki.freebsd.org/MasonLoringBliss/ZFSandGELIbyHAND](https://wiki.freebsd.org/MasonLoringBliss/ZFSandGELIbyHAND)
* [https://www.freebsd.org/doc/handbook/zfs.html](https://www.freebsd.org/doc/handbook/zfs.html)

