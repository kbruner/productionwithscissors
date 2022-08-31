---
layout: post
title: Cassandra, or How Ignorance is Bliss Right Up Until the Greek Armies Pop Out
  of that Wooden Horse
date: 2020-05-28 08:59:09.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- site reliability
meta:
permalink: "/2020/05/28/cassandra-or-how-ignorance-is-bliss-right-up-until-the-greek-armies-pop-out-of-that-wooden-horse/"
excerpt: Trust me when I tell you I know what's going to happen here...
---

_Trust me when I tell you I know what's going to happen here..._

In Greek mythology, Cassandra is the daughter of King Priam and Queen Hecuba of Troy. Considered a great beauty, she was pursued by the god Apollo, who granted her the gift of prophecy in order to woo her. When she rebuffed his advances, he turned the gift into a curse -- although her prophecies were always true, no one would ever believe her warnings.

When her brother Paris brought the married queen Helen to Troy as his lover, Cassandra warned that the pair would doom the city. Everyone called her mad, even when she told them that the Trojan Horse was not a parting gift from the retreating Greek armies, but rather the means to trick the Trojans into opening their gates to the enemy. She was forced to watch helplessly when the Greek soldiers hiding in the wooden horse finally destroyed the city from the inside.

* * *

Aside from the incredible and ongoing human suffering and loss of life, watching this pandemic play out from the safety of my couch, I spent awhile trying to break down the complex reactions I was experiencing. Whenever epidemiologists and public health officials try to warn about what may come and, more importantly, how to prevent COVID-19's spread from turning into a tidal wave, and they are then met with straw man arguments, jingoistic retorts that wouldn't hold up to elementary critical thinking skills, and sometimes even what seems to be a complete and utter disregard for (mostly poor and/or non-white and/or elderly) human life, I have a borderline physical reaction.

A lot of that reaction is the manifestation of grief at the losses, fear that they may still hit someone close to me, and outrage that too many people are either not getting current, accurate information or they just refuse to listen. But some of that physical tension is almost a form of muscle memory, formed from years of experience trying to prevent predictable problems and outages and all-too-often meeting with limited success. I've only managed systems which, if they fail, will not put anyone in real, physical danger. I can only begin to imagine the frustration felt by epidemiologists, virologists, doctors, and other public health officials who are trying to save people's lives.

* * *
In SRE and devops roles, I've had more than one Cassandra moment. "Um, if you do [or don't do, as the case may be] that, there's a non-zero chance that something 100% bad is going to happen."

One of the most personally memorable of these actually involved Cassandra, as in the NoSQL database. A Cassandra ring was becoming increasingly wobbly. The JVMs on the C\* nodes were spending an increasingly large amount of time performing garbage collection, but the cluster's transaction rates were not growing at a comparable rate and the size of the individual data rows stayed constant. Basically, the use case and schema design for the cluster did not even begin to map to Cassandra best practices.

<div align="center">
<img src="/assets/images/2020/05/untitled-drawing-1.png" alt="A venn diagram showing two circles which aren't touching, one labeled 'Cassandra schema design best practices' and the other 'This Cassandra Cluster'">
<br>
<i><small>Venn Diagram: Ideal Cassandra data model vs this cluster. "And never the twain shall meet."</small></i>
</div>
<br>

In order to extract a small data set, the nodes ended up having to read increasingly large tables into memory. The dev who had inherited the application that used the DB and I warned that, unless we took the cluster down to compact and truncate runaway tables, eventually and in the very near future, the table size would outgrow the heap, trapping the JVM in an infinite GC loop. No data would go in or come out of that cluster once that happened. The Cassandra ring would look more like a black hole at that point.

Except, no, we could not take a planned production downtime. It was not a good time for that.

A week or so later, we took an unplanned production downtime on a weekday morning (peak use time). That Cassandra cluster had gone into, wait for it... infinite GC loop.

For certain production outages in certain industries, it is most definitely not better to beg for forgiveness than to ask for permission.

* * *

That was a time where I could not prevent an outage despite relaying credible warnings. I also have numerous examples of issues I prevented without anyone really being aware that there had ever been a danger, because I fixed a problem or added preventive safeguards before it ever spawned an issue that ended up on other people's radar. If a risk does not produce the worst-case outcome, it's often not because the worst-case outcome had been exaggerated from the beginning. If I don't oversleep in the morning because my alarm woke me up on time, the risk that I could have overslept does not retroactively disappear. I did not actually oversleep because I recognized the risk and I acted to prevent it by... setting my alarm. Even if I had gone to bed 12 hours before I needed to wake up in the morning, I would still set the damn alarm.

Granted, many of the preventive measures that we as a society needed to and still need to take in order to fight COVID-19 are not as free of negative consequences compared to setting an alarm clock. But the potential loss of not adopting those measures is also exponentially greater than missing a morning meeting.

So seeing the frustration of people who are motivated by a desire to prevent needless death and suffering as they can only continue to appeal to reason and simple human decency genuinely triggers me. Maybe I'm projecting here, but it seems to me that while maybe some of those individuals may have separate agendas, the vast majority of the scientists, healthcare workers, and other public policymakers

* have a lot more expertise than naysayers in the Dunning-Kruger peanut gallery
* have been and continue to warn about possible if not probable catastrophic outcomes, not in order to make themselves seem important but because the risk still exists
* are not "choosing" to prioritize one important area over another, because the two are actually integrally linked and symbiotic and it would be great if everyone recognized that and acted accordingly
* would probably really rather not be "right" about their predictions, especially given the difficulty in driving unpopular preventive measures, but wishing doesn't make it so
* do not change their predictions as "cover" for having overstated the possible impact but rather because they keep recalculating with new information, including feedback based on current interventions
* have no "agenda" other than fixing shit that's broken and preventing dire outcomes
* are totally waiting for you to shout "why didn't you warn us?" when the worst actually comes to pass after you ignored or undermined them
* are basically just doing their job because it's their job and that's what they're supposed to do

Which sounds a hell of a lot like the experience of being an SRE in an engineering org that doesn't prioritize intelligent and sustainable engineering risk management with a collaborative rather than combative or at least counterproductive dynamic.

Basically, it sucks to know your job, to try to do your job, and not only to be blocked from doing that job effectively but to be demonized in the process. And all I do is try to keep software from falling over. It hurts to think about being in the same basic situation if I was trying to save human lives.

Oh, P.S. Wear a goddamn mask, people.

