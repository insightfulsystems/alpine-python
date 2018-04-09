export IMAGE_NAME?=insightful/alpine-python
export VCS_REF=`git rev-parse --short HEAD`
export VCS_URL=https://github.com/insightfulsystems/alpine-python
export BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
export TAG_DATE=`date -u +"%Y%m%d"`

build:
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):2.7 2.7
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=$(IMAGE_NAME):2.7 \
		-t $(IMAGE_NAME):2.7-onbuild onbuild
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):3.5 3.5
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=$(IMAGE_NAME):3.5 \
		-t $(IMAGE_NAME):3.5-onbuild onbuild
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		-t $(IMAGE_NAME):3.6 3.6
	docker build --build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VCS_URL=$(VCS_URL) \
		--build-arg BASE=$(IMAGE_NAME):3.6 \
		-t $(IMAGE_NAME):3.6-onbuild onbuild
push:
	docker push $(IMAGE_NAME)
