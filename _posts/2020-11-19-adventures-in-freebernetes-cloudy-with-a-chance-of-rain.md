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
  _wpcom_is_markdown: '1'
  _thumbnail_id: '0'
  _last_editor_used_jetpack: block-editor
  _oembed_4088ba2739a0f6239e47dac71d936eed: "{{unknown}}"
  timeline_notification: '1605748275'
  _oembed_c42a98414c8947ea3b370c759a482ffd: "{{unknown}}"
  _oembed_08260af46875a37a5506a909319cd186: "{{unknown}}"
  _oembed_e8d1e0307c43c341b4e3da648fc0084c: "{{unknown}}"
  _oembed_cd1534290eb5e87fc9e48528bcc2d84f: "{{unknown}}"
  _oembed_59949981000d72547bcc33bf5bdb1e97: "{{unknown}}"
  _oembed_a78b0f51d38e985ecec26cf404935346: "{{unknown}}"
  _oembed_358abc1b1e0661e8a40774849d378df5: "{{unknown}}"
  _oembed_835e99767467b626ea39ef3d1b43b625: "{{unknown}}"
  _oembed_5dda607c7a1ff4f3e311999b3344281b: "{{unknown}}"
  _oembed_9d950a3cb7c27717be78f4c777fe7eb3: "{{unknown}}"
  _oembed_502a2356c4f1e2104cc2255a90610608: "{{unknown}}"
  _oembed_b887a764dd979e6a9d0ff6680938cf26: "{{unknown}}"
  _oembed_c0d1b27df3d8cfb13e0a9f1b15f08ee1: "{{unknown}}"
  _oembed_eee0de75e26f7bdbb590ca519ec64111: "{{unknown}}"
  _oembed_aaf677f8b061a144fa3e4d79d1aff4a7: "{{unknown}}"
  _publicize_job_id: '51224064549'
  _oembed_c994567c1fea55796b7fc745c92d8952: "{{unknown}}"
  _oembed_208485a5ed3f40c167aad5462c3d6133: "{{unknown}}"
  _oembed_c0ee5e3334ca3755fff040bbeb2a2adf: "{{unknown}}"
  _oembed_51e2474a73937b5c073726684d5a29d6: "{{unknown}}"
  _oembed_049685a0a45e0c8016a5c04f3d7a5111: "{{unknown}}"
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/11/19/adventures-in-freebernetes-cloudy-with-a-chance-of-rain/"
excerpt: 'Part 8 of experiments in FreeBSD and Kubernetes: Building a Custom Cloud
  Image in CBSD'
---
<!-- wp:paragraph {"fontSize":"medium"} -->

_Part 8 of experiments in FreeBSD and Kubernetes: Building a Custom Cloud Image in CBSD_

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

