# Operating Systems & Networks

# Lab Worksheet 12: The Transport Layer

## This Week's Objectives

1. Be able to configure and run multiple Kathara lab machines.
2. Be able to describe the format of UDP packets.
3. Be able to describe the format of TCP packets.

## Expected Outcomes

After the laboratory session, students should be able to:

- pass data from a UDP client to a UDP listener in Linux using the
  `netcat` / `nc` command.
- analyse a captured `pcap` file using Wireshark and explain the ports used in
  UDP datagrams.
- explain how UDP datagrams are carried in IP packets, which are in turn
  carried over the LAN in Ethernet frames.
- adapt marginally incorrect instructions and / or Kathara configurations.
- identify and fix deliberate errors in the lab configuration or commands.

## Workplan

Make accurate notes of everything that you do for later consideration and
revision. Use your lab diary to note commands used, the result of each command,
and answers to the questions in this worksheet.

This is a complex lab. Read each instruction carefully. If you miss out steps,
you should not expect to achieve the correct results.

Make sure you have completed all the steps in this worksheet before the next lab
session.

## Starting Assumptions

You have completed the work in previous lab sheets:

- You have used Kathara to launch a coordinated group of several virtual
  machines.
- You know how this group is coordinated by the `lab.conf` file.
- You know how to shut down a Kathara lab using `kathara lclean`.
- You have used `ip` and `ping` inside virtual machines.
- You have saved captured network traffic from a virtual machine using
  `tcpdump`.
- You have viewed a packet capture file on the real Linux host using Wireshark.

## Getting Started

1. Create a directory for this lab's work:

   ```sh
   cd ~
   mkdir -p ctec1704/lab_12
   ```

2. Copy or download the Kathara lab archive/directory for Lab 12 into
   `~/ctec1704/lab_12`.

   If you have the archive, extract it:

   ```sh
   cd ~/ctec1704/lab_12
   tar -xvf kathara_lab_12.tar.xz
   ```

   If your tutor provided the unpacked `kathara_lab_12` directory, place it in
   `~/ctec1704/lab_12`.

3. This Kathara lab represents four hosts and three gateways / routers. The
   machines are connected through Kathara collision domains named `W`, `X`, and
   `D`.

   Look in `lab.conf`. Confirm that the ASCII art diagram corresponds to this
   diagram. Ignore `/29` and `/27` for now.

   ```text
   W - 172.28.97.40/29

      m1 .41       m2 .42       gww .46
        |            |             |
   -----+------------+-------------+-----
                                gww .150.55
                                      |
   D - 10.227.0.0/16                 |
   -----------------------------------+---------- gw .150.254
                                      |
                                gwx .150.56
        |            |             |
   -----+------------+-------------+-----
      m6 .106      m7 .107      gwx .126

   X - 172.21.62.96/27
   ```

4. Place yourself in the newly created lab directory and list its contents:

   ```sh
   cd ~/ctec1704/lab_12/kathara_lab_12
   ls -l
   ```

5. You should see several directories and startup files, one for each virtual
   machine.

6. Start the virtual lab:

   ```sh
   kathara lstart
   ```

7. Look carefully at the virtual machines as they start. Be patient. Record any
   errors that you see.

8. If terminal windows are not opened automatically, connect to machines from
   your host terminal when needed:

   ```sh
   kathara connect m1
   kathara connect m2
   kathara connect gww
   kathara connect m6
   kathara connect m7
   kathara connect gw
   ```

9. Arrange any terminal windows so they match the network diagram above.

## Look at the Configuration

10. Once all machines are up, use `tcpdump` on machines `m2`, `m7`, and `gw` to
    store captured traffic in a `captures` directory in your host home
    directory.

    On the host, create the directory first:

    ```sh
    mkdir -p ~/ctec1704/captures
    ```

    Then run commands like these inside the relevant Kathara machines:

    ```sh
    tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/m2-d1.pcap
    tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/m7-d1.pcap
    tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/gw-d1.pcap
    ```

    If your Kathara installation does not expose the host home directory as
    `/hosthome`, write the capture into the lab's shared directory or into the
    machine filesystem, then copy it back to the host after the capture.

11. Make a careful note of the exact instruction you used on each machine.

## TCP vs UDP

You are going to use `netcat` to create network traffic. `netcat` / `nc` can
use either TCP or UDP to carry messages. Use the man page to read about the
tool:

```sh
man nc
```

12. On machine `gww`, launch a TCP listener:

    ```sh
    netcat -l -p 51966
    ```

    Use the man page to understand the switches. Convert the port number to
    hexadecimal and note the value.

