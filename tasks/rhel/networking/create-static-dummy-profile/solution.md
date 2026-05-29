# Create Static Dummy Profile

1. Create a NetworkManager dummy connection named `lab-static`.
2. Set the IPv4 address, gateway, and DNS server exactly as requested.
3. Disable IPv6 and enable autoconnect.
4. Bring the connection up and verify with `nmcli connection show lab-static` and `nmcli connection show --active`.
