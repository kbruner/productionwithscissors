---
layout: post
title: Mermaid Markdown for Procrastinators
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Tech Tools
tags:
- documentation
- tech-tools
meta:
permalink: /2022/08/30/mermaid-markdown/
excerpt: An example of the Mermaid Markdown-ish graph generator
thumbnail: /assets/images/2022/08/meh2.png
---

I went down the rabbit hole to look at the [Mermaid
diagram tool](https://mermaid-js.github.io/mermaid/#/) that allows you to
generate graphs and charts of various kinds using a markdown-like syntax. A
number of [markdown](https://www.markdownguide.org/) systems support Mermaid
now without additional tooling, including GitHub.
[Jekyll](https://jekyllrb.com/), which powers this site, also has a Mermaid
plugin, and it seems like it might be useful at some
point, so I decided to experiment, because what else was I going to do with
my time?

<div class="mermaid">
gitGraph
   commit id: "Need a project"
   commit id: "Play with FreeBSD again"
   branch write-blog-post-on-freebsd
   checkout write-blog-post-on-freebsd
   commit id: "Start writing markdown"
   branch reinstall-freebsd
   checkout reinstall-freebsd
   commit id: "Get FreeBSD reinstalled"
   checkout write-blog-post-on-freebsd
   merge reinstall-freebsd
   commit id: "Write more markdown"
   branch install-nvim-markdown-plugin
   checkout install-nvim-markdown-plugin
   commit id: "Spend 4 hours trying to get it working"
   branch write-blog-post-about-nvim-plugins
   checkout write-blog-post-about-nvim-plugins
   commit id: "Write a post to save others from my fate"
   checkout install-nvim-markdown-plugin
   merge write-blog-post-about-nvim-plugins
   checkout write-blog-post-on-freebsd
   merge install-nvim-markdown-plugin
   branch tweak-blog-settings
   checkout tweak-blog-settings
   commit id: "Fix formatting and other shit"
   checkout write-blog-post-on-freebsd
   merge tweak-blog-settings
   branch play-with-mermaid
   checkout play-with-mermaid
   commit id: "Here we are"
</div>

<center><small><i>GitHub repo graph showing how my focus jumps between current
projects, like experimenting with FreeBSD and making superfluous updates to
this site</i></small></center>
<br/>

The mermaid markdown (mmd) for this graph:
```
gitGraph
   commit id: "Need a project"
   commit id: "Play with FreeBSD again"
   branch write-blog-post-on-freebsd
   checkout write-blog-post-on-freebsd
   commit id: "Start writing markdown"
   branch reinstall-freebsd
   checkout reinstall-freebsd
   commit id: "Get FreeBSD reinstalled"
   checkout write-blog-post-on-freebsd
   merge reinstall-freebsd
   commit id: "Write more markdown"
   branch install-nvim-markdown-plugin
   checkout install-nvim-markdown-plugin
   commit id: "Spend 4 hours trying to get it working"
   branch write-blog-post-about-nvim-plugins
   checkout write-blog-post-about-nvim-plugins
   commit id: "Write a post to save others from my fate"
   checkout install-nvim-markdown-plugin
   merge write-blog-post-about-nvim-plugins
   checkout write-blog-post-on-freebsd
   merge install-nvim-markdown-plugin
   branch tweak-blog-settings
   checkout tweak-blog-settings
   commit id: "Fix formatting and other shit"
   checkout write-blog-post-on-freebsd
   merge tweak-blog-settings
   branch play-with-mermaid
   checkout play-with-mermaid
   commit id: "Here we are"
```

