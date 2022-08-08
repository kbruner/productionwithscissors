---
layout: post
title: 'Star Wars: Imperial Engineering Fails'
date: 2022-01-10 13:17:28.000000000 -08:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
- Star Wars
tags:
- architecture
- engineering culture
- engineering fails
meta:
  _wpcom_is_markdown: '1'
  _last_editor_used_jetpack: block-editor
  _thumbnail_id: '1673'
  _publicize_job_id: '67519813272'
  timeline_notification: '1641833714'
  _edit_last: '108235749'
  _wp_old_date: '2022-01-11'
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2022/01/10/star-wars-imperial-engineering-fails/"
excerpt: While this series of engineering failures may have happened a long, long
  ago in a galaxy far, far away, it also happened last week in tech company not too
  far from here.
---
<!-- wp:paragraph -->

_Disclaimer: This post is chock full of spoilers for several Star Wars movies._

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Anyone who has watched _Star Wars: A New Hope_ will, of course, remember that the Rebel Alliance was able to destroy the humongous Death Star. Blueprints of the space station, smuggled out of the Empire, revealed that the Death Star could be destroyed by just one well-aimed torpedo.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

However, the failure of the Death Star was just one Imperial engineering disaster of many, albeit a very critical failure. Like many projects that don't live up to their original ideal, a lack of focus on reliability and resiliency in the design phase, poor or missing design review, useless or nonexistent operational procedures, all tracing back to abysmal product management and arrogant leadership, doomed the Death Star and, ultimately, the Empire itself.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

So, let's break down Imperial engineering project failures in the films Episodes IV-VI. We'll skip Episodes I-III, which predated the Empire, and VII-IX, because I don't even want to try to pretend that I can explain what's going on there. As a bonus, we will also throw in _Rogue One_, the direct prequel to Episode IV.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Episode IV: _A New Hope_

<!-- /wp:heading -->

<!-- wp:paragraph -->

