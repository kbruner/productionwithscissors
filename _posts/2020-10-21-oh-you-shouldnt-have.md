---
layout: post
title: Oh, You Shouldn't Have!
date: 2020-10-21 02:46:08.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- engineering culture
meta:
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/10/21/oh-you-shouldnt-have/"
excerpt: You don't need 5 routers for your 50-person office, but you do need to respect your engineers' time and expertise
thumbnail: /assets/images/2020/10/sketch1603088565601-01.jpeg
---

_You don't need 5 firewall devices for your 50-person office, but you do need to respect your engineers' time and expertise_

##### _[tl;dr for Executives]({{ site.baseurl }}/2020/10/21/oh-you-shouldnt-have/#what-execs-need-to-know)_

In the famous O. Henry story "The Gift of the Magi," a young couple with limited funds exchange Christmas gifts. The husband buys his wife a set of fancy combs for her beautiful long hair, while his wife gets him a platinum chain for his pocket watch. But irony! The wife has cut off and sold her long hair to a wig maker to pay for the watch chain, and the husband sold his pocket watch to purchase the hair combs.

Actually, this story always bothered me. The wife's hair would grow back eventually.

* * *

Maybe this has happened to you: someone in upper management tells your team that the company has signed a contract with MegaCorp for some device that does foofy stuff. Do you think to yourself...

1. We already have something that does foofy stuff just fine.
1. We don't need something to do foofy stuff because we don't have any foofy-compatible whatchamadoodads.
1. This foofy stuff device isn't compatible with our infrastructure because we don't use a token ring network because it's 2020.
1. What the hell is "foofy stuff?"

<div align="center">
<img
src="{{ site.baseurl }}/assets/images/2020/10/sketch1603088565601-01.jpeg"
alt="Engineer wearing cat t-shirt: We need a foofy-thing-to-whatchamadoodad adapter now & Sales person wearing a tie: We have 5 customers who want to sell us one of... what was that again?">
<br>
<i><small>
All sales people wear ties in my head
</small></i>
</div>
<br>

Depending on the size of the company you work for and what your team actually does, you may not see this often. (I saw this often working with hardware in the film/animation industry. Good times.) However, if you work at a start-up that provides business-to-business software or services, you will see this a lot, I guarantee it.

But this post isn't for you, the engineers. It's for the management chain that pushes technical decisions down by making purchases informed by sales reps instead of by the engineers on the ground. (Ok, engineers, it really is for you.)

## What Execs Need To Know About Buying Tech

1. I'm an extremely experienced infrastructure engineer and I cannot figure out what any product actually does and does not do based on the marketing materials. In particular, if you're an exec for a company that sells tech and you don't know this or you think your company is the only one that does this, then I just have no words.
1. Even if you used to be a hands-on engineer, you are just not going to be as familiar with your company's current inner workings in engineering as you think you are. And trust me, everything has just gotten more and more complicated since you last spent any time working directly with it. The devils of compatibility, manageability, maintainability, operability are all in the details. See point 1 on why you won't be able to grok those from marketing materials and sales meetings, because even the people working hands-on daily with the tech in your org will be hard-pressed to pull critical and pertinent real-world facts out of marketing fairy tales.
1. The amount it costs your company to adopt new tech, even if it serves a critical, relevant purpose, does not stop at the hardware price tag or the annual contract cost. Your engineers are going to have to spent real time not just learning and integrating it with your existing pieces, but they also need to maintain it: monitor it for issues, perform software/firmware upgrades, watch for and react to relevant security bulletins. Picking tech which requires extra work to fit in your organization's environment or is just plain unreliable, build with poor quality controls or prone to outages (particularly for SaaS-based services) can steal hours and energy from your engineering team, pulling them away from areas where their time is better spent and possibly eventually leaving you with the choice of hiring more engineers to support a suboptimal product or watching people burn out and critical work go undone.

I know this customer wants to sell you something and you think the quid pro quo will go along way with them. Maybe it will or maybe it won't. But you're also never going to be able to buy from every customer, so I would hope that's not a standard part of your own sales strategy. No, your company's cloud-based infrastructure really can't use physical networking hardware. Oh, the customer also sells network routing software packaged for AWS? You still don't need five different software routers.

The technology that goes into building out your company's infrastructure and services is complex and sometimes brittle and the pieces don't always fit together neatly, requiring engineering work to glue it together and keep everything moving. If you can find a way to help them get the products they need while making one of your customers happy, then great. But throwing "Hey, Norm at MegaCorp just told me about this wackadoodle they sell. He can give us a discount on licenses. You should see if we can use it" at them out of nowhere can put a number of time and decision-making pressures on your engineers, even if they were actually researching wackadoodles.

Yes, sometimes business needs will dictate technology in ways that are less avoidable. Many retail companies won't serve out of Amazon Web Services because Amazon is their main competitor, or perhaps your company signed a major partnership deal with a tech vendor so you need to use their products. But acknowledging the necessity of some business-driven technical decisions does not mean you should treat all technical decisions that same way. Don't remove the options for engineering-driven choices when you have no valid, external reason for preempting the people whom your company hired for their expertise in their own areas.

If your company genuinely wants to support and enable efficient and effective workings of your engineering organization, then you need to empower your engineers, in this case by allowing them to make critical decisions while occasionally offering support and options.

