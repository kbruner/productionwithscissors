---
layout: post
title: 'Adventures in Freebernetes: Will Linux bhyve?'
date: 2020-10-31 20:38:50.000000000 -07:00
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
  _thumbnail_id: '0'
  _last_editor_used_jetpack: block-editor
  _oembed_1c572d25e82e2a67ddbc14a219420ec4: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">TIL
    MacOS&#39;s HyperKit is built on xhyve, a port of FreeBSD bhyve. Which doesn&#39;t
    surprise me, but cool.<br><br>You can run Docker on your Mac thanks to FreeBSD.
    Of course, you can run your Mac thanks to FreeBSD, too.</p>&mdash; Karen Bruner
    (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1320831517497511936?ref_src=twsrc%5Etfw">October
    26, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_1c572d25e82e2a67ddbc14a219420ec4: '1604049688'
  _oembed_fd6469378c768c802cadd9acd9d221ec: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">Oh,
    since when did root&#39;s shell default to csh on FreeBSD?<br><br>(For all I know,
    it&#39;s been &quot;forever,&quot; but I forgot. But wondering why my patently-Bourne
    shell multi-file handle redirection wasn&#39;t working was making me nuts, until
    I finally thought to check...)</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1321867141587570695?ref_src=twsrc%5Etfw">October
    29, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_fd6469378c768c802cadd9acd9d221ec: '1604049688'
  _oembed_dc25057a4d7b4945483d85285901e74a: "{{unknown}}"
  _oembed_b99001233faa52c293efa7dcc4a6ba71: "<div class=\"embed-twitter\"><blockquote
    class=\"twitter-tweet\" data-width=\"550\" data-dnt=\"true\"><p lang=\"en\" dir=\"ltr\">I
    MISSED YOU SOOOO MUCH, FREEBSD CORE FILES!!!! ❤️\U0001F525 <a href=\"https://t.co/ORmzIRqrLi\">pic.twitter.com/ORmzIRqrLi</a></p>&mdash;
    Karen Bruner (@fuzzyKB) <a href=\"https://twitter.com/fuzzyKB/status/1322348545064644608?ref_src=twsrc%5Etfw\">October
    31, 2020</a></blockquote><script async src=\"https://platform.twitter.com/widgets.js\"
    charset=\"utf-8\"></script></div>"
  _oembed_time_b99001233faa52c293efa7dcc4a6ba71: '1604597145'
  _publicize_job_id: '50552499916'
  _oembed_bae6c6efe3e53cc7fb576da3c8d438d8: "<div class=\"embed-twitter\"><blockquote
    class=\"twitter-tweet\" data-width=\"500\" data-dnt=\"true\"><p lang=\"en\" dir=\"ltr\">I
    MISSED YOU SOOOO MUCH, FREEBSD CORE FILES!!!! ❤️\U0001F525 <a href=\"https://t.co/ORmzIRqrLi\">pic.twitter.com/ORmzIRqrLi</a></p>&mdash;
    Karen Bruner (@fuzzyKB) <a href=\"https://twitter.com/fuzzyKB/status/1322348545064644608?ref_src=twsrc%5Etfw\">October
    31, 2020</a></blockquote><script async src=\"https://platform.twitter.com/widgets.js\"
    charset=\"utf-8\"></script></div>"
  timeline_notification: '1604176735'
  _oembed_78a07a0c3b56316235c8467317e13942: "<div class=\"embed-twitter\"><blockquote
    class=\"twitter-tweet\" data-width=\"550\" data-dnt=\"true\"><p lang=\"en\" dir=\"ltr\">I
    MISSED YOU SOOOO MUCH, FREEBSD CORE FILES!!!! ❤️\U0001F525 <a href=\"https://t.co/ORmzIRqrLi\">pic.twitter.com/ORmzIRqrLi</a></p>&mdash;
    Karen Bruner (@fuzzyKB) <a href=\"https://twitter.com/fuzzyKB/status/1322348545064644608?ref_src=twsrc%5Etfw\">October
    31, 2020</a></blockquote><script async src=\"https://platform.twitter.com/widgets.js\"
    charset=\"utf-8\"></script></div>"
  _oembed_time_78a07a0c3b56316235c8467317e13942: '1604176738'
  _oembed_01fdb47279806bf630f8af97650a016a: "<div class=\"embed-twitter\"><blockquote
    class=\"twitter-tweet\" data-width=\"550\" data-dnt=\"true\"><p lang=\"en\" dir=\"ltr\">I
    MISSED YOU SOOOO MUCH, FREEBSD CORE FILES!!!! ❤️\U0001F525 <a href=\"https://t.co/ORmzIRqrLi\">pic.twitter.com/ORmzIRqrLi</a></p>&mdash;
    Karen Bruner (@fuzzyKB) <a href=\"https://twitter.com/fuzzyKB/status/1322348545064644608?ref_src=twsrc%5Etfw\">October
    31, 2020</a></blockquote><script async src=\"https://platform.twitter.com/widgets.js\"
    charset=\"utf-8\"></script></div>"
  _oembed_time_01fdb47279806bf630f8af97650a016a: '1604176738'
  _oembed_6886b99087ee8edb2311c410e9b171ee: "{{unknown}}"
  _oembed_10f0ee5d04d1fcd6070ee21d1ba4476b: "{{unknown}}"
  _oembed_time_bae6c6efe3e53cc7fb576da3c8d438d8: '1604176833'
  _oembed_3b34f906de3203ed919dc222c6af30c6: "{{unknown}}"
  _oembed_5d23ab16c9ecf96fe457b1235f8fcd8e: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">Oh,
    since when did root&#39;s shell default to csh on FreeBSD?<br><br>(For all I know,
    it&#39;s been &quot;forever,&quot; but I forgot. But wondering why my patently-Bourne
    shell multi-file handle redirection wasn&#39;t working was making me nuts, until
    I finally thought to check...)</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1321867141587570695?ref_src=twsrc%5Etfw">October
    29, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_54a7608075f91a9d0e8570f9bf4161e4: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">TIL
    MacOS&#39;s HyperKit is built on xhyve, a port of FreeBSD bhyve. Which doesn&#39;t
    surprise me, but cool.<br><br>You can run Docker on your Mac thanks to FreeBSD.
    Of course, you can run your Mac thanks to FreeBSD, too.</p>&mdash; Karen Bruner
    (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1320831517497511936?ref_src=twsrc%5Etfw">October
    26, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_5d23ab16c9ecf96fe457b1235f8fcd8e: '1604189127'
  _oembed_time_54a7608075f91a9d0e8570f9bf4161e4: '1604189127'
  _oembed_efe4c01f982cce35c60d9791a8f8882b: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">Woohoo!
    Success! Booting from the ZFS root with no human intervention! <a href="https://t.co/Glj4WaJiHn">pic.twitter.com/Glj4WaJiHn</a></p>&mdash;
    Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1320104084183994368?ref_src=twsrc%5Etfw">October
    24, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_99d285230217198fe6e2dbb189e6d684: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">That&#39;s
    not good. <a href="https://t.co/HmX92ta1SI">pic.twitter.com/HmX92ta1SI</a></p>&mdash;
    Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1320096641840394241?ref_src=twsrc%5Etfw">October
    24, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_2b142712f70f30d3e1fd066a7e16abd9: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">Day
    2 of Operation Free BSD<br><br>I updated the BIOS last night. Now trying to see
    I can manually boot from the ZFS-on-root partition, except Ziggy and George are
    having their 11AM zoomies so I keep getting distracted and miss the menu to exit
    into the boot loader.</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1320067211864621058?ref_src=twsrc%5Etfw">October
    24, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_25c053be4999554489f1d4236c688c0b: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">Ok,
    I got the FreeBSD 13.0-CURRENT memstick image, used my ancient Linux laptop to
    dd it onto the USB drive.<br><br>My only HDMI display is my TV, sooooo I&#39;m
    currently sitting on the floor in front of it (don&#39;t have an HDMI cable +
    USB elongator for the keyboard to reach the couch).</p>&mdash; Karen Bruner (@fuzzyKB)
    <a href="https://twitter.com/fuzzyKB/status/1319742463527940097?ref_src=twsrc%5Etfw">October
    23, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_efe4c01f982cce35c60d9791a8f8882b: '1604215235'
  _oembed_time_99d285230217198fe6e2dbb189e6d684: '1604215235'
  _oembed_time_2b142712f70f30d3e1fd066a7e16abd9: '1604215235'
  _oembed_time_25c053be4999554489f1d4236c688c0b: '1604215235'
  _oembed_ad0110f92deec40f2a22668022989883: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    trying to create a bhyve Debian guest using a ZFS drive and FreeBSD keeps crashing...
    Oops.<br><br>How&#39;s your Saturday?</p>&mdash; Karen Bruner (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1322617187400511488?ref_src=twsrc%5Etfw">October
    31, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_ad0110f92deec40f2a22668022989883: '1604268264'
  _oembed_b251959dc9b1b40dec989ba282849dec: <div class="embed-twitter"><blockquote
    class="twitter-tweet" data-width="500" data-dnt="true"><p lang="en" dir="ltr">I&#39;m
    still not wrong in thinking UEFI was just a plot fueled by Microsoft to increase
    the pain of installing OSS operating systems on PCs, right?</p>&mdash; Karen Bruner
    (@fuzzyKB) <a href="https://twitter.com/fuzzyKB/status/1323092341628887041?ref_src=twsrc%5Etfw">November
    2, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js"
    charset="utf-8"></script></div>
  _oembed_time_b251959dc9b1b40dec989ba282849dec: '1604291371'
  _oembed_ec4429a57301a816bac0a256e63405bf: "{{unknown}}"
  _oembed_b1facdffc819db3c1d2201ca30863882: "{{unknown}}"
  _oembed_11c6aca5f0246ccd8b15de504f2bd750: "{{unknown}}"
  _oembed_2dae57a4bb8fd3ec8d6b4475120aa830: "{{unknown}}"
  _oembed_05136f7449223813d0c46174af9f4548: "{{unknown}}"
  _oembed_a0e0373740eb10734f285ac5e80bef3f: "{{unknown}}"
  _oembed_e6d3f195b40b0a7a87bf3aca8ac5577a: "{{unknown}}"
  _oembed_34351755a8bc94b562dd346b7e88a0f9: "{{unknown}}"
  _oembed_d485a8393c73e355d8518cadcce550fb: "{{unknown}}"
  _oembed_05e523f54a21eb1ebb7936ab7c924423: "{{unknown}}"
  _oembed_6721af674e205f294f24bde25bbcda3a: "{{unknown}}"
  _oembed_95efcebea380fe7a1fc8ad9e58b41c22: "{{unknown}}"
  _edit_last: '108235749'
  _oembed_3170c5d21b04d0e2212b554b9c21eea7: "{{unknown}}"
  _oembed_66b3c762838bfb651438a92b58af192d: "{{unknown}}"
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/10/31/adventures-in-freebernetes-will-linux-bhyve/"
excerpt: 'Part 3 of experiments in FreeBSD and Kubernetes: Linux guests'
---
<!-- wp:paragraph {"fontSize":"medium"} -->

_Part 3 of experiments in FreeBSD and Kubernetes: Linux guests_

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

[_See all posts in this series_](https://productionwithscissors.run/freebsd-virtualization-series/)

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Prep Work

<!-- /wp:heading -->

<!-- wp:jetpack/markdown {"source":"In the [previous post](https:\/\/productionwithscissors.run\/2020\/10\/29\/adventures-in-freebernetes-bhyve-my-guest\/), we started compiling the [`sysutils\/grub2-bhyve`](https:\/\/svnweb.freebsd.org\/ports\/head\/sysutils\/grub2-bhyve\/pkg-descr) port, required for running Linux guests with bhyve. We also need the ISO 9660 image for a Linux installer (I'm using [Arch Linux](https:\/\/www.archlinux.org\/)).\n\n`grub-bhyve` is the bhyve boot loader for Linux images. Just like we realized in the previous post that we needed to run `bhyveload` before we could run a FreeBSD guest, we need `grub-bhyve` so we can boot Linux guests.\n\nWe're assuming you've already created the virtual network interfaces (see the previous post) and no other VMs currently exist."} -->

In the [previous post](https://productionwithscissors.run/2020/10/29/adventures-in-freebernetes-bhyve-my-guest/), we started compiling the [`sysutils/grub2-bhyve`](https://svnweb.freebsd.org/ports/head/sysutils/grub2-bhyve/pkg-descr) port, required for running Linux guests with bhyve. We also need the ISO 9660 image for a Linux installer (I'm using [Arch Linux](https://www.archlinux.org/)).

`grub-bhyve` is the bhyve boot loader for Linux images. Just like we realized in the previous post that we needed to run `bhyveload` before we could run a FreeBSD guest, we need `grub-bhyve` so we can boot Linux guests.

We're assuming you've already created the virtual network interfaces (see the previous post) and no other VMs currently exist.

<!-- /wp:jetpack/markdown -->

<!-- wp:heading -->

## Booting Linux... Maybe

<!-- /wp:heading -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/a3c9700459bbfe73f868f1adfb343d24","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/a3c9700459bbfe73f868f1adfb343d24

<!-- /wp:embed -->

<!-- wp:paragraph -->

This should bring up the [GRand Unified Bootloader (grub)](https://www.gnu.org/software/grub/) menu. Now we need to figure out where Arch Linux hides the `vmlinuz` kernel and load that.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/7882399675642f51db3efd178d4a823f","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/7882399675642f51db3efd178d4a823f

<!-- /wp:embed -->

<!-- wp:paragraph -->

And now we can boot the loaded kernel.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/70a169cc7ea9f9f9124f322a195bc78e","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/70a169cc7ea9f9f9124f322a195bc78e

<!-- /wp:embed -->

<!-- wp:paragraph -->

Hmmm, that didn't work. Some searching turns up the fix: add the ISO image's label to the kernel arguments. I also made grub-bhyve barf at least once before I got it all working. (Arch names its ISOs `ARCH_YYYYMM` with the datestamp of the release version.)

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/twitter.com\/fuzzyKB\/status\/1322348545064644608","type":"rich","providerNameSlug":"twitter","responsive":true,"className":""} -->

https://twitter.com/fuzzyKB/status/1322348545064644608

<!-- /wp:embed -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/534d59bf84f66f7285292796ee0b7309","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/534d59bf84f66f7285292796ee0b7309

<!-- /wp:embed -->

<!-- wp:paragraph -->

And again run the `bhyve` command to try to boot. Victory!

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/1a9bac1d62d250d88eec4829f0c71524","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/1a9bac1d62d250d88eec4829f0c71524

<!-- /wp:embed -->

<!-- wp:paragraph -->

I just gave the whole disk to the root partition because lazy.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Next we format and mount the root partition, and because the network interface was configured via DHCP at boot, we can start installing.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/1d6176ed47802e03447f81b878ff1041","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/1d6176ed47802e03447f81b878ff1041

<!-- /wp:embed -->

<!-- wp:paragraph -->

Ohai perl.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/cb24ca2cc39c8983fa183e3ee2d6233e","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/cb24ca2cc39c8983fa183e3ee2d6233e

<!-- /wp:embed -->

<!-- wp:paragraph -->

Then set up time zone, locale, network configuration, etc., and power off the VM.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I take the `cd0` entry out of the `device.map` file and run `grub-bhyve` again, giving it `hd0` as the root device: `grub-bhyve -m device.map -M 1024M -r hd0 arch`

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/9e47a563830220ec7e8d96b28d6bcda1","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/9e47a563830220ec7e8d96b28d6bcda1

<!-- /wp:embed -->

<!-- wp:paragraph -->

Tada!

<!-- /wp:paragraph -->

<!-- wp:heading -->

## A Guest on ZFS

<!-- /wp:heading -->

<!-- wp:paragraph -->

Now that I have reacquainted myself with exactly how minimal Arch Linux actually is (`-bash: which: command not found` -- really???), I'll use Debian to test giving a VM its own ZFS volume instead of using a `img` file for its virtual disk.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/f8b1ae98915f43b79292f92a7dc0de5a","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/f8b1ae98915f43b79292f92a7dc0de5a

<!-- /wp:embed -->

<!-- wp:paragraph -->

The Debian image already has grub installed and pre-configured, so all we have to do is choose "Install."

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/26d7c45b4ebc84a5ec85ae24b2cdcf41","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/26d7c45b4ebc84a5ec85ae24b2cdcf41

<!-- /wp:embed -->

<!-- wp:paragraph -->

That option only loads the kernel with the installer arguments. We still have to boot it, which should drop us immediately into the interactive installer.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/ca8d3c89858c9d0e3e20782444589dc7","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/ca8d3c89858c9d0e3e20782444589dc7

<!-- /wp:embed -->

<!-- wp:image {"id":993,"sizeSlug":"large","linkDestination":"none"} -->

![Screen shot of the text-based Debian installer]({{ site.baseurl }}/assets/images/2020/10/screenshot-2020-10-30-at-21.59.40-01.jpeg?w=647)

<!-- /wp:image -->

<!-- wp:heading -->

## Nobody Panic, But...

<!-- /wp:heading -->

<!-- wp:paragraph -->

When the Debian installation finished, I exited and ran `grub-bhyve -m debian-device.map -M 1024M -r hd0 debian` and then at the grub menu, run `ls` ... FreeBSD panicked. I rebooted tried again, same outcome.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Fortunately `dmesg` was capturing the error.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/cb7d6ec280100f7129e738b0b3b85829","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/cb7d6ec280100f7129e738b0b3b85829

<!-- /wp:embed -->

<!-- wp:paragraph -->

Some searching turned up [this FAQ](https://www.freebsd.org/doc/en_US.ISO8859-1/books/faq/book.html#idp44219512), which explains that the `witness(4)` lock diagnostic watches for potential deadlocks in the kernel. (After reading _[The Design and Implementation of the FreeBSD Operating System](https://books.google.com/books/about/The_Design_and_Implementation_of_the_Fre.html?id=4vhfQgAACAAJ)_ about 10 years ago, the word "mutex" immediately makes me think of the FreeBSD kernel.)

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

`witness(4)` is enabled by default in `CURRENT` kernels for development and debugging purposes, and as I'm running a build of FreeBSD 13.0-CURRENT from last week, that fits.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Anyway, I am now down the FreeBSD maintainers rabbit hole, so I will throw this post out there for now. The next post should have resolution.

<!-- /wp:paragraph -->

<!-- wp:separator -->

* * *
<!-- /wp:separator -->

<!-- wp:paragraph -->

[The next post in this series](https://productionwithscissors.run/2020/11/05/adventures-in-freebernetes-more-linux-bhyve-iour-plus-cbsd/), as we work toward, yes, someday actually running Kubernetes on FreeBSD, will hopefully show a working Linux-with-ZFS-disk VM and then look at [CBSD](https://cbsd.io/), which helps manage your bhyve VMs.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Sources / References

<!-- /wp:heading -->

<!-- wp:list -->

- [https://wiki.archlinux.org/index.php/installation\_guide](https://wiki.archlinux.org/index.php/installation_guide)
- [https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html](https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html)

<!-- /wp:list -->

<!-- wp:paragraph -->

<!-- /wp:paragraph -->

