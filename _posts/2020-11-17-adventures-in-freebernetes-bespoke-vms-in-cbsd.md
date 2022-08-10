---
layout: post
title: 'Adventures in Freebernetes: Bespoke VMs in CBSD'
date: 2020-11-17 20:58:34.000000000 -08:00
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
permalink: "/2020/11/17/adventures-in-freebernetes-bespoke-vms-in-cbsd/"
excerpt: 'Part 7 of experiments in FreeBSD and Kubernetes: Custom Linux VM Installs in CBSD'
thumbnail: assets/images/2020/11/screenshot-2020-11-15-at-13.36.07-01.jpeg
---

_Part 7 of experiments in FreeBSD and Kubernetes: Custom Linux VM Installs in CBSD_


[See all posts in this series]({{ site.baseurl }}freebsd-virtualization-series/)


* * *

## Custom Linux VM


Finally, as promised, I'm going to make a bhyve VM for a Linux distribution for which CBSD currently does not have an existing configuration. (I'm using CBSD version 12.1.16.) I chose [Alpine Linux](https://alpinelinux.org/), in part because they have offer an ISO image for installation. (I wanted to use [Google's Container-Optimized OS](https://cloud.google.com/container-optimized-os), but they don't distribute a public anything. The same for [AWS's Bottlerocket distribution](https://aws.amazon.com/bottlerocket/), which is also optimized as a server for container runtimes. Both are open-source, but both require compiling from source if you're not deploying in their respective clouds, and that is a completely different experiment.)


To start, I `cd` into the directory with the profile configuration files. Then I copy a random Linux configuration and edit to change the name, version, and download site for the ISO image. I'm not sure about some of the options, so I just leave them as-is.


<script src="https://gist.github.com/kbruner/6705e99299bf53b9edadaf10d98d1c1a.js"></script>


When I run `cbsd bconstruct-tui` and navigate to the OS profile menu, my new entry for Alpine Linux is there.


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-15-at-13.36.19-01.jpeg"
alt="Screenshot of CBSD Linux VM menu with new Alpine Linux entry at the top">
</div>
<br>



<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-15-at-13.36.07-01.jpeg"
alt="Screenshot of CBSD VM creation menu configured to create a VM from the new Alpine Linux configuration">
</div>
<br>


After exiting, I run `cbsd bstart alpine` and it boots up.


<script src="https://gist.github.com/kbruner/d68248271be3304044f728a0bc1c681b.js"></script>


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-15-at-13.52.54.png"
alt="Screenshot of the VNC console of the newly booted alpine installer disk">
</div>
<br>



I've used the Alpine container image as a base in Dockerfiles, but I had never installed it on a server, virtual or real. Fortunately, the ISO image comes with an installer command, `setup-alpine`. I walk through the options, then reboot. It does look like I don't need the CBSD mirrors, because those seem to be alternate hosts for the supported ISO images.


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-15-at-15.35.32.png"
alt="Screenshot of the alpine console showing the system installer">
<br>
<i><small>
Yes, I messed up on the root password the first time
</small></i>
</div>
<br>


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-15-at-16.24.05.png"
alt="Screenshot of the alpine console showing more installer steps">
</div>
<br>



<div align="center">
<img
src="{{ site.baseurl }}assets/images/2020/11/screenshot-2020-11-15-at-20.37.06.png"
alt="Screenshot of the final steps of the alpine installer">
</div>
<br>



That was a success and pretty straightforward, once I figured out where the configuration files lived.


## Customizing with cloud-init


What if I wanted to automate the installation using CBSD's support for populating cloud-init files?


With cloud-init, you generally use a disk image, rather than installing from an ISO image. And, in fact, CBSD seems to be using custom-made raw disk images in place of ISO images for its cloud VM profiles. (I suppose you could still make starting with an ISO image work, if booting the ISO triggered a totally automated installation, including installing the `cloud-init` package; it would still need to be a two-step process to populate the resulting installation's cloud-init files with the VM's custom configuration, but CBSD doesn't support that, so nevermind.)


I could try to build a raw disk image for Alpine to use for cloud installs.


BUT WAIT! It looks like cloud-init support isn't in the Alpine release I used, 3.12.1, but it _has_ been added as a supported package in the unreleased `edge` branch. Ok, let's see if we can install the unnumbered `edge` branch because using a tag recycled for rolling versions never broke anything. (Actually, it has. Don't do this in production, kids.)


It took a little digging to find where Alpine hides its `edge` development build artifacts. ([Here](http://dl-cdn.alpinelinux.org/alpine/edge/releases/).) Unfortunately, it looks like they stopped building ISO images or other artifacts for `edge` several years ago, so that's out. (As I noted at the beginning of this post, if I wanted to compile an entire distribution from source, I would have been using another distro.)


* * *

OK FINE. In the next part, I will actually create an image to create and configure an Alpine Linux VM using cloud-init.


## Sources / References


- [https://alpinelinux.org/](https://alpinelinux.org/)
- [https://wiki.alpinelinux.org/wiki/Installation](https://wiki.alpinelinux.org/wiki/Installation)
- [https://www.bsdstore.ru/en/11.2.x/wf\_bcreate\_ssi.html](https://www.bsdstore.ru/en/11.2.x/wf_bcreate_ssi.html)


