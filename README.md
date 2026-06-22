# Cache Controller Design

A complete RTL implementation of a **direct-mapped cache controller** designed in **Verilog HDL**.

This project implements the control logic and datapath required to manage communication between a CPU and external main memory through a cache hierarchy.

The design focuses on understanding and implementing fundamental concepts involved in processor memory subsystems:

- Cache organization
- Address decomposition
- Cache hit/miss detection
- Dirty line management
- Write-back policy
- Cache line refill
- FSM-based control design
- RTL datapath implementation
- CPU-memory handshake protocols

---

# Project Overview

Modern processors use cache memory to reduce the performance gap between high-speed CPU cores and slower main memory.

A cache controller is responsible for:

- Detecting whether requested data exists in cache
- Returning cached data on hits
- Fetching data from memory on misses
- Writing dirty cache lines back to memory before replacement

This project implements a custom cache controller from scratch using synthesizable Verilog RTL.

The design follows a modular architecture consisting of:

1. Address Decoder
2. Cache Controller (FSM)
3. Cache Datapath
4. Cache Memory Array
5. Top-Level Integration Module

---

# Features

## Cache Features

- Direct-mapped cache architecture
- Word-based data storage
- Tag-based lookup mechanism
- Valid bit support
- Dirty bit support
- Write-back cache policy
- Cache line refill mechanism
- Dirty cache line eviction

## Controller Features

- FSM-based cache management
- Separate controller and datapath architecture
- Custom CPU handshake interface
- Custom memory handshake interface
- Multi-cycle refill operation
- Multi-cycle writeback operation

## Verification Features

The verification environment tests:

- Cache reset operation
- Read miss handling
- Cache line refill
- Read hit operation
- Write hit operation
- Dirty line creation
- Dirty line writeback
- Conflict miss handling
- Write miss handling

---

# Cache Organization

The cache uses a **direct-mapped organization**.

Each cache line contains:

```
+--------------------------------+
| Valid | Dirty | Tag | Data     |
+--------------------------------+
```

## Valid Bit

Indicates whether the cache line contains meaningful data.

```
Valid = 0 → Empty cache line

Valid = 1 → Cache line contains valid data
```

## Dirty Bit

Indicates whether cached data has been modified by the CPU.

```
Dirty = 0 → Cache data matches memory

Dirty = 1 → Cache data must be written back before replacement
```

---

# Address Decoder

The CPU address is divided into:

```
+-----------+---------+--------------+--------------+
| Tag       | Index   | Word Offset  | Byte Offset  |
+-----------+---------+--------------+--------------+
```

The address decoder extracts:

- Cache tag
- Cache index
- Word offset

The decoded address fields are provided separately to the controller and datapath.

---

# RTL Module Description

## 1. Address Decoder

### Function

Converts the CPU address into cache-access parameters.

### Outputs

- Tag
- Index
- Word Offset

---

# 2. Cache Memory

The cache memory module implements the actual storage array.

It contains:

- Data array
- Tag array
- Valid bits
- Dirty bits

### Responsibilities

- Provide cache data during reads
- Store refill data
- Update metadata
- Provide current cache line information to controller

---

# 3. Cache Controller

The controller is the decision-making unit of the cache.

It is implemented using a finite state machine.

### Responsibilities

- Detect cache hits and misses
- Decide between refill and writeback
- Generate cache update signals
- Generate memory requests
- Manage transaction completion

---

# Datapath Architecture

The datapath performs all data movement operations.

The controller decides:

> What operation must happen?

The datapath decides:

> How data is transferred?

---

## Cache Read Address Generation

The datapath selects cache read addresses based on controller signals.

Sources include:

- CPU request address
- Internal cache operations

---

## Cache Write Data Selection

The datapath selects the source of data written into cache:

- CPU write data during write hits
- Memory read data during refill

---

## Memory Address Generation

The datapath generates external memory addresses.

### Writeback

Uses the old cache tag:

```
Old Tag + Index + Word Counter
```

### Refill

Uses the requested CPU tag:

```
New Tag + Index + Word Counter
```

---

# Memory Interface

The cache communicates with external memory using a custom handshake protocol.

## Memory Request Signals

### Memory Read Request

Generated during cache refill.

### Memory Write Request

Generated during dirty line writeback.

## Memory Response

Memory provides:

- Read data
- Ready indication

---

# Verification Environment

A behavioral memory model is used for simulation.

The testbench verifies:

## Read Miss

```
CPU Request
     |
Cache Lookup
     |
Miss Detected
     |
Memory Refill
     |
Cache Update
     |
CPU Response
```

---

## Read Hit

```
CPU Request
     |
Cache Lookup
     |
Hit
     |
CPU Response
```

---

## Write Hit

```
CPU Write
     |
Cache Update
     |
Dirty Bit Set
```

---

## Dirty Eviction

```
Dirty Cache Line
        |
New Conflicting Request
        |
Writeback
        |
Refill
        |
Metadata Update
```
---

# Tools Used
- Xilinx Vivado

# Conclusion

This project demonstrates the complete RTL design flow of a cache controller, starting from architecture definition and progressing through:

- FSM design
- Datapath implementation
- Module integration
- Verification

The project provides practical understanding of processor memory hierarchy implementation and serves as a foundation for advanced hardware architecture projects.
