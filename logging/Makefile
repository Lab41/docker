NEW_TAG := tmp
TMP_IMAGE_NAME := tmpimage
all:
	mo/mo Dockerfile.mo.logging > Dockerfile.$(NEW_TAG)
	docker build -t $(TMP_IMAGE_NAME) -f Dockerfile.${NEW_TAG} .
	@echo
	@echo "New image built and tagged $(TMP_IMAGE_NAME)"
	@printf "Invoke with\n\tdocker run -it -v /var/run/docker.sock:/var/run/docker.sock --env-file=[PATH TO env.list] $(TMP_IMAGE_NAME)\n"

jupyter:
	_NOPL_BASE_IMAGE="python:2" \
	_NOPL_SETUP_STEPS="RUN pip install jupyter" \
	mo/mo Dockerfile.mo.logging > Dockerfile.jupyter && \
	docker build -t lab41/jupyter:logging -f Dockerfile.jupyter .
	echo "docker run -it -v /var/run/docker.sock:/var/run/docker.sock --env-file=env.list lab41/jupyter:logging jupyter notebook --ip='*' --no-browser" | tee go.jupyter
	chmod +x go.jupyter
