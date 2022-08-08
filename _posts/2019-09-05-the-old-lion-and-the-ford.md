---
layout: post
title: The Old Lion and the Ford
date: 2019-09-05 08:02:07.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- devops
meta:
  _rest_api_published: '1'
  _rest_api_client_id: '2697'
  timeline_notification: '1567670740'
  _publicize_job_id: '34953431336'
  _edit_last: '108235749'
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2019/09/05/the-old-lion-and-the-ford/"
excerpt: On the normalization of deviance
---

_On the normalization of deviance_

In Aesop's fable, "The Old Lion and the Fox," a fox passing by a cave hears a voice calling out. The voice claims to be a sick, old lion too infirm to leave the cave, and asks the fox to come into the cave to help ease his loneliness. The fox, noting that the only tracks to be seen went into the cave but none came out, wisely refuses. The moral of the story is to learn from the failures of others instead of repeating their mistakes.

Perhaps oddly, I see a corollary to this story in one of my father's jokes. My father was born and raised in Georgia (the state, not the country), and thus had a large collection of redneck jokes which generally made me cringe. The only one I can remember, though, goes like this:

> One man gets a ride from another in his pickup. As they're driving along, they come up to an intersection with a red light. The driver flies through the intersection.
> 
> The passenger says, "Hey, you just ran that red light!"
> 
> The driver replies, "Naw, it's ok. My brother does it all the time."
> 
> They come to another intersection, and again, the pickup blows through the red light.
> 
> "Hey, man, that light was red, too! That's really dangerous!"
> 
> "Naw, I told you, my brother drives through red lights all the time and he's fine."
> 
> At the third intersection, they have a green light. The pickup stops.
> 
> The passenger: "Hey, man, what's wrong with you? Why are you stopping for a green light?"
> 
> The driver: "My brother might be coming the other way!"

[This blog post](https://danluu.com/wat/) that I have re-read and shared many times over the years talks about the ubiquitousnous in Silicon Valley of a sociological phenomenon called the "normalization of deviance." The term was coined by Diane Vaughan to explain the gradual, unconscious acceptance of dangerous engineering practices and beliefs in NASA and its contractors that led to the preventable explosion of the Space Shuttle _Challenger._

These delusions usually start to take root the first few times someone takes a shortcut or compromises on quality. If there is no bad outcome, the risk must have been overestimated, right? This behavior quickly becomes acceptable, and then it becomes... normal. "Everyone must do it this way, right?" And when they finally hit those 10:1, 100:1, or 1,000,000:1 odds, \*that\* must have been a fluke, right? That can't possibly happen again. There are good reasons why the government appointed commissions independent of NASA to investigate the agency's major fatal disasters. In most tech startups, though, there are few if any external factors to force an objective evaluation of what went wrong. So nothing changes. Then new people come in, and particularly those who are, maybe, in the first job, or are joining what's considered a world-class organization, will often start thinking this must be normal, too, because surely it wouldn't happen here otherwise. Right?

It's very frustrating to come into an organization with these delusions. Silicon Valley is supposed to be full of smart people, right? Iconoclasts, critical thinkers, all that, right? I tend to agree with the conclusions in Dan Luu's post, adding that the arrogance and optimism which drives this industry is actually sometimes more like to feed normalization of deviance rather then defeat it. And whether or not (frequently, not) they can learn from someone else's mistakes, the resulting cultures all too often cannot learn from their own, because, oh, hey, that wasn't a mistake. Probably some butterfly in China was flapping their wings. (I'm pretty sure there are lots of butterflies in China that will flap their wings, so, uh, if one can take down your entire website, shouldn't you still try to build in protection against _that_?)

I also believe normalization of deviance goes a long way to explain why so many attempts to adopt that whole "devops" thing fail. First, there is the very common mistake of thinking devops == Agile and you just need to put your code in git, throw up a Jenkins server, and change someone's title from sysadmin/syseng/prodeng/whatever to "devops engineer." Even when an organization is savvy enough to realize that, hey, this devops thing requires some cultural change, it's one thing to create new, good habits. What's often neglected is realizing that you also need to break old, bad habits, something that becomes that much more unlikely if no one can actually recognize these habits as toxic anymore.

I don't have any obvious solutions. But maybe as a starting place, every time someone makes a compromise in the name of start-up necessity, write it on a Post-It note and put it on a Wall of Deviance in the office. And, just to drive the lesson home, as you stick one on the wall, repeat the mantra, "This is not normal. This is not normal."

