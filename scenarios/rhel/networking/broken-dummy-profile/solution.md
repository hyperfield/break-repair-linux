# Broken Dummy Profile

This is a contained NetworkManager exercise. The host's real network can stay
online while the `lab-broken` dummy profile has incorrect settings.

1. Inspect the `lab-broken` profile with `nmcli connection show lab-broken`.
2. Correct the IPv4 address, gateway, and DNS server.
3. Disable IPv6 for the profile and bring the connection back up.
4. Confirm the final values and active state with `nmcli`.
