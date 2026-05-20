#set page(
  margin: (x: 22mm, y: 18mm),
)

#set text(
  font: "Liberation Sans",
  size: 11pt,
)

#set par(
  justify: true,
  leading: 0.62em,
)

#set heading(numbering: "1.")

#let bash(body) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  fill: luma(245),
  stroke: luma(205),
)[#raw(body, lang: "bash", block: true)]

#let plainblock(body) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  fill: luma(245),
  stroke: luma(205),
)[#raw(body, block: true)]

#let note(body) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  fill: luma(248),
  stroke: luma(180),
)[*Note:* #body]

#let question(body) = [
  *Question:* #body
]

#let figplaceholder(caption) = [
  #block(
    width: 100%,
    height: 90pt,
    inset: 10pt,
    radius: 4pt,
    fill: luma(245),
    stroke: luma(180),
  )[
    #align(center)[*Insert image here*]
  ]
  #emph(caption)
]

#align(center)[
  = Operating Systems & Networks

  == Lab Worksheet 11

  *The Application Layer — HTTP & Apache — the HTTP Request/Response Cycle*
  *Kathara edition*
]

#v(0.8em)

== This Lab's Objectives

1. Understand the structure of a Kathara lab.
2. Launch and manage a small multi-machine Kathara topology.
3. Observe and log HTTP communication between two virtual machines.
4. Analyse the HTTP request/response cycle.
5. Capture and inspect HTTP and TCP traffic with `tcpdump` and Wireshark.

== Expected Outcomes

After this laboratory session, students should be able to:

- create and launch a multi-machine Kathara lab;
- connect to running Kathara machines from the host;
- configure and test a simple client/web-server lab;
- capture HTTP traffic with `tcpdump`;
- inspect captured traffic with Wireshark;
- explain the steps in a complete HTTP request/response cycle.

== Workplan

These lab worksheets assume that you make accurate notes of everything you do
for later revision. Record:

- commands used;
- the purpose of each command;
- output and observations;
- answers to the questions posed in the worksheet.

You should complete any unfinished work before the next lab session.

== Starting Assumptions

You should already be able to:

- use basic Linux file and directory commands;
- start and stop Kathara labs;
- inspect network interfaces and addresses;
- use `ping`, `tcpdump`, and Wireshark;
- navigate between the host system and virtual machines;
- save files into the Kathara machine overlay directories.

#note[
  This worksheet assumes you are using Debian-based Kathara machines with the
  following tools available:

  - `apache2`
  - `apache2ctl`
  - `tcpdump`
  - `lynx`
  - `telnet` or `nc`
  - `nmap`

  If any of these are missing from your image, install them first or use a
  prepared image supplied by your tutor.
]

== Lab Layout and Files

A Kathara lab directory for this exercise will typically contain:

- one `lab.conf` file;
- one startup file per machine;
- one directory per machine, used as the filesystem overlay;
- optional subdirectories inside each machine directory for configuration files,
  web content, and captures.

For this lab we will use two machines:

- `web-client`
- `web-server`

== 1. Create the Lab Directory

On the host system:

#bash(
  "cd ~\nmkdir -p ctec1704/lab_11\ncd ctec1704/lab_11",
)

Create the machine directories:

#bash(
  "mkdir -p web-client web-server",
)

== 2. Create the Kathara Lab Files

Create `lab.conf`:

#bash(
  "gedit lab.conf &",
)

Add the following content:

#plainblock(
  "web-client[0]=lan\nweb-server[0]=lan",
)

Create `web-client.startup`:

#bash(
  "gedit web-client.startup &",
)

Add:

#plainblock(
  "ip addr add 192.168.150.1/24 dev eth0\nip link set eth0 up",
)

Create `web-server.startup`:

#bash(
  "gedit web-server.startup &",
)

Add:

#plainblock(
  "ip addr add 192.168.150.2/24 dev eth0\nip link set eth0 up",
)

== 3. Check the Directory Structure

List the directory contents:

#bash(
  "ls -l",
)

You should now have something similar to:

#plainblock(
  "lab.conf\nweb-client/\nweb-client.startup\nweb-server/\nweb-server.startup",
)

You can also use `tree`:

#bash(
  "tree",
)

#figplaceholder[Example `tree` output for the lab directory.]

== 4. Review the Configuration Files

Use `cat` to inspect each file:

#bash(
  "cat lab.conf\ncat web-client.startup\ncat web-server.startup",
)

Record the following in your notes:

- machine names;
- interface names;
- IP addresses;
- the shared network segment.

Draw a simple network diagram showing:

- `web-client` on `192.168.150.1/24`
- `web-server` on `192.168.150.2/24`
- both connected to `lan` via `eth0`

== 5. Start the Lab

From the `lab_11` directory on the host:

#bash(
  "kathara lstart",
)

Kathara starts the machines in the background. Unlike Netkit, this does not
usually open xterm windows automatically.

Open two host terminals and connect to each machine:

#bash(
  "kathara connect web-client",
)

In another host terminal:

#bash(
  "kathara connect web-server",
)

