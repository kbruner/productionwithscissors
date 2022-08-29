---
layout: post
title: 'Adventures in Freebernetes: My Out-of-Control Plane'
date: 2020-11-28 08:10:28.000000000 -08:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- FreeBSD Virtualization
tags:
- dns
- freebsd
- ipv4
- kubernetes
- linux
- virtualization
meta:
author: karen
permalink: "/2020/11/28/adventures-in-freebernetes-my-out-of-control-plane/"
excerpt: 'Part 11 of experiments in FreeBSD and Kubernetes: Bootstrapping the Kubernetes Control Plane'
thumbnail: assets/images/2020/11/screenshot-2020-11-27-at-03.54.07-01.jpeg
---

_Part 11 of experiments in FreeBSD and Kubernetes: Bootstrapping_ _the Kubernetes Control Plane_

[_See all posts in this series_](/freebsd-virtualization-series/)

#### Table of Contents

1. [Recap](#recap)
2. [Bootstrapping the etcd Cluster](#bootstrapping-etcd-cluster)
3. [Bootstrapping the Kubernetes Control Plane](#bootstrapping-control-plane)

* [Rabbit Hole #3: Load Balancing Revisited](#rabbit-hole-3-load-balancing)
* [Verifying the Control Plane](#verifying-control-plane)
* [Sources / References](#sources-references)

## Recap

In [the previous post](/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/) in this series, I created my Kubernetes cluster's [virtual machines](/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/#creating-instances), [the cluster certificates](/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/#generating-certificate-authority), and [client authentication files](/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/#generating-kubernetes-configuration-files), following the tutorial in [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way). I also set up an authoritative [DNS](/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/#rabbit-hole-1-dns) server to handle my local zone on the hypervisor, as well as creating firewall rules to [load balance](/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/#rabbit-hole-2-fake-load-balancing) across the three controller instances. Now I'm ready to bootstrap `etcd`.

A few details for reference:

* My hypervisor is named `nucklehead` (it's an Intel NUC) and is running FreeBSD 13.0-CURRENT
* My home network, including the NUC, is in the 192.168.0.0/16 space
* The Kubernetes cluster will exist in the 10.0.0.0/8 block, which exists solely on my FreeBSD host.
  * The controllers and workers are in the 10.10.0.0/24 block.
  * The control plane service network is in the 10.50.0.0/24 block.
  * The cluster pod network is in the 10.100.0.0/16 block.
  * The cluster service network has the 10.110.0.0/24 block.
* The cluster VMs are all in the `something.local` domain.
* The `kubernetes.something.local` endpoint for `kube-apiserver` has the virtual IP address 10.10.0.1, which gets round-robin load-balanced across all three controllers by `ipfw` on the hypervisor.
* Yes, I am just hanging out in a root shell on the hypervisor.

<a id="bootstrapping-etcd-cluster"></a>
## [Bootstrapping the etcd Cluster](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/07-bootstrapping-etcd.md)

First off, I fire up tmux, create three panes, then google to figure out how to split them more or less evenly. Then I spend another five minutes trying to fix the `term` type because I've finally lost patience with getting rows of `q` instead of a solid border. However, nothing I try seems to fix it and I can't find anything on the net, so this is what my window looks like and why am I reading `/etc/termcap` in the year 2020?

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-27-at-02.27.58-01.jpeg"
alt="Screen shot of my terminal with three tmux panes divided by lines of q">
</div>
<br>


<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-27-at-02.58.19-01.jpeg"
alt="Screenshot of terminal with three tmux panes setting the IP and name variables on each controller VM">
</div>
<br>


And done.

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-27-at-03.54.07-01.jpeg"
alt="Screenshot of 3 panes in tmux showing each controller has etcd running">
</div>
<br>

<a id="bootstrapping-control-plane"></a>
## [Bootstrapping the Kubernetes Control Plane](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/08-bootstrapping-kubernetes-controllers.md)

I didn't read the section on certificate creation closely enough, so I missed the part about how the Kube API service IP should (must?) be part of a dedicated block for control plane services. My current `kube-apiserver` endpoint is currently in the same block as the VMs, so I will use 10.50.0.0/24 for the service block. I quickly redo the virtual IPs I added to the controllers and the `ipfw` rules on the hypervisor, then update the DNS record for `kubernetes.something.local` to 10.50.0.1.

<a id="rabbit-hole-3-load-balancing"/>
### Rabbit Hole #3: Load Balancing Revisited

After I set up the `nginx` reverse proxy with its passthrough to `kube-apiserver`'s `/healthz` endpoint on each controller, I wondered a bit if I should revisit the cut-rate load balancing I had set up using `ipfw` and VIPs. While it spreads the requests to the Kubernetes API's virtual service address across the three controllers, it has no [health check](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/08-bootstrapping-kubernetes-controllers.md#enable-http-health-checks) support to make sure it's not sending a request to a server that cannot respond, and `ipfw` does not support such a thing.

I consider a few options:

* Create a service on the FreeBSD hypervisor that runs the health check for each backend and then updates the `ipfw` rules as needed; requires maintaining another service and also requires ensuring I don't mangle my firewall in the process.
* Instead of using a virtual IP address for the API endpoint, convert it to a round-robin DNS record. Using a custom service health-check like the one mentioned above, the service could update the DNS zone to remove a failed backend host. This option would actually be worse than updating `ipfw` rules, because not only because I would risk mangling my DNS zone. I would also have to deal with time-to-live (TTL) for the DNS record, which requires balancing a low TTL which carries frequent DNS lookups versus using a longer TTL, which can make the time to fail over unpredictable for clients. Round-robin DNS is clearly not a better option, but I mention it because round-robin records often buy simplicity of implementation at the price of multiple headaches down the road.
* Add a reverse proxy service on the hypervisor, such as `nginx` or `haproxy`, to query the `/healthz` endpoint on each backend and avoid sending incoming requests to servers that are unhealthy. Unlike the `ipfw` round-robin, this solution runs in user space rather than in the kernel, which means it adds a performance hit and also requires managing another service.
* Use CARP (Common Address Redundancy Protocol) for failover. While I had originally thought I could use [CARP](https://www.freebsd.org/doc/handbook/carp.html) on the FreeBSD host to handle some form of failover, it became clear that was not an option, because CARP has to be configured on the endpoint servers themselves. However, I could use the Linux analog `ucarp` to create server failover between the controllers.

I ended up not setting up CARP for a few reasons:

* Unlike FreeBSD's implementation, which runs as an in-kernel module, Linux's `ucarp` runs as a service in userland. In other words, it requires managing yet another service on each of the controllers.
* Neither CARP implementation can monitor a specific service port for liveness. Failover only occurs when the host currently using the configured virtual IP address stops advertising on the network.
* `ucarp` only supports pairs of servers for a given virtual IP address, while I have three controllers. I could do something like create three CARP groups, one for each possible pair, and then use those for the endpoints in the `ipfw` firewall rules. However, that doesn't really solve the problem of a VM advertising on the network but not serving `kube-apiserver` requests for other reasons. But I had to look at CARP again anyway.

<div align="center">
<img
src="/assets/images/2020/11/sketch1606526054394-01.jpeg"
alt="Diagram of 3-way failover with CARP when each controllers sharing a different virtual IP address with each of the other two controllers">
<br>
<i><small>
Diagram showing what a 3-way failover could look like with CARP when you can only have two servers in a group
</small></i>
</div>
<br>



In the end, I decide not to implement a truly highly-available configuration because I'm not creating a production system, I already have more than one single point of failure (SPOF) so what's one more, and I was hoping for a more elegant or a more interesting solution. I'd probably go with setting up a reverse proxy to use as a health-checking load balancer on the FreeBSD hypervisor if I really needed high availability in this scenario.

<a id="verifying-control-plane"></a>
### [Verifying the Control Plane](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/08-bootstrapping-kubernetes-controllers.md#verification)

After escaping from that rabbit hole, it's time to see if I set up the control plane correctly.

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-27-at-15.10.16-01.jpeg"
alt="Screen shot of shell with three tmux panes showing all three controllers are using an invalid certificate due to missing IP address">
</div>
<br>


Well, that's a no. It looks like I somehow missed adding the localhost endpoint when generating one of the certificates (probably the API server's). And come to think of it, I also forgot to update the certificates when I changed the `kubernetes.something.local` IP address.

I regenerate `kubernetes.pem` and then copy it around. Both `kube-apiserver` and `etcd` use it, the latter for authenticating peer connections from the API server. I restart the services and... still get the error. I double check the generated cert with `openssl x509 -in kubernetes.pem -text` and yes, the hostnames are all there in the list of Subject Alternative Names (SANs).

<script src="<script src="https://gist.github.com/kbruner/d50ce38edba57c5ab7bbf04d318acdac.js"></script>.js"></script>

Except it's odd that the `kubectl` error tells me the only valid IP addresses are `10.10.0.1[0-2]` (depending on the controller) and `10.0.0.1`, the default gateway configured on the VMs. Sooo... I go digging. It looks like `kube-apiserver`'s default path for certificates is `/var/run/kubernetes`, which I had created per the tutorial. Sure enough, there were two files there which I had not created: `apiserver.crt` and `apiserver.key`. And when I ran the `openssl x509 ...` command on `apiserver.crt`, it only had two configured Subject Alternative Names: `10.10.0.1[0-2]` (depending on the controller) and `10.0.0.1`.

I delete those files, restart `kube-apiserver` and as I expected, it regenerates them, but they still have the same useless SANs. So, I stop everything again, and copy over the damn `kubernetes.pem` and `kubernetes-key.pem` (the ones I had created) from `/var/lib/kubernetes` to `/var/run/kubernetes` with the appropriate file names, fire everything up (again), and yay, shit works now, let's move on.

<div align="center">
<img
src="/assets/images/2020/11/screenshot-2020-11-27-at-23.40.40-01.jpeg"
alt="Screen shot of shell with tmux panes showing the kubectl command now works on all the controllers.">
</div>
<br>


I configure `kubelet` RBAC, skip the section on creating a load balancer in Google Cloud since I have my `ipfw` rules in place and, you know, not in GCP. I test my fake load balancer endpoint, and everything works.

<script src="<script src="https://gist.github.com/kbruner/882b321f8fb66cfc5f40eff621046aed.js"></script>.js"></script>

* * *

In the [next installment](/2020/12/01/adventures-in-freebernetes-tripping-to-the-finish-line/), I'll start off by bootstrapping the worker nodes and maybe finish building the cluster, depending, as always, on the number of rabbit holes I can't resist.

## Sources / References

* [https://github.com/kelseyhightower/kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
* [https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)
* [https://manpages.ubuntu.com/manpages/focal/man8/ucarp.8.html](https://manpages.ubuntu.com/manpages/focal/man8/ucarp.8.html)
* [https://www.freebsd.org/doc/handbook/firewalls-ipfw.html](https://www.freebsd.org/doc/handbook/firewalls-ipfw.html)

