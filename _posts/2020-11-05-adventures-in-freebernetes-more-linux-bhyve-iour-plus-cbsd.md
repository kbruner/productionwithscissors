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
  _last_editor_used_jetpack: block-editor
  _oembed_49d011b5a532b5864de9fc6549a480a4: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    trying to create a bhyve Debian guest using a ZFS drive and FreeBSD keeps crashing...
    Oops.<br><br>How&#39;s your Saturday?</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1322617187400511488?ref_src=twsrc%5Etfw">October
    31, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_49d011b5a532b5864de9fc6549a480a4: '1604605096'
  _oembed_f36e2fe523ac86c08406a5e95fb2ddc9: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    still not wrong in thinking UEFI was just a plot fueled by Microsoft to increase
    the pain of installing OSS operating systems on PCs, right?</p>&mdash; Karen Bruner
    (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1323092341628887041?ref_src=twsrc%5Etfw">November
    2, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_f36e2fe523ac86c08406a5e95fb2ddc9: '1604605096'
  _oembed_ad0110f92deec40f2a22668022989883: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    trying to create a bhyve Debian guest using a ZFS drive and FreeBSD keeps crashing...
    Oops.<br><br>How&#39;s your Saturday?</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1322617187400511488?ref_src=twsrc%5Etfw">October
    31, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_ad0110f92deec40f2a22668022989883: '1604296435'
  _oembed_b251959dc9b1b40dec989ba282849dec: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    still not wrong in thinking UEFI was just a plot fueled by Microsoft to increase
    the pain of installing OSS operating systems on PCs, right?</p>&mdash; Karen Bruner
    (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1323092341628887041?ref_src=twsrc%5Etfw">November
    2, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_b251959dc9b1b40dec989ba282849dec: '1604296435'
  _oembed_9ca62d79c37e3b10710af9a9cd2ecd4b: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    trying to create a bhyve Debian guest using a ZFS drive and FreeBSD keeps crashing...
    Oops.<br><br>How&#39;s your Saturday?</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1322617187400511488?ref_src=twsrc%5Etfw">October
    31, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_bae6c6efe3e53cc7fb576da3c8d438d8: "<div class=\"embed-twitter\"><blockquote
    class=\"twitter-tweet\" data-width=\"500\" data-dnt=\"true\"><p lang=\"en\" dir=\"ltr\">I
    MISSED YOU SOOOO MUCH, FREEBSD CORE FILES!!!! ❤️\U0001F525 <a href=\"https://t.co/ORmzIRqrLi\">pic.twitter.com/ORmzIRqrLi</a></p>&mdash;
    Karen Bruner (@fuzzyKB) <a href=\"https://twitter.com/fuzzyKB/status/1322348545064644608?ref_src=twsrc%5Etfw\">October
    31, 2020</a></blockquote><script async src=\"https://platform.twitter.com/widgets.js\"
    charset=\"utf-8\"></script></div>"
  timeline_notification: '1604596508'
  _publicize_job_id: '50726174543'
  _oembed_time_9ca62d79c37e3b10710af9a9cd2ecd4b: '1604596511'
  _oembed_d3f721167671e55237ee6f1b72fe0772: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    still not wrong in thinking UEFI was just a plot fueled by Microsoft to increase
    the pain of installing OSS operating systems on PCs, right?</p>&mdash; Karen Bruner
    (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1323092341628887041?ref_src=twsrc%5Etfw">November
    2, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_d3f721167671e55237ee6f1b72fe0772: '1604596511'
  _oembed_2e5b9559b828d29747f1f31d45a0b569: "{{unknown}}"
  _oembed_60af7631e18d20808a4f7b94a449f18b: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    trying to create a bhyve Debian guest using a ZFS drive and FreeBSD keeps crashing...
    Oops.<br><br>How&#39;s your Saturday?</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1322617187400511488?ref_src=twsrc%5Etfw">October
    31, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_60af7631e18d20808a4f7b94a449f18b: '1604596511'
  _oembed_f4cce3d4a0f6b0f9d0e12df3f4cfef1b: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    still not wrong in thinking UEFI was just a plot fueled by Microsoft to increase
    the pain of installing OSS operating systems on PCs, right?</p>&mdash; Karen Bruner
    (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1323092341628887041?ref_src=twsrc%5Etfw">November
    2, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_f4cce3d4a0f6b0f9d0e12df3f4cfef1b: '1604596512'
  _oembed_78e8e97845a5a7b8b855265d361f5db2: "{{unknown}}"
  _oembed_4b5c7db4098d6b5398075cedc5cdf5e6: "{{unknown}}"
  _oembed_eae0d132a3aeec380c804ae6d4409c9d: "{{unknown}}"
  _oembed_03f6a9a8a0b323a8ae50b77a392bc09c: "{{unknown}}"
  _oembed_f96864a9ffc8e4a6fc7698594a130b41: "{{unknown}}"
  _oembed_6e118d49a5ca64f4f8bb3ca6f6301d3c: "{{unknown}}"
  _oembed_time_bae6c6efe3e53cc7fb576da3c8d438d8: '1604596965'
  _edit_last: '108235749'
  _oembed_85873db5d4f45e4bf2c19b1311276737: "{{unknown}}"
  _oembed_e71892c5d3b68e61c13b92461b237d66: "{{unknown}}"
  _oembed_5b52f8b0b79d56c8c611685377179b7f: "{{unknown}}"
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/11/05/adventures-in-freebernetes-more-linux-bhyve-iour-plus-cbsd/"
excerpt: 'Part 4 of experiments in FreeBSD and Kubernetes: UEFI Booting + Installing
  CBSD'
---
<!-- wp:paragraph {"fontSize":"medium"} -->

_Part 4 of experiments in FreeBSD and Kubernetes: UEFI Booting + Installing CBSD_

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

[_See all posts in this series_](https://productionwithscissors.run/freebsd-virtualization-series/)

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

At the end of the previous post, I hit an issue while trying to create a Debian guest backed by a ZFS volume on the FreeBSD hypervisor. Installation from a virtual CD ISO onto the ZFS volume went fine, but when trying to boot from the ZFS virtual disk using `grub-bhyve`, the FreeBSD kernel panicked.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/twitter.com\/fuzzyKB\/status\/1322617187400511488","type":"rich","providerNameSlug":"twitter","responsive":true,"className":""} -->

https://twitter.com/fuzzyKB/status/1322617187400511488

<!-- /wp:embed -->

<!-- wp:heading -->

## Booting with UEFI

<!-- /wp:heading -->

<!-- wp:paragraph -->

After spending half a day waiting for the `sysutils/bhyve-firmware` port and its missing dependencies, which include the past-its-expiration-date Python 2.7, to compile, I try to boot the Debian guest using UEFI, but after a few failed attempts and more reading, it looks like converting an existing BIOS disk is iffy, especially as UEFI requires disk space of its own, which I didn't preserve.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/twitter.com\/fuzzyKB\/status\/1323092341628887041","type":"rich","providerNameSlug":"twitter","responsive":true,"className":""} -->

https://twitter.com/fuzzyKB/status/1323092341628887041

<!-- /wp:embed -->

<!-- wp:paragraph -->

So I boot from the installer image again, but adding UEFI bootrom. (Note that UEFI boot does not require running `bhyveload` or `grub-bhyve` first.)

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/0be1bbcbce8e4250c351e108241f6327","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/0be1bbcbce8e4250c351e108241f6327

<!-- /wp:embed -->

<!-- wp:paragraph -->

And install. And then run the same command, but without the ISO virtual device. And success!

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/52ba7d67d6d261712f71b098a9c2e5c0","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/52ba7d67d6d261712f71b098a9c2e5c0

<!-- /wp:embed -->

<!-- wp:paragraph -->

Ok, the terminal is messed up because UEFI assumes a graphical output, so I effectively have a 3-line display. (Not joking.) So I get the IP address with `ip addr show | grep inet` (after cursing the lack of `ifconfig`) and ssh in.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

So, yes, using a ZFS volume as the root disk for a Linux VM works (and should provide some disk I/O performance benefits, which I am not benchmarking), but you have to use UEFI instead of BIOS.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Grub Booting ZFS Redux

<!-- /wp:heading -->

<!-- wp:paragraph -->

Meanwhile, on FreeBSD Twitter, I was connected with [Chuck Tuffli](https://twitter.com/ctuffli), who gave me access to an update development version of `grub-hyve` to test with the grub-based Debian ZFS volume. Before I had overwritten my original Debian ZFS volume for UEFI booting, I had created a clone:

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/e3085004775b77a85f63da8d5825eed5","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/e3085004775b77a85f63da8d5825eed5

<!-- /wp:embed -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/acbcc6df2c9a4a5b0f13d05b49f8845c","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/acbcc6df2c9a4a5b0f13d05b49f8845c

<!-- /wp:embed -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/705729f4a9584f050ac2340cbfa9f95d","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/705729f4a9584f050ac2340cbfa9f95d

<!-- /wp:embed -->

<!-- wp:paragraph -->

This time `grub-bhyve` read the ZFS volume without making FreeBSD panic, and I was able to load and boot the kernel for Debian.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Hopefully this updated `grub-bhyve` version, which also adds XFS support, will get pushed to the ports tree soon.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Getting Ready for CBSD

<!-- /wp:heading -->

<!-- wp:paragraph -->

The last two posts and change have demonstrated some of the permutations of possible bhyve guests and the amount of effort even simple proofs-of-concept involve.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

The [CBSD](https://cbsd.io/) project exists to help manage that complexity. While it also supports FreeBSD jails and Xen VMs, I'm going to focus on bhyve. I'm building it from the `sysutil/cbsd` port, so now, among other packages, I now have `sudo` installed.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

After the port finishes compiling, it reminds the user to finish installation by running `env workdir="/usr/cbsd" /usr/local/cbsd/sudoexec/initenv` and interactively fed it the following values:

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/2e469cf22bfdacf0e318eae103be5258","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/2e469cf22bfdacf0e318eae103be5258

<!-- /wp:embed -->

<!-- wp:heading -->

## Running CBSD

<!-- /wp:heading -->

<!-- wp:paragraph -->

With that installed, I reboot the host to clear the network interfaces and VMs I had created and then try to start bhyve.

<!-- /wp:paragraph -->

<!-- wp:jetpack/markdown {"source":"```\nroot@nucklehead:~ # cbsd bconstruct-tui\nNo kldloaded module: vmm\nPlease add vmm_load=\u0022YES\u0022 to \/boot\/loader.conf and\nput kld_list=\u0022vmm if_tuntap if_bridge nmdm\u0022 into your \/etc\/rc.conf then reboot the host.\nPress any key...\n```"} -->

```
root@nucklehead:~ # cbsd bconstruct-tui
No kldloaded module: vmm
Please add vmm_load="YES" to /boot/loader.conf and
put kld_list="vmm if_tuntap if_bridge nmdm" into your /etc/rc.conf then reboot the host.
Press any key...
```

<!-- /wp:jetpack/markdown -->

<!-- wp:paragraph -->

Given then the CBSD had added entries to both files, I'm assuming it skipped these because they had been loaded in the running kernel when I ran `initenv`, but it did not or could not test for cross-boot persistence.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

After adding the entries and rebooting, I try again.

<!-- /wp:paragraph -->

<!-- wp:jetpack/markdown {"source":"```\nroot@nucklehead:~ # cbsd bconstruct-tui\nThe current version requires tmux\nPlease run pkg install tmux or make -C \/usr\/ports\/sysutils\/tmux install it.\n```"} -->

```
root@nucklehead:~ # cbsd bconstruct-tui
The current version requires tmux
Please run pkg install tmux or make -C /usr/ports/sysutils/tmux install it.
```

<!-- /wp:jetpack/markdown -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/e23839d8ce507c965be32615a6cd4144","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/e23839d8ce507c965be32615a6cd4144

<!-- /wp:embed -->

<!-- wp:paragraph -->

That did not require installing half the ports tree this time, so when I ran `cbsd bconstruct-tui` again, it opened the text UI. Third time's a charm.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1093,"sizeSlug":"large","linkDestination":"none"} -->

![Screen shot of CBSD's text-based user interface showing menu options for creating a new bhyve virtual machine]({{ site.baseurl }}/assets/images/2020/11/screenshot-2020-11-05-at-08.55.48-01.jpeg?w=646)  

_Yes, I need to find a better terminal type for these menus in my Chrome OS Linux terminal. Suggestions welcome._

<!-- /wp:image -->

<!-- wp:separator -->

* * *
<!-- /wp:separator -->

<!-- wp:paragraph -->

[The next post](https://productionwithscissors.run/2020/11/09/adventures-in-freebernetes-vm-management-with-cbsd/) will focus on experiments with CBSD.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Sources / References

<!-- /wp:heading -->

<!-- wp:list -->

- [https://cbsd.io/](https://cbsd.io/)
- [https://cbsd.io/cbsd/docs/Quick-start/](https://cbsd.io/cbsd/docs/Quick-start/ )
- [https://www.freebsd.org/doc/en\_US.ISO8859-1/books/handbook/virtualization-host-bhyve.html](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/virtualization-host-bhyve.html)

<!-- /wp:list -->

<!-- wp:paragraph -->

<!-- /wp:paragraph -->

