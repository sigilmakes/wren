# Build the site for forgejo pages: https://pages.sigilzero.dev/sigilzero/wren/
#
# The nix-runner container has nix + internet but no /usr/bin/env — invoke with
# `shell: bash` and plain commands. Node comes from nixpkgs; SITE_BASE_URL is
# set to /sigilzero/wren/ so asset paths match the pages mount point.
set -euo pipefail

export SITE_BASE_URL="/sigilzero/wren/"

echo "── node ──"
if command -v nix >/dev/null 2>&1; then
    nix shell nixpkgs#nodejs_22 --command bash -c '
        set -e
        echo "── npm ci ──"
        npm ci
        echo "── nuxt generate ──"
        npm run generate
    '
else
    # ubuntu-style image: node is preinstalled
    npm ci
    npm run generate
fi

echo "── output ──"
ls .output/public | head