[_See all posts in this series_](https://productionwithscissors.run/freebsd-virtualization-series/)

<!-- /wp:paragraph -->

<!-- wp:heading {"level":4} -->

#### Table of Contents

<!-- /wp:heading -->

<!-- wp:html -->

1. [Great Image Bake-Off](#great-image-bake-off)
2. [Cloud Seeding](#cloud-seeding)
3. [Great Image Bake-Off Round 2](#great-image-bake-off-round-2)
4. [Cloud Seeding Round 2](#cloud-seeding-round-2)
5. [Great Image Bake-Off Finals](#great-image-bake-off-finals)

<!-- /wp:html -->

<!-- wp:paragraph -->

In [the previous post](https://productionwithscissors.run/2020/11/17/adventures-in-freebernetes-bespoke-vms-in-cbsd/) in this series, I created a custom VM configuration so I could create Alpine Linux VMs in CBSD. That experiment went well. Next up was creating a cloud image for Alpine to allow completely automated configuration of the target VM. However, that plan hit some roadblocks and requires doing a deep dive into a new rabbit hole, documented in this post.

<!-- /wp:paragraph -->

<!-- wp:separator -->

* * *
<!-- /wp:separator -->

<!-- wp:heading -->

## Great Image Bake-Off

<!-- /wp:heading -->

<!-- wp:paragraph -->

I'm going to try to use my existing Alpine VM to install `cloud-init` from the `edge` branch (I have no idea whether it's compatible, but I guess we will find out). The Alpine package tool, `apk`, doesn't seem to support specifying packages for a different branch than the one installed, so I uncomment the `edge` repositories in the apk configuration.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/dc5876eb198af5024cc5f3675876b7e6","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/dc5876eb198af5024cc5f3675876b7e6

<!-- /wp:embed -->

<!-- wp:paragraph -->

I can't easily test whether it will work with rebooting and then having to clean up the markers cloud-init leaves to maintain state across reboots so it doesn't bootstrap more than once. I will just have to test in the new VM. _(I also needed to run_ `rc-update add cloud-init default` _in the VM before I shut it down, but more on that later.)_

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I can't find any specific docs in CBSD on how they generate their cloud images, or even what the specific format is, although [this doc](https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/) implies that it's a ZFS volume.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

So, I look at the raw images in `/usr/cbsd/src/iso`.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/3f18ff679322fc0e3cccd99acab379b3","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/3f18ff679322fc0e3cccd99acab379b3

<!-- /wp:embed -->

<!-- wp:paragraph -->

Oh. They're symbolic links to actually ZFS volume devices. Ok. I create the image directly from `alpine1`'s ZFS volume.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/2d8942d93c34ec260e66348ae3e95629","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/2d8942d93c34ec260e66348ae3e95629

<!-- /wp:embed -->

<!-- wp:paragraph -->

I left the raw file in `~cbsd/src/iso` to see if CBSD would import it into ZFS automatically when I run `cbsd bconstruct-tui`.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Cloud Seeding

<!-- /wp:heading -->

<!-- wp:paragraph -->

Again, I have no idea if the above steps actually created a bootable image which CBSD will accept, but before I can try, I have to create the cloud VM profile's configuration.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I have no idea what variables or custom parameters Alpine uses or supports for cloud-init and since I've been combing through CBSD and other docs all day, I would just as soon skip digging into cloud-init. I copied over the CBSD configuration file for a cloud Ubuntu VM profile in `~cbsd/etc/defaults` and edited that.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Also, I could not find it documented, but the cloud-init template files used to populate VMs are stored in `/usr/local/cbsd/modules/bsdconf.d/cloud-tpl`. The Debian cloud VM I made earlier used the `centos7` templates, so I will try those with Alpine.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Here's the VM profile I create as `/usr/cbsd/etc/defaults/vm-linux-cloud-AlpineLinux-3.12.1-x86_64-standard.conf`:

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/3bff605091fff6a959fe12c04ac92124","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/3bff605091fff6a959fe12c04ac92124

<!-- /wp:embed -->

<!-- wp:paragraph -->

And then I create the new VM using that profile.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1232,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of CBSD Linux profile selections]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-17-at-18.57.11-01.jpeg?w=706)

<!-- /wp:image -->

<!-- wp:image {"id":1234,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of CBSD interface configuring our cloud Alpine VM]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-17-at-19.07.12-01.jpeg?w=701)

<!-- /wp:image -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/4f46ca9b748f5ff4537cf3d33680d9c8","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/4f46ca9b748f5ff4537cf3d33680d9c8

<!-- /wp:embed -->

<!-- wp:paragraph -->

The good news: CBSD did indeed import the disk file. The bad news: bhyve couldn't start the VM.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/d7f2c2e82f79f4088c8d54957048707f","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/d7f2c2e82f79f4088c8d54957048707f

<!-- /wp:embed -->

<!-- wp:paragraph -->

Ok, that's a little weird... There are four raw device files instead of the one the other cloud images have.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/ef9982566d81489531f85b450e9f361f","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/ef9982566d81489531f85b450e9f361f

<!-- /wp:embed -->

<!-- wp:paragraph -->

OOOOOOOOOkay. I copied `alpine1`'s entire virtual disk, which includes the partition table, EFI partition, and swap partition, in addition to the system partition. I'm not sure how CBSD's import ended up breaking out the partitions, but either way, we only care about the system data, not EFI or swap. We'll need to extract the root partition into its own raw file.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Great Image Bake-Off, Round 2

<!-- /wp:heading -->

<!-- wp:paragraph -->

I need to get the contents of the `linux-data` partition out of the `vhd` file. There are a few ways to do this, but the simplest way is to create [memory disk](https://www.freebsd.org/cgi/man.cgi?query=md&sektion=4) so we can access each partition through a device file. First we need to get the vhd contents into a regular file, because `mdconfig` cannot work from the character special device in the ZFS /dev/zvol tree.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/06c130d58c044e9b482defff35b76040","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/06c130d58c044e9b482defff35b76040

<!-- /wp:embed -->

<!-- wp:paragraph -->

`mdconfig` created `/dev/md0` for the entire virtual hard disk, and because the `vhd` had a partition table, the `md` driver (I assume) also created device files for each partition. I just want the third partition, so I need to read from `/dev/md0p3`.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/6e50aa648e9bb925c7153fe8a8784d25","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/6e50aa648e9bb925c7153fe8a8784d25

<!-- /wp:embed -->

<!-- wp:heading -->

## Cloud Seeding, Round 2

<!-- /wp:heading -->

<!-- wp:paragraph -->

We now have `alpine1`'s root file system in `raw` format. I copy that file to `cbsd-cloud-cloud-AlpineLinux-3.12.1-x86_64-standard.raw` and try to create my VM again.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/9c9539be853df0e7a0eeabc531bf4350","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/9c9539be853df0e7a0eeabc531bf4350

<!-- /wp:embed -->

<!-- wp:paragraph -->

It started without error! CBSD once again automatically handles importing the raw file I just dropped into the `src/iso` directory. Now we need to see if it actually booted via VNC. I opened the VNC client and... it timed out trying to connect. I go back to the terminal window with the `ssh` session to my NUC and... that's hanging. So, I connect my HDMI capture dongle to the NUC, and see FreeBSD had panicked.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1255,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of FreeBSD console showing a kernel panic]({{ site.baseurl }}/assets/images/2020/11/img_20201118_133131.jpg?w=1024)

<!-- /wp:image -->

<!-- wp:paragraph -->

But when the NUC rebooted, it brought up the `alpine2` VM without any obvious issues, and I could connect to the console. I don't know why.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/da35fd9111f666857622f3bc55626600","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/da35fd9111f666857622f3bc55626600

<!-- /wp:embed -->

<!-- wp:image {"id":1260,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of VNC client showing the new VM successfully booted but did not get reconfigured]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-18-at-14.21.55.png?w=1024)

<!-- /wp:image -->

<!-- wp:paragraph -->

However, the new `alpine2` VM still thinks it's `alpine1` and did not apply any of the other cloud-init configurations. And even if cloud-init had run successfully, I couldn't really count it as much of a win if causing the host to panic is part of the deal.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

But I'll worry about the panic problem later. First, I want to diagnose the cloud-init issue. If I run `openrc --service cloud-init start` in my VM, cloud-init runs _and_ successfully reconfigures tthe hostname to `alpine2`. It also rewrites `/etc/network/interfaces` with the static IP address I had assigned, and... ok, it did not use my password hash for root. Meh, I'll still consider that a win.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1264,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of console for alpine2 VM after running cloud-init manually]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-18-at-15.10.25.png?w=1024)

<!-- /wp:image -->

<!-- wp:image {"id":1266,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot showing rc-status output with cloud-init set to manual]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-18-at-15.17.10.png?w=1024)

