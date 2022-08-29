---
layout: post
title: Fake It Until Ik Spreek Het
date: 2020-07-06 23:52:16.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- istio
- kubernetes
- slides
meta:
author: karen
permalink: "/2020/07/06/fake-it-until-ik-spreek-het/"
excerpt: If you ever need to write bilingual slides...
---

_If you ever need to write bilingual slides..._

In the story "The Page Who Feigned to Know the Speech of Birds" from _1001 Nights_, a servant overhears his rich boss telling his wife that she should spend the following day relaxing in their garden. That night, the servant sneaks into the garden, placing several items.

The next day, as the servant accompanies the lady to the garden. As they walked around the garden, a crow cawed out. The servant thanked the bird and told the lady the bird said they could food under a nearby tree which she should eat. Since the lady was apparently not too bright, she took this to mean that the servant could understand the birds' language. The next time the crow cawed, she asked the servant to translate. He replied that she could find some wine under another nearby tree. Drinking the wine that was, in fact, nearby, the lady became even more impressed with the servant. The third time the crow cawed, the servant thanked it and told the lady the bird told him there were sweets under yet another tree, by which time she found the servant completely fascinating.

The next time the crow cawed, the servant threw a rock at it. The lady asked him why he would do that, and he replied...

Ok, this story gets a little adult here, so you can go read the ending on your own if so inclined.

* * *

I recently gave an online talk on [zero trust architectures in Kubernetes](https://www.cloudnativeday.ca/en/program/#Bruner) for [Cloud Native Day](https://www.cloudnativeday.ca/en/). Learning that it was based out of Québec, I was told they didn't require bilingual slides, but I decided to try my hand at them anyway.

I am by no means fluent in French, although I took French all through high school, and in the past couple years, I've been practicing on [Duolingo](http://www.duolingo.com/) to refresh and update it. My skills are mostly along the lines of _« Je peux probablement trouver mon hôtel, commander mon dîner et m'excuser pour mon terrible accent »_ ("I can probably find my hotel, order dinner, and apologize profusely for my horrible accent.") (I'm also learning Dutch and Spanish on Duolingo, hence the wonky English/Dutch bilingual post title.)


<iframe src="//www.slideshare.net/slideshow/embed_code/key/oclNPr1nvKKa91" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/KarenBruner/trust-no-8-ne-faisez-pas-confiance-8" title="Trust No 8 / Ne faisez pas confiance à 8" target="_blank">Trust No 8 / Ne faisez pas confiance à 8</a> </strong> from <strong><a href="//www.slideshare.net/KarenBruner" target="_blank">KarenBruner</a></strong> </div>

Here are some tips if you ever happen to find yourself in the position of preparing bilingual slides for a technical talk when you are familiar with, but not fluent in, the second language.

* **Puns probably don't translate.** I gave my talk a (very bad) title before I realized I was going to try to make it at least a little bilingual-friendly.
* **Keep the slides simple.** Really, most recommendations for technical slide content say you should limit the amount of text on slides. People should be listening, not reading. Tersely-worded slides make even more sense when balancing two languages. Avoid idioms or other non-literal phrasings that are unlikely to translate well.

My slides feature a mix of my high-quality stick figure illustrations and some small groups of bullet points.

* **Have a native or fluent speaker check your translations.** Hopefully you can find someone with a technical background, but if not, even just simple grammar and spelling checks are useful.

But how do you find the accepted translations for technical terms? Often, even in somewhat closely related languages, the accepted translation for a term may not be the literal translation. For example, the Dutch term for "peanut butter" is _pindakaas_, which literally translates to "peanut cheese."

Finding accepted translations for uncommon technical jargon can require some digging. I was writing about zero trust networks, [Kubernetes](https://kubernetes.io/), and [Istio](https://istio.io/), so I did a lot of googling and ended up using a mix of the following sites and methods:

* While the Istio docs only come in English and Chinese, the official Kubernetes documentation comes in many translations, although not all pages are translated for all languages. Check the docs for the technology you're covering to see if there are translations. You don't even need to be able to comprehend everything, only to pick out the phrasings used for the concepts you want to cover.
* If the official docs don't cover your language, try finding hits on documentation sites of large, multi-national companies which may use or leverage the tech in question. [One of my page hits for Istio](https://www.ibm.com/cloud/istio) was on the IBM Cloud site. They have a language pull-down menu in the page footer, so I switched to French and got some useful jargon translations there.
* [Modify your Google search settings](https://support.google.com/websearch/answer/3333234) to return pages in the language you need. This won't be immediately useful unless you also disable English, because most page hits will likely be in English. However, once you start using the translated terms you've been able to find, you will start getting hits in the second language.
* Once you start finding the key terms you need, you may want to double-check that they are the most commonly used by googling those and making sure you get a good number of legitimate hits back.
* [Reverso](https://reverso.net/) is not a technical site, but they have a huge database of examples in actual texts, so you may be able to find localized translations for some terms you need there.
* And of course there's Google Translate, but even for the most popular languages, its translations for all but the simplest phrases still feel unnatural if not plain wrong.

So, that's it! _Alors, c'est tout !_

