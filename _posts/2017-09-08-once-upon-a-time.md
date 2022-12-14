---
layout: post
title: Once Upon a Time...
date: 2017-09-08 23:51:03.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- devops
meta:
excerpt: Introduction to the Nightmare before DevOps
permalink: "/2017/09/08/once-upon-a-time/"
---

There was a kingdom that made most of its money by placing little advertisements everywhere (everywhere!) it could fit them on a webpage. It had to record each of these ads very carefully so it could tax the advertiser and so the kingdom's tax collectors didn't come after them for misreporting. The monarch had two regiments to work on making sure the ad serves were processed accurately. One regiment wrote the code to process the ad serves and the other ran the machinery on which the code ran. The two regiments were separated by a big wall. When the first regiment received orders to change their code, once they finished a couple weeks later, they would throw the code over the wall separating them from the second regiment, much like a grenade, because the new code would usually explode in the second regiment's faces. Sometimes it would even explode when the first regiment hadn't pulled the pin from the grenade they made. However, the second regiment was virtually powerless to get the first regiment to stop lobbing grenades over the wall, and no one lived happily ever after, but the first regiment was definitely getting more sleep.

The End.

Well, not the end. I have countless horror stories in the same vein, though, and sadly, they're all true. Even now, that's how software services are still developed and deployed in too many places. The software developers (the first regiment) implement the features requested by the product managers. In a separate silo, the operations team (the second regiment) deals with deploying the code to the servers and trying to keep the whole thing running in the real world, with varying degrees of recourse if the code is unreliable, non-performant, or just a big pile of crap. That model doesn't work and requires an ever-growing army of round-the-clock operations people, which costs real money over the lifecycle of a service, to keep the show running in this 24/7 Internet economy.

So, yes, this is yet another devops blog. I've worked in traditional "operations" roles for many years (past titles include variants of Unix system administrator, systems engineer, service engineer, site reliability engineer, and devops engineer). I plan to share some more of those horror stories, talk about best practices for designing reliable, scalable services, and whatever else seems relevant or interesting.

