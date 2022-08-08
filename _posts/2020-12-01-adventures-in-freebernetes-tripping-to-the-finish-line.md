---
layout: post
title: 'Adventures in Freebernetes: Tripping to the Finish Line'
date: 2020-12-01 01:47:30.000000000 -08:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- FreeBSD Virtualization
tags:
- freebsd
- kubernetes
- linux
- virtualization
- zfs
meta:
  _wpcom_is_markdown: '1'
  _last_editor_used_jetpack: block-editor
  timeline_notification: '1606787255'
  _publicize_job_id: '51682640345'
  _oembed_d553f662335470532d5a635dd3310bbc: "{{unknown}}"
  _oembed_2dde8e09737374e5a9ab5bb7ed6d0c66: "{{unknown}}"
  _oembed_27f18f18406f8de3b9fbd2310f548e4e: "{{unknown}}"
  _oembed_94f8a754b03988f280ad0cfcf9e08ca4: "{{unknown}}"
  _oembed_cbce4690d2a8ba55f189c9a4330dcb53: "{{unknown}}"
  _oembed_23ddca1d9226217b6d546abd48b1f591: "{{unknown}}"
  _oembed_875a3217e8248e4e388ac0bfd3bb4003: "{{unknown}}"
  _oembed_cc13badff72cfcaaeeb45506b68950dc: "{{unknown}}"
  _oembed_47feb48649918ea088ac6ebac1725b03: "{{unknown}}"
  _oembed_da194698def3a55b1431caebc98f0f79: "{{unknown}}"
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/12/01/adventures-in-freebernetes-tripping-to-the-finish-line/"
excerpt: 'Part 12 of experiments in FreeBSD and Kubernetes: Completing and testing
  the Kubernetes Cluster'
---
<!-- wp:paragraph {"fontSize":"medium"} -->

_Part 12 of experiments in FreeBSD and Kubernetes: Completing and testing the Kubernetes Cluster_

<!-- /wp:paragraph -->

<!-- wp:paragraph {"fontSize":"normal"} -->

