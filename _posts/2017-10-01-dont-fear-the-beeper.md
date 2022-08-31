---
layout: post
title: Don't Fear the Beeper
date: 2017-10-01 07:09:27.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- devops
- on-call
meta:
permalink: "/2017/10/01/dont-fear-the-beeper/"
excerpt: You shouldn't have to be afraid of being on-call
---

In one of Aesop's fables, a shepherd boy gets his jollies by raising the alarm that a wolf is threatening the herd to trick the villagers to run out to offer protection, only to find they'd been tricked. After the boy had pulled his prank a few times, a wolf really does come to threaten the sheep, but by now, the villagers no longer believe the boy's cries of "Wolf!" and the herd, and in some variants, the boy, are consumed by the predator.

Any engineer who has spent any amount of time in an on-call rotation that invariably bombards them with constant alerts, particularly when a sizable number of those are either invalid or not really critical, has probably also been tempted to risk letting a wolf eat the bratty shepherd boy.  This "pager fatigue" gets compounded when the same issues arise time after time and never get fixed at the root cause level, and the engineer feels powerless to improve the situation over time. When the on-call rotation is 24 hours, with alerts coming any time of day or night, the physical effects of sleep interruption and deprivation can quickly compound the psychological issues.

I've had more than my fair share of on-call rotations from hell over the years. What would invariably make an already awful situation even worse was the knowledge that it was not likely to get any better. Particularly when the software developers were well-removed from the bugs in their code that were making the service brittle and unreliable, but also when management would not take the time to prioritize those fixes, or, worse, thought a week every month or two of no sleep for an operations engineer was "normal" and part of the job description (not, of course, of the job description they actually posted to hire you), and the situation starts to seem helpless. MTTA (Mean Time To Acknowledge) starts to rise as people are too demoralized or physically tired to jump on every page.

For those deeply-unempathetic upper management types who still believe that, well, this is just part of the job, they're missing the business costs of this effect. Time spent responding over and over to the same issues which never get fixed at the root cause really adds up over time. Site uptime and service-level agreements also get put at risk, which can sometimes result in loss of income or financial penalties to customers. And one of the well-known effects of sleep deprivation (which, after all, is used as a form of torture for a reason) is that it [greatly increases the risk of accidents](http://www.huffingtonpost.com/2013/12/03/sleep-deprivation-accidents-disasters_n_4380349.html). Do you really want an engineer who can barely keep their eyes open trying to fix a complex, broken system, when there's a very non-negligible chance they will just make it worse?

I've also personally witnessed in more than one organization a form of "[learned helplessness](https://en.wikipedia.org/wiki/Learned_helplessness)," where engineers, feeling disempowered and just plain tired, stop pushing for fixes and don't even take care of simple root-cause fixes within their ability. Even on the off-chance that everything else about the job is great (and it's probably not when there's an elephant in the room everyone is ignoring, so no one is cleaning up the elephant-scale dung heaps, either), the never-ending cycle of frustration and stress becomes demoralizing.

While this may be an unwinnable war at many organizations because of the almost industry-wide, deeply-entrenched[normalization of deviance](https://danluu.com/wat/)around how pagers are just going to be noisy and engineers are just going to lose sleep, on-call duty should not have to be an unavoidably soul-sucking experience. And since I've just started a new job, and after one week noticed the engineer on-call seemed to be ack'ing a lot of pages, I knew I had to nip that in the bud. Specifically, before I went on-call.

Here's my plan of action.

1. Technical or configuration actions
   1. Get rich metrics for paging alerts. Unfortunately, the canned reports and analytics for the paging service we're using leave a lot to be desired, so I will probably have to go through the API and generate the per-service, per-error metrics myself. I was also looking at [Etsy's opsweekly tool](https://github.com/etsy/opsweekly), but it doesn't support our pager service, either, so we'd have to write the plugin.
   1. Identify the alerts that are non-actionable and stop making them page. If the on-call can't fix (or temporarily ameliorate) an issue, they shouldn't get woken up for it. If a situation does need handling but does not pose an immediate threat, can it wait until morning? Then wait until morning. If it's still important that people be aware of a situation. send it to Slack or something. If it's a bug that can only be fixed by code change, which may take time, you may need to mute it temporarily, although that's risky. (Do you **always** remember to re-enable an alert when the underlying condition is fixed? Really?)
   1. Prioritize fixes for the most frequent and most time-consuming alerts. If it's broke, fix it. Developer time is precious, yes, and there are new features to deliver, but those same developers are the people getting paged in this on-call rotation. We're [borrowing from Peter to pay Paul](https://en.wikipedia.org/wiki/To_rob_Peter_to_pay_Paul).
1. Engineering culture and attitudes towards on call
   1. Get top-down buy-in. Engineers generally have a natural inclination to fix what's broken. However, they need the time and power to do that. All levels of management need to be cognizant of the entire on-call experience, including being willing to make short-term trade-offs of priorities when possible, with the understanding that payoffs both in time resources and team effectiveness and morale will pay off in the longer term. (Fortunately, I have that now.)
   1. Empower team members to own their on-call experience. Again, as the developers are in this rotation, they are the ones who can fix issues. They're also not removed from the incentive of knowing if they fix a certain issue, it won't wake them up the next time they're on-call. (This very separation of power from pain is one of the factors that has made the traditional dev vs ops silos and their associated services so dysfunctional.) And if it's not something that can be fixed quickly, make sure it gets tracked and priotized as needed for a permanent fix.
   1. Use those metrics to show improvements. Being able to see in hard numbers that, over time, yeah, we really aren't getting woken up as often, or interrupted by alerts that we can't fix is both the goal and incentive. A noisy pager isn't something you fix for once and for all, but requires ongoing vigilance and incentives.

I admit, I've been woken up too many times by unimportant, misdirected, or _[déjà vu millions de fois](https://translate.google.com/#fr/en/d%C3%A9j%C3%A0%20vu%20millions%20de%20fois)_ alerts. It kills morale, breeds resentment, and has probably shortened my life because of all the sleep deprivation and stress. I would love to help build an org where the pager is usually so quiet, engineers start to check their phones to make sure the battery didn't die. No one's going to jump for joy when they go on-call, but it's a win if they aren't filled with dread.



