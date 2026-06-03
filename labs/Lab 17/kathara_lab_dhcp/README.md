# Lab 17: Configuring and Using DHCP with Kathara

## Objectives

By the end of this lab you should be able to:

- configure a simple ISC DHCP server;
- start client machines that request IPv4 addresses from DHCP;
- capture and analyse a DHCP conversation;
- explain the DHCP Discover, Offer, Request, Acknowledge cycle;
- recognise how short DHCP leases are renewed;
- control client MAC addresses and observe their effect on DHCP leases.

## Topology

The lab uses one Ethernet segment named `lan`.

| Machine | Interface | Initial role | Addressing |
| --- | --- | --- | --- |
| `dhcp_server` | `eth0` | DHCP server | Static `172.16.12.253/24` |
| `dhcp_client_1` | `eth0` | DHCP client | DHCP lease |
| `dhcp_client_2` | `eth0` | DHCP client | DHCP lease |

The DHCP pool is:

```text
172.16.12.65 - 172.16.12.150
```

The server advertises:

- subnet mask: `255.255.255.0`;
- broadcast address: `172.16.12.255`;
- router/default gateway: `172.16.12.254`;
- default lease time: `30` seconds;
- maximum lease time: `60` seconds.

The configured router address is intentionally not assigned to a running router in this lab. It is included so you can inspect the router DHCP option in packet captures.

## Files

