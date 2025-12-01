![Docker](docker-logo.png)

## Docker

Using our Docker image is an easy and quick way to install and use the LUCI ROS2 SDK. With each release, we maintain a Docker image which has everything you need to run our SDK. More specifically, it includes:
- An installation of ROS2 (Humble)
- gRPC and protobuf (which LUCI uses to talk to ROS2)
- LUCI's ros2 sdk packages:
    - [luci-ros2-grpc] (https://github.com/lucimobility/luci-ros2-grpc)
    - [luci-ros2-msgs] (https://github.com/lucimobility/luci-ros2-msgs)
    - [luci-ros2-transforms] (https://github.com/lucimobility/luci-ros2-transforms)
    - [luci-ros2-keyboard-teleop] (https://github.com/lucimobility/luci-ros2-keyboard-teleop)

All of this run inside of a virtual machine within Docker, allowing you to use the SDK with any opperating system (Windows, Mac, Linux).

## Install Docker

If you don't have docker, you can install it by following instructions here: [Install Docker](https://docs.docker.com/engine/install/)

## Working with Docker

**Note: You may have to preface the docker commands below with 'sudo'**

### Pull the LUCI ROS2 SDK docker image

`docker pull luci.jfrog.io/ros2-sdk-docker-local/luci-ros2-sdk:latest`

### Running the container

**Step 1**: Run the main container in the background
TODO: add more details here like: 
- how to run it to use rviz
- how to connect an external file
`docker run -d -it -p 8765:8765 luci.jfrog.io/ros2-sdk-docker-local/luci-ros2-sdk:latest`

(Note: This runs the container in the background and will continue to run until explicitly stopped)

**Step 2**: Get the container id
`docker ps`

**Step 3**: Connect to the container
TODO: add instructions for once you have the image running, how do you run the sdk stuff
`docker exec -it <container-id> bash`

(Note: You can connect to the container running in the background in as many terminals as needed)

**Stop** the container
`docker stop <container-id>`
