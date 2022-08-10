---
layout: post
title: Driving a Lemon
date: 2017-09-19 00:00:42.000000000 -07:00
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
  _rest_api_published: '1'
  _rest_api_client_id: "-1"
  _publicize_job_id: '9427759228'
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2017/09/19/driving-a-lemon/"
excerpt: Services can be lemons, too
---
There's a popular urban myth known as "The Killer in the Backseat." The most common variations of the story involve a lone driver, almost always a woman, on a deserted backroad at night. Another vehicle, usually some sort of truck, is following her, flashing its lights, trying to pass her, or even trying to ram her. The car's driver naturally panics and tries to evade the truck, but ultimately either gets pushed off the road or finds a gas station to pull into. The truck's driver then runs up to the window to tell her there's a threatening stranger in the backseat of her car. She had been mistaken about the true threat all along, instead fearing the person who was trying to help her.`

A more realistic automobile fear may be of buying a lemon, a car, usually used, that just ends up having either a series of non-stop issues or one major issue that never quite gets fixed. (My mother ended up with a lemon once; a Buick with a sticky gas pedal. You would be at a stop, then gradually press the gas to start moving, and nothing would happen. If you kept pressing the gas, it would eventually engage and then lurch forward, like it suddenly applied the amount of gas that it should have been ramping up to as the pedal was pushing down. Apparently neither my father nor the mechanic could replicate the behavior, which, granted, didn't happen all the time, but when I came to visit and borrowed the car, it happened to me, too.)

How does all this car stuff relate to devops? Well, let's set up the following analogy: the car is a web application or service, the mechanic (and car builders!) is the software engineering team, and the driver is the "traditional" operations engineering team.

What do I mean by _"traditional" operations engineer_? Basically, when web companies became a thing, they had a clear separation between the people writing the code and the people who kept it running in production. Much of this is because the operations side generally evolved from pre-web system administrators, the people who kept the servers running in any given company. Except those companies, whether they were shrink-wrap software companies or government research labs or visual effects companies, rarely scaled in size and customer base at the rate of the new web businesses. The traditional silo model didn't translate to web applications, and in fact, it helped create and perpetuate major issues.

<div align="center">
<img alt="Two silos standing next to each other labeled dev and ops" src="{{ site.baseurl }}/assets/images/2017/09/untitled-drawing.png" align="center">
<br><i><small>The traditional silo model of web application development and operations. Note the one-way arrow.</small></i>
</div>
<br>


With the silo model, developers are so isolated from the environment and reality of keeping their code operational and performant in a 24/7 web economy that they don't get the proper feedback to help them avoid designs and assumptions that inevitably create issues. Operations engineers, who are the ones who understand what breaks and what scales in a production environment, can, at best, only give advice and request changes after the fact, when the design is long since finished and the code is already in place and many of the developers have been assigned to a new project. The broken app stays broken, and as traffic scales linearly or exponentially, often the team that supports the application must scale with it. If that team is already relatively large because the service is a brittle piece of engineering riddled with technical debt, then the company is faced with either trying to hire more people, assuming it can even attract skilled engineers in this economy, or watching its uptime become an industry joke as the overworked ops people get burned out and leave.

So it is a with a lemon. Maybe the driver can do a few things to mitigate chronic issues, like using a specific kind of higher-grade oil or octane gas, changing belts or filters more frequently, etc., but that can be relatively costly over the life of the car, if it works at all. Or, as with my mother's car, she could tell the mechanic the exact behavior, but if the mechanic is not skilled or not sympathetic, they may just ignore her.  But since the mechanic is probably the only one capable of fixing the root cause, that car and its owner are doomed to a lifetime of expensive and frustrating palliative care.

So it goes with web companies. If the operations team only comes in after the fact to try to manage a poorly-designed. buggy, or non-scalable service, the company is going to throw money at it for the entire life of the service. Even if, and in my experience (which can't be isolated), this is not always the case, the development team has the bandwidth and desire or requirement to fix bugs escalated by the operations team, if the major issues lie deep in the application design or its fundamental execution, those fixes won't be easy.

I still encounter and hear of far too many companies and "old-school" engineering higher-ups who think that an operations team that was not consulted (or didn't exist) during the design and original coding of a service should still somehow magically be able to make any pile of code run in production. Well, maybe, but only if the bosses are willing to hire a large enough team. It would generally be more cost-effective, as in most things, though, to fix the root cause: the code.

Let's take a trivial example. Say a software developer has written some incredibly inefficient SQL queries for dealing with the backend database. Exactly how is an operations team supposed to mitigate that on their own? Well, maybe they could scale the database infrastructure, but that takes money, money that will almost certainly far exceed, over the lifetime of the application (probably just within a couple of days, actually), the amount of money it would take to get the developer to fix the errant SQL queries.

To sum up, the traditional silos create and perpetuate web services that are brittle and fiscally expensive to run, because the people designing and implementing the services rarely have practical experience of what does and does not work well in production, especially at web scale. After-the-fact operations teams can only mitigate some of those issues and only at great cost over the life of the application.

This is a simplified overview of the cultural and organizational issues the DevOps movement and its cousin, site reliability engineering, evolved to address and prevent. I'll delve into it more later.

