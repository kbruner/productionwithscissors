---
layout: post
title: Engineering Quality of the Anti-Road Runner Traps of Wile E. Coyote, Esq.
date: 2020-01-23 12:24:02.000000000 -08:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
- TV and Stuff
- Wile E
tags:
- engineering fails
- root cause analysis
- not-tech
- entertainment
meta:
author: karen
permalink: "/2020/01/23/engineering-quality-of-the-anti-road-runner-traps-of-wile-e-coyote-esq/"
excerpt: Beep Beep!
---

At one point a number of years ago, when I was working at Yahoo!, my team somehow got into an IRC discussion about why Wile E. Coyote always failed to catch the Road Runner. Was Coyote just a bad engineer or was ACME Co.'s quality assurance just non-existent? (Of course, the latter option begs the question, if ACME goods were so shoddy, how smart was Coyote to keep using them?)

At the time, I firmly came down on the side of Coyote being a crappy engineer. Not long after, I realized that one of the Looney Tunes DVD collections I had contained an entire disc dedicated to golden-era Coyote v. Road-Runner cartoons, so it seemed like the perfect opportunity to do some research. I watched all those cartoons, taking notes and tallying the root cause of the failure of each of Coyote's traps. I posted it on Google+ and then... forgot about it. Until after Google shut Google+ down, taking the content with it. (Dammit, Google!)

If you're familiar with this blog's format, that story does, in fact, serve as my standard horror story opener for this post. I think at this point Google's penchant for taking beloved services out back and putting a bullet in their head (I still remember you, Reader!) has reached legendary status, making it a perfect opener.

That said, I decided I should recreate the original post. I will be watching the same cartoons on the same disc. I will spare you the gory details of how I hadn't used my DVD player in at least a year, so I spent almost half an hour looking in and behind and under the sofa for its remote control. In the process, I managed to dislodge a lot of detritus and realized I really need to vacuum the couch, although I did make the cats happy with all the toys that came out from under the couch. (No, I really was sparing you the gory details there.) Finally, I thought to look for the remote control in the most unlikeliest of places: next to the DVD player. How the remote got there, I have no earthly idea, but there it was, and after swapping in some fresh batteries, I was good to go.

