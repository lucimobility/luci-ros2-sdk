# Installing Basic System Dependencies

## Setting up your development machine

**This can be skipped if using the docker container above**

Due to the nature of the current packages, some require dependencies before they can be installed or run. These packages are built and tested to support ROS2 Humble with Ubuntu 22.04. New packages can be developed to fit other ROS2 version and OS needs in the future.

To install the LUCI ROS2 packages manually (which is not recommended) use the `apt install` commands listed.

**If you are installing the SDK manually please follow all the installation sections to get fully set up**

## Manual dependencies:

To manually set up an existing system to use the LUCI ROS2 SDK follow the below instructions.

Please note that some of these are system wide installs and could have conflicts with other libraries already installed on your system. If you are concerned about that please either plan on running the SDK packages on a separate clean system or use a virtual machine.

## Install the dependencies below

`sudo apt install -y cmake`

`sudo apt install -y build-essential autoconf libtool pkg-config`

`sudo apt-get install libspdlog-dev`
