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

# Build script for Docker image.
#
# Author: Helio Perroni Filho

# Base image for the OS, update as convenient.
FROM ubuntu:24.04

USER root
WORKDIR /
SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Build settings.
ARG uid
ARG gid
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ
ENV TZ=$TZ

# Update the package index and upgrade existing packages.
RUN apt update && apt upgrade -y

# Install basic utilities.
RUN apt install -y \
  curl \
  locales \
  nano \
  software-properties-common \
  sudo \
  wget

# Ensure that the Ubuntu Universe repository is enabled.
RUN add-apt-repository universe

# Set up the system locale.
RUN update-locale LC_ALL=C.UTF-8 LANG=C.UTF-8
ENV LANG=C.UTF-8

# Configure access to the ROS2 repository.
RUN <<EOF
ROS_APT_SOURCE_URL="https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest"
ROS_SOURCES_DOWNLOAD="https://github.com/ros-infrastructure/ros-apt-source/releases/download"
ROS_APT_SOURCE_VERSION=$(curl -s $ROS_APT_SOURCE_URL | grep -F "tag_name" | awk -F\" '{print $4}')
UBUNTU_VERSION=$(. /etc/os-release && echo $VERSION_CODENAME)
ROS_SOURCES_URL="${ROS_SOURCES_DOWNLOAD}/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.${UBUNTU_VERSION}_all.deb"
curl -L -o /tmp/ros2-apt-source.deb $ROS_SOURCES_URL && dpkg -i /tmp/ros2-apt-source.deb
rm /tmp/ros2-apt-source.deb
EOF

# Install ROS2 packages.
RUN apt update && apt install -y \
  dumb-init \
  python-is-python3 \
  python3-pip \
  python3-venv \
  ros-dev-tools \
  ros-jazzy-desktop

# Create ordinary user with passwordless sudo permission.
RUN <<EOF
userdel -r ubuntu # Remove the default ubuntu user.
groupadd -g $gid user
useradd -u $uid -g $gid -G dialout,plugdev,video -m -s /bin/bash user
echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
EOF
COPY --chown=user:user user.bashrc /home/user/.bashrc

# Clean the APT cache and index.
RUN apt clean && rm -rf /var/cache/apt/archives /var/lib/apt/lists

# Setup dumb-init as the init process.
# See: https://github.com/Yelp/dumb-init
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Set up the ordinary user as the image default.
USER user
WORKDIR /home/user
CMD ["/bin/bash"]

# Create a Python virtual environment to hold packages through PyPI.
RUN python -m venv --system-site-packages ros2
