# Development
This folder is only for developing and testing the SDK and should not need to be touched by anyone outside of the LUCI organization.

LUCI engineers use this docker image to develop and test new ROS packages.

Individual package repositories also use this docker image for their CI/CD pipelines.

# Building

This docker container is used for LUCI engineers to develop and edit the ROS2 packages included in the SDK. If you are a research institute or private party that wants to just run the ROS2 packages provided in this SDK but does not need to edit them please refer to the getting started instructions at https://lucimobility.github.io/luci-sdk-docs/.

## Building manually

In order to build this docker file please run the following commands. This ROS2 humble docker image only builds with gRPC and protobuf. You will need to clone or download the repositories you need. 
1. git clone this repository `git clone https://github.com/lucimobility/luci-ros2-sdk.git`
2. `cd luci-ros2-sdk/development`
3. `docker build -t luci_development_docker .`
4. `docker run -it luci_development_docker` - This will run the docker in your terminal.
5. To open other terminals with the same docker image run `docker exec -it luci_development_docker`

## Pulling SDK repositories from github
To run LUCI with ROS you only need two [luci-ros2-grpc](https://github.com/lucimobility/luci-ros2-grpc) and [luci-ross2-msgs](https://github.com/lucimobility/luci-ros2-msgs) repositories. These are public. 

1. Make a ws directory `mkdir ros_ws`
2. `cd ros_ws`
3. Make a project directory `mkdir luci_ros2/src`
4. `cd luci_ros2/src`
5. Run `git clone https://github.com/lucimobility/luci-ros2-grpc.git` and `git clone https://github.com/lucimobility/luci-ros2-msgs.git`
6. Now cd back to src level. Note: You should only need to build at the src level. 
7. Since gRPC depends on message definitions, it's best to build them first. Run `colcon build --packages-select luci_messages`, then source the setup script for your shell: `source install/setup.bash` (for Bash) or `source install/setup.zsh` (for Zsh). Use the appropriate command if you're using a different shell.
8. Once the luci_messages package is built, you can run `colcon build` to build all remaining packages. Then, source the appropriate setup script for your shell: `source install/setup.bash` (for Bash), `source install/setup.zsh` (for Zsh), or the equivalent for your shell. 
9. You are all set to run LUCI with the SDK.
10. To connect to LUCI, run the following command: `ros2 run luci_grpc_interface grpc_interface_node -a <IP>`. More information for this node can be found on [luci-ros2-grpc](https://github.com/lucimobility/luci-ros2-grpc) repository.

### File struture to follow
```bash
ros_ws
└──luci-ros2
    └── src (Use colcon build at this level)
        ├── luci-ros2-grpc
        └── luci-ros2-msgs
```

## Building with provided script (FOR LUCI EMPLOYEES)

There is also a provided script to build and deploy the docker image to jfrog. 
1. cd to the root of this directory
2. To build the dev container (this one) run `./build-and-deploy.sh -d`
3. To build the release container (the one used by researcher to run the SDK) run `./build-and-deploy.sh -r`

<b>IF YOU ARE NOT A LUCI AUTHORIZED USER THE UPLOAD WILL FAIL.</b>

## Using
In order to use this docker image you can either 
1. build it manually (see above instructions)
2. pull the latest built image down from the LUCI servers

If you dont need to edit the image and just need to use it then just pull it from the servers with 
1. `docker pull luci.jfrog.io/ros2-sdk-docker-local/luci-sdk-development-image:latest`
2. `docker run -d -it -p 8765:8765 luci.jfrog.io/ros2-sdk-docker-local/luci-sdk-development-image:latest`

If you need to edit the image and have followed the above build steps then run 
`docker run -d -it -p 8765:8765 luci-sdk-development-image:latest`


### SSH key transfer
In order to push to the LUCI repositories you will need an SSH key on the running docker container. The easiest way to do this by copying over and existing key from your dev machine. 

If you want your docker to have different ssh key for you to keep track, you can do this by following the github or bitbucket guidelines to add and make ssh keys. This method should be performed inside the docker container and will be set for all terminals.
- [Bitbucket](https://support.atlassian.com/bitbucket-cloud/docs/set-up-personal-ssh-keys-on-linux/)
- [Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

#### Steps
Note: you can find your `<docker id>` with the command `docker ps -a`

1. Join the docker image 
2. On your dev machine in a new terminal transfer both the private and public ssh key you use for github and or bitbucket
`docker cp <github>.pub <docker id>:/root`
`docker cp <github> <docker id>:/root`
3. Go back to the docker image and inform it of the new ssh keys `exec ssh-agent bash` then `ssh-add <github>` (Note that I am adding the private key) 

From there you should be able to run git clone in that terminal. Newly opened terminals may require running step 3 again.