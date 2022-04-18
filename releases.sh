#!/bin/bash

set -ex

source init.sh

curl https://api.github.com/repos/brimdata/zed/releases?per_page=5 \
| zq -I releases.zed - \
| zed load -use github-metrics -
