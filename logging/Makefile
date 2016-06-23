	NEW_TAG = tmp
all:
	mo/mo Dockerfile.mo.logging > Dockerfile.$(NEW_TAG)
	IMAGE_HASH=$(docker build -t $(NEW_TAG):logging -f Dockerfile.$(NEW_TAG) .)  \
	echo "docker run -it -v /var/run/docker.sock:/var/run/docker.sock --env-file=env.list $(IMAGE_HASH)" | tee go.$(IMAGE_HASH)
	chmod +x go.$(IMAGE_HASH)

jupyter:
	_NOPL_BASE_IMAGE="python:2" \
	_NOPL_SETUP_STEPS="RUN pip install jupyter" \
	mo/mo Dockerfile.mo.logging > Dockerfile.jupyter && \
	docker build -t lab41/jupyter:logging -f Dockerfile.jupyter .
	echo "docker run -it -v /var/run/docker.sock:/var/run/docker.sock --env-file=env.list lab41/jupyter:logging jupyter notebook --ip='*' --no-browser" | tee go.jupyter
	chmod +x go.jupyter
