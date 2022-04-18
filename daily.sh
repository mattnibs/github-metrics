#!/bin/bash
set -ex
source init.sh

touch /tmp/github-data
trap "rm /tmp/github-data; echo 'removed'" EXIT

# popular paths
curl https://api.github.com/repos/brimdata/zed/traffic/popular/paths -H "Authorization: token $GITHUB_TOKEN" \
| zq -I paths.zed - >> /tmp/github-data

# # referrers
curl https://api.github.com/repos/brimdata/zed/traffic/popular/referrers -H "Authorization: token $GITHUB_TOKEN" \
| zq -I referrers.zed - >> /tmp/github-data

# views
# Since the views endpoint returns the count for each day over the past 14 days,
# skip the days that we already have. 
last=$(zed query -z -use github-metrics 'nameof(this) == "views" | head 1 | yield ts')
curl https://api.github.com/repos/brimdata/zed/traffic/views -H "Authorization: token $GITHUB_TOKEN" \
| zq -I views.zed - \
| zq "\"$last\" == \"\" or ts > time(\"$last\")" - >> /tmp/github-data

# clones 
# Since the clones endpoint returns the count for each day over the past 14 
# days, skip the days that we already have.
last=$(zed query -z -use github-metrics 'nameof(this) == "clones" | head 1 | yield ts')
curl https://api.github.com/repos/brimdata/zed/traffic/clones -H "Authorization: token $GITHUB_TOKEN" \
| zq -I clones.zed - \
| zq "\"$last\" == \"\" or ts > time(\"$last\")" - >> /tmp/github-data

zed load -use github-metrics /tmp/github-data
