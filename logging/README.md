# Docker Logs w/o Pleats

Build Ubuntu/Debian Docker images with two remote logging options: Filebeat+logstash and rsyslog. 

Example
-------

Compile and run a basic image with python 2.7 and logging:

```sh
_NOPL_BASE_IMAGE="python:2" make
docker run -it --env-file=env.list -v /var/run/docker.sock:/var/run/docker.sock tmpimage
```

Compile and run a Jupyter notebook server with logging:
```sh
make jupyter
./go.jupyter
```

Customize a lab41-specific image and use `docker run` to configure startup and expose the Jupyter 
notebook port 8888 on web port 80:
```sh
_NOPL_BASE_IMAGE=lab41/attalos make
docker run -it -p 80:8888 --env-file=env.list -v /var/run/docker.sock:/var/run/docker.sock lab41/lab41-attalos:nopleats
```

Configuration
-------------

You can configure both how the custom image is built and what happens when containers are
created from the image. You *must* configure logging correctly for the image to be useful;
see *Container Settings*, below.

### Image Build Settings

No Pleats makes a custom Dockerfile and builds and tags the corresponding Docker image, based on the template found at [Dockerfile.template](Dockerfile.template). 
The Dockerfile will extend the image denoted in `_NOPL_BASE_IMAGE`, or using a preset Make recipe (currently only available for Jupyter Notebook server).
The base image should use a recent Ubuntu or Debian distribution.

The environment variables `_NOPL_SETUP_STEPS` and `_NOPL_TEARDOWN_STEPS` can optionally contain Dockerfile directives to add before and after the logging setup is configured in the Dockerfile template.

### Container Settings

Logging is configured using environment variables passed into the container at runtime. By default,
the `go.xyz` script generated during the build process looks for a file called `env.list`. You can use
`env.list.template` to generate your `env.list`. The relevant variables include:

* `_l41_username`: you will be logged in as this user by default
* `_l41_groupname`: the default group of the container user
* `_l41_gid`: GID for container user (try running `id -g`)
* `_l41_uid`: ID for container user (try running `id -u`)

These variables tell Filebeat where to send messages:
* `_l41_logstash_host`: IP/URI of logstash server
* `_l41_logstash_port`: Port to send filebeat JSON messages to logstash on.

These rsyslog-related variables are optional:
* `_l41_rsyslog_host`: IP/URI of rsyslog listener
* `_l41_rsyslog_port`: Port to send rsyslog on
* `_l41_rsyslog_template`: String to add to syslog messages

### Startup customization

The image will log you in as `$_l41_username`. When you are building the custom image,
you can add custom startup configuration to perform as root or as the container user.
To do so, copy executable scripts into super or user to run at startup:

[super](super) - directory for scripts to run as root when the container starts

[user](user) - directory for scripts to run as `_l41_username` when the container starts

#### Naming conventions for startup config

`S##-yourName` - the `##` are 2 digits. Scripts will run in alphanumeric order.
`S00xxxx` will start before `S01aaaa`.

Additional docker-related variables are created at runtime
all docker related environment variables are prefixed with \_docker
and are not exposed to the notebook user by default.

#### Application Logging: Filebeat Log Decoration

The variables `_l41_application_dirspec` and `_l41_make_dir` can be passed into the container to specify 
locations that containerized applications can log to file. Files created in this location will be forwarded
by Filebeat to the logstash server,
and will contain Docker-specific information as configured in [filebeat\_basic.yaml](opt/filebeat_basic.yaml).

`_l41_make_dir` should refer to the root of the path glob given in `_l41_application_dirspec`, so that the 
configuration scripts can make sure it is created.

Build and Run
-------------

`make` - build nopleats-enabled image extending the image denoted by `_NOPL_BASE_IMAGE`

`make [xyz]` - build lab41/xyz:nopleats Docker image (requires xyz recipe to be configured)

`go.xyz` - runs a container of the xyz image with the environment variables set in `env.list` (see `env.list.template`)

