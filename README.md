# cloudflare-ddns
Update Cloudflare DNS record with shell script on EdgeRouter X
Forked from [lifehome/systemd-cfddns/src/cfupdater-v4](https://github.com/lifehome/systemd-cfddns/blob/master/src/cfupdater-v4)

## Use cases
This script is intended to be used for specific needs:
- Upstream router before EdgeRouter X runs NAT
- EdgeRouter X itself does not have a global IPv4 address on any interfaces

NOTE: Although EdgeRouter X has build-in Dynamic DNS client, it does not work with an environment where its interface does not have global IPv4 address.


