export IMAGE_NAME?=insightful/alpine-python
export VCS_REF=`git rev-parse --short HEAD`
export VCS_URL=https://github.com/insightfulsystems/alpine-python
export BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
export TAG_DATE=`date -u +"%Y%m%d"`
export ALPINE_VERSION=3.12.3
export BUILD_IMAGE_NAME=local/alpine-base
export TARGET_ARCHITECTURES=amd64 arm32v6 arm32v7
export PYTHON_VERSIONS=2.7 3.8
export QEMU_VERSION=5.1.0-8
export QEMU_ARCHITECTURES=arm aarch64
export SHELL=/bin/bash

# Make sure make ignores the folders (I like short target names, but these collide with the folder structure)
.PHONY: 2.7 3.8 qemu wrap push manifest clean

qemu:
	-docker run --rm --privileged multiarch/qemu-user-static:register --reset
	-mkdir tmp 
	$(foreach ARCH, $(QEMU_ARCHITECTURES), make fetch-qemu-$(ARCH);)
	@echo "==> Done setting up QEMU"

fetch-qemu-%:
	$(eval ARCH := $*)
	@echo "--> Fetching QEMU binary for $(ARCH)"
	cd tmp && \
	curl -L -o qemu-$(ARCH)-static.tar.gz \
		https://github.com/multiarch/qemu-user-static/releases/download/v$(QEMU_VERSION)/qemu-$(ARCH)-static.tar.gz && \
	tar xzf qemu-$(ARCH)-static.tar.gz && \
	cp qemu-$(ARCH)-static ../qemu/
	@echo "--> Done."

wrap:
	@echo "==> Building local base containers"
	$(foreach ARCH, $(TARGET_ARCHITECTURES), make wrap-$(ARCH);)
	@echo "==> Done."

wrap-amd64:
	docker pull amd64/$(BASE_IMAGE):$(ALPINE_VERSION)
	docker tag amd64/$(BASE_IMAGE):$(ALPINE_VERSION) $(BUILD_IMAGE):amd64

wrap-translate-%:
	@if [[ "$*" == "arm64v8" ]] ; then \
	   echo "aarch64"; \
	else \
		echo "arm"; \
	fi

wrap-%:
	$(eval ARCH := $*)
	@echo "--> Building local base container for $(ARCH)"
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=$(shell make -s wrap-translate-$(ARCH)) \
		--build-arg BASE=$(ARCH)/$(BASE_IMAGE):$(ALPINE_VERSION) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(BUILD_IMAGE):$(ARCH) qemu | sed -e 's/^/local $(ARCH): /;'
	@echo "--> Done building local base container for $(ARCH)"

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

3.8:
	$(foreach var, $(TARGET_ARCHITECTURES), make 3.8-$(var);)

3.8-%: # This assumes we have a folder for each major version
	$(eval ARCH := $*)
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg BASE=$(BUILD_IMAGE_NAME):$(ARCH) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):3.8-$(ARCH) 3.8
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg ARCH=$(ARCH) \
		--build-arg BASE=$(IMAGE_NAME):3.8-$(ARCH) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):3.8-onbuild-$(ARCH) onbuild
	echo "\n---\nDone building $(ARCH)\n---\n"

push:
	docker push $(IMAGE_NAME)

expand-%: # expand architecture variants for manifest
	@if [ "$*" == "amd64" ] ; then \
	   echo '--arch $*'; \
	elif [[ "$*" == *"arm"* ]] ; then \
	   echo '--arch arm --variant $*' | cut -c 1-21,27-; \
	fi


manifest:
	docker manifest create --amend \
		$(IMAGE_NAME):latest \
		$(foreach arch, $(TARGET_ARCHITECTURES), $(IMAGE_NAME):3.8-$(arch))
	$(foreach arch, $(TARGET_ARCHITECTURES), \
		docker manifest annotate \
			$(IMAGE_NAME):latest \
			$(IMAGE_NAME):3.8-$(arch) $(shell make expand-$(arch));)
	docker manifest push $(IMAGE_NAME):latest
	docker manifest create --amend \
		$(IMAGE_NAME):onbuild \
		$(foreach arch, $(TARGET_ARCHITECTURES), $(IMAGE_NAME):3.8-onbuild-$(arch) )
	$(foreach arch, $(TARGET_ARCHITECTURES), \
		docker manifest annotate \
			$(IMAGE_NAME):onbuild \
			$(IMAGE_NAME):3.8-onbuild-$(arch) $(shell make expand-$(arch));)
	docker manifest push $(IMAGE_NAME):onbuild


clean:
	-docker rm -fv $$(docker ps -a -q -f status=exited)
	-docker rmi -f $$(docker images -q -f dangling=true)
	-docker rmi -f $(BUILD_IMAGE_NAME)
	-docker rmi -f $$(docker images --format '{{.Repository}}:{{.Tag}}' | grep $(IMAGE_NAME))

