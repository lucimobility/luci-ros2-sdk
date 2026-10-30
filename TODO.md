# TODO: SDK site migration (JFrog Artifactory → sdk.luci.com)

Remaining work to move the SDK docs, apt repository and Docker images off JFrog Artifactory and GitHub Pages, onto <https://sdk.luci.com>. The site (S3 + CloudFront) is defined in `aws-cdk/lib/sdk-site-stack.ts` in [aws-dev-infrastructure](https://github.com/lucimobility/aws-dev-infrastructure). Delete this file once everything below is checked off.

`sdk.luci.com` is live, and every PR in this migration points at it. The `sdk.luci-guci.com` test deployment has been removed.

## 1. DNS and infrastructure

- [x] Deploy `sdk-site-zone-stack` from the aws-dev-infrastructure PR. It creates the `sdk.luci.com` hosted zone and outputs its `name-servers`.
- [x] Have the luci.com DNS admin add four `NS` records for `sdk` pointing at those name servers. Check with `dig NS sdk.luci.com`.
- [x] Once the delegation resolves, deploy `sdk-site-certificate-stack`, then `sdk-site-stack`. The distribution and DNS records move to `sdk.luci.com`; the bucket, its contents and the IAM roles stay.
- [x] Delete the old `sdk-site-cert-stack` in us-east-1, which removes the `sdk.luci-guci.com` certificate.
- [x] Check <https://sdk.luci.com/>, <https://sdk.luci.com/ros2/docs/> and `https://sdk.luci.com/ros2/apt/dists/jammy/InRelease`.

## 2. Settings

- [x] **Archive signing key.** The repository is currently signed with a temporary test key. Generate the real key and set this repo's `APT_ARCHIVE_SIGNING_KEY` and `APT_ARCHIVE_PASSPHRASE` secrets, following [apt/README.md](apt/README.md#archive-signing-key).
- [x] **Actions variables on luci-ros2-sdk**, from the `sdk-site-stack` outputs:
  - `AWS_DEPLOY_ROLE_ARN` = `publish-role-arn` (`arn:aws:iam::439948611370:role/luci-sdk-publish`)
  - `SDK_SITE_BUCKET` = `bucket-name` (`luci-sdk-site`)
  - `SDK_SITE_DISTRIBUTION_ID` = `distribution-id` (`E204ZEINOLYPXO`)
- [x] **Actions variables on the package repos** (luci-ros2-msgs, -grpc, -transforms, -third-party, -keyboard-teleop):
  - `AWS_DEPLOY_ROLE_ARN` = `ros2-pool-upload-role-arn` (`arn:aws:iam::439948611370:role/luci-sdk-ros2-pool-upload`)
  - `SDK_SITE_BUCKET` = `bucket-name` (`luci-sdk-site`)
- [x] **GitHub App permissions.** The package repos start `Publish Apt Index` here with a token from the app behind the org `APP_ID`/`APP_PRIVATE_KEY` secrets. That app needs the **Actions: write** permission, and an org owner has to approve the change.
- [x] **GHCR access.** On the `luci-ros2-sdk` and `luci-sdk-development-image` packages, under Package settings → Manage Actions access, give `luci-ros2-sdk` the **Write** role so `Create and Deploy Docker` can push.
- [x] **Unused GHCR package.** Delete the `sdk-docs-deployment` package; the docs workflows no longer use a container.

## 3. Merge order

1. [ ] aws-dev-infrastructure: the SDK site PR. Its stacks are already deployed from the PR branch.
2. [ ] luci-sdk-docs: the site migration PR, then the branding PR stacked on it. Both have to be on `main` before luci-ros2-sdk merges, because merging luci-ros2-sdk starts `Create Next Documentation`, which builds with luci-sdk-docs' `main` config.
3. [ ] luci-ros2-sdk: this PR.
4. [ ] Package repos: luci-ros2-msgs, luci-ros2-grpc, luci-ros2-transforms, luci-ros2-third-party, luci-ros2-keyboard-teleop.
5. [ ] encoder-to-odom-library: `remove-conan` (can merge at any point).

