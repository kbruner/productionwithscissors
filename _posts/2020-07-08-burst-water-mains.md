---
layout: post
title: Burst Water Mains
date: 2020-07-08 00:18:48.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- cloud
- incidents
meta:
  _publicize_job_id: '46311383464'
  timeline_notification: '1594167531'
  _edit_last: '108235749'
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/07/08/burst-water-mains/"
excerpt: When root causes aren't
---

Scary story: commuting in LA traffic.

That's it. If you've ever lived there, that's enough.

Now imagine you're on a major surface street during an evening commute. ("surface street" == not a highway, major means it's as wide as a highway. LA traffic has its own jargon, and when I moved to the Bay Area, I was surprised by how much of that jargon was local to Socal specifically.) You're stopped at a major intersection (where two major surface streets meet) and suddenly water starts gushing up into the intersection from the maintenance holes.

Yeah, you're not getting home any time soon.

In the summer of 2009, when I was still living just outside LA proper, this scenario played out [multiple times](https://latimesblogs.latimes.com/lanow/2009/09/2-more-la-water-main-burst-overnight-bringing-more-questions.html). The LA Department of Water and Power (DWP) recorded 101 water main breaks, more than double the preceding year. (The city's water mains tend to run beneath major streets, hence the locations for the flooding.)

Some of the bursts just caused traffic disruptions, but some were large enough to cause real property damage to buildings. One blowout opened up [a sinkhole that tried to eat a fire engine](https://www.scpr.org/news/2009/09/08/6065/fire-truck-falls-north-hollywood-sinkhole/).

As the realization hit that the numbers were much higher than in previous years, the DWP and others began floating theories, including:

* The most obvious reason: the age of the mains. Most of them were iron pipes dating back almost a full century. The DWP had already started planning replacement work.
* Temperature variations, although the summer of 2009 was about average.
* Increased seismic activity.
* Statistical anomaly.

City engineers were puzzled, though, because the breaks were taking place [all over the city](https://www.latimes.com/local/la-me-watermain-break-map20-html-htmlstory.html). (They also seemed to take place at many different times of the day and night, but I can't find a comprehensive list.)

However, 2009 was a bit different from previous years in one critical way. [The DWP had instituted new lawn-watering rules for water conservation](https://www.latimes.com/archives/la-xpm-2009-apr-23-me-lawn-watering23-story.html) that went into effect at the beginning of the summer. Automatic sprinkler systems could only run on Mondays and Thursdays and only outside the hours of 9AM-4PM.

The new water rationing was not a major theory in the DWP, though, because many other cities in the area, including Long Beach, had similar rules but without the increased incidence of pipe blowouts.

The city created a panel of scientists and engineers to investigate. In the end, they found that [water rationing was the key player here.](https://www.latimes.com/archives/la-xpm-2010-apr-13-la-me-water-mains14-2010apr14-story.html) While the age and condition of the pipes played a major role, the extreme changes in water pressure in the pipes between days with and without residential watering proved to be the tipping point. As a result of the findings, the city changed the water conservation policy to try to maintain more consistent flows.

(While we're here, let's note the irony of a policy designed to conserve water that led directly to conditions that sent millions of gallons of it flooding city streets.)

Production service incidents tend to follow similar patterns. There is never just one root cause. Instead, as in LA in the summer of 2009, pre-existing, less-than-ideal conditions often suddenly get pushed past their breaking point by a sometimes small change. I don't know how much research was conducted before the city decided to institute the original conservation policy, and whether or not water pressure changes and their effects on the mains were even considered. If the DWP was not consulted, that's another contributing factor. If they were and, for whatever reason, they did not anticipate issues given the known state of their infrastructure (remember, they were already planning on replacing century-old pipes, a process ongoing to this day), either case would also act as a contributing factor to the incident.

One of my favorite examples of a (very, in this case) complex chain reaction of events colliding with less-than-ideal conditions comes from the write-up of the [AWS S3 outage in us-east-1](https://aws.amazon.com/message/41926/) in February 2017. In addition to the sheer size and length of the outage, it also gave many engineering teams and users a chaos monkey look into which services had hard dependencies on that specific S3 region; one of these impacted services was AWS's own status board. AWS had to use Twitter to supply updates to customers during the outage.

The media at the time kept writing stories with headlines like, "Typo Takes Down S3," but that was not only a gross oversimplification, it was... well, maybe not wrong, but arbitary scapegoating. Here are some equally valid and yet invalid, given the lack of scope, headlines they could have used:

* "Maintenance Script That Did Not Check Input Parameters Takes Down S3"
* "S3 Suffers Regional Outage Because AWS Stopped Testing for Regional Outages"
* "S3 Collapses Under the Weight of Its Own Scale"

Honestly, someone should make a Mad Libs based on those headlines.

At any rate, focusing on a chain of discrete or tightly-coupled events in a post-mortem makes less sense than focusing on the contributing conditions, at least if you genuinely want to prevent future issues. These conditions, especially where humans are involved (which is everywhere), are highly contextual and directly related to the organization's culture. If the engineering teams involved have a culture of strong ownership and collaboration, your set of solutions, both technical and process-related, can and probably should be very different than if the team has a lack of discipline or a lack of footing in reality. And in the latter case, ideally (but probably not realistically), the existing culture should be a target of remediation.

Those century-old cast-iron water mains would have failed sooner or later. In fact, they still do on a regular basis. However, a well-intentioned policy change meant to address a situation unrelated the health of the infrastructure and which may or may not have taken that infrastructure's decrepit, degraded condition in mind created some chaotic water main blowouts that summer. If you're looking at a production incident and your "root cause" is singular, whether it's either just one event, or one pre-existing condition, or a simple combination, you're not going to prevent anything in the future, except perhaps effective incident prevention itself.

(P.S. You should read John Allspaw's definitive [writings](https://www.kitchensoap.com/2014/11/14/the-infinite-hows-or-the-dangers-of-the-five-whys/) on incident analysis.)

