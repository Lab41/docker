NEW_TAG=tmp
NEW_IMAGE=tmpimage
all:
	mo/mo Dockerfile.mo.sacred > Dockerfile.$(NEW_TAG)
	docker build -t $(NEW_IMAGE):sacred -f Dockerfile.$(NEW_TAG) .
	echo "Built image and tagged it ${NEW_IMAGE}:sacred"
	rm Dockerfile.$(NEW_TAG)
