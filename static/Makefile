IMAGE=klakegg/hugo:0.85.0-ext-debian
BASE_URL=https://d3cvuhrgx7tzue.cloudfront.net/
POST_INDEX=$$(ls src/content/post | wc -l | awk '{print $1}' | xargs)
POST_FILE=${POST_INDEX}-${POST}.md

# abuse make pattern rules feature to stop the command being executed for each target file (one invocation generates both)
src/go%sum src/go%mod:
	docker run --rm -it -v `pwd`/src:/src klakegg/hugo:0.85.0-ext-debian mod init my-site

site:
	docker run --rm -it -v `pwd`:/src ${IMAGE} new site src

build: src/go.mod src/go.sum
	docker run --rm -it -v `pwd`/src:/src ${IMAGE} --gc --minify --baseURL ${BASE_URL}

post:
	docker run --rm -it -v `pwd`/src:/src ${IMAGE} new post/${POST_FILE}

server:
	docker run --rm -it -p 1313:1313 -v `pwd`/src:/src ${IMAGE} server -D
