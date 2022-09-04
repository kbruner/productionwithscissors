---
layout: post
title: 'Fun with FreeBSD: Your First Linux Guest'
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
- linux
meta:
author:
permalink: /2022/09/02/fun-with-freebsd-first-linux-guest/
excerpt: Getting up and running with CBSD on FreeBSD
thumbnail: assets/images/2022/09/bconstruct-tui.png
feature-img: assets/images/2022/09/bconstruct-tui.png
---

[_See all posts in this series_](/freebsd-virtualization-series/)

  - [Intro](#intro)
    - [Audience](#audience)
    - [FreeBSD Tips for Linux People](#freebsd-tips-for-linux-people)
  - [Setup and configuration](#setup-and-configuration)
    - [Host (FreeBSD Hypervisor) Requirements](#host-(freebsd-hypervisor)-requirements)
    - [Install and Configure Tools](#install-and-configure-tools)
  - [Create our Linux Virtual Machine](#create-our-linux-virtual-machine)
    - [Notes](#notes)
    - [Configure the VM](#configure-the-vm)
    - [Start the VM](#start-the-vm)
    - [Install Ubuntu](#install-ubuntu)
    - [Clean up](#clean-up)
  - [References](#references)


# Intro

The [FreeBSD](https://www.freebsd.org/) operating system contains innumerable
powerful features. One of these features is
[`bhyve`](https://wiki.freebsd.org/bhyve), its native type 2 (OS-level)
hypervisor, which can host virtual machines running multiple different OSes,
including Linux.

This post will walk you through creating a Linux virtual machine on FreeBSD
using the [CBSD](https://cbsd.io/) tool, which greatly simplifies creating
and managing `bhyve` VMs.

**Note**: This tutorial is meant for a learning experiment only. It is not
meant for use setting up production systems. It
skips most security features and sets up no fault tolerance.

## Audience

This tutorial assumes you have basic FreeBSD or Linux command-line or system
administration skills and have gone through the process of
[installing FreeBSD](https://docs.freebsd.org/en/books/handbook/bsdinstall/).

## FreeBSD Tips for Linux People

### Software installation

FreeBSD has a very mature and reliable software package management system and
a library of third-party packages similar to most Linux distributions. You can
[install pre-compiled binary packages using
`pkg`](https://docs.freebsd.org/en/books/handbook/ports/#pkgng-intro) or you
can compile from source code using the [`ports`
collection](https://docs.freebsd.org/en/books/handbook/ports/#ports-using).

I generally compile from `ports`, which allows custom compile-time options and
can sometimes be more up-to-date, but `pkg` should be fine and definitely much
faster.

### Text-based User Interfaces

FreeBSD uses a very distinctive style of interactive menus. If you compile
from `ports`, you will see it a lot. CBSD also uses it.

<div align="center">
<img
src="/assets/images/2022/09/ui-example.png"
alt="Screenshot of an example of the FreeBSD user interface, with its light blue background, checkboxes, and Ok and Cancel buttons">
<br>
<i><small>
The distinctive FreeBSD interactive interface with its shadow box menu and its
light blue background
</small></i>
</div>
<br>

* To navigate the menu: use the `<up/down>` arrow keys
* To change an option: navigate to that line, press the spacebar.
   * If the item is a checkbox, it will toggle the selection
   * A pop-up will appear if the option is a multi-choice or a text box entry

When you have finished the configuration, use the `<left>/<right>` arrow keys to
navigate the options below the menu. Select `<Ok>` to confirm and hit enter.

### Tools

   * Your favorite Linux command-line tools like `grep`, `sed`, `awk, and
     `find` are all here but they sometimes behave a little differently than
     on GNU/Linux.
   * If you absolutely need the GNU versions, you can usually install them via
     packages or ports, with `g` or `gnu` prefixed to the name (`gnugrep`,
     `gsed`, etc.)
   * `bash` is also not installed by default. You can install it via `pkg` or
     `ports`

### Root access

`sudo` access is **not** set up automatically, unlike many Linux distributions.
In the default installation, FreeBSD expects users needing root access to be
added to the `wheel` group (in `/etc/group`) and to `su` to root, using the
root password to authenticate. If this is an important or shared host, you
can [configure
sudo](https://docs.freebsd.org/en/books/handbook/security/#security-sudo)

# Setup and configuration

## Host (FreeBSD Hypervisor) Requirements

   * CPUs must support FreeBSD bhyve virtualization (see [the FreeBSD Handbook page on bhyve](https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html) for compatible CPUs)
   * FreeBSD: At least `13.0-CURRENT`. I tested this on `13.1-RELEASE`
   * File system for VM storage: [ZFS](https://docs.freebsd.org/en/books/handbook/zfs/)
      * If you don't want to install root on ZFS, that's fine. You can create
        a ZFS pool on another disk or disk partition.
      * I installed `13.1-RELEASE` as ZFS-on-root and let the installer
        use its default partitions. Previous FreeBSD installers may require
	[additional ZFS configuration](/2020/10/25/adventures-in-freebernetes-installing-freebsd/#zfs-on-root)
    * Static IP. If your host's IP address changes, you may have to
      reconfigure CBSD later.

### VNC Client

To connect to the console of the new VM during the installation phase, you
will need a VNC (Virtual Network Computing) client on a graphics-based host
(for example, Windows or a
Linux desktop). When connecting from a Linux host, I like
the [TigerVNC](https://tigervnc.org/) client, which is available as a
pre-built package for many Linux distros.

### ZFS Storage

These instructions assume you have a
[ZFS pool](https://docs.freebsd.org/en/books/handbook/zfs/) of reasonable
size and it's named `zpool`. "Reasonable size" depends on how many VMs you
want to create, but let's assume a bare minimum of 10-20Gb per VM.

## Install and Configure Tools

### Tools

You will need to install the following via the `pkg` command or by compiling
the `port`. The `port` group is in parentheses.

  * `git` (`devel`)
  * `CBSD` (`sysutils`)
  * `nsd` (`dns`)
  * `tmux` (`sysutils`)

### Initialize CBSD

Before we run CBSD the first time, we need to
initialize its configuration. You can find the default values in 
`/usr/local/cbsd/share/initenv.conf` but we're going to change a few of those.

In addition to populating `/usr/cbsd` (the "workdir") and writing
configuration files, the `initenv` subcommand given the
above values will also append boot-time CBSD options to `/etc/rc.conf` and
`/boot/loader.conf`.

You can run the `initenv` subcommand one of two ways:
1. Interactively. This is long and rather confusing if you don't know what
   you're doing.
2. Using a seed file with the values pre-set.

**Important: all `CBSD` commands need to be run as `root`**

**Notes:**
* My host has the hostname `nucklehead` and the IP address
  192.168.1.76. You should use your own host's values for those options.
* For the RSYNC and RACCT questions, because this is a non-production system,
  you probably want to answer disable them to save resources
* CBSD version 13.1.13 seems to ignore the `racct=0` option (don't enable
  accounting). After initialization is done, you can remove the line
  `kern.racct.enable=1` from `/boot/loader.conf`
* `initenv` may offer different configuration questions depending on answers
  to previous questions

#### Initialize CBSD the Quick Way

<details markdown="1">
  <summary><b>Configure CBSD from the command line</b></summary>

1. Save the following to a file called `initenv.conf`
```shell
# cbsd initenv preseed file for nucklehead host
# refer to the /usr/local/cbsd/share/initenv.conf
# for description.
#
nodeip="192.168.1.76"
nodename="nucklehead"
jnameserver="10.0.0.1"
nodeippool="10.0.0.0/16"
nat_enable="pf"
fbsdrepo="1"
zfsfeat="1"
parallel="0"
stable="0"
sqlreplica="0"
statsd_bhyve_enable="0"
statsd_jail_enable="0"
statsd_hoster_enable="0"
ipfw_enable="0"
racct="0"
natip="10.0.0.1"
initenv_modify_sudoers=""
initenv_modify_rcconf_hostname=""
initenv_modify_rcconf_cbsd_workdir="1"
initenv_modify_rcconf_cbsd_enable="1"
initenv_modify_rcconf_rcshutdown_timeout="1"
initenv_modify_syctl_rcshutdown_timeout=""
initenv_modify_rcconf_cbsdrsyncd_enable=""
initenv_modify_rcconf_cbsdrsyncd_flags=""
initenv_modify_cbsd_homedir="1"
workdir="/usr/cbsd"
```
2. Edit `nodeip` to you FreeBSD's IP address and `nodename` to the hostname
3. Run
```shell
env workdir=/usr/cbsd /usr/local/cbsd/sudoexec/initenv inter=0 `pwd`/initenv.conf
```

</details>

#### Initialize CBSD the Long Way

<details markdown="1">
  <summary><b>Configure CBSD interactively</b></summary>

This example shows a run-through of an interactive configuration, using the
command

`env workdir=/usr/cbsd /usr/local/cbsd/sudoexec/initenv`

<script src="https://gist.github.com/kbruner/d76c7823d519a1af46f1c52dedf00057.js"></script>

</details>


### Enable `pf` Networking

The [`pf`
firewall](https://docs.freebsd.org/en/books/handbook/firewalls/#firewalls-pf)
needs some additional setup.

```shell
# Create the configuration file
cp /usr/local/examples/pf.conf /etc/pf.conf
# Enable the NAT gateway
echo 'gateway_enable="YES"' >> /etc/rc.conf
# Start
service start
```

### Load kernel modules

We need to set up several kernel modules. We load them now then add them to
`/boot/loader.conf` so they will load automatically at boot time.

```shell
for module in vmm if_tuntap if_bridge nmdm; do
    kldload "$module"
    echo "${module}_load=\"YES\"" >> /boot/loader.conf
done
```

# Create our Linux Virtual Machine

We're finally ready to create our VM.

We're going to select the latest available supported version of Ubuntu. Note
that this may not be the current Ubuntu release. We'll cover how to configure
releases with no CBSD support in a later post.

## Notes

* In this example, we are going to use Ubuntu Server 22.04.
* Your menu options may differ if you're using a different version of CBSD.
* We will configure the VM manually through the UI. A later post will show how
  to configure from a template file instead.

## Configure the VM

Run `cbsd bconstruct-tui` to start the VM configuration.

<div align="center">
<img
src="/assets/images/2022/09/bconstruct-tui.png"
alt="Screenshot of a menu to cover a VM in CBSD. The available options include OS type, hostname, and network options">
<br>
<i><small>
This menu shows my configuration. You may want to tweak `jname` (the VM's
identifying name), `host_hostname`, or network options.
</small></i>
</div>
<br>

We also want to set up our VNC endpoint so we can connect to the VM after it
boots.

Navigate to the `bhyve_vnc_options` option and
press enter to bring up the sub-menu.

<div align="center">
<img
src="/assets/images/2022/09/vnc-menu.png"
alt="Screenshot of the bconstruct-tui sub-menu for configuring the VNC endpoint">
<br>
<i><small>
VNC configuration sub-menu
</small></i>
</div>
<br>

VNC options:

* If you connect to your hypervisor via SSH, you want to change the bind IP
  (`bhyve_vnc_tcp_bind`) to
  that host's IP address. You can also set it to 0.0.0.0 to bind it to all the
  network interfaces on the host hypervisor.
* If the `vm_vnc_port` is set to 0, a random port number will be assigned.
  We'll set it here to 5901. Be careful of port collisions if you have more
  than one VM on the host. They each need a unique VNC port.
* Be sure to set the password!
* Select `Save` when done to go back to the main menu.

Once you've finished the configuration, select `Ok` in the main menu.
You will then be asked if you want to create the vm immediately. We'll select
`yes` here.

## Start the VM

Our VM still hasn't started running, but CBSD has created its configuration.
We can start the VM by running one more command.

`cbsd bstart mylinuxvm`

The first time you start an image with a specific operating system, you will
need to wait as the image is pulled from the internet, which can take take
several minutes or more, depending on the speed of your internet connection.
CBSD will try to find the fastest mirror for you. Once the image for a
specific Linux version has been downloaded, though, you can re-use it for more
VMs with the same version, which will speed up the process greatly.

```text
[root@nucklehead ~]# cbsd bstart mylinuxvm
init_systap: waiting for link: em0
Looks like /usr/cbsd/vm/mylinuxvm/dsk1.vhd is empty.
May be you want to boot from CD?
[yes(1) or no(0)]
1
Temporary boot device: cd
vm_iso_path: iso-Ubuntu-Server-22.04-amd64
No such media: /usr/cbsd/src/iso/cbsd-iso-ubuntu-22.04-live-server-amd64.iso in /usr/cbsd/src/iso
Shall i download it from: http://mirror.truenetwork.ru/ubuntu-releases/22.04/ http://ubnt-releases.xfree.com.ar/ubuntu-releases/22.04/ http://mirror.pop-sc.rnp.br/mirror/ubuntu-releases/22.04/ http://mirror.easyspeedy.com/ubuntu-iso/22.04/ http://ubuntu.mirrors.ovh.net/ubuntu-releases/22.04/ http://ftp.halifax.rwth-aachen.de/ubuntu-releases/22.04/ http://ubuntu.connesi.it/22.04/ http://mirror.nl.leaseweb.net/ubuntu-releases/22.04/ http://releases.ubuntu.com/22.04/ http://mirror.waia.asn.au/ubuntu-releases/22.04/ ?
[yes(1) or no(0)]
1
Download to: /usr/cbsd/src/iso/cbsd-iso-ubuntu-22.04-live-server-amd64.iso
Scanning for fastest mirror...
             Mirror source:                       bytes/sec:
 * [ 1/17  ] http://electro.bsdstore.ru:          0
 * [ 2/17  ] http://ftp.halifax.rwth-aachen.de:   failed (http://ftp.halifax.rwth-aachen.de/ubuntu-releases/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 3/17  ] http://mirror.easyspeedy.com:        failed (http://mirror.easyspeedy.com/ubuntu-iso/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 4/17  ] http://mirror.nl.leaseweb.net:       failed (http://mirror.nl.leaseweb.net/ubuntu-releases/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 5/17  ] http://mirror.pop-sc.rnp.br:         failed (http://mirror.pop-sc.rnp.br/mirror/ubuntu-releases/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 6/17  ] http://mirror.truenetwork.ru:        failed (http://mirror.truenetwork.ru/ubuntu-releases/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 7/17  ] http://mirror.waia.asn.au:           failed (http://mirror.waia.asn.au/ubuntu-releases/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 8/17  ] http://releases.ubuntu.com:          failed (http://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 9/17  ] http://ubnt-releases.xfree.com.ar:   failed (http://ubnt-releases.xfree.com.ar/ubuntu-releases/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 10/17 ] http://ubuntu.connesi.it:            failed (http://ubuntu.connesi.it/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 11/17 ] http://ubuntu.mirrors.ovh.net:       failed (http://ubuntu.mirrors.ovh.net/ubuntu-releases/22.04/ubuntu-22.04-live-server-amd64.iso)
 * [ 12/17 ] https://clonos.ca.ircdriven.net:     593920
 * [ 13/17 ] https://clonos.us.ircdriven.net:     643072
 * [ 14/17 ] https://electrode.bsdstore.ru:       0
 * [ 15/17 ] https://mirror.bsdstore.ru:          0
 * [ 16/17 ] https://mirror2.bsdstore.ru:         0
 * [ 17/17 ] https://plug-mirror.rcac.purdue.edu: 8125098
 Winner: https://plug-mirror.rcac.purdue.edu/cbsd/iso/
Processing: https://plug-mirror.rcac.purdue.edu/cbsd/iso/ubuntu-22.04-live-server-amd64.iso
retrieve ubuntu-22.04-live-server-amd64.iso from plug-mirror.rcac.purdue.edu, size: 1g
/usr/cbsd/src/iso/cbsd-iso-ubuntu-22.04-live-s        1398 MB   10 MBps 02m08s
Checking CRC sum: 84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f...Passed
Automatically register iso as: cbsd-iso-ubuntu-22.04-live-server-amd64.iso
Path already exist for: iso-Ubuntu-Server-22.04-amd64
VRDP is enabled. VNC bind/port: 192.168.1.76:5901
For attach VM console, use: vncviewer 192.168.1.76:5901
Resolution: 1024x768.
VNC pass: vncpass

Warning!!! You are running a system with open VNC port to the world wich is not secure
Please use IP filter or balancer with password to restrict VNC port access
Or change vnc_bind params to 127.0.0.1 and reboot VM after maintenance work

bhyve renice: 1
Waiting for PID.
PID: 75699
bstart done in 4 minutes and 16 seconds
[root@nucklehead ~]#
```

We can check the status of our vm:

`cbsd bls mylinuxvm`
```
[root@nucklehead ~]# cbsd bls mylinuxvm
JNAME      JID    VM_RAM  VM_CURMEM  VM_CPUS  PCPU  VM_OS_TYPE  IP4_ADDR  STATUS  VNC
mylinuxvm  75699  2048    0          2        0     linux       DHCP      On      0.0.0.0:5901
```

Once it starts, we can open our VNC client. For the VNC server, you need to
enter the IP address of your FreeBSD host and the port that you assigned
during configuration, e.g. `192.168.1.76:5901`

## Install Ubuntu

A window should open showing the the Linux boot. Depending on how long it
takes you to connect, you may see the `grub` boot menu or the Ubuntu installer
may have already started. Go through the installation process.

<div align="center">
<img
src="/assets/images/2022/09/vnc1.png"
alt="Screenshot of a VNC client showing the console of a booting Linux server">
<br>
<i><small>
Success! We're booting!
</small></i>
</div>
<br>

<div align="center">
<img
src="/assets/images/2022/09/vnc2.png"
alt="Screenshot of Ubuntu text installer completing the installation process">
<br>
<i><small>
And installing!
</small></i>
</div>
<br>

Rebooting will usually close the VNC client, forcing reconnection. The host
should boot to console, allowing you to log in with the username and password
you chose during installation.

<div align="center">
<img
src="/assets/images/2022/09/mylinuxvm.png"
alt="Screenshot of a VNC client showing a Linux console at the text login prompt!">
<br>
<i><small>
Voila!
</small></i>
</div>
<br>

## Clean up

Once you're done with the VM, you can run the following to stop and free the
resources.
```shell
# Stop the VM
cbsd bstop jname=mylinuxvm
# Delete the VM configuration and ZFS volume
cbsd bdestroy jname=mylinuxvm
```

* CBSD added some configuration options to the files to `/etc/rc.conf`
and `/boot/loader.conf` that you will want to remove.

You can reboot your system to clear the following two changes, or manually
revert them. Leaving them in place until the next reboot is probably
harmless, though.
* Unload the kernel modules you added via `kldload` above
* Remove the VM's network interfaces, probably named `bridge1`
  and `tap1`, depending how many VMs you created. You can remove these with
  the command for each interface. (**DO NOT** try to destroy any other
  interfaces! Leave `lo0` and `em0` alone!)
```shell
ifconfig tap1 down
ifconfig tap1 destroy
```

---

And that's it! Now you know how to create a basic Linux VM on FreeBSD bhyve!

If you have questions or comments, you can [@ me on
Twitter](https://www.twitter.com/fuzzyKB).

---

# References

* [https://cbsd.io/](https://cbsd.io/)
* [https://docs.freebsd.org/en/books/handbook/bsdinstall/](https://docs.freebsd.org/en/books/handbook/bsdinstall/)
* [https://docs.freebsd.org/en/books/handbook/firewalls/#firewalls-pf](https://docs.freebsd.org/en/books/handbook/firewalls/#firewalls-pf)
* [https://docs.freebsd.org/en/books/handbook/ports/#pkgng-intro](https://docs.freebsd.org/en/books/handbook/ports/#pkgng-intro)
* [https://docs.freebsd.org/en/books/handbook/ports/#ports-using](https://docs.freebsd.org/en/books/handbook/ports/#ports-using)
* [https://docs.freebsd.org/en/books/handbook/security/#security-sudo](https://docs.freebsd.org/en/books/handbook/security/#security-sudo)
* [https://docs.freebsd.org/en/books/handbook/zfs/](https://docs.freebsd.org/en/books/handbook/zfs/)
* [https://tigervnc.org/](https://tigervnc.org/)
* [https://www.freebsd.org/](https://www.freebsd.org/)
* [https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html](https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html)


---
