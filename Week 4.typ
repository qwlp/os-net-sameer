#import "prelude.typ": *;
#show: styling


== The Internet

- The internet connects millions of devices/hosts, they are connect with
  packets.
- To send info, it is first parsed through (packets), including header info
- Packets are then sent through the network to their destination using routers
  and link-layer switches.

#table(
  columns: (1fr, 1fr),
  stroke: none,
  [*Switch*], [*Router*],
  [Operates at the Data Link Layer (Layer 2).],
  [Operates at the Network Layer (Layer 3).],

  [Connects devices within the same network.],
  [Connects multiple different networks.],

  [Uses MAC addresses for forwarding.], [Uses IP addresses for routing.],
)

Given the millions of ISPs, that exists, how do we connect them together?

- Tier-1 ISPs connect to each other through private peering points or Internet
  Exchange Points (IXPs) as a "network of networks."
- Today: about a dozen Tier-1 ISPs
  - Ex: AT&T (AS7018), Level 3 (AS3356, AS3549), Deutsche Telekom (AS3320)
- Lower tiers (Tier-2/Tier-3) obtain transit by paying Tier-1 ISPs to access the
  rest of the internet.

These numbers are ASN, Autonomous System Number, it's like an ID number for a
network on the internet.

An Autonomous System (AS) is basically a large network controlled by one
organization, like:
- an Internet provider
- a university
- a big company
- a cloud provider

You -> Regional ISP -> Global ISP

Examples of regional networks in the UK:
- British Telecom
- KCOM Group
- Vodafone

== Protocols

- A protocol is like a language shared between two people. If you speak English
  and the other person speaks only French, communication fails. Similarly, two
  computers must agree on the same "language" (rules, timing, and format) to
  successfully exchange data.

=== Five-layer Internet Protocol Stack

- Application Layer: Where network applications (web browsers, email) live
  (e.g., HTTP, SMTP).
- Transport Layer: Handles end-to-end data transfer and reliability (e.g., TCP,
  UDP).
- Network Layer: Manages packet routing and addressing across different networks
  (e.g., IP).
- Link Layer: Manages data transfer between neighboring network nodes (e.g.,
  Ethernet, Wi-Fi).
- Physical Layer: Transmits raw bits over a physical medium (e.g., cables,
  fiber, radio waves).

== Physical Media

- Guided media: signals that propagate in solid media. Ex: copper, fibre, co-ax
- Unguided media: signals that propagate freely. Ex: radio, microwave
