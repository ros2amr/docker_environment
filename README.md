# docker_environment

ROS2 development environment encapsulated in a Docker container.

## Setup

Run the following script to install the Docker runtime and other host-side dependencies:

    sudo ./scripts/docker/install_host.sh

Once it's completed, build the Docker image with:

    ./scripts/docker/build.sh

## Usage

After the Docker image is built, start a container with:

    ./scripts/docker/start.sh

The script creates the container and provides it with several useful privileges, including the ability to access the host's X server (for running GUI applications) and a mapping of the host user's home directory to `/home/user/host`. It also starts a [GNU screen](https://www.gnu.org/software/screen/) session configured to automatically connect shell windows to the container.

The GNU screen session can be controlled through shortcuts of the form `Ctrl+a <key>`, i.e. first type `Ctrl+a`, then release those keys and type `<key>`. See below for a quick reference:

* `Ctrl+a c` - create a window
* `Ctrl+a n` - switch to the next window
* `Ctrl+a p` - switch to the previous window
* `Ctrl+a Esc` - enter [copy/scrollback mode](https://www.gnu.org/software/screen/manual/html_node/Copy.html), allowing to scroll through past outputs; press `q` to exit
* `Ctrl+a :<command>` - execute `<command>` in the host environment, e.g. enter `Ctrl+a :screen bash` to create a window in the host's (as opposed to the container's) context

See the [GNU screen documentation](https://www.gnu.org/software/screen/manual/html_node/index.html) for more information. To close windows, simply enter `exit` to terminate the shell session; when all sessions are closed, the container is automatically stopped.