<!-- /wp:image -->

<!-- wp:paragraph -->

Ok, I'll need to go back to my source VM and run `rc-update add cloud-init default` to run cloud-init at boot, then make a new raw image. But I should also figure out what may have caused the FreeBSD kernel panic.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

After I rebooted the NUC, I saw similar GPT-related messages for the other cloud `raw` ZFS volumes in the `dmesg` log.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/dc39775895bb098be44adb1bf8664ce8","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/dc39775895bb098be44adb1bf8664ce8

<!-- /wp:embed -->

<!-- wp:paragraph -->

Ok, fine, I should check to see what how the disks in the CBSD-distributed raw cloud images are laid out.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/64217ca01d1fd7b0ae5b1bfe396cba4d","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/64217ca01d1fd7b0ae5b1bfe396cba4d

<!-- /wp:embed -->

<!-- wp:paragraph -->

Ok, the CBSD-distributed `raw` cloud files are in fact full disk images, including partition table and other partitions, with no consistency between the number, order, or even types of partitions. So I apparently was overthinking when I decided I needed to extract the root data partition.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I update the `alpine1` image in a non-cloud VM to set cloud-init to run at boot, and then it's time to try again to create a raw image that won't cause a kernel panic.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Great Image Bake-Off Finals

<!-- /wp:heading -->

<!-- wp:paragraph -->

I'm not sure what else to try to get a safe image or even if I hadn't missed something the first time I tried to copy the source ZFS volume contents to a raw file. So, I figure I may as well try that again with my updated raw image. I remove the artifacts of the previous attempt and try again.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/235d067ea6241cb0d7d746210d18e439","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/235d067ea6241cb0d7d746210d18e439

<!-- /wp:embed -->

<!-- wp:paragraph -->

Then I run `cbsd bconstruct-tui` again with the same settings (except for details like hostname and IP addresses) and start the VM.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/297266d5ef7c639eae306f4429fa8ff1","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/297266d5ef7c639eae306f4429fa8ff1

<!-- /wp:embed -->

<!-- wp:image {"id":1274,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of VM console showing a successful boot and cloud-init run]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-18-at-16.35.42.png?w=1024)

<!-- /wp:image -->

<!-- wp:paragraph -->

It starts, it boots, cloud-init runs, and as a bonus, no FreeBSD kernel panic! (No, my password hash for the `root` user did not get applied this time, either, and I think `/etc/network/interfaces` gets written with the correct information because I used the Centos template, but Alpine does not use the same network configuration method. But do you really want this post to get longer so you can watch me debug that?)

<!-- /wp:paragraph -->

<!-- wp:separator -->

* * *
<!-- /wp:separator -->

<!-- wp:paragraph -->

That took a lot of trial and error, even after I omitted a few dead-ends and lots and lots of web searches.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

In the next part, I will actually live up to the original premise of this series and start doing real Kubernetty things that involve FreeBSD.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Sources / References

<!-- /wp:heading -->

<!-- wp:list -->

- [https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/](https://cbsd.io/cbsd/tutorials/bhyve-and-cloud-init/)
- [https://www.cyberciti.biz/faq/how-to-enable-and-start-services-on-alpine-linux/](https://www.cyberciti.biz/faq/how-to-enable-and-start-services-on-alpine-linux/)
- [https://github.com/cbsd/cbsd](https://github.com/cbsd/cbsd)

<!-- /wp:list -->

