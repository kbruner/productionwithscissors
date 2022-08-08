---
layout: post
title: Shared Irresponsibility Model
date: 2020-02-25 04:33:35.000000000 -08:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Running With Scissors
tags:
- cloud security
meta:
  _edit_last: '108235749'
  timeline_notification: '1582605218'
  _publicize_job_id: '41083009268'
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2020/02/25/shared-irresponsibility-model/"
excerpt: Security is hard when cloud providers give you keys but no locks
---

_Security is hard when cloud providers give you keys but no locks_

In the Grimm brothers' fairy tale "The Mouse, the Bird, and the Sausage," the titular characters (including, yes, an anthropomorphic sausage, because why not) all live together happily. Each has their own specific household task: the bird gathers wood in the forest, the mouse brings in water, and cooking falls to the sausage, because why not. Apparently the trio have no utensils, so the sausage rolls around in the pot to stir the cooking food, because why not.

One day, some neighborhood frenemy birds shame the bird into going home and going on strike until they switch the jobs around. The bird ends up in charge of water, the mouse does the cooking, and the sausage has to go collect wood, because why not.

The very next day, the sausage fails to return with firewood, and the bird goes out to the forest to search. The bird meets a dog and asks after the sausage. The dog, who in reality, saw the sausage, said "Sausage!" and then ate the sausage, says the sausage was carrying forged letters, because why not, so the dog was forced to execute the sausage. The bird can't argue with that, shrugs, and goes home to tell the mouse.

While the bird goes to collect firewood, the mouse tries to cook for the first time, rolling around in pot to stir, and burns to death. The bird returns home, and not knowing what had happened to the mouse, panics and drops the wood. The house catches fire, so the bird runs to the well to get water, falls in, and with no roommates to help, drowns.

The end.

Cloud providers like Amazon Web Services and Google Cloud operate under a shared responsibility model for security. The provider takes responsibility for the security of their infrastructure and software, leaving their customers to take responsibility for running secure applications and using the provider's controls for locking down their piece of the virtual environment.

Sure, that sounds fair. Except why have leaky S3 buckets in AWS been exposing sensitive data on a regular basis for years now?

My take:

