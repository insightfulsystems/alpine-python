export IMAGE_NAME?=insightful/alpine-python
export VCS_REF=`git rev-parse --short HEAD`
export VCS_URL=https://github.com/insightfulsystems/alpine-python
export BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
export TAG_DATE=`date -u +"%Y%m%d"`
export ALPINE_VERSION=alpine:3.9

# Make sure make ignores the folders (I like short target names, but these collide with the folder structure)
.PHONY: 2.7 3.6

deps:
	-docker run --rm --privileged multiarch/qemu-user-static:register
	-mkdir tmp 
	cd tmp && \
	curl -L -o qemu-arm-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/v3.0.0/qemu-arm-static.tar.gz && \
	tar xzf qemu-arm-static.tar.gz && \
	cp qemu-arm-static ../qemu/
	make qemu-arm32v6
	make qemu-arm32v7

qemu-arm32v6:
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=arm32v6 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=arm32v6/$(ALPINE_VERSION) \
		-t qemu-arm32v6 qemu

qemu-arm32v7:
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=arm32v7 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=arm32v7/$(ALPINE_VERSION) \
		-t qemu-arm32v7 qemu

2.7:
	make 2.7-amd64
	make 2.7-arm32v6
	make 2.7-arm32v7

2.7-amd64:
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BASE=$(ALPINE_VERSION) \
		--build-arg ARCH=amd64 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):2.7-amd64 2.7
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=amd64 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=$(IMAGE_NAME):2.7-amd64 \
		-t $(IMAGE_NAME):2.7-onbuild-amd64 onbuild

2.7-arm32v6:
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BASE=qemu-arm32v6 \
		--build-arg ARCH=arm32v6 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):2.7-arm32v6 2.7
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=arm32v6 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=$(IMAGE_NAME):2.7-arm32v6 \
		-t $(IMAGE_NAME):2.7-onbuild-arm32v6 onbuild

2.7-arm32v7:
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BASE=qemu-arm32v7 \
		--build-arg ARCH=arm32v7 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):2.7-arm32v7 2.7
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=arm32v7 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=$(IMAGE_NAME):2.7-arm32v7 \
		-t $(IMAGE_NAME):2.7-onbuild-arm32v7 onbuild

3.6:
	make 3.6-amd64
	make 3.6-arm32v6
	make 3.6-arm32v7

3.6-amd64:
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BASE=$(ALPINE_VERSION) \
		--build-arg ARCH=amd64 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):3.6-amd64 3.6
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=amd64 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=$(IMAGE_NAME):3.6-amd64 \
		-t $(IMAGE_NAME):3.6-onbuild-amd64 onbuild

3.6-arm32v6:
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BASE=qemu-arm32v6 \
		--build-arg ARCH=arm32v6 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):3.6-arm32v6 3.6
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=arm32v6 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=$(IMAGE_NAME):3.6-arm32v6 \
		-t $(IMAGE_NAME):3.6-onbuild-arm32v6 onbuild

3.6-arm32v7:
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BASE=qemu-arm32v7 \
		--build-arg ARCH=arm32v7 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):3.6-arm32v7 3.6
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=arm32v7 \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=$(IMAGE_NAME):3.6-arm32v7 \
		-t $(IMAGE_NAME):3.6-onbuild-arm32v7 onbuild

manifest:
	docker manifest create --amend \
		$(IMAGE_NAME):latest \
		$(IMAGE_NAME):3.6-amd64 \
		$(IMAGE_NAME):3.6-arm32v6 \
		$(IMAGE_NAME):3.6-arm32v7
	docker manifest push $(IMAGE_NAME):latest
	docker manifest create --amend \
		$(IMAGE_NAME):onbuild \
		$(IMAGE_NAME):3.6-onbuild-amd64 \
		$(IMAGE_NAME):3.6-onbuild-arm32v6 \
		$(IMAGE_NAME):3.6-onbuild-arm32v7
	docker manifest push $(IMAGE_NAME):onbuild

push:
	docker push $(IMAGE_NAME)


clean:
	-docker rm -fv $$(docker ps -a -q -f status=exited)
	-docker rmi -f $$(docker images -q -f dangling=true)
	-docker rmi -f qemu-arm32v6
	-docker rmi -f qemu-arm32v7
	-docker rmi -f $$(docker images --format '{{.Repository}}:{{.Tag}}' | grep $(IMAGE_NAME))