13. From machine `m1`, send a TCP message to port `51966` on `gww`. You have a
    choice of IP addresses. Note which you chose and why.

    ```sh
    netcat 172.28.97.46 51966
    hello there
    ```

14. Text entered on `m1` should appear in the `gww` terminal. Press `Ctrl-C` to
    stop `netcat` in each terminal.

15. Go back to `m1` and use `netcat` to send `hello` to `m6`. Start a listener
    on `m6` first.

    On `m6`:

    ```sh
    netcat -l -p 51966
    ```

    On `m1`:

    ```sh
    echo "hello" | netcat 172.21.62.106 51966 -q0
    ```

16. Answer these questions:

    - What does the `-q` switch do in `netcat`?
    - What does the pipe symbol `|` do in the shell?
    - What does the `echo` command do?

17. Repeat the message transmissions using UDP packets. Add the `-u` switch to
    both the listener and the sender.

    Example UDP listener:

    ```sh
    netcat -u -l -p 51966
    ```

    Example UDP sender:

    ```sh
    echo "hello" | netcat -u 172.21.62.106 51966 -q0
    ```

18. Stop the packet capture on `m2` and open the capture in Wireshark on the
    host:

    ```sh
    wireshark ~/ctec1704/captures/m2-d1.pcap
    ```

19. Make sure that you can find and explain the TCP and UDP packets from each
    activity.

    For each case, note which client port was used.

    - Is there a pattern?
    - Can you see the text messages you sent?
    - Hint: look in the hex pane, the lowest pane of the Wireshark window.

20. Compare your results with those of a colleague and note similarities /
    differences.

21. Stop the other captures and open them in Wireshark. What other packets have
    been captured?

## Using the `screen` Command

It is often useful to look at two things concurrently in a Kathara virtual
machine. The `screen` command enables you to have several terminal windows
inside one shell, only one of which is visible at a time.

Once you have started `screen`, `Ctrl-A` followed by another character controls
what `screen` does.

- `Ctrl-A c` creates another window.
- `Ctrl-A n` moves to the next window.
- `Ctrl-A p` moves to the previous window.

22. You will use `screen` to do several things on machine `m6`.

23. First, start a packet capture on `m7`, writing to `m7-d1.pcap` in the host
    captures directory:

    ```sh
    tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/m7-d1.pcap
    ```

24. On `m6`, start `screen`. Read the initial message, then press the suggested
    key to get to the shell prompt.

    ```sh
    screen
    ```

25. On `m6`, start a UDP listener on port `64206`. What is this port number in
    hexadecimal?

    ```sh
    nc -u -l -p 64206
    ```

26. Create another window on `m6`:

    ```text
    Ctrl-A c
    ```

27. In the new window, start another UDP listener on port `57005`.

    ```sh
    nc -u -l -p 57005
    ```

28. Check that you can switch between the two windows on `m6`:

    ```text
    Ctrl-A n
    Ctrl-A n
    ```

29. Create a third window on `m6`:

    ```text
    Ctrl-A c
    ```

30. In the third window, start another UDP listener on port `51966`:

    ```sh
    nc -u -l -p 51966
    ```

31. Create a fourth window on `m6`:

    ```text
    Ctrl-A c
    ```

32. In this fourth window, run `netstat` to look for IPv4 sockets:

    ```sh
    netstat -an4
    ```

33. Start a continuous view of the network status:

    ```sh
    watch -n1 netstat -an4
    ```

34. Keep this `netstat` output as the visible screen on `m6`.

35. On `m1`, `m2`, and `gww`, connect to the three UDP listeners you have
    running on `m6`.

    On `m1`, force the client port to `11111` and connect to port `64206`:

    ```sh
    echo "m1m1m1" | nc -u 172.21.62.106 64206 -p 11111 -q0
    ```

    On `m2`, force the client port to `22222` and connect to port `57005`:

    ```sh
    echo "m2m2m2" | nc -u 172.21.62.106 57005 -p 22222 -q0
    ```

    On `gww`, allow the operating system to choose the client port and connect
    to port `51966`:

    ```sh
    echo "gwwgww" | nc -u 172.21.62.106 51966 -q0
    ```

    Do these source ports need to be different, or could they be the same?

36. Record what `netstat` shows as you send each datagram.

37. Stop the packet capture on `m7` and inspect the `pcap` file with Wireshark.
    Explain the port number in each UDP datagram.

## Shutting Down the Kathara Lab

When you have finished, stop and clean up the lab:

```sh
kathara lclean
```

Make sure you have completed all the steps in this worksheet before the next lab
session.
