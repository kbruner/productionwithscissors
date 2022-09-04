---
layout: post
title: 'Fun with FreeBSD: Run Linux Containers on FreeBSD'
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
- linux
meta:
author:
permalink: /2022/09/04/containerd-linux-on-freebsd/
excerpt: How to run an actual Linux container directly on FreeBSD. No virtual machines!
thumbnail: assets/images/2022/09/containerd-runj.png
feature-img: assets/images/2022/09/containerd-runj.png
---

[_See all posts in this series_](/freebsd-virtualization-series/)

<details markdown="1">
  <summary><i>Table of Contents</i></summary>

- [Intro](#intro)
- [Prerequisitites](#prerequisitites)
  - [Audience](#audience)
  - [Platform](#platform)
  - [Setup](#setup)
    - [Packages/ports](#packagesports)
    - [Set up Go](#set-up-go)
    - [Build containerd](#build-containerd)
    - [Build runj](#build-runj)
    - [Enable Linux emulation](#enable-linux-emulation)
- [Run a Linux container!](#run-a-linux-container)
  - [The command line](#the-command-line)
- [References](#references)

</details>

# Intro

This how-to will show you the basics of running a [Linux
container](https://linuxcontainers.org/) directly on
FreeBSD, no virtual machine required!

Thanks to [FreeBSD's Linux
emulation](https://docs.freebsd.org/en/books/handbook/linuxemu/) and lots of
hard work by many people, including the contributions of everyone involved in
[this containerd pull
request](https://github.com/containerd/containerd/pull/7000) and especially
[Samuel Karp's](https://samuel.karp.dev/blog/)
[`runj`](https://github.com/samuelkarp/runj), an [Open Container Initiative
(OCI)](https://opencontainers.org/)-compliant way to launch [FreeBSD
jails](https://docs.freebsd.org/en/books/handbook/jails/), we can now run
Linux containers via `containerd`.

This compatibility is all pretty early-stage and is not guaranteed to work for
all `containerd` use cases (yet!), but all of this work is a huge step
toward using FreeBSD hosts natively as [Kubernetes
nodes](https://kubernetes.io/docs/concepts/architecture/nodes/)

# Prerequisitites

## Audience

This post assumes a basic working knowing of Linux containers, compiling
source code, and basic FreeBSD system administration skills. (You can find a
[cheat sheet
here](https://productionwithscissors.run/2022/09/02/fun-with-freebsd-first-linux-guest/#freebsd-tips-for-linux-people))

## Platform

I'm running on FreeBSD
[13.1-RELEASE](https://www.freebsd.org/releases/13.1R/installation/). I
haven't tested on other versions.

You also need a working [ZFS
pool.](https://docs.freebsd.org/en/books/handbook/zfs/)

## Setup

All these commands need to be run as `root`.

### Packages/ports

Install the following packages or ports:

* `bash` (`shells`)
* `git` (`devel`)
* `gmake` (`devel`)
* `go` (`lang`)

### Set up Go

```shell
# Check /usr/local to find the name of the installed go dir and make a        
# symbolic link to /usr/local/go. My version of `go` is 1.19                  
ln -s /usr/local/go119 /usr/local/go                                          
export GOPATH=/usr/local/go
```

### Build containerd
```shell
# Check out containerd source
git clone https://github.com/containerd/containerd.git
cd containerd
# Minimum required containerd version is v1.6.7
# Find the latest with `git tag -l | tail`
git checkout v1.6.8
# Use gnu make!
gmake install
# Start containerd
service containerd onestart
# For persistence across reboots, add containerd to /etc/rc.conf run at boot
# echo 'containerd_enable="YES"' >> /etc/rc.conf
#
# This also seems to be necessary
mkdir /var/lib/containerd/io.containerd.snapshotter.v1.zfs
```

### Build runj
```shell
git clone https://github.com/samuelkarp/runj.git
cd runj
gmake install
```

### Enable Linux emulation
```shell
kldload linux
# To load the Linux module at boot, run
# echo 'linux_load="YES"' >> /boot/loader.conf
service linux onestart
# To enable Linux emulation at boot, run
# echo 'linux_enable="YES"' >> /etc/rc.conf
```

# Run a Linux container!

```shell
# Pull the image
ctr image pull --platform=linux docker.io/library/alpine:latest
#
# And ....
ctr run --rm --tty --runtime wtf.sbk.runj.v1 --snapshotter zfs --platform linux docker.io/library/alpine:latest mylinuxcontainer uname -a
```

```
[root@nucklehead ~]# ctr image pull --platform=linux docker.io/library/alpine:latest
docker.io/library/alpine:latest:                                                  resolved       |++++++++++++++++++++++++++++++++++++++| 
index-sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad:    done           |++++++++++++++++++++++++++++++++++++++| 
manifest-sha256:1304f174557314a7ed9eddb4eab12fed12cb0cd9809e4c28f29af86979a3c870: done           |++++++++++++++++++++++++++++++++++++++| 
layer-sha256:213ec9aee27d8be045c6a92b7eac22c9a64b44558193775a1a7f626352392b49:    done           |++++++++++++++++++++++++++++++++++++++| 
config-sha256:9c6f0724472873bb50a2ae67a9e7adcb57673a183cea8b06eb778dca859181b5:   done           |++++++++++++++++++++++++++++++++++++++| 
elapsed: 2.5 s                                                                    total:  2.7 Mi (1.1 MiB/s)                                       
unpacking linux/amd64 sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad...
done: 227.895869ms
[root@nucklehead ~]# ctr run --rm --tty --runtime wtf.sbk.runj.v1 --snapshotter zfs --platform linux \
> docker.io/library/alpine:latest mylinuxcontainer uname -a
 
Linux 3.17.0 FreeBSD 13.1-RELEASE releng/13.1-n250148-fc952ac2212 GENERIC x86_64 Linux
[root@nucklehead ~]# uname -a
FreeBSD nucklehead 13.1-RELEASE FreeBSD 13.1-RELEASE releng/13.1-n250148-fc952ac2212 GENERIC amd64
[root@nucklehead ~]# 
```

## The command line

Breaking down the command `ctr run --rm --tty --runtime wtf.sbk.runj.v1 --snapshotter zfs
--platform linux docker.io/library/alpine:latest mylinuxcontainer uname -a`
* `ctr run` -- `containerd` client and its subcommand to run a container
* `--rm` -- remove the container upon completion
* `--tty` -- attach terminal for STDIN/STDOUT to your terminal
* `--runtime wtf.sbk.runj.v1` -- use the `runj` runtime for FreeBSD
* `--snapshotter zfs` -- use ZFS as the storage backend
* `--platform linux` -- use a container image built for Linux
* `docker.io/library/alpine:latest` -- the container image name, in this case
  the one we pulled earlier
* `mylinuxcontainer` -- the name I gave my container. You can use any string
* `uname -a` -- the command to run in the container

* * *
 
And that's it! Wow!

If you have questions or comments, you can [@ me on
Twitter](https://www.twitter.com/fuzzyKB).

---

# References

* [https://docs.freebsd.org/en/books/handbook/jails/](https://docs.freebsd.org/en/books/handbook/jails/)
* [https://docs.freebsd.org/en/books/handbook/linuxemu/](https://docs.freebsd.org/en/books/handbook/linuxemu/)
* [https://docs.freebsd.org/en/books/handbook/zfs/](https://docs.freebsd.org/en/books/handbook/zfs/)
* [https://github.com/containerd/containerd](https://github.com/containerd/containerd)
* [https://github.com/containerd/containerd/pull/7000](https://github.com/containerd/containerd/pull/7000)
* [https://github.com/samuelkarp/runj](https://github.com/samuelkarp/runj)
* [https://iximiuz.com/en/posts/containerd-command-line-clients/](https://iximiuz.com/en/posts/containerd-command-line-clients/)
* [https://kubernetes.io/docs/concepts/architecture/nodes/](https://kubernetes.io/docs/concepts/architecture/nodes/)
* [https://linuxcontainers.org/](https://linuxcontainers.org/)
* [https://opencontainers.org/](https://opencontainers.org/)
* [https://productionwithscissors.run/2022/09/02/fun-with-freebsd-first-linux-guest/#freebsd-tips-for-linux-people](https://productionwithscissors.run/2022/09/02/fun-with-freebsd-first-linux-guest/#freebsd-tips-for-linux-people)
* [https://samuel.karp.dev/blog/](https://samuel.karp.dev/blog/)
* [https://www.freebsd.org/releases/13.1R/installation/](https://www.freebsd.org/releases/13.1R/installation/)


---
