# Lab 13 Kathara Guide: The Network Layer and IPv4 Addressing

## Objectives

By the end of this lab, you should be able to:

1. Configure and run a multi-machine Kathara lab.
2. Explain how IPv4 addresses are used to route datagrams.
3. Configure Linux hosts with `ip`, `/etc/network/interfaces`, and `ifup`.
4. Place several hosts on the same subnet.
5. Explain how netmasks, VLSM, and CIDR notation define the network
   and host portions of an IPv4 address.

## Before You Start

This lab assumes that you already know how to:

1. Start a coordinated group of virtual machines from a `lab.conf` file.
2. Stop and clean up lab machines.
3. Use `ip` and `ping` inside Linux virtual machines.
4. Capture packets with `tcpdump`.
5. Open packet captures in Wireshark on the host machine.

Keep accurate notes as you work. Record the commands you run, their
outputs, any configuration files you edit, and your answers to the
questions in this guide.

Read each step carefully. This lab depends on earlier configuration
steps, so skipping one step can make later results misleading.

## IPv4 Addressing Background

IPv4 is the most common version of the Internet Protocol. Each device on
an IPv4 network has an address in dotted decimal form, such as:

```text
192.168.1.10
```

Part of the address identifies the network. The remaining part identifies
the host on that network. CIDR notation, such as `/24` or `/26`, states
where the split between the network and host portions occurs.

For example:

```text
146.227.150.64/26
```

means that the first 26 bits identify the network, and the remaining bits
identify hosts inside that network.

## 1. Create the Lab Directory

Create a working directory for lab 13:

```sh
cd ~
mkdir -p ctec1704/lab_13
cd ctec1704/lab_13
```

Download `netkit_lab_13.tar.xz` from Blackboard into this directory.
Although the archive was originally built for Netkit, Kathara can use the
same style of lab directory and `lab.conf` file in many teaching labs.

Extract the archive:

```sh
tar -xvf netkit_lab_13.tar.xz
```

Make sure the files and machine directories are directly inside
`~/ctec1704/lab_13`, not inside an extra nested subdirectory.

List the contents:

```sh
ls -l
```

You should see `lab.conf` and one directory for each virtual machine.
Some directories may be empty, while others may contain configuration
files.

## 2. Inspect the Lab Topology

Open `lab.conf` and inspect the topology:

```sh
less lab.conf
```

The lab represents nine hosts and five gateways or routers. The original
worksheet labels the subnets as `W`, `X`, `Y`, `Z`, and `D`.

Draw the topology in your notes before you start the lab. Annotate it as
you discover:

1. The machines on each subnet.
2. The interfaces connected to each subnet.
3. The IPv4 address on each interface.
4. The netmask or CIDR prefix.
5. The broadcast address.

The lab uses hubs rather than switches. Make a note explaining the
difference between a hub and a switch, especially how each handles frames
sent by one connected host.

## 3. Start the Kathara Lab

From inside the lab directory, start all machines:

```sh
kathara lstart
```

List the running machines:

```sh
kathara list
```

If your Kathara installation supports opening terminals automatically,
arrange the windows so that they match the topology diagram in your
notes.

To open a shell on a specific machine, use:

```sh
kathara connect MACHINE_NAME
```

For example:

```sh
kathara connect gww
```

## 4. Record the Existing Network Configuration

For each subnet, inspect every connected host or gateway interface.

On a machine such as `gww`, show the configuration of `eth0`:

```sh
ip addr show dev eth0
```

Record:

1. The interface name.
2. The IPv4 address.
3. The CIDR prefix or netmask.
4. The broadcast address.
5. How the machine received that address.

Repeat this for all relevant machines and interfaces on subnets `W`, `X`,
`Y`, `Z`, and `D`.

Also inspect the routing table on each gateway:

```sh
ip route
```

Record the routes and identify which interface each route uses.

## 5. Capture Traffic on a Subnet

Create a captures directory on your host if you do not already have one:

```sh
mkdir -p ~/ctec1704/captures
```

Connect to the gateway for the subnet you want to observe. For subnet
`W`, connect to `gww`:

```sh
kathara connect gww
```

Inside `gww`, start a packet capture on `eth0`:

```sh
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/ip-dumpW1.pcap
```

Leave this running while you generate traffic.

## 6. Ping Between Hosts on the Same Subnet

Open a shell on one host in the same subnet and ping another host in that
subnet:

```sh
ping TARGET_IP_ADDRESS
```

After a few replies, stop the `tcpdump` capture with `Ctrl-c`.

Open the capture on the host machine with Wireshark:

```sh
wireshark ~/ctec1704/captures/ip-dumpW1.pcap
```

In your notes, identify:

1. The ICMP echo request.
2. The ICMP echo reply.
3. The source and destination IPv4 addresses.
4. The source and destination MAC addresses.
5. Whether ARP traffic was needed before the ping succeeded.

## 7. Compare Wireshark With RFC 791

Look up the IPv4 header format in RFC 791.