* S3 has been around forever (since 2006). It was the first cloud service that Amazon launched and it's still one of the most popular. That, along with [AWS's market share, which is almost equal to all other cloud providers combined,](https://www.forbes.com/sites/jeanbaptiste/2019/08/02/amazon-owns-nearly-half-of-the-public-cloud-infrastructure-market-worth-over-32-billion-report/) means there are a crapload of S3 buckets out there.
* An early popular use of S3 buckets was to create static websites. This meant that content had to be publicly available. As a side effect, every bucket automatically gets a public DNS entry. Savvy users will at least use obfuscated names, but most people end up defaulting to human- (and hacker-) readable names like `big-corporation-customer-database`.
* The overlapping options for setting bucket access control create confusion. Users can choose between using IAM, the AWS Identity and Authentication Management service, which is the standard method for defining access control for all AWS services. But they can also use bucket policies, which bypass AWS IAM, and per-object ACLs. And all the methods have a learning curve.
* Until just a few years ago, AWS accounts had a hard [limit of 100 S3 buckets](https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html). While that may sound like a lot, especially these days when large companies often have 100 different AWS **accounts** , which is also a recent phenomenon, companies with a large number of diverse teams and applications often hit that limit hard. This situation resulted in "sharing" buckets for multiple applications, meaning the data in these buckets may have ended up needing different access requirements. So, you open up the bucket and then rely on those annoying object ACLs and hope everyone who writes to the bucket puts the correct permissions on the object.
* AWS, and this is something all major cloud providers are guilty of, at least to some extent, defaults to creating resources for customers with no security controls. You are responsible for locking that shit down, whether it's your S3 bucket, your VPC network firewall, or whatever else. They want you to use their products, so they make it easy to get started, because (almost) no one wants to figure out how to enable access for a locked-down service before they can start running their insecure application in the cloud.
* I can't even tell you how often I've seen people, faced with trying to make sure that all the pieces they need to connect their application together, struggle with [the principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege) and managing fine-grained access. When they finally hit their frustration level and just want everything to work, all too often they just remove all the protections.
* A lot of people seem to assume that AWS magically secures their buffer overflowing, cross-site scripting, plain-text authenticating application.
* And last, but not least, most people just don't want to Read the Fucking Manual.

Most of this is actually AWS' fault.

* Like I mentioned above, most user get resources get created with wide-open access. They don't want to scare away potential customers by making learning about modifying the security a prerequisite for paying AWS lots of money.
* As I also mentioned, the controls are very often confusing.
* It is too damned easy to get everything set up just right, just to have a careless or clueless person with admin privileges blow away all the protections. (In my experience, the people who do that tend very often to be upper management.)
* AWS pretends like they are providing additional tools and controls to prevent leaky bucket issues, but they come across as disingenuous. The S3 UI now does force users to set some kind of bucket security, or explicitly opt out, during bucket creation. Great, except that's not how all buckets get created, and again, there's that thing about blowing away the best protections later. Oh, and you can also scan your infrastructure for open buckets, but people have to pay attention to those alerts.

One control that could genuinely help many customers do a better job of keeping private S3 contents private would be the ability to make a bucket **permanently** private, limiting access only to authorized IAM users. Yes, some customers will still set everything to public, in case they want to mix private and public data, and some older buckets with little active oversight will still be honeypots for data miners. But a lot of S3 customers would value the peace of mind knowing that they can create buckets without the risk of having the contents exposed to the Internet, no matter what C-level execs that still have full admin on the account do to it.

Maybe it sounds like I'm picking on AWS (which I am), but all the major cloud providers (probably all cloud providers) exhibit the same behaviors, at least to some degree. [AWS' own page on their shared responsibility model](https://aws.amazon.com/compliance/shared-responsibility-model/) for security lays out what they handle and, with a lot more verbiage, what the customer needs to do. But the areas of responsibility which fall to AWS have one incredibly important omission: they do not take responsibility for supplying their customers with all the controls needed to secure their cloud usage.

In some cases, AWS does offer adequate controls. Their move from EC2 instances that just shared the same network space with each other regardless of customer to Virtual Private Clouds for customers added a lot of new protections and tools for users to secure their EC2 instances. Well, it does when the customers actually use them. But particularly in the case of their managed offerings of open-source software, AWS frequently disallows certain standard protections to ease their own management of the service. A few examples:

* For years, the AWS Elasticache for Redis service disabled the option for password-protection of the Redis endpoint, which was an option for open-source Redis. ([AWS only added it this past October.](https://aws.amazon.com/about-aws/whats-new/2019/10/amazon-elasticache-announces-support-for-modifying-redis-authentication-tokens/))
* EFS (Elastic File System, an NFS (Network File System, or my name for it, Nasty Fucking Shit)) implementation, didn't support [root squashing](https://recipeforroot.com/attacking-nfs-shares/), which maps client users with UID 0, aka the root user, to an unprivileged, anonymous UID. Users can enable it on the client EC2 instance mounting the volume, but that's not an adequate protection, particularly if the instance gets compromised. [AWS did actually add a way to simulate root squashing](https://aws.amazon.com/blogs/aws/new-for-amazon-efs-iam-authorization-and-access-points/) just last month (January 2020), but it requires a fair amount of IAM configuration, because why not. But for years, users were just out of luck.
* Amazon's managed Kubernetes service, EKS... I can't even begin to enumerate the ways this platform is a security nightmare. Well, the pending content I've written for my employer's website is the main reason I can't tell you. I will give you a teaser, though: the AWS IAM user or role who creates the cluster has **permanent** authentication access to the cluster's Kubernetes API service, and by default has full cluster admin access in the default Kubernetes RBAC configuration. ([The official EKS docs](https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html#unauthorized) somehow omit that "permanent" bit.)

So, there you go. I bashed on AWS a lot, but at least in part, that's because I just have the most experience with it and its... um, quirks. Google Cloud has its own issues, trust me, not the least of which is the lack of any granularity to their IAM permission sets. And I've mostly been able to give Azure a wide berth, but in AKS, the only service I've spent any time with, they install [the notorious Kubernetes dashboard](https://arstechnica.com/information-technology/2018/02/tesla-cloud-resources-are-hacked-to-run-cryptocurrency-mining-malware/) in every cluster, with zero authentication required within the cluster, and with no way to opt out. I'm more than willing to bet this highly question "feature" represents the tip of a Titanic-sized iceberg.

So what can customers do? Complain. Shop around. Do careful research about services and their security options before using them. Don't settle.

And please, for the love of all that is holy, if you somehow have any of my personal data, don't use EKS.

