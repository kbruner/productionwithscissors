---
layout: post
title: 1001 + 1 Insomniac Nights
date: 2020-08-29 17:31:24.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- security
- stories
meta:
  _publicize_job_id: '48256190530'
  timeline_notification: '1598722287'
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/08/29/1001-1-insomniac-nights/"
excerpt: More stories from the trenches
---

_More stories from the trenches_


[Previously](https://productionwithscissors.run/2020/08/17/1001-insomniac-nights/), I recounted the story of [Scheherazade](https://en.wikipedia.org/wiki/Scheherazade) and the Arabian Nights.


These are my stories.


## [Down a Rabbit Hole](https://productionwithscissors.run/2020/08/17/1001-insomniac-nights/#down-a-rabbit-hole) (cont.)


Eventually, though, not only was Wacko operating efficiently enough to meet its regular throughput demands, it was exceeding them. When my co-worker returned after a month, I gave him his wedding present: an empty pending backup queue. Not only did Wacko no longer cause, directly or indirectly, multiple alerts per week, it had no problems for at least a year, except when the downstream tape backup system, owned by another team, malfunctioned.


For several years, I would tell an abbreviated version of this story in job interviews when asked to describe a difficult problem I had solved. I'm pretty sure I never came close to capturing the sheer, all-consuming absurdity of the situation in that format, though, both because of the time involved and because I would have sounded like a crazy person, which I personally think was actually a completely legitimate and sane response to a situation which was just Wacko.


* * *

## This Case Is Intentionally Empty 


For a period of time around a dozen years ago, HP ([Hewlett Packard](https://en.wikipedia.org/wiki/Hewlett-Packard)) enterprise-grade servers "featured" a remote administrative interface, called "Integrated Lights-Out" ([HP ILO](https://en.wikipedia.org/wiki/HP_Integrated_Lights-Out)). Basically, managing any number greater than 0 of HP servers if you did not have direct physical access to them was.... not ideal.


However, to use HP-ILO, you needed a license, generally paid in addition to the hardware costs. Even if you bought the license keys at the same time as the hardware, HP would send you the license key. Printed on a sticker. Affixed to a [DVD case.](https://en.wikipedia.org/wiki/Keep_case) Which did not contain a DVD. In place of the DVD, the prongs which normally held the DVD in place from the inner circle held a piece of paper, which said something to the effect that this DVD case did not actually come with an actual DVD.


So if you bought hundreds or thousands or more HP servers with HP ILO licenses, you would end up with hundreds or thousands or more DVD plastic DVD cases.


At one point about a dozen years ago, I claimed one of these cases, including its paper insert, with a license key I had applied to an actual server. I may still have it... somewhere.


* * *

## Java For WTF?


At some point at Yahoo!, I sat near some advertising partner team. I was deep infrastructure, but there were so few of us in the Burbank office, we sat in an oddball spot surrounded by unrelated teams.


At some point, Yahoo! launched a new ad platform. (I think it was [Mojito](https://developer.yahoo.com/cocktails/mojito/docs/intro/mojito_quicktour.html).) Someone who sat two cubicle rows over seemed to do a lot of conference calls with ad partners who, apparently, often did not have much of a technical background. So he would tell them that, for customer ad customization, the platform used JavaScript, "which is basically Java, but it runs in the browser."


After multiple calls where he described it this way, apparently someone finally corrected him and he stopped.


* * *

## Bleeding Heart


After the openssl [Heartbleed](https://heartbleed.com/) vulnerability, my employer at the time became much more focused on patching vulnerable Linux package on our myriad servers. We used Chef for configuration management, and I was tasked with writing a Chef recipe to search for and update vulnerable packages.


Chef uses (used?) a [Ruby](https://www.ruby-lang.org/en/) [DSL](https://dev.to/theterminalguy/creating-a-dsl-with-ruby-28hi) for its recipes. Meanwhile, most Linux packages use [semantic versioning](https://semver.org/), with an x.y.z notation.


So, I did the obvious thing.


```
if to_f(installed.version) < to_f(current.version)
  installed.upgrade()
end
```


Except I kept getting a `NoMethodError`. But...floating point?


_to be continued..._


