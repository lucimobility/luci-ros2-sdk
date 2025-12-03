# Manual Installation

**Note: These are instructions for installing ROS2, luci_ros2_sdk, and other system dependencies onto a native Linux system. If you installed everything using the Quick Start and Docker instructions above here, then you do not need to do any part of the installation below.**


## Installing Basic System Dependencies

Due to the nature of the current packages, some require dependencies before they can be installed or run. These packages are built and tested to support ROS2 Humble with Ubuntu 22.04. 

Please note that some of these are system wide installs and could have conflicts with other libraries already installed on your system. If you are concerned about that please either plan on running the SDK packages on a separate clean system or use a virtual machine.

Run the following commands to install the system dependencies.

`sudo apt install -y cmake`

`sudo apt install -y build-essential autoconf libtool pkg-config`

`sudo apt-get install libspdlog-dev`


## Installing ROS2

Instructions from the official ROS maintainers can be found here https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html but the steps we assume you run will be listed below

### Set the local:

`sudo apt update && sudo apt install locales`

`sudo locale-gen en_US en_US.UTF-8`

`sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8`

`export LANG=en_US.UTF-8`

### Add the ROS2 apt repository:

`sudo apt update && sudo apt install curl gnupg lsb-release`

`sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg`

### Add the repo to sources:

`echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null`

### Install ROS2:

`sudo apt update`

`sudo apt upgrade -y`

`sudo apt install ros-humble-desktop`

ROS2 Humble should now be installed. See the above linked instructions to test it out and make sure its ready. (Try some examples)

## Install gRPC

**LUCI uses gRPC, developed by Google, for its wireless messaging system. This system uses protobuf as well. These are very version sensitive so it is important to use the exact versions that are listed below.**

https://github.com/grpc/grpc/blob/master/BUILDING.md#build-from-source

gRPC relies on protobuf as such defaults to installing a version with it. We can tell the installer that we already have protobuf installed however and avoid this. (Note: If you do not tell gRPC to use the 3.17.1 version of protobuf later steps will say that the generated .proto files were generated with the wrong version of protobuf)

We will install gRPC in a special local location, this is very important because a system wide install of gRPC can be borderline impossible to change or uninstall.

`cd ~`

**The below command tells the system to install gRPC in ~/.local folder**

`export MY_INSTALL_DIR=$HOME/.local`

Make sure that directory actually exists

`mkdir -p $MY_INSTALL_DIR`

Add the bin path so it can be used at run time of the LUCI SDK packages

`export PATH="$MY_INSTALL_DIR/bin:$PATH"`

### Clone and Install:

```
git clone -b v1.56.2 https://github.com/grpc/grpc grpc \
    && cd grpc \
    && git submodule update --init \
    && mkdir -p cmake/build \
    && cd cmake/build \
    && cmake -DgRPC_INSTALL=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DgRPC_BUILD_TESTS=OFF \
    -DgRPC_PROTOBUF_PROVIDER=module \
    -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR \
    ../.. \
    && make -j$(nproc) \
    && make install \
    && sudo apt-get install libprotobuf-dev
```

**For some systems the .local folder is not looked at for shared libraries by default. If you get a runtime error that says grpc_node cannot find libgrpc, then run the command below.**

`export LD_LIBRARY_PATH="$HOME/.local/lib":$LD_LIBRARY_PATH`

**Note: This will need to be done on each terminal you run gRPC node. You can add this to your bashrc file if you want it automatically done on each terminal you open**

