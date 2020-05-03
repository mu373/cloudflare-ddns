# cloudflare-ddns
Update Cloudflare DNS record with shell script on EdgeRouter X

Forked from [lifehome/systemd-cfddns/src/cfupdater-v4](https://github.com/lifehome/systemd-cfddns/blob/master/src/cfupdater-v4)

## Use case
This script is intended to be used for specific needs:
- Upstream router before EdgeRouter X runs NAT
- EdgeRouter X itself does not have a global IPv4 address on any interfaces

Although EdgeRouter X has [build-in Dynamic DNS client](https://help.ui.com/hc/en-us/articles/204952234-EdgeRouter-Built-in-Dynamic-DNS), it does not work in an environment where its interface does not have global IPv4 address.