[_See all posts in this series_](https://productionwithscissors.run/freebsd-virtualization-series/)

<!-- /wp:paragraph -->

<!-- wp:heading {"level":4} -->

#### Table of Contents

<!-- /wp:heading -->

<!-- wp:html -->

1. [Recap](#recap)
2. [Rabbit Hole #4: Fixing Shit](#fixes)

- [Larger Size](#larger-size)
- [Space](#space)
- [Bootstrapping the Kubernetes Worker Nodes](#bootstrapping-worker-nodes)
- [Configuring kubectl for Remote Access](#configuring-kubectl)
- [Provisioning Pod Network Routes](#pod-network-routes)
- [Deploying the DNS Cluster Add-on](#dns-add-on)
- [Smoke Test](#smoke-test)
- [Sources / References](#sources-references)

<!-- /wp:html -->

<!-- wp:heading -->

## Recap

<!-- /wp:heading -->

<!-- wp:paragraph -->

In [the last post](https://productionwithscissors.run/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/), I bootstrapped my cluster's control plane, both the [etcd cluster](https://productionwithscissors.run/2020/11/28/adventures-in-freebernetes-my-out-of-control-plane/#bootstrapping-etcd-cluster) and [Kubernetes components](https://productionwithscissors.run/2020/11/28/adventures-in-freebernetes-my-out-of-control-plane/#bootstrapping-control-plane), following the tutorial in [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way). In this post, I will bootstrap the worker nodes, but first, I need to fix a few issues.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

A few details for reference:

<!-- /wp:paragraph -->

<!-- wp:list -->

- My hypervisor is named `nucklehead` (it's an Intel NUC) and is running FreeBSD 13.0-CURRENT
- My home network, including the NUC, is in the 192.168.0.0/16 space
- The Kubernetes cluster will exist in the 10.0.0.0/8 block, which exists solely on my FreeBSD host.
  - The controllers and workers are in the 10.10.0.0/16 block.
  - The internal service network is in the 10.20.0.0./24 (changed from 10.50.0.0/24) block.
  - The cluster pod network is in the 10.100.0.0/16 block.
- The cluster VMs are all in the `something.local` domain.
- The `kubernetes.something.local` endpoint for `kube-apiserver` has the virtual IP address 10.50.0.1, which gets round-robin load-balanced across all three controllers by `ipfw` on the hypervisor.
- Yes, I am just hanging out in a root shell on the hypervisor.

<!-- /wp:list -->

<!-- wp:separator -->

* * *
<!-- /wp:separator -->

<!-- wp:heading -->

## Fixes

<!-- /wp:heading -->

<!-- wp:heading {"level":3} -->

### I Need This in a Larger Size

<!-- /wp:heading -->

<!-- wp:paragraph -->

First off, the disks on the controllers filled up. The bulk of the usage came from `etcd` data in `/var/lib/etcd`. [As I noted](https://productionwithscissors.run/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/#creating-instances), I had only allocated 10Gb to each disk, because I don't have an infinite amount of storage on the NUC. However, I still have enough space on the hypervisor's disk to add space to each controller, especially because their virtual disks are ZFS clones of a snapshot base image. ZFS clones use copy-on-write (COW); they only consume disk space when a change is made on the cloned volume.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

However, as I also noted, using ZFS volumes and CBSD makes it pretty easy to increase the size of the guest VM's virtual disk.

<!-- /wp:paragraph -->

<!-- wp:list -->

- Stop the VM
- Use the `cbsd bhyve-dsk` command to resize the VM's virtual disk
- Run `gpart` against the volume's device to increase the size of the filesystem. Note this only works safely if it's the last partition on the disk. We're doing this from the hypervisor so we don't have to re-write the partition table for the live VM, which would either involve booting a rescue CD (which I'm too lazy to figure out) or make the change from the live VM, which is a bit scary when modifying a mounted partition, but can be done.
- Restart the VM
- Log in to the VM and run `resize2fs` on the resized partition.

<!-- /wp:list -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/af5868ab33f11096920eff2f754ca176","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/af5868ab33f11096920eff2f754ca176

<!-- /wp:embed -->

<!-- wp:paragraph -->

I increase the virtual disk on all three controllers and everything is up and running again, except `etcd` on one controller won't restart because of a corrupted data file. I read more docs and figure out I need to stop `etcd`, remove the bad member from the cluster, delete the contents of `/var/lib/etcd`, then re-add the member to the cluster. `etcdctl` will output several lines that need to be added to the errant member's `/etc/etcd/etcd.conf` before restarting `etcd` on that host. (I forgot to grab the shell output.) `etcd` came up, joined the existing cluster, and started streaming the data snapshot from an existing member.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Except `kube-apiserver` keeps writing its own TLS certificate in `/var/run/kubernetes` and it keeps using only the primary IP address on the primary interface plus the gateway IP address in the SAN (Subject Alternative Name) list, while connections to `etcd` and other K8s controller services go over the loopback interface.

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Space

<!-- /wp:heading -->

<!-- wp:paragraph -->

I check the documentation, and as long as `kube-apiserver` has a certificate and key specified by the `--tls-cert-file` and `--tls-private-key-file` options passed at start time. They're both present and correctly set in `/etc/systemd/system/kube-apiserver.service`, so I am comfused. I happen to be running `ps` on one of the controllers while checking the `etcd` cluster and the command's arguments look odd. As in, they end with a trailing `\`. I look at `/etc/systemd/system/kube-apiserver.service` and sure enough, there's a trailing space after the end-of-line continuation `\` of the last argument passed to `kube-apiserver` at start. The '`\ `' would have been interpolated not as an end-of-line continuation, but as a string.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

`systemd` supports a list of start commands, so it would have started `kube-apiserver` without error, throwing an error when it couldn't run the trailing options as an actual command. But since the service process itself started without issue, I didn't notice. Removing the trailing space from the file fixed the issue.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/135bff97050cd949332e9e74df82d748","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/135bff97050cd949332e9e74df82d748

<!-- /wp:embed -->

<!-- wp:paragraph -->

Now that these issues are taken care, the control plane hosts should be stable and reliable, at least for more than 24 hours.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## [Bootstrapping the Kubernetes Worker Nodes](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/09-bootstrapping-kubernetes-workers.md#bootstrapping-the-kubernetes-worker-nodes)

<!-- /wp:heading -->

<!-- wp:paragraph -->

Most of this section is straightforward, other than updating IP addresses and ranges.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

When I [created the worker VMs](https://productionwithscissors.run/2020/11/26/adventures-in-freebernetes-certs-certs-dns-more-certs/#creating-instances), I added, through some hackery of CBSD's `cloud-init` data handling, a `pod_cidr` field to the instance metadata to configure each worker with its unique slice of the pod network. `cloud-init` puts the metadata in `/run/cloud-init/instance-data.json`. We need this value now to configure the CNI (Container Network Interface) plugin.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1401,"sizeSlug":"large","linkDestination":"none"} -->

![Screen shot of tmux showing the pod cidr value of worker nodes]({{ site.baseurl }}/assets/images/2020/12/screenshot-2020-11-29-at-23.45.34-01.jpeg?w=654)  

_I still haven't found a better terminal type_

<!-- /wp:image -->

<!-- wp:paragraph -->

After finishing the configuration, everything looks as expected.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/e7ca9cd7bc3f53ad6ddc05657b1e1cd7","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/e7ca9cd7bc3f53ad6ddc05657b1e1cd7

<!-- /wp:embed -->

<!-- wp:heading -->

## [Configuring kubectl for Remote Access](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/10-configuring-kubectl.md#configuring-kubectl-for-remote-access)

<!-- /wp:heading -->

<!-- wp:paragraph -->

This section only requires setting the `KUBERNETES_PUBLIC_ADDRESS variable` to my VIP for the kube API endpoint.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## [Provisioning Pod Network Routes](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/11-pod-network-routes.md#provisioning-pod-network-routes)

<!-- /wp:heading -->

<!-- wp:paragraph -->

This part gets a little more complicated. In the tutorial, it relies on the Google Compute Engine's inter-VM networking and routing abilities. However, since all the inter-VM networking for this cluster goes through the FreeBSD `bridge1` interface where `ipfw` is already doing all kinds of heavy-lifting, I can also use `ipfw` to handle the routing for the pod network.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/821348683827777af92fe620b0214660","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/821348683827777af92fe620b0214660

<!-- /wp:embed -->

<!-- wp:heading -->

## [Deploying the DNS Cluster Add-on](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/1.18.6/docs/12-dns-addon.md#deploying-the-dns-cluster-add-on)

<!-- /wp:heading -->

<!-- wp:paragraph -->

In this section, since my IP blocks differ, I had to download and edit the YAML for the DNS deployment.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

At this point I end up massaging my cluster network a bit, changing the cluster network's netmask from /8 to /16 and adding the alias 10.10.0.1 to the `bridge` interface on the FreeBSD hypervisor to put a gateway in the 10.10.0.0/16 VM network as it was no longer in the same CIDR block as the old gateway, 10.0.0.1.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/41116564431dfede790d73ac8f5e6918","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/41116564431dfede790d73ac8f5e6918

<!-- /wp:embed -->

<!-- wp:paragraph -->

Oddly, though, my cluster ended up assigning 10.0.0.1 to the cluster's internal Kubernetes API proxy `Service`, even though that is outside the configured 10.50.0.0/24 `Service` network. I wonder if that happened because 10.50.0.1 was already a routable IP address within the cluster, as I had configured it as the external Kubernetes API endpoint and as a virtual IP on the controllers?

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Either way, I need to move the "public" API endpoint address out of the services block. It's arguably easier to change the service CIDR block for the existing cluster as it's only set as arguments for `kube-apiserver` and `kube-controller-manager`. I will also need to update the `kubernetes.pem` used by `kube-apiserver` to add the new internal service IP address to the list of accepted servernames.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/b4ebaf2858ddf72db7e85a8eabfca34a","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/b4ebaf2858ddf72db7e85a8eabfca34a

<!-- /wp:embed -->

<!-- wp:paragraph -->

I was so focused on getting the updated certificate files copied around and restarting dependent services that I initially forgot to update the `--service-cluster-ip-range `option for` kube-apiserver` and `kube-controller-manager`. I'm not completely sure why the service was initially given the cluster IP 10.0.0.1, which I could have tested by deleting the `kubernetes` Service before making the changes, but I didn't think of it until afterward. Once everything was updated, the service was recreated with the 10.20.0.1 address, as expected.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/171e482ac61688eab1f0687b068e0582","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/171e482ac61688eab1f0687b068e0582

<!-- /wp:embed -->

<!-- wp:heading -->

## [Smoke Test](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/8fd6380bbc92137f8d1cb62f00865f1b3c681d3c/docs/13-smoke-test.md#smoke-test)

<!-- /wp:heading -->

<!-- wp:paragraph -->

Now it's time to smoke test the cluster. The data encryption and deployment tests work fine without modification.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/44adaa6d107def282b0439ed0f495a27","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/44adaa6d107def282b0439ed0f495a27

<!-- /wp:embed -->

<!-- wp:paragraph -->

For the `NodePort` `Service`, I just need to connect directly to the worker IP from the hypervisor, because it has a direct route to the cluster network.

<!-- /wp:paragraph -->

<!-- wp:embed {"url":"https:\/\/gist.github.com\/kbruner\/9861aabae29be2f23bab504385e79200","type":"rich","providerNameSlug":"embed","className":""} -->

https://gist.github.com/kbruner/9861aabae29be2f23bab504385e79200

<!-- /wp:embed -->

<!-- wp:paragraph -->

And that's it!

<!-- /wp:paragraph -->

<!-- wp:separator -->

* * *
<!-- /wp:separator -->

<!-- wp:paragraph -->

This series of posts show one way you can run a Kubernetes cluster on FreeBSD using OS-level virtualization so we can create the traditional, supported Linux environment for Kubernetes. My next post will look at some potential alternatives in various stages of development and support.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Sources / References

<!-- /wp:heading -->

<!-- wp:list -->

- [https://cloudinit.readthedocs.io/en/latest/topics/instancedata.html](https://cloudinit.readthedocs.io/en/latest/topics/instancedata.html)
- [https://github.com/kelseyhightower/kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)
- [https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#replacing-a-failed-etcd-member](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#replacing-a-failed-etcd-member)

<!-- /wp:list -->

