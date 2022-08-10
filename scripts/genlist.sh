#!/bin/bash

cat <<EOF >../pages/freebsd.md
---
layout: page
title: "FreeBSD Virtualization Series"
permalink: /freebsd-virtualization-series.html
excerpt: Articles in the FreeBSD/Kubernetes series
---

EOF

for f in *freebernetes*; do
	path="$(grep -m 1 -E '^permalink: ' $f | sed -e 's/^permalink: *//' -e "s/'//g" -e s'/"//g')"
	#path="$(echo $f | sed -e 's/^\([0-9]*\)-\([0-9]*\)-\([0-9]*\)-/\/\1\/\2\/\3\//g' -e 's/\.md$/\//')"
	title="$(grep -m 1 -E '^title: ' $f | sed -e 's/^title: *//' -e "s/^'//; s/'\$//;")"
	day="$(grep -m 1 -E '^date: ' $f | sed -e 's/^date: *//' -e 's/\([0-9]*-[0-9]*-[0-9]*\) *.*$/\1/')"
	date="$(date +"%B %e, %Y" -d "$day")"
	excerpt="$(grep -m 1 -E '^excerpt: ' $f | sed -e 's/^excerpt: *//' -e "s/^'//; s/'\$//;")"

	cat <<EOF >>../pages/freebsd.md
### [$title]({{ site.baseurl }}$path)

#### $excerpt

##### $date

* * *
EOF

done
