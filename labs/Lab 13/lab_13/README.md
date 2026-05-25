# Kathara Lab 13

This directory contains the Kathara version of lab 13, covering IPv4
addressing and routing.

## Start the Lab

```sh
kathara lstart
```

## List Running Machines

```sh
kathara list
```

## Connect to a Machine

```sh
kathara connect m1
```

Replace `m1` with any machine name from `lab.conf`.

## Stop and Clean the Lab

```sh
kathara lclean
```

## Notes

The original Netkit topology has been kept. The startup files now use
`ip route` commands and the D network consistently uses `10.227.0.0/16`.
