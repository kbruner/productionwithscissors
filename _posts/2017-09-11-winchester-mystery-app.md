---
layout: post
title: Winchester Mystery App
date: 2017-09-11 19:43:15.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- devops
- worst practices
meta:
permalink: "/2017/09/11/winchester-mystery-app/"
excerpt: You will never be able to escape the ghosts of an un-designed architecture
---

_You will never be able to escape the ghosts of an un-designed architecture_

Several years ago, I took the tour of the Winchester Mystery House in San Jose. The mansion was built by Sarah Winchester, widow of the heir of the Winchester gun fortune. After suffering through several personal tragedies, she was said to believe that her family and fortune were haunted by the victims of Winchester rifles, and only constant building could appease them. She spent the last 38 years of her life constantly adding on to the house without ever using an architect and with no real plan, leading to a house with doors that go nowhere or open onto rooms a floor or two down and priceless Tiffany windows set in north-facing walls which receive no direct sunlight.

(My tour group included a little girl named Olivia. I know her name is Olivia because she kept wandering ahead and touching things she shouldn't, resulting in her parents' consistently ineffective pleas to stand still. Given her likely-conditioned lack of heed, I mentally renamed her "Oblivia.")

Unfortunately, I've seen far too many software projects that bear more than a few similarities to the Winchester Mystery House. No cohesive architecture, inconsistent conventions and APIs, dead-end methods. This tends to result in a brittle codebase which is hard to test and even harder to change safely and predictably. Just as the rooms in Sarah Winchester's house were connected in unpredictable ways, an application with strange, non-standard dependencies between classes/modules/libraries resists easy, safe changes. Say you decide you want to change your backing database, but if it's not accessed via a consistent interface class, it's going to be a lot more work to find all the special snowflake cases in your code and fix them before they've destabilized your production service, because, let's face it, you probably don't have very good test coverage, either.

I'm sure a lot of people, especially at start-ups, think this is normal, and maybe it does happen more often than not, but normal should never be automatically conflated with "good." So let's consider scenarios where this kind of application development might arise.

* Most likely scenario: a small team needs to get an application running for proof-of-concept funding, so they just start writing code. Developer A is writing the database interface, but dev B is writing the storage engine which depends on it, can't wait for the interface, so just accesses the database interface class directly. Hey, it works, they get funding, and they'll just fix it later, except now they need to add features so they can get paying customers, and there's never going to be enough time. At some point the team will agree on conventions and so forth, but the tech debt is still in the codebase, accruing interest which will likely result in a balloon payment (probably production downtime) sooner or later.
* A lack of team discipline, usually under the mantle of "total freedom to get your job done." Maybe the project did actually have an architect or at least some agreements on the architecture, but the developers still ended up doing their own thing when they wanted to or just decided it was more expedient to get a feature out the door. Usually this involves some excuse like, "I didn't realize we already had a class for that," or "I know we already use library X but I like library Y better," or, my personal favorite, "I wanted to try out cool new tool Z, so what better place than in production?" And now you're stuck with it until someone has time to rip it all out, except remember, this is Winchester Mystery Code, so that's a lot harder than it should be, and there's never enough time to begin with.
* The company or at least the intended functionality of the app "pivoted," and rather than start clean, everyone started building on top of the existing code in a new direction.
* The architect really had no idea what they were doing.

It could be a combination of factors, too, but the net result is the same. By "the same," I mean a completely unique bundle of code, but the pain of maintaining it and services that run off of it remains the same.

I also like to use Katamari Damacy as an analogy for this type of application development. Katamari Damacy is an old Japanese console video game which translates to something like "clump of souls." The backstory has the King of All Cosmos destroying all the stars in a drunken rage, so he sends his son (the player), the Prince of All Cosmos, out with a sticky ball to roll up masses large enough to replace the stars. As the ball picks up bulky, misshapen objects (think skyscrapers pointy side out), the clump becomes much more difficult to steer, and you're never going to be able to smoothe it out. A badly (or not-at-all) designed application becomes a big clump of bugs, and if the piece of code you need to fix or replace is buried under many interlocking accretion layers, imagine how fun it's going to be to change it.

Some cases are more avoidable than others, but that doesn't mean it's impossible to prevent or mitigate large-scale issues.  While it may sometimes seem like there's no time to waste because you need to start writing code now (now! NOW!), getting clear plans can speed up development in the short and long runs, because developers won't be duplicating effort or stepping on each other's toes or organizing code in a painfully haphazard way which is going to make modification difficult. Some discipline should be required to make sure new code is using established conventions, and friction should be required before pulling in new third-party dependencies to make sure they aren't redundant or inappropriate.

