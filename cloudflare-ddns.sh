#!/bin/bash

# Forked from lifehome/systemd-cfddns/src/cfupdater-v4

# CHANGE THESE
auth_email="mail@example.com"            # The email used to login 'https://dash.cloudflare.com'
auth_key="xxxxx"   # Top right corner, go to "My profile" > "API token" and generate new token allowing access to read and edit DNS.
zone_identifier="xxxxx" # Can be found in the "Overview" tab of your domain
record_name="foo.example.com"                     # Which record you want to be synced
keep_log=true

# Fetch Global IP address
ip=$(curl -s inet-ip.info)

# Seek for the current record on Cloudflare
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" \
	-H "Authorization: Bearer $auth_key" \
	-H "Content-Type: application/json")

# Can't do anything without the record
record_count=$(echo $record | jq -r '.result_info.count')
if [[ $record_count == 0 ]]; then
	>&2 echo "[Cloudflare DDNS] Record does not exist, perhaps create one first?"
	exit 1
fi

# Extract existing IP address from the fetched record
old_ip=$(echo $record | jq -r '.result[0].content')
echo "[Cloudflare DDNS] Currently set to $old_ip"

# Compare if they're the same
if [ "$ip" == "$old_ip" ]; then
	echo "[Cloudflare DDNS] IP address has not changed."
	exit 0
fi

# Extract record identifier from result
record_identifier=$(echo $record | jq -r '.result[0].id')

# Update IP address through Cloudflare API
update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" \
	-H "Authorization: Bearer $auth_key" \
	-H "Content-Type: application/json" \
	--data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"ttl\":1}")

# Log IP address if it has changed
if "${keep_log}"; then
	currenttime=$(date '+%Y-%m-%dT%H:%M%z')	
	echo "$currenttime, $ip" >> ip-address.txt
fi

# Result
success=$(echo $update | jq -r '.success')

case "$success" in
"true")
	echo "[Cloudflare DDNS] IPv4 context '$ip' has been synced to Cloudflare.";;
*)
	>&2 echo "[Cloudflare DDNS] Update failed for $record_identifier. DUMPING RESULTS:\n$update"
	exit 1;;
esac
