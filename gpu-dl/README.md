# Build Lab41 deep learning images

If you want to use theano on a GPU-equipped machine there is a usable solution now:
- ssh to the machine
- `git clone https://github.com/pcallier/docker`
- `cd docker/gpu-dl`
- Edit [config.list](config.list) and change the port number (and possibly the GPU number). Almost any number above 500 is fair game, it seems. GPU will always be mapped to GPU 0 in container.
- `./configure`
- `make theano-notebook`
- Point a browser to [machine URI]:[PORT NUMBER]. Install whatever you might need; you are in a docker container.