```text
.
|-- lab.conf
|-- Dockerfile
|-- dhcp_server.startup
|-- dhcp_client_1.startup
|-- dhcp_client_2.startup
|-- dhcp_server/
|   `-- etc/
|       |-- default/
|       |   `-- isc-dhcp-server
|       `-- dhcp/
|           `-- dhcpd.conf
|-- dhcp_client_1/
|-- dhcp_client_2/
`-- captures/
```

Kathara copies each machine directory into that machine when the lab starts. For example, files under `dhcp_server/etc/dhcp/` appear as `/etc/dhcp/` inside the `dhcp_server` container.

## Prerequisites and Lab Image

You need:

- Kathara installed and working;
- Docker available to build the lab image;
- a terminal in this lab directory;
- Wireshark on the host if you want to inspect packet captures graphically.

This lab uses a small Docker image named `lab17-dhcp:latest`, based on `kathara/base`, with the DHCP and capture tools installed.

Build it once from this directory:

```bash
docker build -t lab17-dhcp:latest .
```

The image provides:

- `isc-dhcp-server` on `dhcp_server`;
- `isc-dhcp-client` or `dhclient` on the clients;
- `tcpdump` for packet capture.

## Start the Lab

From this directory, start the complete lab:

```bash
kathara lstart
```

Kathara reads `lab.conf`, creates the three machines, connects them all to `lan`, and runs each `.startup` file.

Open shells to the machines:

```bash
kathara connect dhcp_server
kathara connect dhcp_client_1
kathara connect dhcp_client_2
```

You can also run one-off commands from the host:

```bash
kathara exec dhcp_server -- ip addr show dev eth0
kathara exec dhcp_client_1 -- ip addr show dev eth0
```

## Check the Initial State

On `dhcp_server`, check the server address:

```bash
ip addr show dev eth0
```

You should see `172.16.12.253/24`.

Check that the DHCP configuration file is present:

```bash
cat /etc/dhcp/dhcpd.conf
```

Check that the DHCP service or daemon is running:

```bash
systemctl status isc-dhcp_server.service
```

If `systemctl` is not available in your Kathara image, use:

```bash
ps aux | grep '[d]hcpd'
```

On each client, check the assigned address:

```bash
ip addr show dev eth0
```

The clients should receive addresses from the configured pool, normally starting at `172.16.12.65`.

## Understand the DHCP Server Configuration

Open `dhcp_server/etc/dhcp/dhcpd.conf` on the host or `/etc/dhcp/dhcpd.conf` inside the server.

Important lines:

```text
authoritative;
```

This tells clients that this DHCP server is authoritative for the subnet. If a client asks to keep an unsuitable address, the server can reject it with DHCPNAK.

```text
subnet 172.16.12.0 netmask 255.255.255.0
```

This declares the network served by this DHCP configuration.

```text
range 172.16.12.65 172.16.12.150;
```

This is the address pool. The server can lease addresses from this range to DHCP clients.

```text
default-lease-time 30;
max-lease-time 60;
```

These deliberately short lease times make renewal traffic easy to observe during the lab.

## Questions

Answer these in your lab notes:

1. What is significant about addresses in `172.16.0.0/12`?
2. How many host addresses are available in `172.16.12.0/24`?
3. Which addresses in this lab should not be leased to clients?
4. Why is the DHCP server address outside the pool?
5. Why can the server advertise `172.16.12.254` as a router even though no router VM exists?

## Manually Renew a Client Lease

On `dhcp_client_1`, release any current lease:

```bash
dhclient -r eth0
```

Remove any remaining IPv4 address if needed:

```bash
ip addr flush dev eth0
```

Request a new DHCP lease:

```bash
dhclient -v eth0
```

Check the result:

```bash
ip addr show dev eth0
ip route
```

Repeat the same process on `dhcp_client_2`.

## Capture DHCP Traffic

Start with a clean lab so the capture includes the clients' first DHCP requests:

```bash
kathara lclean
kathara lstart dhcp_server
```

Connect to the server:

```bash
kathara connect dhcp_server
```

Inside `dhcp_server`, start a capture:

```bash
tcpdump -i eth0 -s 0 -v -w /shared/dhcp1.pcap
```

In another host terminal, start the clients one at a time:

```bash
kathara lstart dhcp_client_1
kathara lstart dhcp_client_2
```

Leave `tcpdump` running long enough to catch initial leases and renewals. Because the lease time is short, a few minutes is enough.

Stop `tcpdump` with `Ctrl-C`.

The capture file should be available from the host in Kathara's shared directory for this lab. If your Kathara setup maps `/shared` differently, run:

```bash
kathara exec dhcp_server -- ls -l /shared
```

You can also write captures into a mounted host directory if your local Kathara setup provides one.

## Analyse DHCP in Wireshark

Open the capture in Wireshark and apply this display filter:

```text
bootp.option.type == 53
```

Wireshark still uses the historical BOOTP field name because DHCP extends BOOTP. DHCP message type option `53` identifies messages such as Discover, Offer, Request, and Acknowledge.

Find the DORA cycle:

| DHCP step | Typical source | Typical destination | Meaning |
| --- | --- | --- | --- |
| Discover | Client `0.0.0.0:68` | Broadcast `255.255.255.255:67` | Client asks for available DHCP servers |
| Offer | Server `172.16.12.253:67` | Client or broadcast `:68` | Server offers an address |
| Request | Client `0.0.0.0:68` | Broadcast `255.255.255.255:67` | Client requests the offered address |
| Acknowledge | Server `172.16.12.253:67` | Client or broadcast `:68` | Server confirms the lease |

Inspect these fields:

- client MAC address;
- offered client IP address;
- DHCP message type;
- DHCP server identifier;
- lease time;
- subnet mask option;
- router option;
- broadcast address option.

## Observe Lease Renewal

With a `30` second default lease, the clients will try to renew quickly.

In Wireshark, look for DHCP Request and Acknowledge messages after the first DORA exchange. Renewal normally uses Request and Acknowledge rather than repeating the full Discover, Offer, Request, Acknowledge sequence.

Answer in your notes:

1. Which DHCP messages appear during the initial lease?
2. Which DHCP messages appear during renewal?
3. Does renewal traffic use broadcast or unicast in your capture?
4. Which packet field shows the lease duration?

## Monitor DHCP Logs

On `dhcp_server`, inspect DHCP-related logs.

Depending on the Kathara image, messages may be in `/var/log/daemon.log`, `/var/log/syslog`, or only visible from the daemon output.

Try:

```bash
tail -f /var/log/daemon.log
```

If that file does not exist:

```bash
tail -f /var/log/syslog
```

Then renew a lease from a client:

```bash
dhclient -r eth0
dhclient -v eth0
```

Make notes on the log entries produced by the DHCP server.

## Client MAC Addresses

The client startup files manually set MAC addresses before requesting a lease:

```bash
ip link set dev eth0 address 02:0f:c9:02:02:02
ip link set dev eth0 up
dhclient -v eth0
```

`dhcp_client_1` uses:

```text
02:0f:c9:02:02:02
```

`dhcp_client_2` uses:

```text
02:0f:c9:04:04:04
```

Restart the clients and capture the traffic again:

```bash
kathara lclean
kathara lstart dhcp_server
kathara lstart dhcp_client_1
kathara lstart dhcp_client_2
```

Confirm in Wireshark that the client hardware addresses match the configured MAC addresses.

## Add a Third DHCP Client

Create a third client directory:

```bash
mkdir -p dhcp_client_3
```

Create `dhcp_client_3.startup`:

```bash
ip link set dev eth0 address 02:0f:c9:06:06:06
ip link set dev eth0 up
dhclient -v eth0
```

Add the client to `lab.conf`:

```text
dhcp_client_3[0]=lan
```

Add it to `lab.dep` so it starts after the server:

```text
dhcp_client_1 dhcp_client_2 dhcp_client_3: dhcp_server
```

Restart the lab:

```bash
kathara lclean
kathara lstart
```

Check the third lease:

```bash
kathara exec dhcp_client_3 -- ip addr show dev eth0
```

## Challenge 1: Add a Second DHCP Server

Create another server on the same `lan`, for example `dhcp_server_2`.

Use the same general `dhcpd.conf` settings, but give the two servers different non-overlapping pools:

```text
dhcp_server   range 172.16.12.65 172.16.12.100
dhcp_server_2 range 172.16.12.101 172.16.12.150
```

Capture traffic on both servers:

```bash
tcpdump -i eth0 -s 0 -v -w /shared/dhcp_server-1.pcap
tcpdump -i eth0 -s 0 -v -w /shared/dhcp_server_2.pcap
```

Analyse:

1. Did both servers send DHCP Offer messages?
2. Which server's offer did each client request?
3. Which server sent the final DHCP Acknowledge?
4. What does this tell you about running multiple DHCP servers on one subnet?

## Challenge 2: Static DHCP Leases

Research DHCP host declarations and configure fixed leases so:

- `dhcp_client_1` receives `172.16.12.10`;
- `dhcp_client_2` receives `172.16.12.20`.

Use their configured MAC addresses in the DHCP server configuration.

After editing `dhcpd.conf`, restart the lab and verify:

```bash
kathara lclean
kathara lstart
kathara exec dhcp_client_1 -- ip addr show dev eth0
kathara exec dhcp_client_2 -- ip addr show dev eth0
```

## Challenge 3: Client DHCP Options

Inspect the DHCP client configuration file:

```bash
cat /etc/dhcp/dhclient.conf
man dhclient.conf
```

Experiment with requesting different DHCP options from the server. Capture the traffic and compare the DHCP Parameter Request List option before and after your changes.

## Shut Down and Clean Up

Stop the lab:

```bash
kathara lhalt
```

Remove stopped containers and lab state:

```bash
kathara lclean
```

Use `lclean` before repeating capture tasks so old leases and old machine state do not confuse your observations.

## Review

Before the next lab session, make sure your notes include:

- the commands used to start, stop, and inspect the Kathara lab;
- the client addresses assigned by DHCP;
- a screenshot or written summary of the DORA packet sequence;
- the renewal messages seen after lease expiry;
- DHCP log entries from the server;
- the effect of manually setting client MAC addresses;
- answers to the challenge questions you attempted.
