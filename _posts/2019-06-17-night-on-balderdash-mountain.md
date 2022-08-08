---
layout: post
title: Night on Balderdash Mountain
date: 2019-06-17 07:13:08.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- code smell
- devops
meta:
  _rest_api_client_id: '2697'
  _rest_api_published: '1'
  _edit_last: '108235749'
  _publicize_job_id: '31905002314'
  timeline_notification: '1560756296'
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2019/06/17/night-on-balderdash-mountain/"
excerpt: Focus on making your software usable by the actual users
---

_Focus on making your software usable by the actual users_

In the Disney animated classic _Fantasia,_ we were meant to be the most terrified by the segment featuring Mussorgsky's "Night on Bald Mountain," with its endless stream of dancing spirits risen from their graves. Balderdash. The most terrifying story was earlier in the film. We were fooled because it starred the plucky Mickey Mouse as _The Sorcerer's Apprentice_.

What was so terrifying about a bunch of dancing brooms and buckets? What _wasn't_ terrifying? When we meet him, Apprentice Mickey is stuck with a neverending rotation of menial, manual tasks. Sweep, sweep, sweep. Fetch, fetch, fetch. So Mickey does what any good engineer with a devops inclination woud do: he tries to automate. However, also like any novice engineer without a strong mentor to peer review his pull requests, Mickey creates a ~~fork~~ broom bomb, with his marching brooms flooding the tower. (Furthering the broken culture where he works, his boss, aka The Sorcerer, then gets angry at him. And even then, he probably still doesn't help mentor Mickey, let alone pay down any of their technical debt.)

One of the hallmarks of a good, strong devops culture is the constant drive towards more and better automation of what were, to varying degrees, manual processes. Performing releases by hand. Manually invoking scripts when cued by an alert. Configuring software or infrastruture via graphical user interfaces. An ever-growing number of tools and services aimed at devops engineers and organizations are driving and driven by the empowerment of automation and the automation of empowerment. And, like all software, and also like many companies saying that they are "now doing DevOps," some of these offerings deliver on the devops promise better than others.

Maybe you've heard the term "code smell," referring to what may seem like small, cosmetic flaws or questionable decisions in source code, but which are usually indicative of deeper, more serious issues, kind of like traces of digital comorbidity. Similar watermarks can often be found in services that are marketed to devops teams. Some real-world examples:

* the SaaS is only configurable via a graphical UI
* the Linux server-side agent is written in JavaScript (you want me to run what on my production servers?)
* the (rapidly mutating) version numbers of the (again, you're asking me to run what on my production servers?) agent are hardcoded in the agent's configuration file
* the public API makes backward-incompatible changes on a very frequent cadence

[Cads Oakley](http://blog.pteralix.com/) suggests the term "operational whiffs" to cover the analogous markers in devops tools, because it's a thing. While symptoms like the ones listed above may not always cause issues, they can be indicative of much deeper issues in the producers of the tools: a lack of true understanding of or empathy for devops practitioners. They can create workflows that are not intuitive or native to devops practice; unnecessary pain at upgrade time because of constant backwards-incompatible changes that also require updating any internal automation; and, at worst, a lack of respect for their customer's time. All of this amounts to creating work and friction for the devops teams the tools are supposed to be helping.

How can software companies trying to sell to devops teams avoid these issues, and create devops-native tooling?

* Dogfood your tool or service internally. Run it the way a customer would and note any pain points that require human intervention
* Listen to customer feedback, not just the direct comments, but also the soft signals. "Well, after I edited that file and did this other stuff, it started to work..." And make sure those messages pass from your Customer Success team to the Product and Engineering teams as actionable items, if possible. (For every one of those comments you hear, there are probably a thousand being said under someone's breath, bookended by expletives.)
* Hire experienced devops engineers, and more importantly, _listen to them_

A product can have all the required bullet-point marketing features for its class in the devops tool ecosystem, but if it's a pain in the ass to configure and maintain, well, then it doesn't _really_ have all the required features. Eventually, those are the tools most likely to get optimized out in the sweep of iterative improvement of devops momentum.