Let's start with the obvious issue in the original installment: the Death Star comprised many systems with their own single points of failure (SPoFs; we're going to use this acronym a lot). Of course, the most serious SPoF allowed a proton torpedo fired into an exterior exhaust vent to destroy the entire moon-sized space station. (We'll get deeper into that design flaw when we break down _Rogue One_ below.)

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Design issues

<!-- /wp:heading -->

<!-- wp:list {"ordered":true} -->

1. The Death Star tractor beam used to pull the _Millennium Falcon_ onto the battle station had not one but multiple single points of failure (SPoFs; we're going to use this acronym even more): the entire tractor beam system could be disabled at any one of seven power couplings.  
_Lesson: Redundancy of critical components over redundancy of engineering failure points._
2. That whole "you just need to shoot one proton torpedo into this exhaust vent and the whole Death Star will go boom!" issue has been well-covered.  
_Lesson: You need better threat modeling._

<!-- /wp:list -->

<!-- wp:heading {"level":3} -->

### Operational issues

<!-- /wp:heading -->

<!-- wp:paragraph -->

While design and engineering issues built major vulnerabilities into the Death Star, the poor quality of the Empire's operational practices and the limited ability of their personnel to carry out those procedures also created serious problems.

<!-- /wp:paragraph -->

<!-- wp:list {"ordered":true} -->

1. The gunners on the star destroyer in orbit above Tatooine were picking off escape pods leaving the captured Rebel ship. However, when they found no life signs in one of the pods, they let it go. Were laser blasts in such short supply?  
_Lesson: Apply your security enforcement practices consistently_.
2. Luke Skywalker, Han Solo, and Obi-Wan Kenobi leverage social engineering on multiple occasions to infiltrate and then escape from the Death Star. Luring Imperial stormtroopers onto the _Millennium Falcon_ and stealing their armor; feigning com issues to trick the deck commander into opening their blast door; using Chewbacca as a "prisoner" to gain access to the detention block. While no single measure or procedure could have prevented all of these breaches, social engineering exploits start here and will continue to pose an ongoing problem for the Empire.  
_Lesson: Don't ignore non-technical security vulnerabilities._
3. At one point, we see two stormtroopers asking each other if they knew what was going on. "Maybe it's another drill." While it's important to practice for incident readiness, the Death Star command and crew have apparently been missing critical attack vectors in their drill plans.  
_Lesson: Practice only makes perfect if you're practicing the right things the right way._

<!-- /wp:list -->

<!-- wp:paragraph -->

One last question: when the Death Star jumped into orbit around the planet Yavin IV, why didn't they jump closer to the moon where the Rebellion was headquartered?

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Episode V: _Empire Strikes Back_

<!-- /wp:heading -->

<!-- wp:paragraph -->

This installment doesn't really expose major Imperial engineering failures, although the bit about the _Millennium Falcon_ hiding by clamping onto the back of a star destroyer's command tower also seems a little inexplicable, even taking into account the Empire's questionable engineering prowess.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

The most relevant takeaway from this film: The expressions of people frozen in carbonite bear an uncanny resemblance to DMV photos in our universe.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Episode VI: _Return of the Jedi_

<!-- /wp:heading -->

<!-- wp:paragraph -->

The Empire's brilliant new plan: build a new Death Star! Could they pull out a win this time? Let's find out!

<!-- /wp:paragraph -->

<!-- wp:list -->

- _Win:_ While the main reactor in the original design could be destroyed by a torpedo fired into an external exhaust port, the main reactor in this new design could only be destroyed by direct blaster fire.   
**Score: +1**
- _Loss:_ Conveniently for the Rebellion, the design also included navigable shafts that ran from the surface to the reactor core.  
**Score: -2**
- _Win:_ The Death Star construction project did include a force field to prevent unauthorized access to these access shafts.  
**Score: +5**
- _Loss_: During construction, the Death Star's shield had only a single generator, situated on the forest moon of Endor. Unfortunately for the Empire, any firewall, when built or operated with SPoFs at critical load-bearing points, can provide only severely limited and unreliable protection (yup, still seeing those single points of failure in action).  
**Score: -10**
- _Win:_ The force field generator was well-guarded and housed in a unit with multiple blast doors, in an area heavily patrolled by Imperial scout transports.  
**Score: +1** (limited points because it's still unnecessarily a SPoF)
- _Loss_: Those safeguards were doomed to failure with the Empire's typical lack of attention to social engineering exploits and non-standard combat styles.  
**Score: -5**

<!-- /wp:list -->

<!-- wp:paragraph -->

Hubris coming from the top down ultimately doomed the second Death Star and the entire Empire. Large projects can be more prone to failure if no one believes they can fail. This arrogance fuels the neglect to exploring or adopting measures that could increase the chance of success and mitigate clear risk. The Emperor had tied his success to this new Death Star. When that project failed, it cost him his job, among other losses.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## _Rogue One_

<!-- /wp:heading -->

<!-- wp:paragraph -->

While this film, "the prequel we never knew we needed," takes place immediately before _A New Hope_, we're covering it last on this list, and not just because of the chronological release order. This whole movie functions as the consummate how-to guide to ruining your most critical engineering projects.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

_With our step-by-step instructions, you will learn how to_

<!-- /wp:paragraph -->

<!-- wp:list -->

- _Motivate by threats_!
- _Alienate your workforce and key talent_!
- _Skip design reviews!_
- _Promote the people least capable of doing the job!_
- _Miss all your deadlines!_
- _Do whatever it takes to get your promotion and vanity title!_
- _Deliver a flawed but shiny product!_
- _Destroy the Empire!_

<!-- /wp:list -->

<!-- wp:paragraph -->

_All with pictures!_ (There are no pictures.)

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### _Get your vanity title while trying to cover your ass!_

<!-- /wp:heading -->

<!-- wp:paragraph -->

Orson Krennic, who apparently holds the vanity title of "Director of Advanced Weapons Research," is clearly an asshole, but he's also reporting to even more tyrannical executives. Risk of being "managed out" or even missing out on regular job title inflation motivates many product managers. Krennic's superiors constantly remind him that failure of the Death Star project would be met with a very tall enforcer who can force-choke Krennic just by making some squeezy hand gestures.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

_Lesson: Promote bad managers and motivate them with threats to get the worst out of them!_

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### _Steal credit when a project looks successful!_

<!-- /wp:heading -->

<!-- wp:paragraph -->

Krennic seems to expend as much energy trying to secure a promotion as he does overseeing the actual Death Star project. While politics generally do win out over actual job competence in too many organizations, failing to deliver a critical project still doesn't generally work in one's favor. When Krennic proceeds with a successful, but unsanctioned, test of the Death Star's weapon, he not only fails to gain favor with his superiors, he also gets kicked off the project because someone else wants to take credit. Ouch.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

_Lesson: Be sure to leverage an apparently successful project for a promotion, but watch out for someone else who wants to steal credit_!

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### _Adopt involuntary recruitment and other methods to alienate your design engineers!_

<!-- /wp:heading -->

<!-- wp:paragraph -->

Krennic forces the brilliant researcher Galen Erso to create the Death Star only after murdering the scientist's wife. That sort of antisocial behavior generally leads to disgruntled employees who might want to sabotage the project they're working on, which is unsurprisingly the case here. Krennic also "motivates" Erso by threatening to kill his co-workers, who have as little freedom as Erso himself. The scientist feels he must continue to work on the Death Star, but he also hides a dangerous flaw in its implementation.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

_Lesson: Forcibly hire and torture your workforce for the most disastrous results!_

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### _Skip design reviews and quality assurance_ _to ensure failure!_

<!-- /wp:heading -->

<!-- wp:paragraph -->

The Death Star project also proceeds again a backdrop of poor engineering design and brittle operational practices. Incompetent and dictatorial management has no idea how to design robust engineering infrastructure and does not understand the necessity of investing into these "overhead" areas. Such deficiencies often arise from an organizational focus limited to feature delivery, without recognizing the results of operational failures and the necessity of trying to prevent outages and limit the blast radius when they do occur, sometimes literally. They are also endemic to a culture that does not respect the expertise of its engineers.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

_Lesson: Leave out design reviews because quality and reliability assurances have no place in your product!_

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

_ **Now you should have all the skills you need to create an unsuccessful product and destabilize your entire organization!** _

<!-- /wp:paragraph -->

<!-- wp:heading -->

## _If you're part of the Rebel Alliance, you may also want to check out our new book!_

<!-- /wp:heading -->

<!-- wp:paragraph -->

_Learn how to_

<!-- /wp:paragraph -->

<!-- wp:list -->

- _Reprogram Imperial droids!_
- _Make those droids snarky!_
- _Steal Imperial transports and landing codes!_
- _Retrieve disks from Imperial archives!_
- _Run data cables to transmit stolen blueprints!_
- _Reposition satellite dishes!_
- _Take out planetary force fields!_
- _Disable star destroyers with ion blasts!_
- _And more!_

<!-- /wp:list -->

<!-- wp:separator -->

* * *
<!-- /wp:separator -->

<!-- wp:paragraph -->

In closing, we have a good idea of why the Empire failed. Don't repeat their mistakes, unless, of course, you're working from within to sabotage and destabilize your whole organization, too!

<!-- /wp:paragraph -->

