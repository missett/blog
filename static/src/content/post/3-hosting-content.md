---
title: "Hosting Content"
date: 2022-01-28T10:59:38Z
draft: true
---

In the last post we talked about how to get a static site generator to turn markdown content into HTML pages for us, and we created a nice makefile to help us perform basic tasks with the content. One of those tasks was `make site` whic h builds the site locally and starts a server on `localhost:1313` for us to view the rendered content in a browser.

Rendering the content locally and having a server on our local laptop isn't much use for showing our blog to other people, so let's talk about serving this content up somewhere on the internet for the world to see.

There are a thousand ways to host a site that's as simple as the site we've created (after all, we really just have a directory full of HTML files). You could get a raspberry pi and install nginx, buy a static IP from your ISP and point a DNS entry to it. You could use a service like Netlify which offers free static site hosting (plus I think they have some solid dynamic features that I haven't tried out). In fact in the [git repo for this project](https://github.com/missett/blog) you can even spot a netlify.yaml file in the project root that configures deployments onto a Netlify account that I briefly experimented with. We could also try something a little more involved for the sake of learning something new...

One of the goals of this project that I mentioned in the intro post was that I wanted to learn about AWS for the purposes of a new job (and potentially many more jobs, since basically every Ops related tech role now seems to want experience with at least one cloud provider). It's not something I've ever really used before, and it's slightly mind boggling when I look at the list of features and services they provide, but I finally got around to buying myself a years subscription to [acloud.guru](https://acloud.guru) and doing a little bit of learning on the subject. 

_NB. A Cloud Guru aren't paying me to mention them (you really think this blog gets enough traffic for that?!) but after trying them out for a few weeks their product seems genuinely very cool and informative. It's not cheap, but when you look at the knowledge on offer and the potential benefits to your career it starts to seem more reasonable._

## Infrastructure as Code
After spending time as a DevOps for a large org I'm obsessed with the idea of infrastructure as code (IaC). This means that not only does your application code exist in a git repo, the infrastructure that runs your code exists in a repo. You can read more about the concept [here](https://www.redhat.com/en/topics/automation/what-is-infrastructure-as-code-iac). Briefly though, I favour Terraform for IaC, and since that's what I have the most experience with, I'll be provisioning my AWS infrastructure through Terraform.

## S3 Hosting

