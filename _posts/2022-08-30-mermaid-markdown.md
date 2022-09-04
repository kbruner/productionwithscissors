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

<br>

To embed in an `.md` file, you can wrap it like this:
<script src="https://gist.github.com/kbruner/51023f98a7fdaffbe9d7882271ca9c97.js"></script>


## Rendering to a file

You can use the [cli](https://github.com/mermaid-js/mermaid-cli) to write
directly to a file. You can install the cli as an `npm` package locally, but
I got dependency errors and I'm not a node person, so forget that.

Fortunately, they distribute a docker container. If you already have `docker`
installed, you just need to pull the image, and you're good to go.

The cli supports `svg`, `png`, `md`, and `pdf` output formats. I want an image
file, so first I tried `png` but the file wasn't loadable in one image viewer
I tried. Instead I output to `svg` and then used `gimp` to convert it to
`png`. (Plenty of other tools exist for that image conversion.)

```
k@slaapmatje:~$ mkdir mermaid
k@slaapmatje:~$ mv my-brain.mmd mermaid
k@slaapmatje:~$ cd mermaid
k@slaapmatje:~/mermaid$ chmod 777 .
k@slaapmatje:~/mermaid$ sudo docker pull minlag/mermaid-cli
Using default tag: latest
latest: Pulling from minlag/mermaid-cli
Digest: sha256:bf130e7ce53fa2269d4d7784c4d7d3edea63185f2fb72d337148224ffd22f1ec
Status: Image is up to date for minlag/mermaid-cli:latest
docker.io/minlag/mermaid-cli:latest
k@slaapmatje:~/mermaid$ sudo docker run -it -v `pwd`:/data minlag/mermaid-cli -i /data/my-brain.mmd -o /data/my-brain.svg
Generating single mermaid chart
k@slaapmatje:~/mermaid$ ls
my-brain.mmd  my-brain.svg
k@slaapmatje:~/mermaid$
```

(We give the `mermaid` directory global write permissions so the `docker` user
can write to it.)

---

Mermaid supports a number of graph and diagram formats, and it's fun
to write!