#note[
  If your local setup uses a slightly different workflow, for example wrapper
  scripts or an IDE integration, follow your local Kathara procedure for opening
  terminals on each machine.
]

== 6. Test Connectivity

From `web-client`, test connectivity to the server:

#bash(
  "ping -c 2 192.168.150.2",
)

From `web-server`, test connectivity back to the client:

#bash(
  "ping -c 2 192.168.150.1",
)

Record the results.

== 7. Starting the Apache Web Server

In Kathara containers, `systemd` is often not running, so this guide uses
`apache2ctl` rather than `systemctl`.

From `web-server`, first check whether Apache is already running:

#bash(
  "ps -ef | grep '[a]pache2'\nss -ltnp | grep ':80'",
)

If Apache is not running, start it:

#bash(
  "apache2ctl start",
)

Check again:

#bash(
  "ps -ef | grep '[a]pache2'\nss -ltnp | grep ':80'",
)

#question[
  What is a PID in this context?
]

Write your answer in your notes.

#figplaceholder[Apache running on the `web-server` machine.]

== 8. Inspect the Default Web Page

On `web-server`, locate the default web root:

#bash(
  "ls -l /var/www/html\ncat /var/www/html/index.html",
)

This directory is the web root of the site.

Record:

- the path to the default page;
- the file name of the default page;
- a short description of its contents.

== 9. Access the Web Page with Telnet

From `web-client`, connect to TCP port 80 on the web server:

#bash(
  "telnet 192.168.150.2 80",
)

If `telnet` is unavailable, use:

#bash(
  "nc 192.168.150.2 80",
)

You should see a connection message.

Now type the HTTP request manually:

#plainblock(
  "GET / HTTP/1.0",
)

Then press Enter twice to terminate the request headers with a blank line.

You should receive an HTTP response similar to:

#plainblock(
  "HTTP/1.1 200 OK\nDate: ...\nServer: Apache/...\nLast-Modified: ...\nETag: ...\nAccept-Ranges: bytes\nContent-Length: ...\nConnection: close\nContent-Type: text/html\n\n<html> ... </html>",
)

Analyse the separate parts of the request:

- `GET`
- `/`
- `HTTP/1.0`

Then analyse each response line, especially:

- the status line;
- `Date`;
- `Server`;
- `Content-Length`;
- `Connection`;
- `Content-Type`.

== 10. Apache Control Commands

From `web-server`, restart Apache if needed:

#bash(
  "apache2ctl restart",
)

To stop Apache:

#bash(
  "apache2ctl stop",
)

To start it again:

#bash(
  "apache2ctl start",
)

== 11. Remove the Apache ServerName Warning

Apache may warn that it cannot reliably determine the server's fully qualified
domain name.

In a Debian-style Apache setup, the cleanest fix is to add a config snippet
under `conf-enabled`.

Exit both Kathara machine consoles, then on the host create:

#bash(
  "mkdir -p web-server/etc/apache2/conf-enabled\n\
gedit web-server/etc/apache2/conf-enabled/servername.conf &",
)

Put the following into the file:

#plainblock(
  "ServerName 127.0.0.1",
)

Restart the lab so the new overlay file is used:

#bash(
  "kathara lclean\nkathara lstart",
)

Reconnect to `web-server` and start Apache again:

#bash(
  "kathara connect web-server",
)

Inside the machine:

#bash(
  "apache2ctl start",
)

Check whether the warning has disappeared.

== 12. Start Apache Automatically at Boot

Edit `web-server.startup` on the host and add `apache2ctl start` below the IP
commands:

#bash(
  "gedit web-server.startup &",
)

The file should now look like this:

#plainblock(
  "ip addr add 192.168.150.2/24 dev eth0\n\
ip link set eth0 up\n\
apache2ctl start",
)

Restart the lab:

#bash(
  "kathara lclean\nkathara lstart",
)

Reconnect to `web-server` and check whether Apache is already running:

#bash(
  "kathara connect web-server",
)

Inside the machine:

#bash(
  "ps -ef | grep '[a]pache2'\nss -ltnp | grep ':80'",
)

From `web-client`, check that you can still download the default page.

== 13. Other HTTP Methods

From `web-client`, connect again to the server:

#bash(
  "telnet 192.168.150.2 80",
)

Test the following methods one at a time:

#plainblock(
  "POST / HTTP/1.0",
)

#plainblock(
  "HEAD / HTTP/1.0",
)

#plainblock(
  "TRACE / HTTP/1.0",
)

For each one:

- press Enter twice after typing the request line;
- record the response;
- compare it with the `GET` response.

#question[
  How does the output from `HEAD` differ from the output from `GET`?
]

#question[
  What does `TRACE` return?
]

Now repeat with deliberate errors, for example:

#plainblock(
  "get / HTTP/1.0\nGeT / HTTP/1.0\nGET /missingpage HTTP/1.0\nGET / HTTP/9.9",
)

Observe how the response changes in each case.

== 14. Capture an HTTP Request/Response Cycle

Create a captures directory in the server overlay on the host:

#bash(
  "mkdir -p web-server/captures",
)

Start a packet capture on `web-server`:

#bash(
  "kathara connect web-server",
)

Inside the machine:

