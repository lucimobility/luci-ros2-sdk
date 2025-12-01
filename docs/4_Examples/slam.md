# SLAM Notes

LUCI as a sensor platform allows for a jump start on applying a SLAM methodology to power wheelchairs.

While LUCI does not offer a existing SLAM package for the ROS2 SDK here are a few tips for a successful implementation.

## Packages

There are two main SLAM packages that have been successful with partners.

1. [slam_toolbox](http://wiki.ros.org/slam_toolbox)
2. [gmapping](http://wiki.ros.org/gmapping)

Both have their pros and cons but can run successfully with only LUCI data streams.

## Architecture

Here is a sample design of an implementation and what the resulting map looked like
![Architecture](slam.png)

![Map](map.png)

## Data

#### 2D vs 3D

While some of the SLAM nodes will expect a 2D point cloud and LUCI provides a 3D cloud you will need some method of converting our provided feed to 2D.
This can be done in a couple of ways.

1. Implement a z height flatten filter that casts all points to a single z height.
2. Run through an existing pointcloud->lidar converter node. This one proved decent.  
   [pointcloud_to_laserscan](https://github.com/ros-perception/pointcloud_to_laserscan)

<b>_Note: Not all SLAM nodes need 2D and 3D data is definitely the better choice to use for LUCI if able_</b>

Casting points to 2D produces a decent map but will struggle with localization later.

#### Ultrasonic Data

As LUCI produces ultrasonic curves as points it is recommended that you do <b>NOT</b> include them in the mapping of an environment as they will add curved noise to your map.

## JS to Twist Message

As LUCI and wheelchairs operate with a left-right/forward-back joystick and most ROS2 packages expect a [Twist](http://docs.ros.org/en/melodic/api/geometry_msgs/html/msg/Twist.html) message a conversion node will be required.

Here are two different methods LUCI has played with to varying degrees of success that may be of help.

1. Find the max speed at a given speed setting then apply a linear fit mapping JS for 0-Max speed in a piece-wise function that is stepped based on speed settings.
2. Create a PID loop that takes in a chairs speed (already exposed through the luci_grpc_interface) as well as a goal speed and output a JS value of 0-100. 

Either can be run as a “converter” node in between the SLAM node and the grpc-endpoint node. We recommend the PID approach.
