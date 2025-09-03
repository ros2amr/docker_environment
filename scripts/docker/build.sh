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

# Build a Docker image containing the software stack build and runtime
# dependencies.
#
# Author: Helio Perroni Filho

SCRIPT_PATH=$(readlink -f "$0")
export SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

# Load script settings.
source "$SCRIPT_DIR/settings.sh"

cd "$SCRIPT_DIR/build"
docker build \
  --build-arg uid="$(id -u)" \
  --build-arg gid="$(id -g)" \
  --build-arg TZ="$(timedatectl | perl -ne 'print $1 if /Time zone: ([^ ]+)[^\\r\\n]*/' 2>/dev/null)" \
  -t $IMAGE .
