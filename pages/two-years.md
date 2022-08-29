---
layout: page
title: TWO YEARS
date: 2021-03-10 07:01:41.000000000 -08:00
type: page
parent_id: '0'
published: true
password: ''
status: publish
categories: []
tags: []
hide: true
meta:
author: karen
permalink: "/two-years/"
---

_AKA The log4j Incident_


_AKA Karen Was Right_


I worked a company that used Java with [Log4j](https://logging.apache.org/log4j/) for logging. Log4j was configured to submit log entries to a logging SaaS by sending them to an agent running on the same server. However, the multi-line Java stack traces would get appear as single-line entries on the logging SaaS, making them very hard to correlate and follow.


People would come to me periodically to deal with the issue by blaming the SaaS. I would tell them that it wasn't the SaaS, which supported multi-line entries, as could be seen with our non-Java apps, and that the logging library shared by the Java apps was likely at fault. Eventually I ran a test with `tcpdump` on a server, showing that the messages had already been broken up into one line per message to the logging agent. But still, regular visits blaming the log service. Eventually, I even wrote an FAQ about the issue, which included the `tcpdump` output, so when people pinged me about it, I could point them to it. It was on the app side, clear as day.


This went on for two years. TWO YEARS. Finally, I had had it. I sat down, combed through the `log4j` docs and examples, altered the logger class and made a test app that showed that, by using a different `log4j` method (or maybe it was a method option? I can't remember), the multi-line stack traces would appear in Sumo as single, discrete log entries.


I don't generally have the inclination to say, "I told you so," (especially when it should really go without saying), but TWO YEARS. I told my boss I wanted t-shirts distributed to everyone in engineering saying, "Karen was right."


<div align="center">
<img
src="{{ site.baseurl }}assets/images/2021/03/sketch1615358278475-01.png"
alt="Stick figure drawing of a person wearing a t-shirt that reads 'Karen was right'">
<br>
<i><small>
A shirt for any and all contexts
</small></i>
</div>
<br>


The t-shirts were not forthcoming. I left the company soon thereafter.


