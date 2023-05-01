# cloudflare-ddns
Update Cloudflare DNS record with shell script on EdgeRouter X

Forked from [lifehome/systemd-cfddns/src/cfupdater-v4](https://github.com/lifehome/systemd-cfddns/blob/master/src/cfupdater-v4)

## Use case
This script is intended to be used for specific needs:
- Upstream router before EdgeRouter X runs NAT
- EdgeRouter X itself does not have a global IPv4 address on any interfaces

Although EdgeRouter X has [build-in Dynamic DNS client](https://help.ui.com/hc/en-us/articles/204952234-EdgeRouter-Built-in-Dynamic-DNS), it does not work in an environment where its interface does not have global IPv4 address.

## Setup
- Update settings in the script
	- `auth_key`: Top right corner, go to "My profile" > "API token" and generate new token allowing access to read and edit DNS.
	- `zone_identifier`: Can be found in the "Overview" tab of your domain
	- `record_name`: Domain which you want to update the A record
	- `keep_log`: Whether or not you want to keep IP address changes as log (true/false)
- Copy script to EdgeRouter `/config/scripts`.
- Update permission on EdgeRouter: `chmod 755 cloudflare-ddns.sh`
- Set task scheduler
```
configure
set system task-scheduler task cloudflare-ddns executable path /config/scripts/cloudflare-ddns.sh
set system task-scheduler task cloudflare-ddns interval 15m
commit; save; exit;
```
- Confirm scheduled task
```
configure
show system task-scheduler
exit
```
