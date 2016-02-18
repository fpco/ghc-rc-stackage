#!/usr/bin/env bash

set -eux

NIGHTLY=$(curl -i https://www.stackage.org/nightly | grep '^Location:' | sed 's@^Location: /@@' | sed 's@\r@@')
curl https://raw.githubusercontent.com/fpco/stackage-nightly/master/$NIGHTLY.yaml > plan.yaml

exec stackage-curator make-bundle \
    --plan-file plan.yaml \
    --docmap-file docmap.yaml \
    --bundle-file bundle.yaml \
    --target nightly-$(date "+%Y-%m-%d") \
    --allow-newer \
    --no-rebuild-cabal