Now that gRPC is installed, using the protobuf version installed in the prior step, you are ready to clone and install the ROS2 SDK [repo](https://github.com/lucimobility/luci-ros2-sdk).


## Install LUCI ROS2 SDK

The ROS2 SDK provided by LUCI is broken up into a collection of examples and individual ROS2 packages. We chose to split the packages into individually installable .deb binaries. This choice was made to ensure that the SDK could be as modular as possible.

### Release packages

With each release of the SDK there are official packages of the ROS2 packages provided by LUCI published as well (See the Packages section) These packages are individually tagged with their current version and are grouped into a specific SDK release. This indicates that those packages will all be compatible with each other.

Each package follows the same [Semantic Versioning](https://semver.org/) as the full SDK does.

**Please note that we do NOT test any package versions for compatibility other then the ones in an official SDK. While some non SDK released packages may function it is not guaranteed.**

### Package versions

The correct versions of the binary packages can be found in the versions.json file in the release directory of the SDK repo corresponding to the SDK release tag.

This file shows all the packages that are included in said release and their version number.

Each package is published to an apt repository upon release and is added by first informing your computer of the repository.

### Install packages for specific SDK Release

If this is your first time using the LUCI ROS2 SDK repository you need to first add the repo and gpg key to you system. This informs your computer that the LUCI .deb packages exist and can be installed.

### Add the GPG key

`curl -fsSL https://luci.jfrog.io/artifactory/api/security/keypair/ros-humble-keys/public | sudo gpg --dearmor -o /usr/share/keyrings/ros2-sdk-packages.gpg`

### Add the debian repository to sources file

`echo "deb [signed-by=/usr/share/keyrings/ros2-sdk-packages.gpg] https://luci.jfrog.io/artifactory/ros2-sdk-packages jammy private" | sudo tee /etc/apt/sources.list.d/ros2-sdk-packages.list > /dev/null`

### Install the package

Once you have added the repo and gpg key for the LUCI ROS2 packages you can install all by running the command below. These will install the latest updated versions of the package. 

```
sudo apt update
apt install ros-humble-luci-basic-teleop
apt install ros-humble-luci-grpc-interface
apt install ros-humble-luci-messages
apt install ros-humble-luci-third-party
apt install ros-humble-luci-transforms
```

After each install you should see it downloaded the version of the package that matches the version number listed in the versions.json file

To check the version of a given package run

`apt show [package-name]`

For examble to check the basic-teleop package you would run

`apt show ros-humble-luci-messages`

and the output should be similar to this

```
Package: ros-humble-luci-messages
Version: 2.0.0-0jammy
Priority: optional
Section: misc
Maintainer: shail <shail@luci.com>
Installed-Size: 1185 kB
Depends: libc6 (>= 2.4), libgcc-s1 (>= 3.3.1), libpython3.10 (>= 3.10.0), libstdc++6 (>= 5.2), ros-humble-fastcdr, ros-humble-rosidl-default-runtime, ros-humble-std-msgs
Download-Size: 84.7 kB
APT-Manual-Installed: yes
APT-Sources: https://luci.jfrog.io/artifactory/ros2-sdk-packages jammy/private amd64 Packages
Description: Custom Luci message types

```

### Non Debian Install
LUCI is proud to have the SDK packages open-source. If you want to make specific changes you can directly clone the repositories from github. Here are the steps:

1. Make a ws directory `mkdir ros_ws`
2. `cd ros_ws`
3. Make a project directory `mkdir luci_ros2/src`
4. `cd luci_ros2/src`
5. Clone the repositories you need. At a minimum, you will need luci_grpc_interface and luci_messages to communicate with LUCI. If you need TF, you can also clone the tf_transforms repository we provide. 
    - luci-ros2-grpc - `git clone https://github.com/lucimobility/luci-ros2-grpc.git`
    - luci-ros2-msgs - `git clone https://github.com/lucimobility/luci-ros2-msgs.git`
    - luci-ros2-transforms - `git clone https://github.com/lucimobility/luci-ros2-transforms.git`
    - You can also clone the keyboard teleop demo with - `git clone https://github.com/lucimobility/luci-ros2-keyboard-teleop.git`
6. Now cd back to src level. Note: You should only need to build at the src level. 
7. Since gRPC depends on message definitions, it's best to build them first. Run `colcon build --packages-select luci_messages`, then source the setup script for your shell: `source install/setup.bash` (for Bash) or `source install/setup.zsh` (for Zsh). Use the appropriate command if you're using a different shell.
8. Once the luci_messages package is built, you can run `colcon build` to build all remaining packages. Then, source the appropriate setup script for your shell: `source install/setup.bash` (for Bash), `source install/setup.zsh` (for Zsh), or the equivalent for your shell. 
9. You are all set to run LUCI with the SDK.

You can also visit LUCI [github](https://github.com/lucimobility) for more repositories and our work. 

### File struture to follow
```bash
ros_ws
└──luci-ros2
    └── src (Use colcon build at this level)
        ├── luci-ros2-grpc
        ├── luci-ros2-transforms
        └── luci-ros2-msgs
```

**Note: Currently only Ubuntu focal (22.04/20.04) with ROS Humble is supported. If you need support for another Linux/Ubuntu version please submit an issue card in the [SDK Repo](https://github.com/lucimobility/luci-ros2-sdk)**

## Test the install

To test your install open a new terminal and run

`source /opt/ros/humble/setup.sh`

Then you should be able to type ros2 run luci and tab complete you should get several options.

For Native Install, you will have to run `source ros_ws/luci_ros2/install/setup.bash` for the tab options to show up. 

To test your connection with LUCI, in the same terminal run `ros2 run luci_grpc_interface grpc_interface_node -a <CHAIR_IP>`

**If that works congrats you are up and running!**

Check out the examples and launch files included in the [SDK repo](https://github.com/lucimobility/luci-ros2-sdk) for information on how to use them, and look at the package pages for information on how the actual packages are designed and what topics are exposed from each.
