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

# Connect to a running container.
#
# Author: Helio Perroni Filho

SCRIPT_PATH=$(readlink -f "$0")
export SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

# Load script settings.
source "$SCRIPT_DIR/settings.sh"

NAME=${IMAGE//[:\/]/_}

export DOCKER_CONTAINER_NAME=$NAME

echo "Connecting to container..."

if ! screen -ls $NAME > /dev/null
then
  screen -S $NAME -R -U -c "$SCRIPT_DIR/screenrc" docker exec -it $NAME /bin/bash
else
  screen -r $NAME -U -c "$SCRIPT_DIR/screenrc"
fi

if ! screen -ls $NAME > /dev/null
then
  echo "Stopping container..."
  docker stop $NAME
fi
