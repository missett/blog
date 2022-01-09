---
title: "Content Management"
date: 2022-01-08T16:31:05Z
draft: false
---

I'm a big believer in simplicity. This doesn't necessarily mean that the quickest way to do something is the best though. In my opinion, the best way to do something is usually the way that involves the fewest moving parts. Fewer moving parts means there are fewer things that can go wrong. 

Let's think about what this project actually wants to do- I just want to be able to publish text, maybe accompanied by images, potentially with some links in the text. It would be nice if each text document that I published had a consistent look. I want the text to be viewed in a web browser, obviously, but with the potential to provide the content in some other format (RSS isn't dead, yet). I don't particularly want to write HTML by hand, because that's incredibly tedious and error prone. 

If my incredibly obvious, _and reverse engineered_, requirements haven't given the game away yet, I'm trying to drive this particular article down the 'static site generator' path.

## Static Site Generators
Static site generators have been around a long time at this point. The concept is fairly simple- for a given class of website, the pages served up are all 'static'. That is, the site viewed by one visitor is exactly the same as the site as viewed by another. There's no facility to 'log in', there's no 'suggested content' based on previously viewed content, and so on. This means that the technology used to serve the site can be really simple, we can just have a server that responds to HTTP GET requests with an HTML document. It doesn't need to create the document on the fly by retrieving information from a database. That's about as simple as things can get.

There are dozens, maybe hundreds of static site generators available to use for free at this point. Just see this article on [Netlify](https://www.netlify.com/blog/2021/06/02/10-static-site-generators-to-watch-in-2021/). They all offer different feature sets, so it's worth reading up on the differences. For this project my requirements are extremely simple. I want to be able to write documents using Markdown, run a process on the directory containing my documents, and have it output a build folder containing generated HTML and all the other required assets. Based on my reading Hugo seems to be the perfect choice for this. You edit a config file to set basic information about your site- name, domain, chosen theme etc. and run Hugo on the directory. Hugo will then output a build directory that you can deploy somewhere. 

## Hugo
Let's get started on making a repo that lets us work with Hugo effectively. You can find all the code [here](https://github.com/missett/blog/tree/ab08001b887d9399918d5a7ee0cd49f3720c21b7/static) on Github. 

First thing's first- I don't like to drop random binary files on my PATH if I can avoid it, since I generally forget how they got there or if there were any special instructions to install it etc. Where possible I prefer to use things inside Docker containers, so that I can simply destroy the container once I'm finished. If I then delete the image then there should be no trace of it left on my system. This is great for quickly trying things out and keeping your laptop crud free. Luckily there are images available that contain the Hugo binary for us already.

### Creating An Empty Site
Hugo has a command to generate a new site for us, which we can simply tag onto the end of the docker command-
```
docker run --rm -it -v `pwd`:/src klakegg/hugo:0.85.0-ext-debian new site src
```

Now we'll need to do some basic config of the site. The config file can be found [here](https://github.com/missett/blog/blob/ab08001b887d9399918d5a7ee0cd49f3720c21b7/static/src/config.toml). Crucially we set the title, some personal details for links to external content (twitter and the like), and we also choose a theme. The theme means that all our content will look the same from page to page, without us having to do anything.

Hugo has added a new theme system in a recent version. Instead of downloading the entire theme into your repo and committing it into source, we can give the config file a link to a git repo containing a Go module that implements a Hugo theme. This is brilliant since it helps us keep our own repo nice and slim. 

NB. It's worth noting that this version of the Makefile does not include an important step when first creating the site. After we have run the above 'new site' command we need to run `docker run --rm -it -v `pwd`/src:/src klakegg/hugo:0.85.0-ext-debian mod init <site name>` in order to initialize our repo as a module, so that we can then use other modules, like our theme. If you run that command and then run a build, you'll end up with a go.mod and a go.sum file in your src folder. These should be committed into source control so that your builds always pull down the same versions of the theme (and any other modules you use). In a future version of the Makefile I'll automate this step.

### Viewing Our Site
Let's tell Hugo to render our site locally for us so we can see what it looks like-
```
docker run --rm -it -p 1313:1313 -v `pwd`/src:/src klakegg/hugo:0.85.0-ext-debian server -D
```
This command will not exit immediately. If you view the output of the console you'll see that Hugo has started serving on localhost:1313. If you view localhost:1313 in your browser, you'll see that our new empty site is now displayed in the browser for us! This is a local rendering mode that's perfect when you're writing content and want to see what it looks like rendered as HTML. You don't have to actually publish the content to try it, you simply use this command to see it locally.

### Building Our Site For Publication
What about when we want some content ready to be uploaded to a remote server ready for the world to view? 
```
docker run --rm -it -v `pwd`/src:/src klakegg/hugo:0.85.0-ext-debian
```
Simple enough. We'll end up with a directory called 'public' that contains all our HTML and other assorted asset types ready for the entire thing to be sent to a server somewhere for publication.

## Usability
The DevOp (and common sense) in me says that all these Docker commands will be a nightmare to remember. Because of this I've prepped a Makefile (make is great, if you don't already use it) that effectively aliases these commands to more useful names, along with a few other usability improvements. You can take a look at the Makefile [here](https://github.com/missett/blog/blob/ab08001b887d9399918d5a7ee0cd49f3720c21b7/static/Makefile).

Generate a new site-
```
make site
```

Build the content-
```
make build
```

Start the local dev server-
```
make server
```

Start writing a new post-
```
POST=hello-world make post
```

That last command is probably the one that's most useful. It will create a new markdown file in the correct place in our repo, with the correct file name, prepending an integer index to the file name since I want my directory to be organised in order of the date I started writing the content. The command shown above would create a new post with the title hello-world.

Well, that about covers an introduction into Hugo for now. It's not super complicated, but hopefully the use of Docker and a Makefile makes someones life easier. We now have a really simple way to manage content on our site. In the next post I think we'll be talking about how to get the content hosted somewhere (no guarantees though).
