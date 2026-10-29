# LUCI ROS2 Apt Repository

The LUCI ROS2 packages are served as an apt repository at <https://sdk.luci.com/ros2/apt>, from the SDK site's S3 bucket behind CloudFront. The bucket and the IAM roles that write to it are defined in `aws-cdk/lib/sdk-site-stack.ts` in [aws-dev-infrastructure](https://github.com/lucimobility/aws-dev-infrastructure).

## How packages get published

1. Releasing a package repo (`luci-ros2-msgs`, `luci-ros2-grpc`, `luci-ros2-transforms`, `luci-ros2-third-party`, `luci-ros2-keyboard-teleop`) builds and signs its `.deb` and uploads it to `ros2/apt/pool/main/<package>/` in the bucket. Its workflow then starts the `Publish Apt Index` workflow in this repo.
2. `Publish Apt Index` runs `publish-apt-index.sh`, which rebuilds the index (`dists/`) from every `.deb` in the pool, signs it with the archive key, uploads it and clears the CloudFront cache for it. It also runs nightly, in case a package repo's request to run it was lost.

Packages are never removed from the pool, so every released version stays installable with `apt install <package>=<version>-0jammy`.

## Users

```bash
curl -fsSL https://sdk.luci.com/ros2/apt/luci-ros2-archive-keyring.gpg | sudo tee /usr/share/keyrings/luci-ros2-archive-keyring.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/luci-ros2-archive-keyring.gpg] https://sdk.luci.com/ros2/apt jammy main" | sudo tee /etc/apt/sources.list.d/luci-ros2.list > /dev/null
sudo apt update
```

## Archive signing key

The index is signed with a key used only for this repository. The individual `.deb` files are still signed with `dpkg-sig` by each package repo, using that repo's `GPG_SIGNING_KEY`.

The public key is exported from the signing key and uploaded on every run, so nothing needs to be committed when it changes. To create or replace the key:

1. `gpg --quick-gen-key "LUCI ROS2 SDK Archive Signing Key" ed25519 sign 3y`, with a passphrase.
2. Store the private key and passphrase in the password manager.
3. Set this repo's `APT_ARCHIVE_SIGNING_KEY` secret to the output of `gpg --armor --export-secret-keys <key id>`, and `APT_ARCHIVE_PASSPHRASE` to the passphrase.
4. Run `Publish Apt Index`. Users who added the old key have to download the new one before `apt update` works again.

## Repository settings

`Publish Apt Index`, the docs workflows and `Deploy Landing Page` need these Actions variables, from the outputs of `sdk-site-stack`:

- `AWS_DEPLOY_ROLE_ARN` - `publish-role-arn`
- `SDK_SITE_BUCKET` - `bucket-name`
- `SDK_SITE_DISTRIBUTION_ID` - `distribution-id`
