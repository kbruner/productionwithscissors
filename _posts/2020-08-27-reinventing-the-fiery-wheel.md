---
layout: post
title: Reinventing the Fiery Wheel
date: 2020-08-27 00:15:51.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- architecture
- engineering culture
meta:
permalink: "/2020/08/27/reinventing-the-fiery-wheel/"
excerpt: Code is lava. So is everything else.
thumbnail: assets/images/2020/08/ixion-u.gif
---

_Code is lava. So is everything else._

<div align="center">
<img
src="/assets/images/2020/08/ixion.gif"
alt="Animated gif of a stick figure on a rotating wheel on fire">
</div>
<br>

In Greek mythology, an entitled bro named Ixion was driven out of his father's kingdom after murdering his father-in-law for stealing some of Ixion's horses after Ixion had refused to pay the "bride price" for his wife. ("Bride price" == buying your bride from her family because women were property.) Zeus took pity on Ixion, even after all this assholery, by inviting him to Mount Olympus, where Ixion promptly started lusting after his host's wife, Hera. Zeus punished Ixion by telling Hermes to bind the asshole to a fiery wheel which never stopped spinning.

* * *

Several years ago, I interviewed at a very small startup. The founders had been at Facebook many years prior to creating this company. In a phone screen with one founder, I was describing how I approached SRE and infrastructure work. One precept: write as little code as possible.

I explained: it's not that I don't like writing code. What I really do not like, though, is _maintaining_ code. That holds true whether I wrote it initially or not. And the maintenance costs of that code over any amount of time will far outweigh the cost of the time it took to write it initially.

The ex-Facebooker seemed genuinely surprised when I said that. But Facebook has armies of engineers who are maintaining all those internal tools, and Facebook had to create many of its own solutions because no solutions existed at the time to support its previously unknown scale in that space. Meanwhile, this guy's startup had maybe a dozen engineers. Surely they needed to concentrate their time as much as possible on the core product which the startup was trying to sell.

Developers develop. Code is their hammer and every problem is a nail. But most developers, especially those who have been at very large and usually older companies, have less visibility or understanding of what it takes to keep that code working month after month, year after year. The original developers will move on to different projects or companies. If the code runs as a service, another team probably owns operations for it. Even if the original developers do contribute to the code's upkeep, they still may not appreciate the volume of work by other engineers to ship monitor it, respond to issues, and ship code updates.

Even cleanly written, well-designed code will almost certainly need various forms of maintenance over time: upstream APIs will change, new functionality requirements will come in, third-party libraries will make backwards-incompatible changes, new scaling requirements will require design modifications, newly discovered security vulnerabilities will need patching.

So what's the alternative to writing your own solution? Sometimes there isn't an obvious one. But either way, you need to have awareness and a plan for managing the resulting service or tool over its lifespan before you start writing code. Most importantly, you need to see code for what it is: a mortgage. You move into your house, but you're going to be paying down the debt for a long time to come, quite probably as long as you live in the house. Look at the principal as standard operational costs and the interest as the technical debt that will accrue over time unless you invest in ongoing maintenance. Eventually you may need to take out a second mortgage to make major renovations.

Very often, an existing open-source or proprietary offering, although it may not suit your needs perfectly, might get you 90% of the way there. Great! That solves all (or at least 90%) of your problems!

Or does it? Let's look at the pros and cons of various hypothetical options.

## Paid / Proprietary Solutions

Depending on the type of software and what your specific use case is, you may have one or more possible options here. First we list the traits common to these, then additional pros and cons by type of offering or solution.

### Common Traits

Pros:

* You're paying them money so they have at least some incentive to keep you happy
* Probably has a fancy, shiny interface because a lot of software is still purchased by pointy-hair types who think shiny == true value

Cons:

* You're paying them money
* They can raise their price in the next annual renewal phase, banking on the probability that it's more trouble for you to rip them out than to suck up the cost increase
* They may not be that good at, or even that motivated to, keeping you happy
* That fancy, shiny interface often comes at the expense of comprehensive API functionality or command-line tooling
* If their software has a bug, you have to wait for them to fix it
* If you want a feature that does not exist, they have to first agree to implement it (rather than shoot it down or lead you on, most likely the latter. "It's on our roadmap" is product manager speak for "Don't hold your breath") and then _actually implement and ship it._ And there's nothing you can do to speed that along (unless you're a really, really big customer) or even get a realistic idea of if and when it will ship. Until then, you're left to create your own workaround or glue code, and by the time they do actually ship the feature, it may be _more_ work to pull out your workaround so you can use their solution.

