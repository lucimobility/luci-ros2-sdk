# Public Docker image used by anyone wanting to use the LUCI SDK. Comes preinstalled with all LUCI packages.
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# General install stuff
RUN apt update \
    && apt install -y \
    cmake \ 
    vim \
    gdb \
    build-essential \
    autoconf \
    libtool \
    pkg-config \
    libspdlog-dev \
    curl \
    gnupg \
    lsb-release \
    git \
    automake \
    make \
    g++ \
    unzip \
    && apt-get clean

# Locales
RUN apt install locales \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LAND=en_US.UTF-8 \
    && export LANG=en_US.UTF-8

# Add ROS repo
RUN apt update \
    && apt upgrade -y \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS2 Humble
RUN apt update \
    && apt install -y ros-dev-tools \
    && apt install -y ros-humble-desktop

# Add LUCI repo
RUN curl -fsSL https://luci.jfrog.io/artifactory/api/security/keypair/ros-humble-keys/public | \
    gpg --dearmor -o /usr/share/keyrings/ros2-sdk-packages.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ros2-sdk-packages.gpg] https://luci.jfrog.io/artifactory/ros2-sdk-packages jammy private" \
    > /etc/apt/sources.list.d/luci.list && \
    apt update

# Copy the version JSON
COPY versions.json /root/version.json

# Install packages based on pinned versions
RUN apt update && apt install -y jq bash && \
    bash -c "\
        declare -A key_to_pkg=( \
            [messages]='ros-humble-luci-messages' \
            [grpc]='ros-humble-luci-grpc-interface' \
            [keyboard_teleop]='ros-humble-luci-basic-teleop' \
            [transforms]='ros-humble-luci-transforms' \
            [third_party]='ros-humble-luci-third-party' \
        ); \
        for key in \${!key_to_pkg[@]}; do \
            version=\$(jq -r --arg k \"\$key\" '.[\$k].version' /root/version.json | sed 's/^v//'); \
            pkg=\${key_to_pkg[\$key]}; \
            echo \"Installing \$pkg version \$version\"; \
            apt install -y \"\$pkg=\${version}-0jammy\" || exit 1; \
        done"

# Hold all LUCI packages so they dont auto update on apt update
RUN apt-mark hold ros-humble-luci-basic-teleop \
    && apt-mark hold ros-humble-luci-grpc-interface \
    && apt-mark hold ros-humble-luci-messages \
    && apt-mark hold ros-humble-luci-third-party \
    && apt-mark hold ros-humble-luci-transforms

RUN rm -f /root/version.json

# Install Foxglove support
RUN apt install ros-humble-foxglove-bridge -y

# Clean the docker image
RUN apt-get clean

# Add ROS2 sources to terminal by default
RUN echo source "/opt/ros/humble/setup.bash" >> /root/.bashrc
