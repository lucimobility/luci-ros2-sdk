#!/bin/bash
# Rebuilds the ROS2 apt repository's index from every package in the pool, signs it and publishes
# it. The package repos only add .deb files to the pool, so the index is always rebuilt from
# scratch: a run that is lost or races another is corrected by the next one.
#
# Needs the AWS CLI with credentials for the SDK site, apt-ftparchive (apt-utils), and the archive
# signing key imported into gpg.
#
# Usage: SDK_SITE_BUCKET=... SDK_SITE_DISTRIBUTION_ID=... KEY_ID=... ./publish-apt-index.sh

set -euo pipefail

: "${SDK_SITE_BUCKET:?}" "${SDK_SITE_DISTRIBUTION_ID:?}" "${KEY_ID:?}"

DIST=jammy
COMPONENT=main
ARCHITECTURES="amd64"
PREFIX=ros2/apt
KEYRING=luci-ros2-archive-keyring

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cd "$work"

# The local tree mirrors the repository root, so the Filename fields apt-ftparchive writes
# (pool/main/...) resolve against https://<site>/ros2/apt/.
aws s3 sync --only-show-errors "s3://$SDK_SITE_BUCKET/$PREFIX/pool" pool

for arch in $ARCHITECTURES; do
    dir=dists/$DIST/$COMPONENT/binary-$arch
    mkdir -p "$dir"
    apt-ftparchive --arch "$arch" packages pool > "$dir/Packages"
    gzip -9 --keep --no-name "$dir/Packages"
done

# Written outside dists/ first so the Release file doesn't list itself.
apt-ftparchive \
    -o APT::FTPArchive::Release::Origin=LUCI \
    -o APT::FTPArchive::Release::Label="LUCI ROS2 SDK" \
    -o APT::FTPArchive::Release::Suite=$DIST \
    -o APT::FTPArchive::Release::Codename=$DIST \
    -o APT::FTPArchive::Release::Architectures="$ARCHITECTURES" \
    -o APT::FTPArchive::Release::Components=$COMPONENT \
    release "dists/$DIST" > Release
mv Release "dists/$DIST/Release"

gpg --batch --yes --local-user "$KEY_ID" --clearsign \
    --output "dists/$DIST/InRelease" "dists/$DIST/Release"
gpg --batch --yes --local-user "$KEY_ID" --armor --detach-sign \
    --output "dists/$DIST/Release.gpg" "dists/$DIST/Release"

gpg --export --armor "$KEY_ID" > $KEYRING.asc
gpg --export "$KEY_ID" > $KEYRING.gpg

# The Packages files go up before the Release files that hold their hashes, so a client never sees
# a Release file that refers to Packages files it can't fetch yet.
aws s3 sync --only-show-errors --delete "dists" "s3://$SDK_SITE_BUCKET/$PREFIX/dists" \
    --exclude "$DIST/Release" --exclude "$DIST/InRelease" --exclude "$DIST/Release.gpg"
for file in Release.gpg Release InRelease; do
    aws s3 cp --only-show-errors "dists/$DIST/$file" "s3://$SDK_SITE_BUCKET/$PREFIX/dists/$DIST/$file"
done
aws s3 cp --only-show-errors $KEYRING.asc "s3://$SDK_SITE_BUCKET/$PREFIX/$KEYRING.asc"
aws s3 cp --only-show-errors $KEYRING.gpg "s3://$SDK_SITE_BUCKET/$PREFIX/$KEYRING.gpg"

aws cloudfront create-invalidation --distribution-id "$SDK_SITE_DISTRIBUTION_ID" \
    --paths "/$PREFIX/dists/*" "/$PREFIX/$KEYRING.*" > /dev/null
