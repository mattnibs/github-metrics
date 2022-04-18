#!/bin/bash
set -e

function checkcmd() {
	cmd=$1
	if ! command -v $cmd &> /dev/null; then
		echo >&2 "$cmd could not be found"
		exit
	fi
}

checkcmd curl
checkcmd $HOME/go/bin/zed
checkcmd $HOME/go/bin/zq

echo "Enter your github access token:"
read -s GITHUB_TOKEN
if ! curl -f -I https://api.github.com -H "Authorization: token $GITHUB_TOKEN" &> /dev/null; then
	echo >&2 "invalid github auth token"
	exit 1
fi

echo "Enter the desired lake url:"
read ZED_LAKE
if ! zed auth verify &> /dev/null; then
	cat <<EOF

Not authorized for lake $ZED_LAKE.
Please authenticate by running this command:
    
    zed auth -lake $ZED_LAKE login

When successfully complete rerun install.sh.
EOF
	exit 1
fi

dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

cat <<EOF > cron
GITHUB_TOKEN=$GITHUB_TOKEN
ZED_LAKE=$ZED_LAKE
PATH=/usr/bin:/bin:/usr/local/bin:$HOME/bin/go
EOF

sed -e "s/USER/$(whoami)/" cron.tmpl \
| sed -e "s+GITHUB_METRICS_PATH+$dir+" >> cron

cat << EOF
Success! Next assign the correct file permissions and copy the cron file in
this directory into /etc/cron.d:

    sudo chown root cron && sudo chmod 0644 cron
    sudo mv cron /etc/cron.d/github-metrics

EOF
