#!/bin/bash

set -ex

export ZED_LAKE=https://shasta.lake.brimdata.io

zed auth verify
zed ls github-metrics || zed create -orderby ts:desc github-metrics
curl https://api.github.com/repos/brimdata/zed/releases?per_page=5 \
| zq -I releases.zed - \
| zed load -use github-metrics -