Choose one captured ping packet in Wireshark and compare the IPv4 header
fields with the RFC. Record the values you see for:

1. Version.
2. Header length.
3. Total length.
4. Identification.
5. Flags.
6. Fragment offset.
7. Time to live.
8. Protocol.
9. Header checksum.
10. Source address.
11. Destination address.

Explain how Wireshark presents those fields and how they correspond to
the RFC diagram.

## 8. Change Subnet W at Runtime

Modify the running machines on subnet `W` so that they are all on:

```text
146.227.150.64/26
```

Use `ip addr` commands inside each relevant machine. The exact addresses
must be valid host addresses inside the `/26` subnet.

For example, if `m1`, `m2`, and `gww` are on subnet `W`, you might use
addresses such as:

```text
m1   146.227.150.65/26
m2   146.227.150.66/26
gww  146.227.150.67/26
```

On each machine, replace the existing address on the correct interface:

```sh
ip addr flush dev eth0
ip addr add ADDRESS/PREFIX dev eth0
ip link set eth0 up
```

For example:

```sh
ip addr flush dev eth0
ip addr add 146.227.150.65/26 dev eth0
ip link set eth0 up
```

Test connectivity with `ping`.

Answer this question in your notes:

```text
Why can the machines not be placed on 146.227.150.64/25?
```

Hint: calculate the network address range for `146.227.150.64/25` and
check whether `.64` is a valid `/25` network address.

## 9. Restore the Original Configuration

Stop the affected machines and start them again from the lab files.

For a Kathara lab, stop selected machines with:

```sh
kathara lclean --machines m1,m2,gww
```

Then start them again:

```sh
kathara lstart --machines m1,m2,gww
```

If your installed Kathara version does not support `--machines`, stop and
restart the full lab instead:

```sh
kathara lclean
kathara lstart
```

Check the restored addresses:

```sh
ip addr
ip route
```

## 10. Add an Extra Machine

Add a new machine named `foo` to subnet `X`.

Record every change you make. You should need to:

1. Edit `lab.conf`.
2. Create a `foo` directory.
3. Configure one Ethernet interface for `foo`.
4. Give `foo` an IPv4 address on subnet `X`.
5. Start or restart the lab.
6. Test connectivity with other machines on subnet `X`.

Create the machine directory:

```sh
mkdir foo
```

Edit `lab.conf` and add `foo` with one Ethernet interface attached to the
same collision domain or link as subnet `X`.

Then configure `foo` using the same pattern as the existing machines.
Depending on how the lab is structured, this may involve creating an
interface configuration file under `foo/etc/network/interfaces`.

After editing, restart the lab:

```sh
kathara lclean
kathara lstart
```

Connect to `foo`:

```sh
kathara connect foo
```

Check the interface:

```sh
ip addr
ip route
```

Ping another machine on subnet `X`:

```sh
ping TARGET_IP_ADDRESS
```

## 11. Extension: Duplicate an IP Address

Give two machines on the same subnet the same IPv4 address.

Test what happens when you:

1. Ping the duplicated address.
2. Capture traffic with `tcpdump`.
3. Inspect ARP traffic in Wireshark.
4. Check the ARP cache with `ip neigh`.

Record the symptoms and explain why duplicate IPv4 addresses cause
unreliable behaviour.

Restore the correct configuration before continuing.

## 12. Extension: Break and Diagnose the Lab

Make one or two small configuration changes so that the lab is slightly
broken. For example:

1. Use the wrong netmask on one host.
2. Configure an incorrect default gateway.
3. Put one interface on the wrong link in `lab.conf`.
4. Assign an address outside the intended subnet.

Ask a colleague to identify and fix the problem using commands such as:

```sh
ip addr
ip route
ip neigh
ping
tcpdump
```

Record the fault, the symptoms, and the fix.

## 13. CIDR Spreadsheet Task

Open the CIDR spreadsheets provided with the lab materials. They may be
available in both Excel and ODF formats.

Explain exactly what the spreadsheets show. Your answer should cover:

1. How a CIDR prefix maps to a netmask.
2. How many host bits remain for each prefix.
3. How many usable host addresses are available.
4. How network and broadcast addresses are derived.
5. How changing the prefix changes the subnet size.

## 14. Clean Up

When you have finished, stop the Kathara lab:

```sh
kathara lclean
```

Check that no lab machines are still running:

```sh
kathara list
```

Keep your notes, packet captures, topology diagram, and answers for
revision.

## Command Reference

Common Kathara commands used in this lab:

```sh
kathara lstart
kathara lclean
kathara list
kathara connect MACHINE_NAME
```

Common Linux network commands used inside machines:

```sh
ip addr
ip addr show dev eth0
ip addr flush dev eth0
ip addr add ADDRESS/PREFIX dev eth0
ip link set eth0 up
ip route
ip neigh
ping TARGET_IP_ADDRESS
tcpdump -s0 -i eth0 -w OUTPUT_FILE.pcap
```
