#!/bin/bash
# export ZED_LAKE=https://shasta.lake.brimdata.io

zed auth verify
zed ls github-metrics || zed create -orderby ts:desc github-metrics