For reference, all these cartoons were directed by the legendary [Chuck Jones](https://en.wikipedia.org/wiki/Chuck_Jones). Also, I'll only give full descriptions for the first few cartoons and simply show tallies for the rest, both because otherwise a 5-minute cartoon ends up taking half an hour to write up, and because I did the exact same thing last time.
So, without further ado:

[Skip to totals](#totals)

* Beep, Beep (1952)
  * Traps
    * Trap 1: Boxing glove affixed to large, compressed spring, which was fastened to a boulder. Coyote hides behind the boulder, ready to release the spring and knock out the passing Road Runner
      * Result: When releasing the spring, the glove remained stationary while the boulder was propelled backward, smashing Coyote into a rocky overhang
      * RCA: Cartoon physics. 
    * Trap 2: Coyote carries an anvil across a tightwire between two cliffs lining the road, preparing to drop it on Road Runner
      * Result: Instead of being a taught tightwire, the wire stretched down to the ground when Coyote got to the middle with the anvil. The recoil then shot him up into the air.
      * RCA: Unknown. We don't know if the ACME product was mislabeled or defective, or if Coyote did not properly research the material's properties (aka, failure to do load testing) 
    * Trap 3: Coyote rigs a free glass of water to light a barrel of TNT when picked up.
      * Result: Apparently road runners can't read and don't drink water. They can write signs communicating as much, however.
      * RCA: We'll chalk this one up to unexpected user behavior. 
    * Trap 4: Coyote positions himself on catapult consisting of two hinged boards with a spring compressed between them, held ready by a restraining rope.
      * Result: When he cuts the rope with a knife, the catapult slams him into the pavement
      * RCA: Engineering failure. Seriously. 
    * Trap 5: Coyote uses belts to attach himself to a rocket mounted horizontally on four wheels, with bicycle handlebars affixed to the rocket.
      * Result: Upon lighting of its fuse, the rocket still manages to launch itself into the sky, taking the Coyote with it, before exploding into fireworks.
      * RCA: Another tough call. We'll put this one under "unknown." 
    * Trap 6: Wearing ACME brand Rocket Powered Roller Skates, Coyote attempts to catch Road Runner at his own speed.
      * Result: It seems Coyote can't actually roller skate. Also, the skates don't appear to have brakes.
      * RCA: I'm calling this an engineering failure. I see no evidence that Coyote attempted to RTFM. 
    * Trap 3 revisited: Once the rocket-powered roller skates run out of fuel, after having knocked Coyote around mightily, he's left in front of the water-glass-triggered-TNT trap. And he takes the water glass. And the TNT goes off.
      * Revised result: Engineering success! I'll give Coyote credit, even though it does also have a whiff of technical debt to leave the trap out.
    * Trap 7: Coyote builds a fake railroad crossing with a short length of track, obscuring the ends with bushes.
      * Result: Road Runner races over the track, knocking Coyote onto it, leaving him dazed. Then a train comes.
      * RCA: Cartoon physics strikes again. 
  * RCA Tally
    * Engineering failures: 2
    * ACME failures: 0
    * Unknown: 2
    * Cartoon physics: 2
    * Engineering success: 1 
* Going! Going! Gosh! (1952)
  * Traps
    * Trap 1: Coyote ties a stick of dynamite to an arrow. As Road Runner approaches, Coyote lights the fuse and draws the arrow.
      * Result: Coyote releases the bow instead of the arrow. Dynamite explodes.
      * RCA: Engineering failure. Pretty sure he tested his shooting skills on production data (aka lit dynamite). 
    * Trap 2: Coyote sets up an over-sized slingshot in the ground, using himself (with knife and fork and bib) as the projectile.
      * Result: As he walks back to get maximum tension, the slingshot gets pulled from the ground and pins him to a large (pink) cactus.
      * RCA: Engineering failure. 
    * Trap 3: Coyote covers a section of road with a layer of quick-drying cement (not explicitly labeled as ACME, btw)
      * Result: When Road Runner plows through the cement at speed, he splashes it onto the Coyote. Who then gets stuck with the sizable grimace on his face when the cement dries.
      * RCA: We'll be fair and call this unknown. While the trap probably would not have succeeded, it only back-fired because of bad luck on timing. 
    * Trap 4: Coyote hides under a man-hole cover in the road, armed with a grenade.
      * Result: When he hears the Road Runner "meep meep," Coyote pulls the pin and prepares to throw. Except the Road Runner was on a road above his and knocked a large boulder onto the manhole cover, trapping Coyote with the live grenade.
      * RCA: We'll call this engineering. Verify that user input. 
    * Trap 5: Coyote dresses as a hitchhiking blond with high heels and a short skirt.
      * Result: Road Runner rushes past, knocking Coyote down, then returns with a sign explaining, "I already have a date."
      * RCA: We'll call this one blameless. 
    * Trap 6: Coyote places a canvas painted with a t_rompe l'oeil_to disguise the dead-end of a road that ends with a cliff.
      * Result: Road Runner continues into the painting's road. Coyote, dumb-founded, stands in front, scratching his head. Then a truck comes out of the painting road, flattening Coyote. Coyote, furious, decides to run into the painting to catch up with Road Runner. Instead, he runs through the canvas, falling off the cliff.
      * RCA: Cartoon physics X 2 
    * Trap 7: Coyote rolls a large boulder onto a descending mountain pass road.
      * Result: Road Runner, coming up the road, evades the boulder, which then somehow manages to roll up a circular overhang which launches it into the air, where it lands above Coyote's position, surprising and then immediately flattening him.
      * RCA: Cartoon physics strikes again. While the plan was never going to work, that boulder had air that would make professional skateboarders envious. 
    * Trap 8: Using a variety of products (admittedly, only one, the "Street Cleaner's Wagon," was labeled as coming from ACME), Coyote creates a fan-propelled, (not hot-air) balloon vehicle, intending to use it to fly over Road Runner and drop an anvil on him.
      * Result: When the anvil is released, the vehicle shoots up into the air, at which point the string tying the balloon shut comes undone, dropping Coyote into the road. At which point the anvil lands on his head.
      * RCA: I can't really chalk this up to cartoon physics (Newton's third law in action!) Engineering failure. The ACME Street Cleaner's Wagon actually came out remarkably intact, incidentally. 
    * Trap 9: Coyote ties one end of a length of rope to log overhanging the road, suspended across two cliffs, tying the other end around his waste. When he hears the familiar "meep, meep," he swings off the cliff, holding a spear.
      * Result: He is met with a truck whose horn sounds just like a road runner. The force of the collision sends him spinning around the suspended log, where he somehow gets tied to the log under the length of rope.
      * RCA: We'll call this unknown. We do have some cartoon physics, but... Road Runner was driving the truck. 
    * RCA Tally
      * Engineering failures: 4
      * ACME failures: 0
      * Unknown: 2
      * Cartoon physics: 3
      * Engineering success: 0 
* Zipping Along (1953)
  * Traps
    * Trap 1: Coyote + grenade
      * Result: Attempting to remove the pin with his teeth, he instead throws the pin at Road Runner and is left with a live grenade in his mouth.
      * RCA: Engineer(ing) failure 
    * Trap 2: Coyote places a couple dozen mouse traps on the road.
      * Result: Road Runner blows past the spot, sending the traps flying into Coyote's hiding spot.
      * RCA: Engineering failure. I have no idea how this was supposed to work. 
    * Trap 3: Using an ACME Giant Kite Kit and an unlabeled bomb, Coyote attempts to become airborne, hanging onto the kite with one hand and holding the bomb in the other.
      * Result: After getting a few short-lived airborne hops while getting a running start, Coyote reaches the cliff's edge and plummets to the ground, where the bomb explodes.
      * RCA: Engineering failure. 
    * Trap 4: Coyote attempts to chop down a conveniently-located roadside tree to fall on a passing Road Runner.
      * Result: The tree was actually a telephone pole, and when it fell, it pulled its nearest neighbor down onto Coyote.
      * RCA: Engineering failure. Coyote did not practice reasonable situational awareness. 
    * Trap 5: Coyote mixes Ace brand steel shot into a box of ACME bird seed and pours the mixture into the road. When Road Runner consumes the mixture, Coyote attempts to use a giant magnet to pull the bird to him.
      * Result: Instead of Road Runner, the magnet attracts a barrel of TNT, which promptly explodes.
      * RCA: ... cartoon physics? 
    * Trap 6: Coyote reads a book on hypnotism to learn how to make a person jump off cliff. Coyote practices on a fly, which promptly jumps off a rock.
      * Result: When Coyote attempts to use his newfound skill on Road Runner, the bird whips out a mirror, causing Coyote to hypnotize himself.
      * RCA: Engineering success! 
    * Trap 7: Coyote constructs a see-saw with a board using a rock as a fulcrum. He then stands on one end, holding a large rock, which he throws at the other end to catapult himself into the air.
      * Result: Instead of landing on the other end of the board, the boulder lands on Coyote.
      * RCA: Engineering failure. 
    * Trap 8: Coyote mounts a number of rifles to a board positioned on a cliff over the road, tying strings to each trigger.
      * Result: When Coyote pulls the strings, the guns all shoot him.
      * RCA: Engineering failure. He _was_ standing right next to Road Runner when he pulled the strings. 
    * Trap 9: Coyote prepares to cut the end of a rope bridge when Road Runner crosses it.
      * Result: Instead of the rope bridge, the cliff Coyote is standing on plummets to the... well, plummets somewhere
      * RCA: Cartoon physics. 
    * Trap 10: Coyote loads himself in a Human Cannonball cannon after lighting the fuse.
      * Result: The cannon is propelled backward, while Coyote hangs, singed, in midair. At least he was wearing a helmet.
      * RCA: Cartoon physics. 
    * Trap 11: Coyote stands one board suspended between two cliffs, holding a giant wrecking ball that is tied by rope to another board some distance down the road. When Road Runner approaches, Coyote releases the ball.
      * Result: Road Runner stops short of the ball's reach. The ball then loops over its anchoring board, arcs through the air without losing any tension in the rope, and smacks Coyote from above.
      * RCA: While we do have some cartoon physics at play, the ball was going to swing back close enough to its starting point either way. Engineering failure. 
    * Trap 12: Coyote constructs a fake storefront across a narrow mountain pass, offering free birdseed "inside." Behind it, he has set up a large amount of TNT, all connected to an ACME detonator, placed so the plunger should theoretically trigger when the door is opened. Coyote then climbs over the facade and hides nearby.
      * Result: A truck comes barreling down the narrow pass, chasing Coyote back to the facade... where he opens the door.
      * RCA: Engineering success! 
  * RCA tallies
    * Engineering failures: 7
    * ACME failures: 0
    * Unknown: 0
    * Cartoon physics: 3
    * Engineering success: 2 
* Stop! Look! And Hasten! (1954)
  * Engineering failures: 5
  * ACME failures: 0
  * Unknown: 0
  * Cartoon physics: 1
  * Engineering success: 2 (The Burmese tiger trap did, in fact, catch a Burmese tiger. And those ACME Triple-Strength Fortified Leg Vitamins worked like a charm!) 
* Ready, Set, Zoom! (1955)
  * Engineering failures: 6
  * ACME failures: 0
  * Unknown: 1
  * Cartoon physics: 1
  * Engineering success: 1 
* Guided Muscle (1955)
  * Engineering failures: 7
  * ACME failures: 0
  * Unknown: 1
  * Cartoon physics: 2
  * Engineering success: 0 
* Gee Whiz-z-z-z-z-z-z (1956)
  * Engineering failures: 4.5
  * ACME failures: .5 (While that ACME Triple-Strength Battleship Steel Armor Plate proved extremely flimsy, Coyote clearly had no idea how momentum works, so I'll count that as .5.)
  * Unknown: 2 (That exploding bullet did not explode reliably, but we don't know the brand, in addition to a second unbranded product failure.)
  * Cartoon physics: 1
  * Engineering success: 0 
* There They Go-Go-Go! (1956)
  * Engineering failures: 6 (Granted, one of these _started_as a cartoon physics issue, but I've seen firsthand small failures turn into massive outages because people who apparently didn't understand the systems as well as they thought they did just started turning knobs. "I got this bottle of water out of Karen's freezer. I'll just throw it on the fire to put it out." Now we have two problems: the clear liquid which, mysteriously, was still liquid at 32°F, has actually seemed to accelerate the fire, and now Karen is out of vodka.)
  * ACME failures: 0
  * Unknown: 1 (Coyote clearly had a defective rocket, but again, it was not branded.)
  * Cartoon physics: 1
  * Engineering success: 0 
* Scrambled Aches (1957)
  * Engineering failures: 6 
  * ACME failures: 0
  * Unknown: 0
  * Cartoon physics: 3
  * Engineering success: 0
* Zoom and Bored (1957)
  * Engineering failures: 6
  * ACME failures: 0
  * Unknown: 1
  * Cartoon physics: 1
  * Engineering success: 0 
* Whoa, Be-Gone! (1958)
  * Engineering failures: 6
  * ACME failures: 0 (Those ACME Instant Tornado Seeds worked like charm! Tech debt: not putting the lid back on.)
  * Unknown: 1 (unbranded product failure)
  * Cartoon physics: 1
  * Engineering success: 0 
<a id="totals"></a>

| | Eng Failures | ACME Failures | Unknown Cause | Cartoon Physics | Eng Successes | Total Traps |
| Totals | 59.5 | 0.5 | 11 | 19 | 3 | 93 |
| % | 64 | 0.5 | 11.8 | 20.4 | 3.2 | |

In sum, I'd say that not only is Coyote, well, a lousy engineer, but that ACME products, at least during this era, often worked a little _too_ well.

A few notes that may or may not be worth reading:

* _Everything_ can be cast as a DevOps parable.
* I worked for a time for Warner Bros Animation. I may or may not have a film credit on _Osmosis Jones_. (I can't bring myself to watch it again to find out. I only saw a rough cut while it was still in production.) I definitely had to fix Brad Bird's email once while he was directing _The Iron Giant_, though. Netscape Navigator, RIP.
* My father started as a mechanical engineer and was, probably not coincidentally, also a Road Runner/Wile E Coyote fan. I had bought this Looney Tunes collection to watch with him while he was ill, but... I never got the chance to watch it with him. It sat on my shelf, still shrink-wrapped, for a couple years, until I finally had a reason to watch these cartoons.
* The spirit (and (lack of) engineering discipline and basic common sense) lives on in, well, most of the Silicon Valley start-ups I've worked for, to some degree or another.
* Seriously, leave a cat toy under the couch for a few months, and when you finally fish it out, it's brand-new to the cats who knocked it there in the first place.
* I still have no idea how the DVD player remote ended up next to the DVD player.

