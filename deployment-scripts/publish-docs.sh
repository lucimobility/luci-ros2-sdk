#! /bin/bash
# Publishes a built docs site to the SDK site under ros2/docs/, replacing what is there.
# Usage: SDK_SITE_BUCKET=... SDK_SITE_DISTRIBUTION_ID=... ./publish-docs.sh <built-site-dir>
set -euo pipefail

: "${SDK_SITE_BUCKET:?}" "${SDK_SITE_DISTRIBUTION_ID:?}"
SITE=${1:?usage: publish-docs.sh <built-site-dir>}

aws s3 sync --only-show-errors --delete "$SITE" "s3://$SDK_SITE_BUCKET/ros2/docs"
aws cloudfront create-invalidation --distribution-id "$SDK_SITE_DISTRIBUTION_ID" \
    --paths "/ros2/docs/*" > /dev/null
