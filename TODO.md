# TODO: SDK site migration (JFrog Artifactory → sdk.luci-guci.com)

Remaining work to move the SDK docs, apt repository and Docker images off JFrog Artifactory and GitHub Pages. The site itself (S3 + CloudFront) is defined in `aws-cdk/lib/sdk-site-stack.ts` in [aws-dev-infrastructure](https://github.com/lucimobility/aws-dev-infrastructure) and is already deployed. Delete this file once everything below is checked off.

## Before merging

- [ ] **Archive signing key.** The repository is currently signed with a temporary test key. Generate the real key and set this repo's `APT_ARCHIVE_SIGNING_KEY` and `APT_ARCHIVE_PASSPHRASE` secrets, following [apt/README.md](apt/README.md#archive-signing-key).
- [ ] **Actions variables on luci-ros2-sdk**, from the `sdk-site-stack` outputs:
  - `AWS_DEPLOY_ROLE_ARN` = `publish-role-arn`
  - `SDK_SITE_BUCKET` = `bucket-name`
  - `SDK_SITE_DISTRIBUTION_ID` = `distribution-id`
- [ ] **Actions variables on the package repos** (luci-ros2-msgs, -grpc, -transforms, -third-party, -keyboard-teleop):
  - `AWS_DEPLOY_ROLE_ARN` = `ros2-pool-upload-role-arn`
  - `SDK_SITE_BUCKET` = `bucket-name`
- [ ] **GitHub App permissions.** The package repos start `Publish Apt Index` here with a token from the app behind the org `APP_ID`/`APP_PRIVATE_KEY` secrets. That app needs the **Actions: write** permission, and an org owner has to approve the change.
- [ ] **GHCR access.** On the `luci-ros2-sdk` and `luci-sdk-development-image` packages, under Package settings → Manage Actions access, give `luci-ros2-sdk` the **Write** role so `Create and Deploy Docker` can push.
- [ ] **Unused GHCR package.** Delete the `sdk-docs-deployment` package; the docs workflows no longer use a container.

## Merge order

1. [ ] aws-dev-infrastructure: `sdk-site` branch (already deployed from the branch)
2. [ ] luci-sdk-docs. It has to go before luci-ros2-sdk: merging luci-ros2-sdk starts `Create Next Documentation`, which builds with luci-sdk-docs' `main` config and would publish pages with the old `/luci-sdk-docs/` base URL.
3. [ ] luci-ros2-sdk (this PR)
4. [ ] Package repos: luci-ros2-msgs, luci-ros2-grpc, luci-ros2-transforms, luci-ros2-third-party, luci-ros2-keyboard-teleop
5. [ ] encoder-to-odom-library: `remove-conan` (can merge at any point)

## After merging

- [ ] Run `Publish Apt Index`. It re-signs the index with the real key. Anyone who added the test key has to download the key again.
- [ ] Run `Create Next Documentation` and check <https://sdk.luci-guci.com/ros2/docs/next/>.
- [ ] Run `Deploy Landing Page` and check <https://sdk.luci-guci.com/>.
- [ ] Check that an old <https://lucimobility.github.io/luci-sdk-docs/> link redirects to the same page under `/ros2/docs/`.
- [ ] Make a patch release of one package repo. Check that its `.deb` lands in the pool, that `Publish Apt Index` runs, and that `apt policy` shows the new version.
- [ ] Release the SDK so the `luci-ros2-sdk` image on GHCR is rebuilt from `release/Dockerfile`, which installs from the new apt repository. The current GHCR images are copies of the JFrog ones and still install from Artifactory.
- [ ] Replace the placeholder copy in `landing/index.html` with the final marketing text.

## Move to sdk.luci.com

- [ ] In aws-dev-infrastructure, add a public hosted zone for `sdk.luci.com` and output its name servers.
- [ ] Have the luci.com DNS admin add `NS` records for `sdk` pointing at those name servers.
- [ ] Add `sdk.luci.com` to the certificate, the distribution's domain names and the alias records.
- [ ] Replace `sdk.luci-guci.com` with `sdk.luci.com` across the SDK repos, including:
  - `docusaurus.config.js` and the GitHub Pages redirect pages in luci-sdk-docs
  - `release/Dockerfile`
  - the docs, READMEs and `landing/`
- [ ] Decide whether `sdk.luci-guci.com` keeps serving the site or redirects.

## Retire JFrog

- [ ] Search the org for remaining `luci.jfrog.io` references.
- [ ] Move luci-safety off the `luci-conan` remote. It still pulls `encoder-to-odom` from there with Conan.
- [ ] Remove the `JF_URL` and `ARTIFACTORY_TOKEN` org secrets.
- [ ] Delete the `ros2-sdk-packages`, `ros2-sdk-docker-local` and `luci-conan` repositories in Artifactory.

## Later

- [ ] Fold luci-sdk-docs into this repo. It still holds the Docusaurus project and the versioned docs snapshots, which `build-docs.sh` commits back on every release. Once the project lives here, keep luci-sdk-docs only for the GitHub Pages redirect, then archive it.
- [ ] Renew the archive signing key before it expires.
