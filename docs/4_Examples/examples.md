# Usage Examples

> **Note: If you are using Docker to run the SDK, make sure to connect a new terminal to your container each time the instructions below tell you to "open a new terminal"**

## Example 1 Receive Data from LUCI

Lets look at a general example of how you might use the LUCI ROS2 SDK to receive data from LUCI from a ROS node. This example spins up the connection to the chair and allows its sensors to be visualized in rviz2.

**Step 1**: Open a fresh terminal and source ros2

`source /opt/ros/humble/setup.sh`

**Step 2**: Spin up the luci_grpc_interface_node.

`ros2 run luci_grpc_interface grpc_interface_node -a <chair-ip-address>`

**Step 3**: Open a NEW terminal and source ros2

`source /opt/ros/humble/setup.sh`

**Step 4**: Run the sensor transform topic. This tells ROS the location of each sensor in the stream.

`ros2 run luci_transforms luci_dev_kit_tf_node`

**Step 5**: Open a THIRD terminal and source ros2

`source /opt/ros/humble/setup.sh`

At this point you can visualize the data in either rviz2 or Foxglove Studio.

### Visualize with rviz2

**Step 6**: Run rviz2. We provide an rviz configuration file that sets up all the sensor displays for you, so this is the quickest way to get started:

`rviz2 -d rviz/pcl-all-sensors.rviz`

If you'd rather configure the displays yourself, run rviz2 with no config and set it up manually instead:

`rviz2`

Then configure it manually:

- Where it says 'Global Options' in Rviz, select 'base_camera' under 'Fixed Frame'.
- Then at the bottom left of the screen click 'Add'.
  - Select the 'By Topic' Tab
  - Then select 'PointCloud2' under '/camera_points'

You should now see a point cloud of camera points in Rviz.

### Visualize with Foxglove

Foxglove Studio is an alternative to rviz2. It needs a bridge process to expose ROS2 topics over a websocket, which the LUCI Docker image already has installed (`ros-humble-foxglove-bridge`); if you're not using our Docker image, install it first with `sudo apt install ros-humble-foxglove-bridge`.

**Step 6**: In the same third terminal, run the Foxglove bridge:

`ros2 run foxglove_bridge foxglove_bridge`

**Step 7**: Open [Foxglove Studio](https://studio.foxglove.dev) (desktop app or web) and connect to `ws://localhost:8765`.

Foxglove doesn't come with a pre-built layout, so add panels for the topics you care about — for example a 3D panel for `/luci/camera_points`, or raw message panels for topics like `/luci/odom` and `/luci/joystick_position`.

<!-- TODO: add a provided Foxglove layout file (e.g. foxglove/luci-foxglove.json), analogous to rviz/pcl-all-sensors.rviz, and reference it here as a quick-start option. -->

## Example 2 Send Data to LUCI

**Step 1**: Open a fresh terminal and source ros2

`source /opt/ros/humble/setup.sh`

**Step 2**: Spin up the luci_grpc_interface_node.

`ros2 run luci_grpc_interface grpc_interface_node -a <chair-ip-address>`

**Step 3**: Open a NEW terminal and source ros2.

`source /opt/ros/humble/setup.sh`

**Step 4**: Run the keyboard teleop node.

`ros2 run luci_basic_teleop keyboard_control_node`

With this node running, you can use the arrow keys on your keyboard to drive your wheelchair!
