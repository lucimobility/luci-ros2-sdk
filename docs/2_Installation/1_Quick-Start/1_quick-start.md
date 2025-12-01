# Quick Start

![Docker](docker-logo.png)

Docker is the recommended way to use the LUCI ROS2 SDK. Instructions for how to get started with the docker container are detailed here.

## Install Docker

In order to utilize the docker container, you must have docker installed on your local machine. Instructions for how to install Docker Engine can be found here: [Install Docker](https://docs.docker.com/engine/install/)

## Pull the LUCI ROS2 SDK docker image

**Note: You may have to preface the docker commands below with 'sudo'**

`docker pull luci.jfrog.io/ros2-sdk-docker-local/luci-ros2-sdk:latest`

## Run the container

**Note: You may have to preface the docker commands below with 'sudo'**

**Step 1**: Run the main container in the background
`docker run -d -it -p 8765:8765 luci.jfrog.io/ros2-sdk-docker-local/luci-ros2-sdk:latest`

(Note: This runs the container in the background and will continue to run until explicitly stopped)

**Step 2**: Get the container id
`docker ps`

**Step 3**: Connect to the container
`docker exec -it <container-id> bash`

(Note: You can connect to the container running in the background in as many terminals as needed)

**Stop** the container
`docker stop <container-id>`