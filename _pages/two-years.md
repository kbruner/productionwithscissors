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
meta:
  _wpcom_is_markdown: '1'
  _last_editor_used_jetpack: block-editor
  _publicize_pending: '1'
  _coblocks_attr: ''
  _coblocks_dimensions: ''
  _coblocks_responsive_height: ''
  _coblocks_accordion_ie_support: ''
  amp_status: ''
  spay_email: ''
  _starter_page_template: blank
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/two-years/"
---
<!-- wp:paragraph {"fontSize":"medium"} -->

_AKA The log4j Incident_

<!-- /wp:paragraph -->

<!-- wp:paragraph {"fontSize":"medium"} -->

_AKA Karen Was Right_

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I worked a company that used Java with [Log4j](https://logging.apache.org/log4j/) for logging. Log4j was configured to submit log entries to a logging SaaS by sending them to an agent running on the same server. However, the multi-line Java stack traces would get appear as single-line entries on the logging SaaS, making them very hard to correlate and follow.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

People would come to me periodically to deal with the issue by blaming the SaaS. I would tell them that it wasn't the SaaS, which supported multi-line entries, as could be seen with our non-Java apps, and that the logging library shared by the Java apps was likely at fault. Eventually I ran a test with `tcpdump` on a server, showing that the messages had already been broken up into one line per message to the logging agent. But still, regular visits blaming the log service. Eventually, I even wrote an FAQ about the issue, which included the `tcpdump` output, so when people pinged me about it, I could point them to it. It was on the app side, clear as day.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

This went on for two years. TWO YEARS. Finally, I had had it. I sat down, combed through the `log4j` docs and examples, altered the logger class and made a test app that showed that, by using a different `log4j` method (or maybe it was a method option? I can't remember), the multi-line stack traces would appear in Sumo as single, discrete log entries.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I don't generally have the inclination to say, "I told you so," (especially when it should really go without saying), but TWO YEARS. I told my boss I wanted t-shirts distributed to everyone in engineering saying, "Karen was right."

<!-- /wp:paragraph -->

<!-- wp:image {"align":"center","id":1584,"sizeSlug":"large","linkDestination":"none"} -->

![Stick figure drawing of a person wearing a t-shirt that reads "Karen was right"]({{ site.baseurl }}/assets/images/2021/03/sketch1615358278475-01.png?w=415)  

_A shirt for any and all contexts_

<!-- /wp:image -->

<!-- wp:paragraph -->

The t-shirts were not forthcoming. I left the company soon thereafter.

<!-- /wp:paragraph -->

