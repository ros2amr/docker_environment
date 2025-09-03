#!/bin/bash

# Copyright (C) 2025 Helio Perroni Filho (xperroni@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Start the container with useful privileges.
#
# Author: Helio Perroni Filho

SCRIPT_PATH=$(readlink -f "$0")
export SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

# Load script settings.
source "$SCRIPT_DIR/settings.sh"

NAME=${IMAGE//[:\/]/_}

# Create the PulseAudio socket to enable audio access from the Docker container.
pactl load-module module-native-protocol-unix socket=/tmp/pulseaudio.socket 2> /dev/null

if [[ "$(docker ps -aq -f name=$NAME -f status=exited)" ]]
then
  echo "Restarting container..."
  docker restart $NAME
elif [[ "$(docker ps -aq -f name=$NAME)" == "" ]]
then
  echo "Starting container..."
  docker run -id \
    -e DISPLAY \
    --net=host \
    --privileged \
    --cap-add=ALL \
    --env PULSE_SERVER=unix:/tmp/pulseaudio.socket \
    --env PULSE_COOKIE=/tmp/pulseaudio.cookie \
    --volume="$HOME:/home/user/host" \
    --volume="$HOME/.ssh:/home/user/.ssh" \
    --volume="$SCRIPT_DIR/../../../..:/home/user/ROS2AMR" \
    --volume="/dev:/dev" \
    --volume="/lib/modules:/lib/modules" \
    --volume="/run/user:/run/user" \
    --volume="/var/run/dbus:/var/run/dbus" \
    --volume="/tmp/pulseaudio.socket:/tmp/pulseaudio.socket" \
    --volume="$SCRIPT_DIR/pulseaudio.client.conf:/etc/pulse/client.conf" \
    --name="$NAME" \
    $IMAGE
fi

bash "$SCRIPT_DIR/connect.sh"
