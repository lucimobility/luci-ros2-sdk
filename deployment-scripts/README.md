# Deployment Scripts

This folder holds the scripts the `next-docs` and `release-docs` github actions run to build the SDK documentation that is hosted at <https://sdk.luci.com/ros2/docs/>. The actions run them directly on the GitHub runner, using the Node version set by `actions/setup-node` in the workflow.

- `build-docs.sh` - gathers the docs from the repos the action has checked out (`luci-ros2-grpc`, `luci-ros2-msgs`, `luci-ros2-transforms`, `luci-ros2-keyboard-teleop`, `luci-ros2-third-party`, and the docs site repo), builds the Docusaurus site from them, and pushes the source changes (and, for a release, the new docs version) back to the docs site repo.
- `publish-docs.sh` - uploads the built site to the SDK site's S3 bucket under `ros2/docs/` and clears the CloudFront cache for it.
