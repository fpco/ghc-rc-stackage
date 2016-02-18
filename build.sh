#!/usr/bin/env bash

set -eux

# Create stackage user inside container
useradd -u $USERID -d /fake-home stackage
export HOME=/fake-home

# Fix permissions on work directories
mkdir -p /fake-home /build
chown stackage /fake-home /build

# Change to the correct directory
cd /build

# Find out the latest nightly snapshot available
NIGHTLY=$(curl -i https://www.stackage.org/nightly | grep '^Location:' | sed 's@^Location: /@@' | sed 's@\r@@')

# Download the yaml file for that snapshot
curl https://raw.githubusercontent.com/fpco/stackage-nightly/master/$NIGHTLY.yaml > plan.yaml
chown stackage plan.yaml

# Prime the package index
sudo -u stackage stack update
mkdir tmp
chown stackage tmp
(cd tmp && sudo -u stackage stack unpack random)
rm -rf tmp

# Kick off the build. Some details on options:

# * plan-file is the input file downloaded above
# * docmap and bundle files are unused output files (for uploading only)
# * similarly, the target only affects upload
# * allow-newer and no-rebuild-cabal are special arguments for RC builds:
# ignore version bounds, and don't rebuild the Cabal library (we need the one
# bundled with GHC)
sudo -u stackage env "PATH=$PATH" "HOME=$HOME" stackage-curator make-bundle \
    --plan-file plan.yaml \
    \
    --docmap-file docmap.yaml \
    --bundle-file bundle.bundle \
    \
    --target nightly-$(date "+%Y-%m-%d") \
    \
    --allow-newer \
    --no-rebuild-cabal
