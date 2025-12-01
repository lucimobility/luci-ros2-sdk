---
id: intro
title: Introduction
slug: /
---

# LUCI ROS2 Software Developer Kit

The tools in this SDK make LUCI sensor information and control interfaces available to organizations and leading research institutions, allowing them to use LUCI as a research tool. To use the SDK you need a LUCI Dev Kit (a LUCI enabled wheelchair) updated to LuciCore Sandbox Edition, Version 3.0.5 or greater. If you are interested in becoming a Sandbox Partner, contact info@luci.com.

## Overview

LUCI provides this ROS2 SDK to enable Sandbox Partners to use LUCI: 
* for data logging of driver behavior during clinical research, and, 
* development and testing of active features/autonomy for power wheelchairs such as new drive methods and driver assistance software.

*NOTICE: The ROS2 SDK will not work on commercial LUCI units running standard LuciCore software. The ROS2 SDK is not intended for commercial use.*

For ROS2, LUCI provides multiple deb packages containing message types, executable nodes, and URDF whose purpose is to get LUCI data into ROS2 compatible formats to accelerate research. 

The current features of the ROS2 SDK include:
- Reading sensor point cloud data from LUCI,
- Reading available odometry information from the wheelchair,
- Reading wheelchair joystick position, and,
- Writing joystick values to the wheelchair for automated driving.

In addition to this guide, there are additional examples and READMEs in the associated, public repos that are good resources for getting started.

## Network Requirements

Due to the high volume of data being transmitted over the network when running the ROS interface it is critical to have both your dev machine as well as LUCI connected to a 5Ghz wifi channel. This is particularly important when wanting to make remote drive calls while also visualizing the full point cloud or image frames.

## Package Descriptions

There are several individual packages that are designed to be as separate as possible (though some internal dependencies do exist) so that each package can be run individually depending on the feature set and level of LUCI input needed.

## Versioning

This SDK is a combination of multiple individual packages. Each package is a separate repo and as such has its own versioning number. The publicly provided SDK repo however is a holding place for examples and package documentation. As a developer using the SDK you will only need to concern yourself with that single repo and version. All binaries in a specific version will be tested against each other before any public release tag is generated.

New tags will be released based on aggressiveness of the changes which may include new support for an upgraded ROS version or the inclusion of new features in the form of additional package binaries.

Versioning is handled on a major.minor.patch method.

As new features are added to individual ROS2 packages their individual repos will be tagged and binaries released to the public via a deb artifactory. 

**A new release of an individual package is not guaranteed to cause a release of a new SDK. It will likely be common practice to hold on a new SDK release until there are multiple changes to multiple packages.**

*Please note that a package binary is not considered compatible or tested with any other ROS2 nodes other than those listed in its specific SDK release.*

## Software Dependency Table

[Dependency_Table](https://github.com/lucimobility/luci-ros2-sdk/blob/main/README.md#luci-core-software-and-sdk-interdependency-chart)

## WDI

For development and testing of new alternative drive solutions, where ROS2 is not required, WDI compatible input devices can be used directly by plugging into the LuciLink Hub on the back of the seat. For more information on this option see the [WDI Definition](https://github.com/Open-Mobility-Hub/wheelchair-digital-interface).

## License
The LUCI Sandbox ROS2 SDK falls under the [Apache 2.0 License](http://www.apache.org/licenses/)