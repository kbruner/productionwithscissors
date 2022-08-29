---
layout: post
title: Roots of Knowledge
date: 2020-07-19 02:54:55.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- engineering culture
- succulents
meta:
author: karen
permalink: "/2020/07/19/roots-of-knowledge/"
excerpt: Make some cross-pollination of technical knowledge part of your team's culture. Also, grow succulents.
---

_Make some cross-pollination of technical knowledge part of your team's culture. Also, grow succulents._

I have a small collection of [succulents](https://en.wikipedia.org/wiki/Succulent_plant), the only kind of plant I have managed to keep alive. Succulents do not come from a single family of related plants; instead the name describes plants that have adapted usually to arid ecosystems by storing water in their leaves, stems, or roots.

Like pretty much all plants, succulents can have one of two major root systems: a fibrous root system or a taproot. A [taproot](https://en.wikipedia.org/wiki/Taproot) has a single, usually thick root, usually with smaller roots growing from the taproot. When you eat a carrot, you eat that plant's taproot. Lithops, the "living stone" succulents, also have persistent taproots.

<div align="center">
<img src="/assets/images/2020/07/img_20200718_142234-01.png" alt="Photo of small rock-looking plants potted in other rocks">
<br>
<i><small>
My juvenile lithops, one removed to show the taproot. The lithops on the left is currently shedding its old leaf pair, something healthy lithops do annually. ("Lithops" is both the singular and plural form of the plant's name.) This dude needs its summer watering.
</small></i>
</div>
<br>

Most common succulents have branching root systems, though, including [Haworthias](https://en.wikipedia.org/wiki/Haworthia) like this [_H. retusa_](https://en.wikipedia.org/wiki/Haworthia_retusa) pup receiving water therapy. (In a rather surprising twist, while overwatering is the most surefire way to kill most succulents, submerging the roots of some plants that have suffered root damage, a practice called "water therapy," can help them grow new roots and rebound.)

<style>
.piccol {
  float: left;
  width: 45%;
  padding: 5px;
}

/* Clear floats after image containers */
.picrow::after {
  content: "";
  clear: both;
  display: table;
}
</style>

<div class="picrow">
<div class="piccol">
<img src="/assets/images/2020/07/img_20200715_171106-01.jpeg" alt="Photo of a pointy-leaved plant suspended in water">
</div>                                                                          
<div class="piccol">                                                            
<img src="/assets/images/2020/07/img_20200715_171323-01.jpeg" alt="Photo of a pointy-leaved plant suspended in water">
</div>
</div>
<center>
<i><small>
Haworthia retusa pup in water therapy. The lighter colored roots are newer growth. The plump, bright green leaves in the middle of the plant mean it is able to take water from its roots and should be viable to replant.
</small></i>
</center>
<br>

In fact, some of these plants can grow new roots even when it appears their entire root system had died, like my _[H. cymbiformis](https://en.wikipedia.org/wiki/Haworthia_cymbiformis)_. I thought it was a goner after a mealy bug infestation, because all the roots had dried up and broken off. After just a couple weeks of water therapy, though, and it has new roots.

<div align="center">
<img src="/assets/images/2020/07/taproot-01.jpeg" alt="Photo of a pointed-leaved plant suspended in water">
<br>
<i><small>
Haworthia retusa (left) and H cymbiformis (right). The latter had lost all its roots after a mealy bug infestation but after a couple weeks of water therapy, it is growing new roots (white protrusions) and seems to be bouncing back.
</small></i>
</div>
<br>

Mealy bugs strike true fear in the hearts of succulent growers. They are fluffy little fuckers which like to hide among, and consume, the roots and stems of succulents. Their favorites, like mine, seem to be haworthias. The only succulents I've lost were to mealy bugs. (Ok, I did have a lithops which likely succumbed to its injuries from a kitten.) The little assholes can usually be detected by the whispy spiderweb-like strands they deposit on the leaves. I'm not going to post a picture of them because I hate them so very, very much.

So while plants with branching roots can sometimes apparently regrow their entire root system, plants with taproots cannot. If the taproot dies or breaks off, the plant is a goner, although some plants with persistent taproots, like dandelions, can regrow the plant from an intact taproot. Haworthias can be propagated by cutting off smaller rosettes in a clump as long as they get some part of the root system. This practice not only does not work with succulents with taproots, but it also would kill the plant.

* * *

You could probably apply the taproot vs fibrous roots analogy to a number of aspects of software engineering, including monolith architecture vs microservices. But this blog claims to be at least tangentially about devops, so let's talk about breaking down some silos.

I'm not a botanist or an evolutionary biologist, but, at least as an amateur succulent grower, I'd say the plants with a fibrous root system seem to have a clear advantage over those with taproots. Those plants with fibrous roots can often regrow roots after serious injury or damage, and they often allow the plants to be divided into new, smaller clumps. Branching roots can grow off in new directions if they hit an obstruction; taproots tend to grow downward. The root and therefore the plant can suffer and die if they hit a hard obstruction.

Engineering teams in an organization can also take on characteristics of a taproot or a fibrous root system. Teams with a taproot approach may have domain knowledge of one area of the software or architecture, but their connections to other teams relating to shared or connected expertise tend to be more tenuous and shallower.

<div align="center">
<img 
alt="3 circles connected with a few tenuous lines"
src="/assets/images/2020/07/taproot-01.jpeg">
<br>
<i><small>
Visualization of team knowledge with little overlap or connection
</small></i>
</div>
<br>

A more fibrous structure would ideally still have specialized concentrations of knowledge in each team, but the knowledge distribution from team to team would be more of a continuum rather than a set of bounded, unshared proficiencies.

<div align="center">
<img 
alt="3 circles blurred together"
src="/assets/images/2020/07/branch-01.jpeg">
<br>
<i><small>
Visualization of teams with large amounts of shared or interconnected knowledge.
</small></i>
</div>
<br>

The overlapping model does not mean to say that everyone needs to be an expert in every other team's wheelhouse. Specialization should not disappear. But it does need to be collaborative and open. And more importantly, it needs to operate with the understanding that these teams and their areas of responsibility do not exist in vacuums or silos.

Take this example. You may have a team that owns the cloud infrastructure platform, another team which handles database reliability, and a backend product engineering team.

Obviously, the cloud infra team and the database reliability team need a solid subset of shared information and knowledge. While the infra team could just throw some virtual machines and storage at the DB team, effectively managing database reliability and performance is impossible without understanding some key characteristics and behaviors of the underlying infrastructure. Meanwhile, the cloud infra team would have to understand best practices for the database engine's infrastructure requirements.

The backend team would also need some understanding of cloud services on which their own services depend, such as infrastructure security, performance, and availability. They may need to have some understanding of the actual dollar costs of certain design and implementation choices which can affect the cloud provider bill. The cloud infra team needs to understand the backend software's capacity and performance needs and its dependencies and usage of difference cloud services.

The backend and database teams also need to have shared knowledge. The product engineers need to understand the performance characteristics and best practices of the database engine to create efficient schema and queries as well as to avoid anti-patterns that can adversely impact application performance or database stability. The database reliability engineers need to understand the backend services' requirements for stateful storage well enough to make both architectural and more low-level recommendations, as well as to add resilience to the database infrastructure and scale it as needed.

Many engineering organizations either intentionally or, through lack of intention, have teams which do not integrate as well as they should with respect to knowledge. This lack of cohesion can lead to wasted work, incompatible solutions to multi-team projects and problems, and general frustration and mistrust all around.

While some individuals in these teams may make their own attempts to bridge the jargon chasms, learning requires an investment of time and effort. When so many engineering organizations are unwilling or unable to tap on the brakes, thus disrupting their constant state of building broken stuff but doing it fast, this shared technical understanding can be difficult to acquire.

One way to start down the path of being a branched-root rather than taproot org would be to have engineers spend guest sprints or rotations on other teams. These exchanges create some temporary drag as the visiting engineer ramps up and host members help, but actually doing the job is one of the ways to understand both the technology and the experience of that host team.

Another less targeted but good introductory method would be to have regular presentations from different teams to try to educate each other and create the space for conversations.

Spreading technical knowledge across teams does more than help engineers on every team make more informed decisions. It helps develop empathy between teams. "Oh, so _that's_ what they're doing every day." And again, teams don't need to become experts in the specialties of neighboring teams. They do need to learn enough to have useful conversations and, perhaps most importantly, to learn what questions they need to ask when faced with an issue or decision.

Branched-root teams and organizations grow their contextual understanding of their own domain by learning about neighboring teams and their concerns. This strengthens individual engineers because knowledge is power, and it strengthens the organization because teams can talk to each other and collaborate intelligently to create more resilient and efficient systems.