Stacked PRs retarget to `main` automatically only if the branch under them is deleted when it merges.

## 4. After merging

- [ ] Run `Publish Apt Index`. It re-signs the index with the real key.
- [ ] Run `Create Next Documentation` and check <https://sdk.luci.com/ros2/docs/next/>, including the new [Moving from JFrog](https://sdk.luci.com/ros2/docs/next/Installation/moving-from-jfrog) page.
- [ ] Run `Deploy Landing Page` and check <https://sdk.luci.com/>.
- [ ] Check that an old <https://lucimobility.github.io/luci-sdk-docs/> link redirects to the same page on `sdk.luci.com`.
- [ ] Make a patch release of one package repo. Check that its `.deb` lands in the pool, that `Publish Apt Index` runs, and that `apt policy` shows the new version.

## 5. Release and announce

- [ ] Release the SDK. `release-docs` publishes the docs with the Moving from JFrog page, and `Create and Deploy Docker` (RELEASE) rebuilds `ghcr.io/lucimobility/luci-ros2-sdk:latest` from `release/Dockerfile`, which installs from the new apt repository. The GHCR images until then are copies of the JFrog ones and still install from Artifactory.
- [ ] In a clean Ubuntu 22.04 machine or container, follow the Moving from JFrog page from an old JFrog setup and check `apt update` and the pinned installs.
- [ ] Send the announcement email below, with the release version filled in.

### Announcement email

> **Subject:** LUCI ROS2 SDK [version]: new home for packages, Docker images and docs
>
> Hi everyone,
>
> LUCI ROS2 SDK [version] is out, and with it the SDK has moved off JFrog Artifactory. Everything now lives at **https://sdk.luci.com**:
>
> - **Documentation:** https://sdk.luci.com/ros2/docs/ (old GitHub Pages links redirect there)
> - **Apt repository:** https://sdk.luci.com/ros2/apt
> - **Docker images:** `ghcr.io/lucimobility/luci-ros2-sdk` and `ghcr.io/lucimobility/luci-sdk-development-image` (public, no login needed)
>
> **What you need to do.** If you installed the SDK packages with apt, or use the LUCI Docker images, switch to the new locations: the old JFrog repository and images no longer get updates and will be shut down. Your installed packages don't need to be reinstalled; the new repository has every version that was on JFrog.
>
> - **Apt:** replace the old repository and key with the new ones, then run `sudo apt update`. The commands are on the Moving from JFrog page: https://sdk.luci.com/ros2/docs/Installation/moving-from-jfrog
> - **Docker:** pull `ghcr.io/lucimobility/luci-ros2-sdk:latest` and replace `luci.jfrog.io/ros2-sdk-docker-local/` with `ghcr.io/lucimobility/` in your `docker run` commands, Dockerfiles and scripts.
>
> If anything doesn't work after switching, reply to this email or contact info@luci.com.
>
> Thanks,
> The LUCI team

## 6. Retire JFrog

- [ ] Search the org for remaining `luci.jfrog.io` references.
- [ ] Move luci-safety off the `luci-conan` remote. It still pulls `encoder-to-odom` from there with Conan.
- [ ] Remove the `JF_URL` and `ARTIFACTORY_TOKEN` org secrets.
- [ ] Delete the `ros2-sdk-packages`, `ros2-sdk-docker-local` and `luci-conan` repositories in Artifactory, after giving users time to switch following the announcement.

## Later

- [ ] Fold luci-sdk-docs into this repo. It still holds the Docusaurus project and the versioned docs snapshots, which `build-docs.sh` commits back on every release. Once the project lives here, keep luci-sdk-docs only for the GitHub Pages redirect, then archive it.
- [ ] Renew the archive signing key before it expires.
