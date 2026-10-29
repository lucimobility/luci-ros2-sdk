# LUCI SDK Landing Page

The landing page at <https://sdk.luci-guci.com/>, which links to each LUCI SDK component. It lives in this repo until the SDK repos are consolidated. It is plain HTML and CSS with no build step: preview it with any static file server, for example `python3 -m http.server` from this folder.

The copy in `index.html` is a first draft adapted from the ROS2 SDK docs and is meant to be replaced with marketing's text.

## How the site fits together

The site is one S3 bucket behind CloudFront, defined in `aws-cdk/lib/sdk-site-stack.ts` in [aws-dev-infrastructure](https://github.com/lucimobility/aws-dev-infrastructure). The landing page owns only the files at the bucket root: `index.html`, `404.html`, `favicon.ico` and `assets/`. CloudFront serves `404.html` for any missing path on the site. Each SDK component publishes under its own prefix:

| Path | Published by |
| --- | --- |
| `/` | `Deploy Landing Page` workflow, on every push to `main` that changes this folder |
| `/ros2/docs/` | `Create Next Documentation` and `Create Release Documentation` workflows |
| `/ros2/apt/` | the ROS2 package repos and the `Publish Apt Index` workflow (see `apt/README.md`) |

All of them use the same Actions variables; see `apt/README.md`.
