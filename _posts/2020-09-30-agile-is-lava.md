---
layout: post
title: Agile is Lava
date: 2020-09-30 07:55:17.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- agile
- engineering culture
- site reliability
meta:
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/09/30/agile-is-lava/"
excerpt: Stop torturing SREs with Agile process that don't fit
thumbnail: assets/images/2020/09/sketch1601445033757-01.jpeg
---

_Stop torturing SREs with Agile processes that don't fit_

<div align="center">
<img
src="/assets/images/2020/09/sketch1601445033757-01.jpeg"
alt="SREs with torches and pitchforks coming for the scrum board with an infinite to-do list and nothing completed">
<br>
<i><small>
SREs coming for the scrum board from hell
</small></i>
</div>
<br>

When I recently wrote about [when Agile isn't](/2020/09/23/agile-inferno/), I mentioned how making Site Reliability Engineers follow Agile can be like trying to shove a square peg in a round hole. This post describes major issues I've seen and heard of in many engineering organizations that can come from trying to force your SRE teams to conform to your product software development schedules and processes.

I will note that every company does SRE differently, and even within companies, especially large ones, the experience can vary. (Expect future posts on the different idiosyncrasies of SRE teams.)

In this post, we will cover scenarios where SRE and Agile do not mix well and talk about how to recognize and address them. (And, speaking from experience, some of them can create a lot of SRE pain.)

## Fires, Fires Everywhere

If your SRE team constantly battles production outages, gets woken up at all hours by alerts, and otherwise operates entirely in reactive mode, you have no business even trying to make them conform to a production schedule for tasks.

A lot of people assume this non-stop firefighting pattern only happens in smaller startups, which is completely false. This kind of SRE abuse can happen in any organization where the product developers do not bear the primary responsibility for how their software actually performs for customers and where management does not respect and prioritize the health and autonomy of its SREs.

_Ask yourself_

* _Who gets woken up when code breaks in production? The people who wrote it or someone else (your SREs)?_

If you are not paging the people who wrote the errant code, you are both expecting someone who is less familiar and less likely to be able to fix it to respond to the issue **and** you're not creating enough incentive for the code authors to write better code that is less likely to wake someone up at 3AM in the first place. (Before you say, "but I can't wake up my SWEs, they're too important," their sleep is not more important than your SRE's sleep. That's some broken, antiquated, whipping-boy logic to think otherwise right there.)

* _Why do we constantly have fires in production?_

Aside from not providing commonsense feedback loops to motivate writing and pushing more stable code, my next guess: you seem to be using your SRE team as a reactive response team rather than a proactive tool for building reliable, resilient systems. You likely also have a great deal of technical debt which is just collecting interest in the form of downtime, missed deadlines, and, oh, yes, disrupted SRE sleep cycles. And until your SREs have the time, space, and focus (which requires, among other things, rest) to improve your monitoring and observability tooling and other crucial infrastructure to increase stability, the problem will almost certainly just continue to get worse.

* _What am I going to do when my SREs quit from burnout caused by constant emergencies with no agency or autonomy for preventing the fires in the first place?_

I dunno. Good question. Have fun with that.

Or you could fix your clearly dysfunctional engineering culture, starting now.

**If you are not prioritizing your SREs' physical well-being at the same level as your production software engineers, you need to take a hard look at your engineering**  **priorities and**  **culture.**

## Waterfall In Disguise

Waterfall methodology masquerading as Agile is definitely one of the two or three dysfunctional SRE "Agile" patterns I've encountered most often. The SRE team sprint seems to get preempted regularly by "surprise" priorities. (_Surpriorities_?)

Let's say your SRE team does have enough bandwidth, in theory, to work on at least something other than firefighting each sprint. This time should go toward improving tooling, collaborating with product engineers to increase software reliability, or other infrastructure improvements. Except it seems, more often than not, that a bunch of "unplanned" work ends up displacing all your well-laid plans.

_Ask yourself_

* _Is this work is troubleshooting or otherwise responding to downtime?_

See the [firefighting section](/2020/09/30/agile-is-lava/#fires-fires-everywhere) above.

* _Are many of the surprise tasks related to current product engineering sprint tasks?_ _Should these tasks have been prioritized during sprint planning? Do they concern dependencies that no one thought of until the development work had started? Were SREs_ _ **not** _ _involved in the design meetings for the epics in progress, or the product sprint planning meetings? Does the product team not consider SRE work an integral part of successfully-delivered features?_

If you answered "yes" to any of the above questions, congratulations, your organization looks like a beautiful farm with lots of nice, tall silos! (That's bad, by the way.) You need to fix how your product management and engineering teams see and work with your SRE team.

* _Do the tasks come from other internal teams, like customer success or sales?_

If, for whatever reason, these out-of-band requests are frequent, genuinely urgent (and not just the typical sales org's definition of urgent, because everything would be urgent), and not always foreseeable, you may need placeholder sprint tasks to buffer for the time. But really, you need to take pains to make sure you do not allow this out-of-band work to become normalized and friction-free for the teams pouring it on your SREs.

## SREs Do Epic Work, But SRE Work Does Not Always Fit into Epics

A lot of critical, steady SRE work does not fall in the normal buckets product managers (PMs) tend to use. Yes, you will need epics for feature work and bugs to track flaws, but SREs routinely handle chunks of work which don't qualify as either. Sometimes it might make sense to classify and enter these tasks as bugs. Perhaps the previous sprint revealed some alerting thresholds that need tuning, which could arguably qualify as a bug.

Some of these tasks might not fall into clear categories. Perhaps an SRE found a way to make a key tool easier to use, but the changes will require about a sprint's worth of work. The PMs don't really see that sort of work as an epic, so the SRE creates an orphaned story. And that story gets ignored during sprint planning because it's not part of an epic...

_Ask yourself_

* _Does our sprint-planning/issue tracker use labels and buckets that make sense for our SRE work?_

Trying to play by someone else's rules can confuse everyone and just make it harder to track the SRE team work.

* _Do tickets tracking improvements and other important work not attached to a product epic seem to get "lost" or remain unprioritized?_

Does your PM system control the entire queue? If so, why are they not actively tracking this work? Is an SRE representative involved in the meetings that handle priorities? If your PM team is going to insist on being the owner of your ticketing system and/or sprint priority planning, make sure they are really taking a holistic view, both of the SRE team's internal priority needs and wants and of their bandwidth.

SRE work usually involves a unique mix of feature development, troubleshooting, collaborating and consulting with development and other teams, performing routine maintenance, tuning telemetry and other systems, researching new technologies, performing testing that falls out of the scope of regular build testing, and more. Trying to shove this mix of reactive, proactive, and planned work into the same processes your org uses for more traditional software development very often just does not make sense. It often ends up creating additional cognitive work for your SREs as they try to maneuver through their own duties according to a set of rules made for a very different job function, and it allows other teams to make assumptions about the way SRE work gets done based on those artificial processes, rather than on reality. Agile methodology tells teams they should be able to adjust their processes as needed. Are you allowing your SRE team to do so?

At the same time, many of these process issues arise from SREs not really being integrated in a meaningful, proactive way with the PMs and product development teams. If you can't find an Agile process that works well for one team without actively working against another, split them out, but realize that you will need to find other methods to maintain alignment when stories from an epic fall across multiple teams.

If most of your SRE stand-ups just end up being a litany of all the tasks that preempted assigned sprint tasks, leading to the next sprint planning meeting where almost everything just gets pulled in again from the previous sprint, then your Agile process, or Agile period, is not working effectively in your SREs' favor. And this non-stop cycle of looking at the same scrum board todo list or not being able to prioritize improvements that would pay off in the long run takes a real toll on morale.

