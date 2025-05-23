# Install LUCI ROS2 SDK

The ROS2 SDK provided by LUCI is broken up into a collection of examples and individual ROS2 packages. We chose to split the packages into individually installable .deb binaries. This choice was made to ensure that the SDK could be as modular as possible.

## Release packages

With each release of the SDK there are official packages of the ROS2 packages provided by LUCI published as well (See the Packages section) These packages are individually tagged with their current version and are grouped into a specific SDK release. This indicates that those packages will all be compatible with each other.

Each package follows the same [Semantic Versioning](https://semver.org/) as the full SDK does.

**Please note that we do NOT test any package versions for compatibility other then the ones in an official SDK. While some non SDK released packages may function it is not guaranteed.**

## Package versions

The correct versions of the binary packages can be found in the versions.json file in the SDK repo corresponding to the SDK release tag.

This file shows all the packages that are included in said release and their version number.

Each package is published to an apt repository upon release and is added by first informing your computer of the repository.

## Install packages for specific SDK Release

If this is your first time using the LUCI ROS2 SDK repository you need to first add the repo and gpg key to you system. This informs your computer that the LUCI .deb packages exist and can be installed.

Note you will only need to run the next two commands the first time you need to install our packages on your system. If you are updating existing LUCI packages this is not needed

### Add the GPG key

`curl -fsSL https://luci.jfrog.io/artifactory/api/security/keypair/humble-sdk-key/public | gpg --dearmor -o /usr/share/keyrings/ros2-sdk-packages.gpg`

### Add the debian repository to sources file

`sudo sh -c "echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/ros2-sdk-packages.gpg] https://luci.jfrog.io/artifactory/ros2-sdk-packages jammy private' >> /etc/apt/sources.list"`

### Install the package

Once you have added the repo and gpg key for the LUCI ROS2 packages you can install all by running the command below

```
sudo apt update
apt install ros-humble-luci-basic-teleop=1.0.0-0jammy 
apt install ros-humble-luci-grpc-interface=1.0.0-0jammy 
apt install ros-humble-luci-messages=1.0.0-0jammy 
apt install ros-humble-luci-third-party=1.1.0-0jammy 
apt install ros-humble-luci-transforms=1.0.0-0jammy
```

After each install you should see it downloaded the version of the package that matches the version number listed in the versions.json file

To check the version of a given package run

`apt show [package-name]`

For examble to check the basic-teleop package you would run

`apt show ros-humble-luci-basic-teleop`

and the output should be similar to this

```
Package: ros-humble-luci-basic-teleop
Version: 1.0.0-0focal
Priority: optional
Section: misc
Installed-Size: 45.1 kB
Depends: ros-galactic-rclpy, ros-galactic-std-msgs
Download-Size: 8,100 B
APT-Manual-Installed: yes
APT-Sources: https://luci.jfrog.io/artifactory/ros2-sdk-packages jammy/private amd64 Packages
Description: An example node that can be used to drive LUCI using the arrow keys on your keyboard.
 ctrl+c or q to terminate. Compatible with Linux.

```

## Non Debian Install
LUCI is proud to have the SDK packages open-source. If you want to make specific changes you can directly clone the repositories from github. Here are the steps:

1. Make a ws directory `mkdir ros_ws`
2. `cd ros_ws`
3. Make a project directory `mkdir luci_ros2/src`
4. `cd luci_ros2/src`
5. clone the repositories you need. To run the basic grpc, you will need 2 repositories, grpc_interface and luci_messages. If you need TF, you can also clone the tf_transforms repository we provide. 
    - luci-ros2-grpc - `git clone https://github.com/lucimobility/luci-ros2-grpc.git`
    - luci-ros2-msgs - `git clone https://github.com/lucimobility/luci-ros2-msgs.git`
    - luci-ros2-transforms - `https://github.com/lucimobility/luci-ros2-transforms.git`
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
