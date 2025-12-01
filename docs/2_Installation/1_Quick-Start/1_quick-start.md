# Quick Start

![Docker](docker-logo.png)

Using our Docker image is an easy and quick way to install and use the LUCI ROS2 SDK. With each release, we maintain a Docker image which has everything you need to run our SDK. More specifically, it includes:
- An installation of ROS2 (Humble)
- gRPC and protobuf (which LUCI uses to talk to ROS2)
- LUCI's ros2 sdk packages:
    - [luci-ros2-grpc] (https://github.com/lucimobility/luci-ros2-grpc)
    - [luci-ros2-msgs] (https://github.com/lucimobility/luci-ros2-msgs)
    - [luci-ros2-transforms] (https://github.com/lucimobility/luci-ros2-transforms)
    - [luci-ros2-keyboard-teleop] (https://github.com/lucimobility/luci-ros2-keyboard-teleop)

All of this runs inside of a virtual machine within Docker, allowing you to use the SDK with almost any version of Linux.

## Install Docker

If you don't have docker, you can install it by following instructions here: [Install Docker](https://docs.docker.com/engine/install/)

## Pull down the latest LUCI ROS2 SDK docker image

**Note: You may have to preface the docker commands below with 'sudo'**

`docker pull luci.jfrog.io/ros2-sdk-docker-local/luci-ros2-sdk:latest`

## Using the Container

**Note: You may have to preface the docker commands below with 'sudo'**

## Part 1: Create and run the docker container. 

We recommend that you start up the container with the following flags and configuration in order to use it with our examples.

**Note: Before running the command below replace \<container-name> with any name of your choice**

```bash
sudo docker run -d -it \
    --name <container-name> \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=/root/.Xauthority \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $XAUTHORITY:/root/.Xauthority \
    -p 8765:8765 \
    luci.jfrog.io/ros2-sdk-docker-local/luci-ros2-sdk:latest
```
The container will now be running in the background and will not shut down unless explicitly told to shut down.

## Part 2: Starting and stopping.
If you run `docker ps`, you should see a the name of the image that you just started in a list of running containers.
This container will be running until you shut it down. To shut a container down you use `docker stop <container-name>`. Note that when a container is shut down any changes made on the image will be wiped away. To start the container up again use `docker start <container-name>`

## Part 3: Connect to the container.
Now that the container is running, we don't have to call start on it anymore. However, to connect a terminal to the container we need to use the following command:
`docker exec -it <container-name> bash`

(Note: Run this command for each new terminal that you want to connect to the container)

## Part 4: Check to see if everything is working
Make sure the container is running and open a new terminal and run:

`docker exec -it <container-name> bash`

and then: 

`ros2 run luci_grpc_interface grpc_interface_node -a <luci-ip-address>`

In another terminal run:

`docker exec -it <container-name> bash`

and then:

`ros2 topic list`

You should see a list of topics similar to this print out: 
```bash
/events/read_split
/events/write_split
/luci/camera_points
/luci/encoders
/luci/imu
/luci/joystick_position
/luci/joystick_scaling
/luci/odom
/luci/radar_points
/luci/scaling
/luci/ultrasonic_points
/parameter_events
/rosout
/tf
```
If you see this, then you should be up and running and can move on to trying some of our examples.



## Tips and tricks
- Creating aliases for the commands above and then adding them to your .bashrc file is super helpful way to avoid retyping all these long docker commands. The following is an example of alias definitions that you could put in your .bashrc file (on the host machine).
```bash
alias runsdk="docker start <container-name>"
alias stopsdk="docker stop <container-name>"
alias connectsdk="docker exec -it <container-name> bash"
```
- As mentioned above, shuting down a container will erase any changes made on the image. If you have files that you don't want to be discarded when the container is shut down, you can create a "storage folder" on your host machine, and point this folder to the docker container when you create it. The following command shows how you would point a folder at `/home/projects/luci` on the host machine to a folder called `ws` in the docker container.

```bash
sudo docker run -d -it \
    --name <container-name> \
    -v /home/projects/luci:/root/ws \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=/root/.Xauthority \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $XAUTHORITY:/root/.Xauthority \
    -p 8765:8765 \
    luci.jfrog.io/ros2-sdk-docker-local/luci-ros2-sdk:latest
```