#bash(
  "tcpdump -v -i eth0 -s 0 -w /captures/http1.pcap",
)

Leave `tcpdump` running.

== 15. Use the Lynx Text-Based Browser

From another host terminal, connect to `web-client`:

#bash(
  "kathara connect web-client",
)

Inside `web-client`, launch `lynx`:

#bash(
  "lynx 192.168.150.2",
)

You should see the default web page in text form.

#figplaceholder[`lynx` showing the default web page.]

#question[
  Who might need a text-based browser, and why?
]

Exit `lynx`.

If you are unsure how to exit, try:

#plainblock(
  "Press q, then confirm.",
)

Return to the `web-server` terminal and stop `tcpdump` with `Ctrl+C`.

Open the capture on the host using Wireshark:

#bash(
  "wireshark web-server/captures/http1.pcap &",
)

== 16. Analyse the Capture in Wireshark

There should be roughly a small TCP conversation, often around a dozen packets.

Identify the packets that contain:

- the TCP three-way handshake;
- the HTTP request;
- the HTTP response;
- the response payload;
- the TCP connection close.

In Wireshark, inspect the TCP header and note the flag settings in:

- SYN
- SYN/ACK
- ACK
- FIN
- FIN/ACK

#figplaceholder[Wireshark analysis of the HTTP request/response cycle.]

Record:

- source and destination IP addresses;
- source and destination port numbers;
- sequence of protocol events;
- where the HTTP payload appears.

== 17. Replace the Default `index.html`

On the host, create your own page in the server overlay:

#bash(
  "mkdir -p web-server/var/www/html\n\
gedit web-server/var/www/html/index.html &",
)

Use this content:

#plainblock(
  "<html>\n\
<body>\n\
<h1>It works!</h1>\n\
</body>\n\
</html>",
)

Now extend it by adding a paragraph:

#plainblock(
  "<html>\n\
<body>\n\
<h1>It works!</h1>\n\
<p>Hello there!</p>\n\
</body>\n\
</html>",
)

Restart the lab so the updated file is used:

#bash(
  "kathara lclean\nkathara lstart",
)

Use `lynx` from `web-client` to confirm that your edited file is being served.

== 18. Add a Second Web Page

Create a second page on the host:

#bash(
  "gedit web-server/var/www/html/page2.html &",
)

Use:

#plainblock(
  "<html>\n\
<body>\n\
<h1>This is page 2</h1>\n\
<a href=\"index.html\">Return to the home page</a>\n\
</body>\n\
</html>",
)

Now edit `index.html` and add a link to the second page:

#bash(
  "gedit web-server/var/www/html/index.html &",
)

Updated content:

#plainblock(
  "<html>\n\
<body>\n\
<h1>It works!</h1>\n\
<p>Hello there!</p>\n\
<a href=\"page2.html\">Page 2</a>\n\
</body>\n\
</html>",
)

Restart the lab again:

#bash(
  "kathara lclean\nkathara lstart",
)

Use `lynx` to:

- open the home page;
- follow the link to page 2;
- return to the home page.

Repeat the packet capture procedure while you navigate between both pages.

Then inspect the new `.pcap` in Wireshark and identify the complete
request/response cycle for both pages.

== 19. Use `nmap`

Create a new capture on the server:

#bash(
  "mkdir -p web-server/captures",
)

Connect to `web-server` and start:

#bash(
  "tcpdump -v -i eth0 -s 0 -w /captures/nmap1.pcap",
)

From `web-client`, scan the web server:

#bash(
  "nmap -v -sV 192.168.150.2",
)

Be patient while the scan completes.

Read the output carefully and note:

- open ports;
- detected services;
- version information.

Stop the capture and open it in Wireshark:

#bash(
  "wireshark web-server/captures/nmap1.pcap &",
)

#figplaceholder[`nmap` output from the client scanning the web server.]

Analyse the capture, especially:

- the handshake packets;
- resets, if any;
- scans against closed ports;
- how the HTTP service is identified.

#question[
  What do the `-v` and `-sV` switches do?
]

#question[
  Are there any other `nmap` switches that would give useful traffic for
  analysis?
]

Use `man nmap` to help answer this.

== 20. Shut Down the Lab

When you have finished:

#bash(
  "kathara lclean",
)

Check that the lab has stopped cleanly.

== 21. Review

Review what you learned in this lab session. You should now be able to explain:

- how Kathara represents a small network lab;
- how HTTP runs over TCP;
- the structure of a basic HTTP request;
- the structure of an HTTP response;
- how Apache serves files from the web root;
- how packet captures reveal both transport-layer and application-layer
  behaviour.

== Follow-Up Work

Look up common HTTP header fields and explain:

- why each one is needed;
- example values for each;
- how a web browser uses them to request and receive a web page.

You should also be able to explain, step by step, how a browser requests a page
and how a server replies.

For modern HTTP reading, use the current HTTP specifications and your module
resources. If your course materials still reference older HTTP RFCs, compare
them with newer specifications and note the differences in terminology and
structure.

#v(1em)
#align(center)[
  *Make sure you have completed all steps in this worksheet before the next lab
  session.*
]
