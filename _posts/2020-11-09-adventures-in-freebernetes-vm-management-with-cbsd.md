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
  _wpcom_is_markdown: '1'
  _thumbnail_id: '0'
  _last_editor_used_jetpack: block-editor
  _oembed_49d011b5a532b5864de9fc6549a480a4: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    trying to create a bhyve Debian guest using a ZFS drive and FreeBSD keeps crashing...
    Oops.<br><br>How&#39;s your Saturday?</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1322617187400511488?ref_src=twsrc%5Etfw">October
    31, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_49d011b5a532b5864de9fc6549a480a4: '1604610734'
  _oembed_f36e2fe523ac86c08406a5e95fb2ddc9: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    still not wrong in thinking UEFI was just a plot fueled by Microsoft to increase
    the pain of installing OSS operating systems on PCs, right?</p>&mdash; Karen Bruner
    (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1323092341628887041?ref_src=twsrc%5Etfw">November
    2, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_f36e2fe523ac86c08406a5e95fb2ddc9: '1604610734'
  _oembed_b251959dc9b1b40dec989ba282849dec: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    still not wrong in thinking UEFI was just a plot fueled by Microsoft to increase
    the pain of installing OSS operating systems on PCs, right?</p>&mdash; Karen Bruner
    (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1323092341628887041?ref_src=twsrc%5Etfw">November
    2, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _publicize_job_id: '50847241707'
  timeline_notification: '1604896463'
  _oembed_71e7403047efc590b0c170a6ca636399: "{{unknown}}"
  _oembed_cc6b2ed180bcfda94e205848bd165c76: "{{unknown}}"
  _oembed_22820790ebeaa9140b6cda2cfb1de64e: "{{unknown}}"
  _oembed_ef9f56d821b683b1d23bf2d5bf8e4e79: "{{unknown}}"
  _oembed_0168921c42e528e2362e7b57face95ee: "{{unknown}}"
  _oembed_bb9861ea44882f8c491d68430927fd44: "{{unknown}}"
  _oembed_6d9481a549b056864e5ebcf6199f6e51: "{{unknown}}"
  _oembed_ad0110f92deec40f2a22668022989883: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    trying to create a bhyve Debian guest using a ZFS drive and FreeBSD keeps crashing...
    Oops.<br><br>How&#39;s your Saturday?</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1322617187400511488?ref_src=twsrc%5Etfw">October
    31, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_b251959dc9b1b40dec989ba282849dec: '1604896555'
  _oembed_time_ad0110f92deec40f2a22668022989883: '1604896555'
  _edit_last: '108235749'
  _oembed_600ddb5f21802950c65f75a3cea4360d: "{{unknown}}"
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/11/09/adventures-in-freebernetes-vm-management-with-cbsd/"
excerpt: 'Part 5 of experiments in FreeBSD and Kubernetes: Getting started with CBSD'
---
<!-- wp:paragraph {"fontSize":"medium"} -->

_Part 5 of experiments in FreeBSD and Kubernetes: Getting started with CBSD_

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

[_See all posts in this series_](https://productionwithscissors.run/freebsd-virtualization-series/)

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

[At the end of the previous post](https://productionwithscissors.run/2020/11/05/adventures-in-freebernetes-more-linux-bhyve-iour-plus-cbsd/), I had finally finished installing CBSD and its dependencies and configuration.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Doing Stuff with CBSD

<!-- /wp:heading -->

<!-- wp:paragraph -->

There are a bunch of [video tutorials](https://cbsd.io/cbsd/tutorials/tutorials-with-bhyve/) for managing bhyve with CBSD. I'm going to start by trying to creating a basic FreeBSD VM.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1093,"sizeSlug":"large","linkDestination":"none"} -->

![Screen shot of CBSD's text-based user interface showing menu options for creating a new bhyve virtual machine]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-05-at-08.55.48-01.jpeg?w=646)  

_Yes, I (still) need to find a better terminal type for these menus in my Chrome OS Linux terminal. Suggestions welcome._

<!-- /wp:image -->

<!-- wp:paragraph -->

Other than choosing a `jname` of `freebsd1`, I keep all the defaults, and tell it to create the VM immediately.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1103,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of shell output after telling cbsd to create my VM immediately, with commands for interacting with the VM]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-06-at-15.16.42-01.jpeg?w=646)

<!-- /wp:image -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/9fd30a4162853d3f76462bd654948b78","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/9fd30a4162853d3f76462bd654948b78

<!-- /wp:embed -->

<!-- wp:paragraph -->

Oh, wait, I could use my Chromebook's VNC app if the VNC port was bound to a routeable IP address.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/d1f30737e228d7afe04440f114f8c586","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/d1f30737e228d7afe04440f114f8c586

<!-- /wp:embed -->

<!-- wp:image {"id":1109,"sizeSlug":"large","linkDestination":"none"} -->

![VNC desktop image of FreeBSD LiveCD menu]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-07-at-22.41.36.png?w=1024)  

_Screenshot of VNC desktop view of FreeBSD CBSD guest_

<!-- /wp:image -->

<!-- wp:paragraph -->

I select "Install" and let it go. After rebooting, all is copacetic.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1111,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of VNC app showing FreeBSD VM console after successful boot]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-07-at-23.21.27.png?w=1024)

<!-- /wp:image -->

<!-- wp:paragraph -->

With CBSD, we get a FreeBSD bhyve guest with a ZFS-backed virtual disk and VNC desktop with just a few commands. Compare that to [my first experiment](https://productionwithscissors.run/2020/10/29/adventures-in-freebernetes-bhyve-my-guest/) with manual bhyve VM creation, when I had to create the virtual network interfaces manually, create my disk file, download the FreeBSD ISO disk image, keep track of the virtual device files, and execute separate load and boot commands each time to bring up the VM.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Doing Linux Stuff with CBSD

<!-- /wp:heading -->

<!-- wp:paragraph -->

Ok, a FreeBSD guest was pretty simple. What about Linux? Arch Linux was the first distribution I tried when manually creating bhyve Linux VMs, so I'll try that first with CBSD, which supports a lot of Linux distros out of the box. (You can also add others for your own use, which I will try later.)

<!-- /wp:paragraph -->

<!-- wp:image {"id":1116,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of CBSD installer OS selector menu]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-07-at-23.29.21-01.jpeg?w=645)

<!-- /wp:image -->

<!-- wp:image {"id":1115,"sizeSlug":"large","linkDestination":"none"} -->

![Screenshot of CBSD installer supported Linux distributions]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-07-at-23.29.55-01.jpeg?w=645)

