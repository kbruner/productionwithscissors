---
layout: post
title: 1001 + 3 Insomniac Nights
date: 2020-11-15 08:48:43.000000000 -08:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- stories
meta:
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/11/15/1001-3-insomniac-nights/"
excerpt: More sleepless stories
thumbnail: assets/images/2020/11/14-1-01.jpeg
---

_More sleepless stories_


Previous insomniac nights:


- [1001]({{ site.baseurl }}/2020/08/17/1001-insomniac-nights/)
- [1001 + 1]({{ site.baseurl }}/2020/08/29/1001-1-insomniac-nights/)
- [1001 + 2]({{ site.baseurl }}/2020/10/09/1001-2-insomniac-nights/)


## Fire and Ice Alarms (cont.)


... had a window that could open, so a lot of the smokers, when they didn't want to go outside the office building and stand in the cold, would stand next to this window and smoke there, because conveniently, the window also did not have a security alarm.


This smoker's window happened to be on the floor right above the machine room with our servers. Apparently someone forgot to close it one night. Thus the pipes in the ceiling above the machine room froze, burst, and water and wackiness ensued.


An alarm was added to the window soon after that event.


* * *

## The Hotel Bar


Yahoo's Burbank office was in a business park a block from the Burbank Airport and next door to a Marriott, which had the closest bar. We would sometimes go after work.


One day, after a disastrous deployment in the morning, we spent the day waiting for the dev team to provide a fix. They hadn't finished by 4, so we ended up going to the Marriott to wait. So, that was the time we did a production deployment from a hotel bar.


* * *

## Hungry Hungry Hippos


Said Yahoo! office used a different conference room naming scheme for each floor. One was cheese, another was arcade games, one was board games, and I forget the fourth.


After a severe outage of a core service, I was told by someone up in HQ to go check out the whiteboard in Hungry Hungry Hippos. Apparently they'd run the post-mortem conference call from there and left an epic "Do not erase" diagram.


So now when I think about post-mortems for major outages, I also think of Hungry Hungry Hippos.


* * *

## Creamer


I worked at a video streaming company that used to livestream Blizzcon. Because it was a major event and held on the weekend, we had shifts in the office in case anything went wrong.


One of the customer success reps working on logistics asked us if we wanted any particular food or beverages or anything else. Some people requested beer. I asked for some Bailey's to put in my coffee.


<div align="center">
<img
src="{{ site.baseurl }}/assets/images/2020/11/14-1-01.jpeg"
alt="cardboard box with a note attached: War Room Team Rules: 1. Enjoy! 2. Karen has first dibs on the Bailey's 3. No one who isn't/hasn't worked on Blizzcon gets any. This is exclusive booze -Ed">
</div>
<br>


I also put in a ticket for facilities to put a sushi-boat style conveyor belt in the conference room we were using, but that never happened.


We didn't go through the whole bottle of Bailey's, so I kept it on my desk afterward. Occasionally people would stop by when they needed special creamer for their coffee.


* * *

## TWO YEARS


I worked a company that used Java with Log4j for logging. Log4j was configured to submit log entries to a logging SaaS by sending them to an agent running on the same server. However, the multi-line Java stack traces would get appear as single-line entries on the logging SaaS, making them very hard to correlate and follow.


People would come to me periodically to deal with the issue by blaming the SaaS. I would tell them that it wasn't the SaaS, which supported multi-line entries, as could be seen with our non-Java apps, and that the logging library shared by the Java apps was likely at fault. Eventually I ran a test with `tcpdump` on a server, showing that the messages had already been broken up into one line per message to the logging agent. But still, regular visits blaming the log service. Eventually, I even wrote an FAQ about the issue, which included the `tcpdump` output, so when people pinged me about it, I could point them to it. It was on the app side, clear as day.


This went on for two years. TWO YEARS. Finally, I had had it. I...


_[to be continued...]({{ site.baseurl }}/2021/03/10/1001-4-insomniac-nights/)_


