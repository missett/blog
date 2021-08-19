IMAGE=klakegg/hugo:0.85.0-ext-debian
SITE=missett.github.io
POST_INDEX=$$(ls content/post | wc -l | awk '{print $1}' | xargs)
POST_FILE=${POST_INDEX}-${POST}

build:
	docker run --rm -it -v `pwd`:/src ${IMAGE}

post:
	docker run --rm -it -v `pwd`:/src ${IMAGE} new post/${POST_FILE}

server:
	docker run --rm -it -p 1313:1313 -v `pwd`:/src ${IMAGE} server -D
