# Usage Examples

**Note: If you are using Docker to run the SDK, make sure to connect a new terminal to your container each time the instructions below tell you to "open a new terminal"**

## Example 1 Receive Data from LUCI:

Lets look at a general example of how you might use the LUCI ROS2 SDK to receive data from LUCI from a ROS node. This example spins up the connection to the chair and allows its sensors to be visualized in rviz2.

**Step 1**: Open a fresh terminal and source ros2

`source /opt/ros/humble/setup.sh`

**Step 2**: Spin up the luci_grpc_interface_node.

`ros2 run luci_grpc_interface grpc_interface_node -a <chair-ip-address>`

**Step 3**: Open a NEW terminal and source ros2

`source /opt/ros/humble/setup.sh`

**Step 4**: Run the sensor transform topic. This tells ROS the location of each sensor in the stream.

`ros2 run luci_transforms quickie_500m_tf_node`

**Step 5**: Open a THIRD terminal and source ros2

`source /opt/ros/humble/setup.sh`

**Step 6**: Run rviz2

`rviz2`

**Step 7**: Configure rviz2
- Where it says 'Global Options' in Rviz, select 'base_camera' under 'Fixed Frame'.
- Then at the bottom left of the screen click 'Add'.
    - Select the 'By Topic' Tab
    - Then select 'PointCloud2' under '/camera_points'

You should now see a point cloud of camera points in Rviz

In addition to this example, we also provide an Rviz configuration file that may be useful: [Rviz Config](https://github.com/lucimobility/luci-ros2-sdk/tree/main/rviz)



## Example 2 Send Data to LUCI:

**Step 1**: Open a fresh terminal and source ros2

`source /opt/ros/humble/setup.sh`

**Step 2**: Spin up the luci_grpc_interface_node.

`ros2 run luci_grpc_interface grpc_interface_node -a <chair-ip-address>`

**Step 3**: Open a NEW terminal and source ros2.

`source /opt/ros/humble/setup.sh`

**Step 4**: Run the keyboard teleop node.

`ros2 run luci_basic_teleop keyboard_control_node`

With this node running, you can use the arrow keys on your keyboard to drive your wheelchair!

