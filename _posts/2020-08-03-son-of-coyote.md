---
layout: post
title: Son of Coyote
date: 2020-08-03 05:26:58.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- TV and Stuff
- Wile E
tags:
- engineering fails
meta:
  timeline_notification: '1596432421'
  _wp_old_slug: '382'
  _wp_old_date: '2020-07-27'
  _publicize_job_id: '47286051697'
  _edit_last: '108235749'
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/08/03/son-of-coyote/"
excerpt: More root cause analysis of failed road runner traps
---

_More root cause analysis of failed road runner traps_

Back in January, I recreated a write-up I had done long ago of the Coyote/Road Runner cartoons to determine [the root cause patterns of Coyote's inevitable failure to catch the Road Runner](https://nightmare-before-devops.xyz/2020/01/23/engineering-quality-of-the-anti-road-runner-traps-of-wile-e-coyote-esq/).

Lo and behold, Warner Bros. has put much of the Looney Toons oeuvre on HBO Max. While it does not currently offer [every existing episode](https://en.wikipedia.org/wiki/Wile_E._Coyote_and_the_Road_Runner#List_of_cartoons)[featuring](https://en.wikipedia.org/wiki/Wile_E._Coyote_and_the_Road_Runner#List_of_cartoons) Wile E. Coyote, it does host a large number of them, including the very first installment from 1949.

They also have a couple of the handful of Wile E Coyote vs. Bugs Bunny episodes. These entries tend to stand out from the Road Runner cartoons for two main reasons: Coyote speaks in the BB cartoons, which he never does in the RR cartoons, and his plots and devices tend to function as planned. His failures to catch Bugs instead come about because Bugs always remains at least one step ahead. I've omitted them from this analysis.

A couple other production notes:

- All cartoons until the mid-60s were directed or co-directed by the legendary Chuck Jones. (I've noted in the table which were not directed by Jones.)
- The batch from the mid-60s look much cheaper than the movie-theater quality cartoons from the 50s because they are much cheaper. They were produced for weekly Saturday morning cartoons, so watching them sequentially really highlights the frequent reuse of some scenes (for example, Coyote poring through the ACME Mail Order Catalog and then dropping his order in the mailbox), backgrounds, and props.

Notes about methodology:

- I did not include cartoons from the first episode, even if they are available on HBO Max.
- I've added a new outcome called "Outsmarted," for plots and devices that might have succeeded had not the Road Runner tricked or outwitted the Coyote.
- I was tempted to distinguish between "Engineering Failures" and "Engineer/Operator Failures" but I did not actually end up breaking them out.

I did a trap-by-trap write-up for the first cartoon, Fast and Furry-ous. Subsequent cartoons are summarized in the table.

* Fast and Furry-ous (1949 C. Jones)
  * Traps
    * Trap 1: Hides in crevice at side of road, holds a... shield? Pan lid? In road as R. Runner approaches
      * Result: R. Runner stops short just in front of shield? Pan lid? Turns, runs in the other direction. Coyote drops lid on the road in frustration and prepares to run after R Runner. R Runner returns, picks up shield? pan lid? and Coyote runs straight into it. 
      * RCA: Eng/Operator error.
    * Trap 2: "One Genuine Boomerang" (no brand listed on box)
      * When Coyote turns to run after R Runner, _his_ boomerang returns... and hits him in the back of the head.

      * RCA: Outsmarted by R Runner, followed by operator error due to distraction
    * Trap 3: Coyote paints a crosswalk with School Crossing sign on the road, then dresses as a schoolgirl skipping across.
      * Result: R Runner speeds through the crosswalk, sending Coyote spinning. R Runner then returns holding a sign that reads "Road Runners Can't Read."
      * RCA: Eng failure. Coyote should know that road runners can't read.
    * Trap 4: Coyote straps himself to a rocket, aims for R Runner on a facing mountain grade, then lights the rocket's fuse.
      * Result: The rocket inexplicably launches straight up into the air, sending Coyote's head through a rock outcropping immediately above.
      * RCA: cartoon physics. Although, really, strapping yourself to a large explosive does not seem like a good idea.
    * Trap 5: Coyote situates a boulder on a cliff above the road, with a plumb line hanging from the boulder above the road below, planning to remove the boulder's keystone just as R Runner passes below, thus crushing (HA-HA!) R Runner.
      * Result: once the keystone is removed, the boulder initially begins leaning toward the road but then changes direction and crushes Coyote, who is standing behind it.
      * RCA: cartoon physics
    * Trap 6: Coyote paints a fork in the road which leads into a trompe l'oeil he paints into a sheer rock face.
      * Result: R Runner comes racing along and runs into the trompe l'oeil as if it were a real tunnel. Coyote, surprised, decides to run after him, smacking into the rock
      * RCA: cartoon physics + knee-jerk reaction
    * Trap 7: Coyote plants a stick of dynamite in the middle of the road, covering it with a pile of dirt.
      * Result: When Coyote pushes the dynamite's plunger down, it explodes in his face.
      * RCA: defective product, probably.
    * Trap 8: Coyote dons an ACME brand "Super Outfit" and attempts to fly off a cliff.
      * Result: Coyote falls off the cliff, crashing into the ground below.
      * RCA: Engineer stupidity
    * Trap 9: Coyote straps a snow generator to his back which he build with a refrigerator, an ACE (not ACME) brand electric motor, and a meat grinder, dons a pair of skis, and attempts to ski down an rock mesa straight into R Runner.
      * Result: He builds up too much speed, flies across the road and off a cliff on the other side.
      * RCA: You have to ask?
    * Trap 10: Coyote puts on "Fleet-Foot Jet-Propelled Tennis Shoes."
      * Result: R Runner taunts him, leading him into a series of highway overpasses until the shoes apparently run out of fuel.
      * RCA: A draw
    * Trap 11: The shoes run out under a sign reading "Short Cut," which Coyote dutifully follows, then hides behind a billboard for "Jones Motel" while holding an axe.
      * Result: When Coyote hears R Runner coming, he jumps into the road, draws back the axe... and gets run over by a bus. In which R Runner is a passenger, making the "BEEP BEEP" call.
      * RCA: I'm not sure how to call this one.

| Name | Engineering / Engineer Failures | ACME Failures | Cartoon Physics | Outsmarted | Eng Successes | Unknown / Other | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Fast and Furry-ous (1949) | 5 | 0 | 3 | 1 | .5 | (.5 x draw) (1 x unknown) = 1.5 |
| Hook, Line and Stinker (1958) | 5 | 0 | 0 | 0 | 0 | 2 (including 2 x .5 partials) | Unbranded product failures: sledgehammer with poorly attached head; dynamite detonating wire which re-rolls itself back up; sticky pulley |
| Beep Prepared (1961) | 5 | 0 | 1 | 0 | .5 | .5 | Dir: C Jones & Maurice Noble |
| To Beep or Not to Beep (1963) | 6.5 | 0 | 3.5 | 0 | 0 | 1 | Dir: C Jones & Maurice Noble; most failures involve a catapult which, it turns out, was built by Road Runner Manufacturing Co. That Coyote continued to use it after the first 2-3 failures is its own failure |
| Boulder Wham (1965) | 3.5 | 0 | 0 | 2 x .5 | .5 | 0 | Dir: Rudy Larriva |
| Hairied and Hurried (1965) | 3 (2 + 2 X .5) | .5 | 1 | .5 | 0 | 1 | Dir: Rudy Larriva; Partial ACME failure: pop-up barrier pops up randomly |
| Highway Runnery (1965) | 3 | 0 | 1 | 1 | 0 | 0 | Dir: Rudy Larriva |
| Chaser on the Rocks (1965) | 2.5 (1 + 3 X .5) | 0 | .5 | .5 | 0 | .5 | Dir: Rudy Larriva |
| Shot and Bothered (1966) | 1.5 | 0 | 2 | 1 | 0 | 1.5 | Dir: Rudy Larriva |
| Out and Out Rout (1966) | 3.5 | 0 | .5 | 2 | 0 | 0 | Dir: Rudy Larriva |
| The Solid Tin Coyote (1966) | 7 | 0 | 0 | 0 | 0 | 0 | Dir: Rudy Larriva; Coyote builds a giant remote-controlled replica of himself; hijinks ensue |
| Clippety Clobbered (1966) | 2 x .5 | 0 | 2 | .5 | 3 x .5 | 1 | Dir: Rudy Larriva |
| Sugar and Spies (1966) | 4 | 0 | 1 | 3 | 0 | 0 | Dir: Robert McKimson; Coyote gets hit in head with a spy kit and uses contents throughout |
| Chariots of Fur (1994) | 3.5 | 0 | 2 (1 + 2 x .5) | 0 | 1.5 | 1 | Dir: Chuck Jones |
| The Whizzard of Ow (2003) | 1 | 0 | 0 | 2 x .5 | 3.5 | .5 | Dir: Chris Kelly; 2 battling wizards in the sky; ACME Book of Magic + a black cat fall into Coyote's den |

Note about "Hairied and Hurried:" includes Coyote performing a test of a kite-delivery system using "practice" bombs. However, the production bomb is much larger and slides off the kite line back to Coyote. Yeah, I've never seen that happen in production environments.

| | Eng Failures | ACME Failures | Cartoon Physics | Outsmarted | Eng Successes | Other / Unknown | Total Traps |
| Totals | 55 | .5 | 17.5 | 11.5 | 8 | 10.5 | 103 |
| % | 53.4 | 0.5 | 17 | 11.2 | 7.8 | 10.2 | |

Even with the introduction of the "Outsmarted" cause, the percentages are reasonably close to those in the original post, all of which date to the 1950s by the original directing/writing pair of Chuck Jones and Michael Maltese.


