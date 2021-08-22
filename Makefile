IMAGE=klakegg/hugo:0.85.0-ext-debian
POST_INDEX=$$(ls src/content/posts | wc -l | awk '{print $1}' | xargs)
POST_FILE=${POST_INDEX}-${POST}

site:
	docker run --rm -it -v `pwd`:/src ${IMAGE} new site src

build:
	docker run --rm -it -v `pwd`/src:/src ${IMAGE}

post:
	docker run --rm -it -v `pwd`/src:/src ${IMAGE} new posts/${POST_FILE}

server:
	docker run --rm -it -p 1313:1313 -v `pwd`/src:/src ${IMAGE} server -D
