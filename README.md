# pay-egress

Alpine image that has squid installed.

Squid config is done via the `SQUID_CONFIG` environment variable.

## Usage

```
docker run -e "SQUID_CONFIG=$(cat /path/to/squid/config)" govukpay/egress
```
