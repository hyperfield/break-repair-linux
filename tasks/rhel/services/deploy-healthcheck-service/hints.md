# Deploy Healthcheck Service

- A oneshot service needs one extra setting if you want `systemctl is-active` to stay `active`.
- Check both the unit properties and the side effect file after you start the service.
