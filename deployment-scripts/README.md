# Deployment Scripts

This folder holds the scripts the `next-docs` and `release-docs` github actions run to build the SDK documentation that is hosted at <https://sdk.luci.com/ros2/docs/>. The actions run them directly on the GitHub runner, using the Node version set by `actions/setup-node` in the workflow. Both workflows share the `sdk-docs` concurrency group, so only one docs build runs at a time.

- `build-docs.sh` - gathers the docs from the repos the action has checked out (`luci-ros2-grpc`, `luci-ros2-msgs`, `luci-ros2-transforms`, `luci-ros2-keyboard-teleop`, `luci-ros2-third-party`, and the docs site repo), and builds the Docusaurus site from them. For a release, it also adds a docs version named after the release tag and pushes that version's snapshot back to the docs site repo; every later build rebuilds the older versions from these snapshots.
- `publish-docs.sh` - uploads the built site to the SDK site's S3 bucket under `ros2/docs/` and clears the CloudFront cache for it.
