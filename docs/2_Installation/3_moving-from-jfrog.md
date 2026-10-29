# Moving from JFrog

From the SDK release after v3.0.4, the LUCI ROS2 packages, Docker images and documentation are published from new locations. The old JFrog Artifactory repository and images no longer receive updates and will be shut down, so switch any machine, Dockerfile or script that uses them.

| | Old location | New location |
|---|---|---|
| Apt repository | `https://luci.jfrog.io/artifactory/ros2-sdk-packages` | `https://sdk.luci.com/ros2/apt` |
| SDK Docker image | `luci.jfrog.io/ros2-sdk-docker-local/luci-ros2-sdk` | `ghcr.io/lucimobility/luci-ros2-sdk` |
| Development Docker image | `luci.jfrog.io/ros2-sdk-docker-local/luci-sdk-development-image` | `ghcr.io/lucimobility/luci-sdk-development-image` |
| Documentation | `https://lucimobility.github.io/luci-sdk-docs/` | `https://sdk.luci.com/ros2/docs/` |

## Apt repository

If you added the LUCI apt repository by following the installation guide before this release, your machine points at JFrog. Remove the old repository and key, then add the new ones:

```bash
sudo rm -f /etc/apt/sources.list.d/ros2-sdk-packages.list /usr/share/keyrings/ros2-sdk-packages.gpg
curl -fsSL https://sdk.luci.com/ros2/apt/luci-ros2-archive-keyring.gpg | sudo tee /usr/share/keyrings/luci-ros2-archive-keyring.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/luci-ros2-archive-keyring.gpg] https://sdk.luci.com/ros2/apt jammy main" | sudo tee /etc/apt/sources.list.d/luci-ros2.list > /dev/null
sudo apt update
```

The new repository has every package version that was on JFrog, with identical files, so there is nothing to reinstall. Packages you have held with `apt-mark hold` stay held.

To check that a package now comes from the new repository, run `apt policy ros-humble-luci-messages`. The version table should list `https://sdk.luci.com/ros2/apt jammy/main amd64 Packages`, and no `luci.jfrog.io` source.

## Docker images

The images are public on the GitHub Container Registry, so no login is needed. Pull the new image:

```bash
docker pull ghcr.io/lucimobility/luci-ros2-sdk:latest
```

Then replace `luci.jfrog.io/ros2-sdk-docker-local/` with `ghcr.io/lucimobility/` wherever you name an image: `docker run` commands, `FROM` lines in your Dockerfiles, compose files and scripts.

Containers that are already running keep using the old image. To move one to the new image, stop and remove it, then start it again from `ghcr.io/lucimobility/luci-ros2-sdk:latest` with the same `docker run` options you used before, as in the [Quick Start](./1_Quick-Start/1_quick-start.md). Anything you kept only inside the old container is lost when you remove it, so copy it out first, or mount a folder from your machine as described in the Quick Start.

Images from earlier releases install packages from JFrog. Use the image for this release or later.

## Documentation

Links to `https://lucimobility.github.io/luci-sdk-docs/` redirect to the same page on `https://sdk.luci.com/ros2/docs/`. Update any bookmarks to the new address.
