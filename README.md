# cloudflare-ddns
Update Cloudflare DNS record with shell script on EdgeRouter X

Forked from [lifehome/systemd-cfddns/src/cfupdater-v4](https://github.com/lifehome/systemd-cfddns/blob/master/src/cfupdater-v4)

## Use case
This script is intended to be used for specific needs:
- Upstream router before EdgeRouter X runs NAT
- EdgeRouter X itself does not have a global IPv4 address on any interfaces

Although EdgeRouter X has [build-in Dynamic DNS client](https://help.ui.com/hc/en-us/articles/204952234-EdgeRouter-Built-in-Dynamic-DNS), it does not work in an environment where its interface does not have global IPv4 address.

## Setup
Fill out in the header of the script

- auth_email: The email used to login 'https://dash.cloudflare.com
- auth_key: Top right corner, "My profile" > "Global API Key"
- zone_identifier: Can be found in the "Overview" tab of your domain on the right side on the lower half of the page
- record_name: Domain on which you want to update the A record

Copy the script with (win)scp to /config/scripts of your router.

Make it executable: `sudo chmod 0755 /config/scripts/cloudflare-ddns.sh`

Schedule task:
```
configure
set system task-scheduler task cloudflare-ddns executable path /config/scripts/cloudflare-ddns.sh
set system task-scheduler task cloudflare-ddns interval 1m
show system task-scheduler
commit-confirm
confirm
save
```


Check scheduled task:
```
configure
show system task-scheduler
exit
```

