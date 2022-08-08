---
layout: post
title: Choose Your Own Architecture
date: 2020-07-16 02:30:40.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- architecture
- databases
meta:
  _publicize_job_id: '46622038623'
  timeline_notification: '1594870033'
  _last_editor_used_jetpack: block-editor
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/07/16/choose-your-own-architecture/"
excerpt: 'Build smart from the start for maintainable, scalable services '
---

_Build smart from the start for maintainable, scalable services_

I remember reading [Choose Your Own Adventure](https://en.wikipedia.org/wiki/Choose_Your_Own_Adventure) books as a kid. These are like RPGs in book form. Yes, we still had actual RPGs (Zork ftw!) but I couldn't exactly take the Apple ][e on car trips, so books.

I only had a few of the titles, so after going through them often enough to end up at the same endings a few times, I start would page through the books to find endings I hadn't reached through the intended manner of picking one of two or more decision options and turning to the corresponding page. In other words, I would try to backwards-engineer all the possible endings in the books. One book, though, had an ending that was simply unreachable. None of the decision pages had an option that led to that page. I did not know if that unattainable ending came about by accident or as an intentional private joke, but the whole thing felt unresolved to me. I don't even remember which book it was or the storyline. I just remember I couldn't reach that ending.

* * *

Let's try this. You just founded a new company with a SaaS-based business model. Now you have to build the actual SaaS out from scratch. Where do you start?
### Choose one option

* [Define your minimal viable product, then let your three seed engineers write their pieces in whichever language they want, even if they each pick a different language](#option-1)
* [Pick your platform and infrastructure components, like your database before defining your data model, then start writing code in JavaScript](#option-2)
* [Start writing code for an API spec you sketched on a cocktail napkin in the newest hipster language](#option-3)

* * *

<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>

<a id="option-1"></a>
<a id="option-2"></a>
<a id="option-3"></a>
## _Some time passes..._
Congratulations! Your engineers are now the ~~proud~~ burnt-out owners and maintainers of a [Winchester Mystery App](https://nightmare-before-devops.xyz/2017/09/11/winchester-mystery-app/)!
_It never ends..._

[Read the post script](#post-script).
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>

<a id="option-4"></a>
## _Some time passes..._

You design and built a maintainable, reliable, and scalable application and everyone lives happily ever after and they always sleep through the night.

_The End_

(This never happens)
[Read the post script](#post-script).

<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>

<a id="post-script"></a>
## _Post Script_

Except perhaps for the tiniest static services, it's almost impossible to create an initial plan both detailed and realistic enough to bear a close similarity to the eventual working, such as it may be, product.

Most of us have probably heard the maxim "Fast, Cheap, or Good? Pick two." (Actually, you're pretty lucky sometimes if you get two.) This maxim doesn't quite map as well for production services which require ongoing availability as it does for more shrink-wrap software.

Database engines in particular end up being make-it-or-break-it components of complex, stateful services. A lot can go wrong along the way, including performance that does not scale proportionally to data size or traffic, instability caused by schema or design patterns that work against the database's strengths and amplify its weaknesses, or simply poor discipline around schema migrations and index creation which make it difficult to monitor changes or prune tables or indices which no longer get used but still cost money and performance in terms of resource overhead.

Care and feeding of databases needs to involve multiple teams, not just whichever team "owns" the database infrastructure. Developers who write queries against the database need to learn efficient patterns for that engine and understand that those patterns may be completely different from other DBs they have been near. Developers designing a database schema need to have even deeper understanding of best practices for that engine.

However, the single most important point of time in the lifecycle of a service's backend database may very well be the selection time. I've personally seen the results when developers pick whatever datastore happened to be up and running and shoved their new use case into it, with disastrous results.

If you have fixed data that receives regular in-place updates and which you need to read much more frequently than you write to it, you don't shove it into a NoSQL time-series store like Cassandra, which is optimized for writes and which takes a massive performance hit when forced to update existing rows. If you have a lot of large blob-y data, shoving it directly into a more traditional relational database may save the developer work in the first 5 minutes of that use case, and then cause pain in perpetuity. Hint: if you have to change the setting for maximum BLOB field size from the default in MariaDB so you can shove a jar file in there, you're probably on the wrong path. Turn back now.

Picking the "perfect" database will never be easy. In fact, like the path to that elusive ending in my Choose Your Own Adventure book, the perfect database for a backend SaaS datastore almost never exists. Not only do you need to fit the type and size of the data you need to handle, you have to consider scale, performance, cost, and what may be the most important factor in some teams: whether your engineering team has the skill and bandwidth to manage that database in production or the organizational support to learn on the fly, through uptime and inevitable downtime.

You will almost always lose hard if you try to force a database to behave in a way that makes your code or application design "easier." Databases are a lot like cats. They're going to do what they want to do. If you take the time to understand how they see the world, you will have a lot more success and fewer scratches. And the bigger the cat, the more time and care you need to take. You will not have any more success in a battle of wills against a database with terabytes of data and a misaligned use case than you would trying to force a Bengal tiger to do what you want by treating it like a trained dog.

Start smart, keep learning, and if you find that you either somehow picked a database engine that you will always have to fight against or you have simply grown apart, be prepared to invest in researching and finding a better solution, because if you go to war against your database engine, you will always lose.

