# simple makefile to build and push docker container images
IMAGE_NAME = sebastianhutter/podcaster

# if the go label is set overwrite the commit id env variable
ifneq ($(GO_PIPELINE_LABEL),"")
ifneq ($(COMMIT_ID),"")
export COMMIT_ID := $(GO_PIPELINE_LABEL)
endif
endif

# build
# build a new docker image
build_commit:
	docker build -t $(IMAGE_NAME):$(COMMIT_ID) .
	echo $(COMMIT_ID) > image_version
	echo $(IMAGE_NAME) > image_name


# latest
# set the latest tag for the image with the specified nextcloud version tag
build_latest:
	docker build -t $(IMAGE_NAME):latest .

# push the commit tag
push_commit:
	docker push $(IMAGE_NAME):$(COMMIT_ID)

# push the build containers
push_latest:
	docker push $(IMAGE_NAME):latest

# deploy commit id image to rancher
deploy_commit:
	rancher_upgrade.sh $(SERVICE_NAME) $(IMAGE_NAME) $(COMMIT_ID)