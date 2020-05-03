#!/bin/bash

# Forked from lifehome/systemd-cfddns/src/cfupdater-v4

# CHANGE THESE
auth_email="mail@hogehoge.com"            # The email used to login 'https://dash.cloudflare.com'
auth_key="xxxxx"   # Top right corner, "My profile" > "Global API Key"
zone_identifier="xxxxx" # Can be found in the "Overview" tab of your domain
record_name="fuga.hoge.com"                     # Which record you want to be synced

# Fetch Global IP address
ip=$(curl -s inet-ip.info)

# Seek for the current record on Cloudflare
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" \
	-H "X-Auth-Email: $auth_email" \
	-H "X-Auth-Key: $auth_key" \
	-H "Content-Type: application/json")

# Can't do anything without the record
if [[ $record == *"\"count\":0"* ]]; then
	>&2 echo -e "[Cloudflare DDNS] Record does not exist, perhaps create one first?"
	exit 1
fi

# Extract existing IP address from the fetched record
old_ip=$(echo $record | grep -o '"content": "[^"]*' | grep -o '[^"]*$' | head -1)
echo "[Cloudflare DDNS] Currently set to $old_ip"

# Compare if they're the same
if [ "$ip" == "$old_ip" ]; then
	echo "[Cloudflare DDNS] IP has not changed."
	exit 0
fi

# Extract record identifier from result
record_identifier=$(echo $record | grep -o '"id": "[^"]*' | grep -o '[^"]*$' | head -1)

# Update IP address through Cloudflare API
update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" \
	-H "X-Auth-Email: $auth_email" \
	-H "X-Auth-Key: $auth_key" \
	-H "Content-Type: application/json" \
	--data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"ttl\":1}")

# Log IP address if it has changed
currenttime=$(date '+%Y-%m-%dT%H:%M%z')
echo "$currenttime, $ip" >> ip-address.txt

# Result
success=$(echo $update | grep -o '"success": .*, "'| awk '{sub(",.*$",""); print $0 }' | awk '{sub("\"success\": ",""); print $0 }')

case "$success" in
"true")
	echo "[Cloudflare DDNS] IPv4 context '$ip' has been synced to Cloudflare.";;
*)
	>&2 echo -e "[Cloudflare DDNS] Update failed for $record_identifier. DUMPING RESULTS:\n$update"
	exit 1;;
esac