<!-- /wp:image -->

<!-- wp:paragraph -->

I selected ArchLinux, set the `jname`, set the VNC IP address so I could connect to the console from my Chromebook.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/c6c0fdb1d50178f96814f87cf6c5146e","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/c6c0fdb1d50178f96814f87cf6c5146e

<!-- /wp:embed -->

<!-- wp:paragraph -->

Because I don't have the ISO image stored locally, it checks its configured mirrors and starts the download.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/10c0e4045553340238a7eb9797975ff6","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/10c0e4045553340238a7eb9797975ff6

<!-- /wp:embed -->

<!-- wp:paragraph -->

Hmmm. I hadn't changed any other values. But that `6 bhyve_flags` bit in the `bhyve` command it's trying to run look suspicious. I look in the configuration file `/usr/cbsd/jails-system/arch1/bhyve.conf` and see the line `bhyve_flags='6 bhyve_flags'` which looks suspicious. I had descended into the bhyve flags options dialog in the UI, but hadn't changed anything. There may have been some default text there which got entered? Either way, I edit the conf file to set `bhyve_flags=''` and run `cbsd bstart arch1` again.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

And got the same error. Even though I had edited the conf file, it had reverted. Apparently it's getting generated. This time I run `cbsd bset jname=arch1 bhyve_flags=''` and try again. This time, success!

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/9d9a47f39604eaa9f5eb10ddd503e372","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/9d9a47f39604eaa9f5eb10ddd503e372

<!-- /wp:embed -->

<!-- wp:image {"id":1122,"sizeSlug":"large","linkDestination":"none"} -->

![Screen shot of VNC client showing ArchLinux installer shell]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-08-at-14.47.12.png?w=1024)

<!-- /wp:image -->

<!-- wp:paragraph -->

I follow [the same installation steps](https://productionwithscissors.run/2020/10/31/adventures-in-freebernetes-will-linux-bhyve/) as earlier. (One difference: the ZFS disk shows up as `/dev/sda`). I reboot and voila.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1124,"sizeSlug":"large","linkDestination":"none"} -->

![Screen shot of VNC client showing rebooted ArchLinux VM console]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-08-at-15.56.30.png?w=1024)

<!-- /wp:image -->

<!-- wp:paragraph -->

Ok, granted, that didn't simplify the manual installation steps for Arch Linux, but it still reduced all the steps require for configuring the virtual network interface and disk, in addition to handling UEFI.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## VM Reproduction

<!-- /wp:heading -->

<!-- wp:paragraph -->

Using ZFS volumes for the VM virtual disk opens up the possibility of easily making copies of the VM image in the same ZFS storage pool. CBSD already has [some tooling to support creating and using ZFS volume snapshots.](https://cbsd.io/cbsd/tutorials/Cloning-a-Virtual-Machine/)

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Since I've just installed a fresh Arch Linux VM, it would make a good source for a snapshot. I shut down the VM. (I don't know if this is strictly necessary, but I don't trust snapshots of unquiesced file systems. Yes, I know what AWS documentation says about EBS snapshots made on live systems being viable backups. No, they're not.)

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/a8491bf89ae0807035113eef85173c30","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/a8491bf89ae0807035113eef85173c30

<!-- /wp:embed -->

<!-- wp:paragraph -->

Oh, wait, I halted the VM from the shell, but I didn't shut it down in bhyve. CBSD wants me to shut it down before cloning it, so there you go. Because ZFS clones use copy-on-write, they initially take up no additional disk space. Only when blocks get written or diverge from the original snapshot do they allocate actual disk space. CBSD also supports making an actual copy of the volume, which means it will no longer require the source snapshot. A full copy can take much longer to create, depending on the size of the volume and the storage performance.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/9b6c141caad21b7d76d042b97ba5d713","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/9b6c141caad21b7d76d042b97ba5d713

<!-- /wp:embed -->

<!-- wp:paragraph -->

And my new VM boots right up!

<!-- /wp:paragraph -->

<!-- wp:separator -->

* * *
<!-- /wp:separator -->

<!-- wp:paragraph -->

In [the next part](https://productionwithscissors.run/2020/11/13/adventures-in-freebernetes-a-bridge-not-far-enough/) of this series, we will look at more options with CBSD, including configuring a custom VM profile.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Sources / References

<!-- /wp:heading -->

<!-- wp:list -->

- [https://cbsd.io/cbsd/docs/freebsd-bhyve/](https://cbsd.io/cbsd/docs/freebsd-bhyve/)

<!-- /wp:list -->

