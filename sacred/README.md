Add IDSIA/Sacred to an Existing Debian/Ubuntu Image
==================================================

This repository will allow you to add Sacred to any Debian-based Docker image,
provided it already has python and pip installed. The base image is indicated
by the variable `_SACRED_BASE_IMAGE`. The resulting image will be tagged
`tmpimage:sacred`.

The following will, for instance, extend the image `lab41/pythia:latest` and create an image
`lab41/pythia:sacred`

```sh
_SACRED_BASE_IMAGE=lab41/pythia make
docker tag tmpimage:sacred lab41/pythia:sacred
```

Since the base image happens to have Jupyter installed, you can then start up a notebook server on port 80 with:

```sh
docker run -it --rm --name=sacred-nb -p 80:8888 lab41/pythia:sacred sh -c 'jupyter notebook --ip=0.0.0.0 --no-browser'
```

Dependencies
------------

Sacred needs a MongoDB server to store observations in, so have one of those around. Your use of sacred 
will need to include how to configure this observer, so check the Sacred docs.