### Proprietary On-prem Software

Pros:

No additional pros.

Cons:

* You still have to manage deploying, configuring, and upgrading the software
* You still have to allocate, manage, and pay for the compute and other infrastructure resources it requires

### SaaS

Pros:

- They're managing the infrastructure so you don't have to
- They manage software upgrades, etc.

Cons:

- You must manage the managed offering (creation, etc.)

### Platform-as-a-Service / Managed Services

Pros:

- They're managing the physical infrastructure so you don't have to

Cons:

- You must manage cloud and service configuration as needed

* * *

Well, that's a bit grim. But what about an open source solution? I can crowd-source the code and its maintenance instead of owning that myself!

## Open Source

Pros:

- You can actually look at the code
- You can track the status of feature requests and bug fixes, or at least to a greater degree generally than proprietary solutions
- If you have the capacity and skills, you can contribute new features and bug fixes to speed up the process
- Depending on the size and release cadence of the project, you may or may not get fixes and improvements at a faster mean rate than from a paid solution
- Depending on the project, its age, and the size of its adoption footprint, you may be able to get a great deal of unpaid support from the user community
- Having real-world, production experience adopting and using an open-source tool can provide valuable fodder for writing public blog posts or submitting conference talk proposals, bringing visibility to both individual engineers and the company as a whole

Neutral or subjective points:

- Fancy interfaces or other "bell and whistle" features tend to come later to open-source projects than in proprietary offerings, where they are much more likely to be first-class citizens over actual functionality because PRETTY! (I personally don't think this a detractor at all, because you why are you interacting with a critical infrastructure or other tool primarily through a UI rather than automatable, reproducible methods?)

Cons:

- No support plan, although in many cases, a company built around the project or another third-party consulting company may offer paid support. This may be less of a con depending on the available community resources and the skill and bandwidth of your team
- Formal documentation may be haphazard or non-existent
- With the money motivator gone, speeding creation of new features can require different methods of motivating prioritization, such as building widespread support in the community, sponsoring someone to contribute the feature work, or finding bandwidth and skill sets within your company to do the work and contribute it back

## Universal Considerations

Great, all of these possible "We don't write the tool from scratch" solutions can have serious drawbacks and overhead. And no matter the source or form of the third-party solution, you will find a few universal considerations:

Pros:

- Someone else writes and maintains the code

Cons:

- You will almost certainly have to write at least a little shim code or other glue to integrate the third-party solution into your environment. You need to consider the amount and complexity of glue required, because that requires its own maintenance and care. If you find the amount of glue exorbitant, either re-evaluate whether this tool actually saves you more work than it creates, or perhaps whether your own environment may be riddled with excessively unique characteristics or other architectural or design anti-patterns
- If the tool or service's interface or outputs change, you may have to modify on your end the bits of your code that interacts with the software
- You still have to figure out how to deploy in your environment and manage patching and upgrades
- If it runs as a service, you have to provision, manage, and pay for the required infrastructure
- Requires research to find what possible solutions exist and which best suit your requirements, both functionally and operationally

## tl;dr

There is no free service lunch. Whether you spend money directly for a software solution or not, engineers somewhere in your company will always have to expend some amount of time of varying quantity and frequency as long as that software exists in your environment.

The key to meeting your technical needs while minimizing the cost of the long-term investment requires genuinely understanding what the birth-to-death lifecycle of software really entails. Many engineers have only ever seen the initial phase of a service, and this itself is a clue that ownership for the development team ends with "code complete," leaving the rest of the software lifecycle as another team's problem.

To create developers who provide skill and value beyond their programming output, success of a project should not always be measured by lines of code written. Sometimes the number of lines of code _not_ written creates more value. Either way, the most valuable skills engineers can learn and hone as they mature and try to level up may involve no code at all: researching and finding the solution that saves engineering effort across the entire organization _and_ across the years to come.


