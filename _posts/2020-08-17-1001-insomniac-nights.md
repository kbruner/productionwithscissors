---
layout: post
title: 1001 Insomniac Nights
date: 2020-08-17 04:39:53.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- architecture
- data centers
- incidents
- stories
- worst practices
meta:
  _publicize_job_id: '47796708494'
  timeline_notification: '1597639196'
  _last_editor_used_jetpack: block-editor
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/08/17/1001-insomniac-nights/"
excerpt: Stories from the tech trenches
---

_Stories from the tech trenches_



In the _Arabian Nights_, Scheherazade offers to marry a misogynistic king who married a succession of women, only to have them executed the morning after the wedding. The night of her own wedding, Scheherazade began telling the king a story, but sunrise came before she finished the tale, and in a move that prefigured Netflix series, she left off on a cliffhanger, forcing the proto-binge-watching king to postpone her execution for a day.


This pattern continued for, you guessed it, 1001 sleepless nights. Each night she would complete the story from the previous night and then start to tell the king a new tale, making certain that sunrise coincided with a dramatic moment. Finally the king called off his wife's death sentence and she lived happily ever after with her misogynistic serial-killer husband.


I have no idea when or if either of them slept, but I've had my fair share of sleepless nights and stories, too. Here are a few stories about running in production with scissors.



* * *

## The Big Red Button



Part of the time I worked at Warner Bros Animation, it was in the three-story tall office which was part of the Sherman Oaks Galleria. We moved into it from the adjoining International Bank Building, where we had occupied several floors. The data center with the image file servers and render farm sat in the basement of a building almost directly across Sepulveda Blvd from the Galleria.


They put us systems folk in the section of the new offices that was furthest away from any windows or exterior walls. The first-floor room also shared a wall with the screening room, which had heavy, sound-proofed walls. The upshot of all this was that the pagers we had to carry (this predates PagerDuty, et al) so we could respond if critical systems had issues could not actually receive pages when we were at our desks. The operators who sat in the data center had to call us on our desk phones to tell us something was broken. As soon as we stepped outside, all those queued pages would set off.


If we had to deal with a hardware or network issue, we would have to cross all seven lanes (three in each direction plus the center turn lane) of Sepulveda Blvd on the block just north of Ventura Blvd. (Think: extremely busy major thoroughfares.) Except we were kind of in the middle of a long block, so it would add at least 5-10 minutes to go to a corner with a crosswalk. Therefore we frequently jaywalked across those seven lanes of Sepulveda Blvd. Fortunately no one had an accident, but I wonder to this day whether, if we had, it would have been covered by workers comp.


One time the operators called us at our desks to tell us every single computer in the data center had lost power. Some large hardware order had come in and one of the delivery people had backed into the emergency stop button, which had no cover over it and was situated on the wall near an exterior door at, oh, about butt-level. The fix to prevent future such outages: tape a cardboard box on the wall to cover the button.



* * *

## Crossover Cable Mystery



At another job, we served our interactive subscription service from servers our office building. (We were too small and young to have a secondary disaster recovery location, and AWS EC2 was still a couple years down the road.) The connection for the service's dedicated T1 line router to the internal network router required an [RJ45 crossover cable](https://en.wikipedia.org/wiki/Ethernet_crossover_cable).


At some point, the service became unavailable. The office network, on its separate connection, still worked. We were trying to figure out what was happening. Finally someone realized that the ethernet cable for the T1 router had somehow been swapped out with a standard RJ45 cable.


We never figured out how that happened.



* * *

## Down a Rabbit Hole

A team I was on at a company which we will call Kazoo! ran some of the ad-serving event pipelines which generated different datasets, ran on a mix of Linux and FreeBSD servers, and lived in a data warehouse consisting of NFS-mounted partitions on network-attached filers (NAS). Lots of NFS mounts. Depending on the server function, sometimes upwards of 200 per host. (I will never, ever manage NFS in production again. That is some Nasty Fucking Shit, period, but that's another story.)



The system for backing up and archiving these datasets worked by copying them to special NFS partitions (yes, even more Nasty Fucking Shit). Once a partition was full, another team had their own weirdness for writing the partitions to tape, after which the partition would be wiped and go back to the backup pool. On our side, an internally-written service managed querying the dataset inventory DB, finding datasets which needed backup, and copying them over to the backup staging partitions. We will call that application Wacko (not its real name). Wacko would take over my life.



I had minimal exposure to Wacko for the first few months that I was on the team. Then the engineer who usually handled issues with it went to India for a month to get married. Wacko was about to take over my life.


It was consistently falling further and further behind on backups, and our multiple terabytes of live datasets threatened to fill our filer space. The pending backup queue had fallen a month behind. And even though this data was used for billing advertisers to the tune of half the company's gross revenue and thus fell under government regulations regarding data retention, no one was buying us more disk space. After about the third time the tier 1 engineers escalated to me because they were getting alerts about disk space or related issues, I said, fuck this, I am fixing this damn thing. Wacko then took over my life.


A couple years ago, I wrote about a form of application architecture which I call the [Winchester Mystery App](https://productionwithscissors.run/2017/09/11/winchester-mystery-app/). Wacko was one such application. A set of Perl scripts, its maintenance had passed through many hands. Wacko "observability" consisted of its log files and its shell interface, which showed the number of dataset backups pending or in various other states. Wacko's shell interface would take over my life.


So, here's the thing. Even though Wacko performed a critical function, it had become "deprecated" software. And while someone really should have killed it with fire, the powers-that-be had deprecated it without finding or creating a replacement for the production teams which still depended on its critical functionality. Ah, classic Kazoo! Before you ask, of course there was no documentation. And, again, Perl code. Deciphering Perl you didn't write (actually, any Perl code you did write, too) is like reading a doctor's handwriting when that doctor was using their non-dominant hand to write while riding a roller coaster through a pitch black tunnel. You could still open a Bugzilla ticket against Wacko, but no team owned it anymore. One engineer somewhere would occasionally look at the tickets and tell you it works fine for this other team which had about 1/100 the volume of data we did. Bugzilla status: `WONTFIX`. Wacko, an application which existed in limbo, was taking my life with it.


I started staring at the shell interface, watching the filer metrics, reading the code, and staring at the logs. One fun fact: the log entries had no standard format, so the backup ID and other fields would move around. I had to write about as many regular expressions as there were different event log types if I wanted to track a single dataset end-to-end. There is a special place in hell for architects who don't define a standard log entry format and for developers who don't figure out the convention and use it, and I can only hope it was worse than the hell I went through trying to untangle that shit, because it had taken over my life.


I started turning different knobs to see what helped, eventually managing to remove or mitigate one bottleneck after another. I spent so much time starting at that refreshing status window that I literally started seeing it in my dreams. I became so obsessed with beating Wacko into submission, I was checking on its status at all hours. I was so tired after a couple weeks of that, I almost fell asleep on an LA Metro bus, the only time that even came close to happening. Wacko was consuming my life.


_... to be continued_


