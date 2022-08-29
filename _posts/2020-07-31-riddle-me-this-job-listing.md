---
layout: post
title: Riddle Me This Job Listing
date: 2020-07-31 04:48:48.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- engineering culture
- hiring
- job search
meta:
author: karen
permalink: "/2020/07/31/riddle-me-this-job-listing/"
excerpt: So you want to hire an SRE?
---

_So you want to hire an SRE?_

_[Jump to the Site Reliability job description best practices](#best-practices)_

In Ancient Greek mythology, the Sphinx guarded the entrance to the city of Thebes, challenging would-be entrants with a riddle and eating anyone who failed to answer correctly. Tourism apparently was not a major industry in Thebes, because no one could solve the Sphinx's riddle, and it apparently did not occur to the Thebans that they should maybe build a second entrance to the city.

One day, Oedipus, fresh off murdering his father, the (now former) king of Thebes, met up with the Sphinx. She sprang her riddle on him and... he answered it correctly. The Sphinx, apparently unable to come up with a new riddle or any other skill to feed herself, then threw herself off a cliff. Oedipus entered Thebes where, as a reward for single-handedly rescuing the city's tourism industry, he was made king and married off to the queen, AKA his mother.

Most ancient sources did not specify the riddle, although the one now commonly associated with the story goes like so: What walks on four feet in the morning, two in the afternoon and three at night?

Answer: An SRE crawling out of bed to get their laptop after getting paged at 3AM, somehow managing to walk upright most of the day, then crawling back into bed at night using only one hand because the other is carrying their laptop.

* * *

I've been on both sides of SRE job postings and I'm actively in the middle of a job search now, so I've got a lot of opinions about what SRE job descriptions should and should not look like. The list comes from efforts trying to encourage diversity of applicants, to optimize for both my time and the potential candidate/employer, and not to be a total asshole to job seekers.

<a id="best-practices"/>
## Karen's List of Best Practices for SRE Job Postings

### 1. State the Opening's Level

I see a lot of listings for "Site Reliability Engineer" with no indication of level. Is it entry-level? No, they seem to want some experience, although they often don't give concrete ranges. While in some rare cases, generally at startups, none of the engineering listings may have specified levels, I will usually see this on a site where the product dev levels **are** spelled out in the listing title. I suspect, in many of these cases, the eng manager comes from a product dev background and either has no idea how to level SREs or possibly even thinks any amount of experience after 2-3 years is irrelevant.

Whatever the reason, please do one of the following:

* Explicitly state a level in the listing so the candidate doesn't waste their time clicking to find out you want someone junior.
* If you're open to multiple levels, say that: e.g. "Sr or Staff SRE opening"
* If you have multiple openings at different levels, say that
* If you frankly have no idea what level SRE you need, say that, unless you think someone may hoodwink you. (I never would, though.)

Also consider that SREs can come from a range of different engineering roles. If you're ok with hiring a very experienced developer who wants to become an SRE but may need some training, state as much in the description (and be honest beforehand whether you have the people to teach them and that you really will give them the support they need).

Of course, putting a potential salary range serves as another way to hint to people about whether or not the role is a level-match, and it could also provide secondary signals if you do not get any resumes from people who are actually qualified.

### 2. Keep the "Must-Have" Specific Technology List Short

And by short, I mean pretty much non-existent.

Look, a smart, motivated engineer can learn whatever thingie they need. Seriously, they weren't born knowing how to PXE boot a goddamn bare-metal Linux server. They can learn. **You want to make sure they are willing and able to learn your shit,** not that they come in knowing it, because, guess what? Your shit will change over time anyways. That's what technology does.

You probably do want to make sure they have had to deal with "a" database, "a" monitoring system, "a" build system, but it really shouldn't need to be "my specific DB/dashboard/pipeline." Now, if you really, really need someone who knows, for example, Kafka inside and out because [stuff happened] and you need someone to hit the ground running NOW, say that. That's ok; that's good, even. But if you need someone who is already an expert with running a dozen+ specific pieces of software, especially if they're complex, you probably need to get real, be ready to shell out a lot of money, or take a hard look at how you've chosen your stack's tech. Also maybe try to figure out how to retain the engineers who knew this stuff in the first place, because apparently losing that knowledge creates... issues.

And who cares if a candidate has "worked with" Docker for 3 years? What if all they'd done that entire time was run `docker pull` and `docker run`? I guess you could list specific tasks they have performed around Docker, but now we're back to that thing about not making a laundry list of required experiences.

Here's another important reason to keep this list short: you're selecting against diversity, [particularly against female candidates](https://hbr.org/2014/08/why-women-dont-apply-for-jobs-unless-theyre-100-qualified), who tend to be much less likely to [Dunning-Kruger](https://en.wikipedia.org/wiki/Dunning%E2%80%93Kruger_effect) themselves into thinking they have a depth of knowledge which they do not actually possess.

So just stop with these goddamn everything-but-the-kitchen-sink "requirements" lists, people. I'm going to start shaming you on Twitter, for real. (Yeah, I'm sure you're quaking at the thought of my 3 followers seeing that.)

### 3. Talk About Your Tech Stack

While you don't want to list every (or any) component of your entire tech stack and platform infrastructure as "must-haves," you should still let the job seeker know what you use. They may think running SQL Server on Linux is the most fun ever, or they may see that you still monitor everything with Nagios and you aren't moving off, which is a major deal-killer to them, as it would be to any sane person. And adding specific tech will also make searches by keyword easier, so candidates with or interested in matching platform skills may even be able to find you more easily.

Again, just make it clear that these specific services are not requirements or even nice-to-haves. "Hey, this is some of the stuff we use, in case you're interested! If you don't know these, though, that's ok, too! We'll figure out if you can learn them when we interview you because that's something we should be trying to figure out in the interview anyway, right? Right?"

### 4. Explain What Your SREs Actually Do

I should maybe put this one at the top. Do you think an SRE sits downstream of product engineers and just has to somehow make their pile of code work? Or do your SREs (or your vision of SRE, if this is your first) have real standing, make decisions for the wider engineering team about how to measure and improve service stability and performance, and work directly with the other teams at all stages of product lifecycle? Is site reliability (uptime, happy customers, etc.) a first-class citizen or just necessary overhead? And if your answer is the latter, maybe, um, spend some time thinking about _that_.

### 5. Be Real

Maybe forgo the standard lists of what you're looking for and talk instead about what the org actually _needs._ "We want to improve the productivity of product engineers by reducing the number/duration of production incidents that eat their time." "We are building out our next-gen platform and want a collaborative SRE to help build resilience into the design and implementation." Etc.

### 6. Be Honest

This one should go without saying, but I know I'm not the only person who took a job that bore no resemblance other than job title to what was published and then discussed with the recruiter, management, and interviewers. People hired under deliberately or accidentally false pretenses will probably leave fast and now you're back at step 0 in filling the role, and how much fun was that for anyone the last time?

### 7. Write for Diverse Candidates

I'm not an expert on exactly how to do this, although not having a white male engineer write the listing would be a good starting place. There's plenty of information on the Internet with advice on how to approach inclusive listings, though. And while it should go without saying, if the hiring manager and the recruiter and everyone else touching the listing are all part of the majority tech demographic, find someone who does not look and sound like them to check the description for tone and other red flags. And if all your candidates still look like your hiring manager and existing team, fix it. A number of consultants and services exist who specialize in helping recruit for diversity.

Just make sure you actively address inclusion and equity so you can keep those employees once you actually find and hire them. That's another story, though.

* * *

Obviously, all these points are optional. And they only partially address a worse problem, namely that most organizations seem to have job listings that could be interchangeable, give or take a few weird combinations of specific required hands-on experience, when the reality of the role in each org varies greatly. That lack of awareness or honesty is also something that seriously needs to change because I can't imagine whom it actually benefits in the long run.

But that's also a topic for another post.


