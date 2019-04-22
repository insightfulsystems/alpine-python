export IMAGE_NAME?=insightful/alpine-python
export VCS_REF=`git rev-parse --short HEAD`
export VCS_URL=https://github.com/insightfulsystems/alpine-python
export BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
export TAG_DATE=`date -u +"%Y%m%d"`
export ALPINE_VERSION=alpine:3.9
export BUILD_IMAGE_NAME=local/alpine-base
export TARGET_ARCHITECTURES=amd64 arm32v6 arm32v7
export PYTHON_VERSIONS=2.7 3.6

# Make sure make ignores the folders (I like short target names, but these collide with the folder structure)
.PHONY: 2.7 3.6 qemu wrap push manifest clean

qemu:
	-docker run --rm --privileged multiarch/qemu-user-static:register
	-mkdir tmp 
	cd tmp && \
	curl -L -o qemu-arm-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/v3.0.0/qemu-arm-static.tar.gz && \
	tar xzf qemu-arm-static.tar.gz && \
	cp qemu-arm-static ../qemu/

wrap:
	$(foreach arch, $(TARGET_ARCHITECTURES), make wrap-$(arch);)

wrap-amd64:
	docker pull amd64/$(ALPINE_VERSION)
	docker tag amd64/$(ALPINE_VERSION) $(BUILD_IMAGE_NAME):amd64

wrap-%:
	$(eval ARCH := $*)
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg BASE=$(ARCH)/$(ALPINE_VERSION) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(BUILD_IMAGE_NAME):$(ARCH) qemu

2.7:
	$(foreach var, $(TARGET_ARCHITECTURES), make 2.7-$(var);)

2.7-%: # This assumes we have a folder for each major version
	$(eval ARCH := $*)
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg BASE=$(BUILD_IMAGE_NAME):$(ARCH) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):2.7-$(ARCH) 2.7
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg BASE=$(IMAGE_NAME):2.7-$(ARCH) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):2.7-onbuild-$(ARCH) onbuild
	echo "\n---\nDone building $(ARCH)\n---\n"

3.6:
	$(foreach var, $(TARGET_ARCHITECTURES), make 3.6-$(var);)

3.6-%: # This assumes we have a folder for each major version
	$(eval ARCH := $*)
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg BASE=$(BUILD_IMAGE_NAME):$(ARCH) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):3.6-$(ARCH) 3.6
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg BASE=$(IMAGE_NAME):3.6-$(ARCH) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):3.6-onbuild-$(ARCH) onbuild
	echo "\n---\nDone building $(ARCH)\n---\n"

push:
	docker push $(IMAGE_NAME)

manifest:
	docker manifest create \
		$(IMAGE_NAME):latest \
		$(foreach arch, $(TARGET_ARCHITECTURES), $(IMAGE_NAME):3.6-$(arch) )
	docker manifest push $(IMAGE_NAME):latest
	docker manifest create \
		$(IMAGE_NAME):onbuild \
		$(foreach arch, $(TARGET_ARCHITECTURES), $(IMAGE_NAME):3.6-onbuild-$(arch) )
	docker manifest push $(IMAGE_NAME):onbuild


clean:
	-docker rm -fv $$(docker ps -a -q -f status=exited)
	-docker rmi -f $$(docker images -q -f dangling=true)
	-docker rmi -f $(BUILD_IMAGE_NAME)
	-docker rmi -f $$(docker images --format '{{.Repository}}:{{.Tag}}' | grep $(IMAGE_NAME))

