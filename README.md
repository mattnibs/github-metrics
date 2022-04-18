# Github Metrics

This repo contains a collection of scripts for imported github metrics into a
Zed lake.

## Installation:

**Prerequisties:**

- Must have curl installed.
- Must have zed and zq installed and in the binary in $HOME/go/bin.
- Must have cron installed with the directory /etc/cron.d
- Must have access to shasta.lake.brimdata.io. Also zed should be authenticated
  to this endpoint.

**Steps:**

1. Clone this repository and cd into it. Make sure the repository is an a
   location it can remain.
2. Run the install script: `./install.sh`. You'll probably need to user super 
   user so the cron script can be installed at /etc/cron.d: `sudo ./install.sh`.

## Supported Metrics

Here are the github metrics currently supported:

### Release Download Counts

**type:** `release_asset`

https://docs.github.com/en/rest/reference/releases#list-releases

The total download count for each release assets. Since Github appears to update
this count whenever a download happens this metric is updated every two hours.

### Top Paths

**type:** `path`

https://docs.github.com/en/rest/reference/metrics#get-top-referral-paths

The top ten paths of the repository with their total view count and unique
visits. Counts are a sum of the past 14 days of traffic. This is updated once
daily.

### Top Referrers

**type:** `referrer`

https://docs.github.com/en/rest/reference/metrics#get-top-referral-sources

The top ten referrals to the repository with counts and unique visits. Counts 
and unique visits are the sum for the past 14 days. This is updated once every 
day.

### Total Page Views

**type:** `views`

https://docs.github.com/en/rest/reference/metrics#get-page-views

The total number of views and unique visits to the repository each day. Updated
daily.

### Total Clones

**type:** `clones`

https://docs.github.com/en/rest/reference/metrics#get-repository-clones

The total number of clones on the repository each day. Updated daily.
