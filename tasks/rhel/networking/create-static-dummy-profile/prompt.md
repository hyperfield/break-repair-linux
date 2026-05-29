# Create Static Dummy Profile

Using NetworkManager, create and activate a connection profile with this target state:

- connection name: `lab-static`
- interface name: `dummy0`
- type: `dummy`
- IPv4 address: `198.51.100.20/24`
- gateway: `198.51.100.1`
- DNS server: `198.51.100.53`
- IPv6 disabled
- autoconnect enabled
