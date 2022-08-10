---
layout: post
title: 'Adventures in Freebernetes: Cloudy with a Chance of Rain'
date: 2020-11-19 01:11:11.000000000 -08:00
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
meta:
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/11/19/adventures-in-freebernetes-cloudy-with-a-chance-of-rain/"
excerpt: 'Part 8 of experiments in FreeBSD and Kubernetes: Building a Custom Cloud Image in CBSD'
thumbnail: assets/images/2020/11/img_20201118_133131.jpg
---

_Part 8 of experiments in FreeBSD and Kubernetes: Building a Custom Cloud Image in CBSD_


[_See all posts in this series_]({{ site.baseurl }}freebsd-virtualization-series/)


#### Table of Contents


1. [Great Image Bake-Off](#great-image-bake-off)
2. [Cloud Seeding](#cloud-seeding)
3. [Great Image Bake-Off Round 2](#great-image-bake-off-round-2)
4. [Cloud Seeding Round 2](#cloud-seeding-round-2)
5. [Great Image Bake-Off Finals](#great-image-bake-off-finals)


In [the previous post]({{ site.baseurl }}2020/11/17/adventures-in-freebernetes-bespoke-vms-in-cbsd/) in this series, I created a custom VM configuration so I could create Alpine Linux VMs in CBSD. That experiment went well. Next up was creating a cloud image for Alpine to allow completely automated configuration of the target VM. However, that plan hit some roadblocks and requires doing a deep dive into a new rabbit hole, documented in this post.


* * *

## Great Image Bake-Off


I'm going to try to use my existing Alpine VM to install `cloud-init` from the `edge` branch (I have no idea whether it's compatible, but I guess we will find out). The Alpine package tool, `apk`, doesn't seem to support specifying packages for a different branch than the one installed, so I uncomment the `edge` repositories in the apk configuration.


<script src="https://gist.github.com/kbruner/dc5876eb198af5024cc5f3675876b7e6.js"></script>


I can't easily test whether it will work with rebooting and then having to clean up the markers cloud-init leaves to maintain state across reboots so it doesn't bootstrap more than once. I will just have to test in the new VM. _(I also needed to run_ `rc-update add cloud-init default` _in the VM before I shut it down, but more on that later.)_


I can't find any specific docs in CBSD on how they generate their cloud images, or even what the specific format is, although [this doc](https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/) implies that it's a ZFS volume.


So, I look at the raw images in `/usr/cbsd/src/iso`.


<script src="https://gist.github.com/kbruner/3f18ff679322fc0e3cccd99acab379b3.js"></script>


Oh. They're symbolic links to actually ZFS volume devices. Ok. I create the image directly from `alpine1`'s ZFS volume.


<script src="https://gist.github.com/kbruner/2d8942d93c34ec260e66348ae3e95629.js"></script>


I left the raw file in `~cbsd/src/iso` to see if CBSD would import it into ZFS automatically when I run `cbsd bconstruct-tui`.


## Cloud Seeding


Again, I have no idea if the above steps actually created a bootable image which CBSD will accept, but before I can try, I have to create the cloud VM profile's configuration.


I have no idea what variables or custom parameters Alpine uses or supports for cloud-init and since I've been combing through CBSD and other docs all day, I would just as soon skip digging into cloud-init. I copied over the CBSD configuration file for a cloud Ubuntu VM profile in `~cbsd/etc/defaults` and edited that.


Also, I could not find it documented, but the cloud-init template files used to populate VMs are stored in `/usr/local/cbsd/modules/bsdconf.d/cloud-tpl`. The Debian cloud VM I made earlier used the `centos7` templates, so I will try those with Alpine.


Here's the VM profile I create as `/usr/cbsd/etc/defaults/vm-linux-cloud-AlpineLinux-3.12.1-x86_64-standard.conf`:


<script src="https://gist.github.com/kbruner/3bff605091fff6a959fe12c04ac92124.js"></script>


And then I create the new VM using that profile.


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-17-at-18.57.11-01.jpeg"
alt="Screenshot of CBSD Linux profile selections">
</div>
<br>



<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-17-at-19.07.12-01.jpeg"
alt="Screenshot of CBSD interface configuring our cloud Alpine VM">
</div>
<br>



<script src="https://gist.github.com/kbruner/4f46ca9b748f5ff4537cf3d33680d9c8.js"></script>


The good news: CBSD did indeed import the disk file. The bad news: bhyve couldn't start the VM.


<script src="https://gist.github.com/kbruner/d7f2c2e82f79f4088c8d54957048707f.js"></script>


Ok, that's a little weird... There are four raw device files instead of the one the other cloud images have.


<script src="https://gist.github.com/kbruner/ef9982566d81489531f85b450e9f361f.js"></script>


OOOOOOOOOkay. I copied `alpine1`'s entire virtual disk, which includes the partition table, EFI partition, and swap partition, in addition to the system partition. I'm not sure how CBSD's import ended up breaking out the partitions, but either way, we only care about the system data, not EFI or swap. We'll need to extract the root partition into its own raw file.


## Great Image Bake-Off, Round 2


I need to get the contents of the `linux-data` partition out of the `vhd` file. There are a few ways to do this, but the simplest way is to create [memory disk](https://www.freebsd.org/cgi/man.cgi?query=md&sektion=4) so we can access each partition through a device file. First we need to get the vhd contents into a regular file, because `mdconfig` cannot work from the character special device in the ZFS /dev/zvol tree.


<script src="https://gist.github.com/kbruner/06c130d58c044e9b482defff35b76040.js"></script>


`mdconfig` created `/dev/md0` for the entire virtual hard disk, and because the `vhd` had a partition table, the `md` driver (I assume) also created device files for each partition. I just want the third partition, so I need to read from `/dev/md0p3`.


<script src="https://gist.github.com/kbruner/6e50aa648e9bb925c7153fe8a8784d25.js"></script>


## Cloud Seeding, Round 2


We now have `alpine1`'s root file system in `raw` format. I copy that file to `cbsd-cloud-cloud-AlpineLinux-3.12.1-x86_64-standard.raw` and try to create my VM again.


<script src="https://gist.github.com/kbruner/9c9539be853df0e7a0eeabc531bf4350.js"></script>


It started without error! CBSD once again automatically handles importing the raw file I just dropped into the `src/iso` directory. Now we need to see if it actually booted via VNC. I opened the VNC client and... it timed out trying to connect. I go back to the terminal window with the `ssh` session to my NUC and... that's hanging. So, I connect my HDMI capture dongle to the NUC, and see FreeBSD had panicked.


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/img_20201118_133131.jpg"
alt="Screenshot of FreeBSD console showing a kernel panic">
</div>
<br>



But when the NUC rebooted, it brought up the `alpine2` VM without any obvious issues, and I could connect to the console. I don't know why.


<script src="https://gist.github.com/kbruner/da35fd9111f666857622f3bc55626600.js"></script>


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-18-at-14.21.55.png"
alt="Screenshot of VNC client showing the new VM successfully booted but did not get reconfigured">
</div>
<br>



However, the new `alpine2` VM still thinks it's `alpine1` and did not apply any of the other cloud-init configurations. And even if cloud-init had run successfully, I couldn't really count it as much of a win if causing the host to panic is part of the deal.


But I'll worry about the panic problem later. First, I want to diagnose the cloud-init issue. If I run `openrc --service cloud-init start` in my VM, cloud-init runs _and_ successfully reconfigures tthe hostname to `alpine2`. It also rewrites `/etc/network/interfaces` with the static IP address I had assigned, and... ok, it did not use my password hash for root. Meh, I'll still consider that a win.


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-18-at-15.10.25.png"
alt="Screenshot of console for alpine2 VM after running cloud-init manually">
</div>
<br>



<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-18-at-15.17.10.png"
alt="Screenshot showing rc-status output with cloud-init set to manual">
</div>
<br>



Ok, I'll need to go back to my source VM and run `rc-update add cloud-init default` to run cloud-init at boot, then make a new raw image. But I should also figure out what may have caused the FreeBSD kernel panic.


After I rebooted the NUC, I saw similar GPT-related messages for the other cloud `raw` ZFS volumes in the `dmesg` log.


<script src="https://gist.github.com/kbruner/dc39775895bb098be44adb1bf8664ce8.js"></script>


Ok, fine, I should check to see what how the disks in the CBSD-distributed raw cloud images are laid out.


<script src="https://gist.github.com/kbruner/64217ca01d1fd7b0ae5b1bfe396cba4d.js"></script>


Ok, the CBSD-distributed `raw` cloud files are in fact full disk images, including partition table and other partitions, with no consistency between the number, order, or even types of partitions. So I apparently was overthinking when I decided I needed to extract the root data partition.


I update the `alpine1` image in a non-cloud VM to set cloud-init to run at boot, and then it's time to try again to create a raw image that won't cause a kernel panic.


## Great Image Bake-Off Finals


I'm not sure what else to try to get a safe image or even if I hadn't missed something the first time I tried to copy the source ZFS volume contents to a raw file. So, I figure I may as well try that again with my updated raw image. I remove the artifacts of the previous attempt and try again.


<script src="https://gist.github.com/kbruner/235d067ea6241cb0d7d746210d18e439.js"></script>


Then I run `cbsd bconstruct-tui` again with the same settings (except for details like hostname and IP addresses) and start the VM.


<script src="https://gist.github.com/kbruner/297266d5ef7c639eae306f4429fa8ff1.js"></script>


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-18-at-16.35.42.png"
alt="Screenshot of VM console showing a successful boot and cloud-init run">
</div>
<br>



It starts, it boots, cloud-init runs, and as a bonus, no FreeBSD kernel panic! (No, my password hash for the `root` user did not get applied this time, either, and I think `/etc/network/interfaces` gets written with the correct information because I used the Centos template, but Alpine does not use the same network configuration method. But do you really want this post to get longer so you can watch me debug that?)


* * *

That took a lot of trial and error, even after I omitted a few dead-ends and lots and lots of web searches.


In the next part, I will actually live up to the original premise of this series and start doing real Kubernetty things that involve FreeBSD.


## Sources / References


* [https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/](https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/)
* [https://www.cyberciti.biz/faq/how-to-enable-and-start-services-on-alpine-linux/](https://www.cyberciti.biz/faq/how-to-enable-and-start-services-on-alpine-linux/)
* [https://github.com/cbsd/cbsd](https://github.com/cbsd/cbsd)


