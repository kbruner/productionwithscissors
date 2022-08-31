---
layout: post
title: 'Adventures in Freebernetes: VM Management with CBSD'
date: 2020-11-09 04:34:18.000000000 -08:00
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
permalink: "/2020/11/09/adventures-in-freebernetes-vm-management-with-cbsd/"
excerpt: 'Part 5 of experiments in FreeBSD and Kubernetes: Getting started with CBSD'
thumbnail: /assets/images/2020/11/screenshot-2020-11-08-at-15.56.30.png
---

_Part 5 of experiments in FreeBSD and Kubernetes: Getting started with CBSD_

[_See all posts in this series_](/freebsd-virtualization-series/)

[At the end of the previous post](/2020/11/05/adventures-in-freebernetes-more-linux-bhyve-iour-plus-cbsd/), I had finally finished installing CBSD and its dependencies and configuration.

## Doing Stuff with CBSD

There are a bunch of [video tutorials](https://cbsd.io/cbsd/tutorials/tutorials-with-bhyve/) for managing bhyve with CBSD. I'm going to start by trying to creating a basic FreeBSD VM.

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-05-at-08.55.48-01.jpeg"
alt="Screen shot of CBSD's text-based user interface showing menu options for creating a new bhyve virtual machine">
<br>
<i><small>
Yes, I (still) need to find a better terminal type for these menus in my Chrome OS Linux terminal. Suggestions welcome.
</small></i>
</div>
<br>

Other than choosing a `jname` of `freebsd1`, I keep all the defaults, and tell it to create the VM immediately.

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-06-at-15.16.42-01.jpeg"
alt="Screenshot of shell output after telling cbsd to create my VM immediately, with commands for interacting with the VM">
</div>
<br>


<script src="https://gist.github.com/kbruner/9fd30a4162853d3f76462bd654948b78.js"></script>

Oh, wait, I could use my Chromebook's VNC app if the VNC port was bound to a routeable IP address.

<script src="https://gist.github.com/kbruner/d1f30737e228d7afe04440f114f8c586.js"></script>

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-07-at-22.41.36.png"
alt="VNC desktop image of FreeBSD LiveCD menu">
<br>
<i><small>
Screenshot of VNC desktop view of FreeBSD CBSD guest
</small></i>
</div>
<br>


I select "Install" and let it go. After rebooting, all is copacetic.

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-07-at-23.21.27.png"
alt="Screenshot of VNC app showing FreeBSD VM console after successful boot">
</div>
<br>


With CBSD, we get a FreeBSD bhyve guest with a ZFS-backed virtual disk and VNC desktop with just a few commands. Compare that to [my first experiment](/2020/10/29/adventures-in-freebernetes-bhyve-my-guest/) with manual bhyve VM creation, when I had to create the virtual network interfaces manually, create my disk file, download the FreeBSD ISO disk image, keep track of the virtual device files, and execute separate load and boot commands each time to bring up the VM.

## Doing Linux Stuff with CBSD

Ok, a FreeBSD guest was pretty simple. What about Linux? Arch Linux was the first distribution I tried when manually creating bhyve Linux VMs, so I'll try that first with CBSD, which supports a lot of Linux distros out of the box. (You can also add others for your own use, which I will try later.)

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-07-at-23.29.21-01.jpeg"
alt="Screenshot of CBSD installer OS selector menu">
</div>
<br>


<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-07-at-23.29.55-01.jpeg"
alt="Screenshot of CBSD installer supported Linux distributions">
</div>
<br>


I selected ArchLinux, set the `jname`, set the VNC IP address so I could connect to the console from my Chromebook.

<script src="https://gist.github.com/kbruner/c6c0fdb1d50178f96814f87cf6c5146e.js"></script>

Because I don't have the ISO image stored locally, it checks its configured mirrors and starts the download.

<script src="https://gist.github.com/kbruner/10c0e4045553340238a7eb9797975ff6.js"></script>

Hmmm. I hadn't changed any other values. But that `6 bhyve_flags` bit in the `bhyve` command it's trying to run look suspicious. I look in the configuration file `/usr/cbsd/jails-system/arch1/bhyve.conf` and see the line `bhyve_flags='6 bhyve_flags'` which looks suspicious. I had descended into the bhyve flags options dialog in the UI, but hadn't changed anything. There may have been some default text there which got entered? Either way, I edit the conf file to set `bhyve_flags=''` and run `cbsd bstart arch1` again.

And got the same error. Even though I had edited the conf file, it had reverted. Apparently it's getting generated. This time I run `cbsd bset jname=arch1 bhyve_flags=''` and try again. This time, success!

<script src="https://gist.github.com/kbruner/9d9a47f39604eaa9f5eb10ddd503e372.js"></script>

<div align="center">
<img
src=""
alt="">
</div>
<br>

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-08-at-14.47.12.png"
alt="Screen shot of VNC client showing ArchLinux installer shell">
</div>
<br>


I follow [the same installation steps](/2020/10/31/adventures-in-freebernetes-will-linux-bhyve/) as earlier. (One difference: the ZFS disk shows up as `/dev/sda`). I reboot and voila.

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-08-at-15.56.30.png"
alt="Screen shot of VNC client showing rebooted ArchLinux VM console">
</div>
<br>


Ok, granted, that didn't simplify the manual installation steps for Arch Linux, but it still reduced all the steps require for configuring the virtual network interface and disk, in addition to handling UEFI.

## VM Reproduction

Using ZFS volumes for the VM virtual disk opens up the possibility of easily making copies of the VM image in the same ZFS storage pool. CBSD already has [some tooling to support creating and using ZFS volume snapshots.](https://cbsd.io/cbsd/tutorials/Cloning-a-Virtual-Machine/)

Since I've just installed a fresh Arch Linux VM, it would make a good source for a snapshot. I shut down the VM. (I don't know if this is strictly necessary, but I don't trust snapshots of unquiesced file systems. Yes, I know what AWS documentation says about EBS snapshots made on live systems being viable backups. No, they're not.)

<script src="https://gist.github.com/kbruner/a8491bf89ae0807035113eef85173c30.js"></script>

Oh, wait, I halted the VM from the shell, but I didn't shut it down in bhyve. CBSD wants me to shut it down before cloning it, so there you go. Because ZFS clones use copy-on-write, they initially take up no additional disk space. Only when blocks get written or diverge from the original snapshot do they allocate actual disk space. CBSD also supports making an actual copy of the volume, which means it will no longer require the source snapshot. A full copy can take much longer to create, depending on the size of the volume and the storage performance.

<script src="https://gist.github.com/kbruner/9b6c141caad21b7d76d042b97ba5d713.js"></script>

And my new VM boots right up!

* * *

In [the next part](/2020/11/13/adventures-in-freebernetes-a-bridge-not-far-enough/) of this series, we will look at more options with CBSD, including configuring a custom VM profile.

## Sources / References

* [https://cbsd.io/cbsd/docs/freebsd-bhyve/](https://cbsd.io/cbsd/docs/freebsd-bhyve/)

