# snmp-f5-bigip-ltm

Monitor your F5 BIG-IP Local Traffic Manager (LTM) platform remotely and gain insights into the health and performance of these devices.

## Overview

The F5 BIG-IP LTM Extension uses SNMP to collect data remotely. Every minute, data is collected from F5 devices and is continuously analyzed by the Dynatrace platform. The new framework allows you to go beyond simple metrics and apply a topology-first approach to monitoring the LTM platform.

**This is intended for users, who:**

- Would like to monitor the health state and performance of their F5 BIG-IP devices
- Look for analysis support for Ops, IT and Network Admins.

**This enables you to:**

- Monitor infrastructure with a comprehensive dashboard
- Detect traffic anomalies and alert on them
- Take pre-emptive measures to avoid service degradations

**Compatibility Requirements**

F5 BIG-IP devices using SNMP v2c and v3

## Details

This extension enables remote monitoring of the F5 BIG-IP platform and Local Traffic Manager (LTM) suite beyond simple charting capability. The unified analysis screens offer insight into the health and performance of the platform while the Dynatrace analytics engine can now baseline and alert on the most important indicators. The topology-first approach allows the DAVIS AI to investigate and correlate detected problems between components and find the root cause.

**The extension package contains:**

- SNMP data source configuration for metric ingestion
- Topology and relationship definitions for F5 Instances along with their Disks and Network interfaces, as well as Pools, Nodes, Virtual Servers, Traffic Profiles, and Rules of the LTM platform
- Overview dashboard template
- Unified Analysis screens for every entity

This extension is built on top of the new [Extension 2.0 Framework](https://www.dynatrace.com/news/blog/extend-dynatrace-automation-and-ai-capabilities-more-easily-than-ever/).

More information can be found in the [Product News Blog](https://www.dynatrace.com/news/blog/simplified-observability-for-your-snmp-devices/).

## Get started

Simply activate the extension in your environment using the in-product Hub, provide the necessary device configuration and you’re all set up.

Read more in the [Extension Documentation](https://www.dynatrace.com/support/help/how-to-use-dynatrace/networks/f5-extension).

## Dev

### Prerequisites
- Nix-capable environment, for Windows that means [installing WSL](https://docs.microsoft.com/en-us/learn/modules/get-started-with-windows-subsystem-for-linux/2-enable-and-install)
- [nix](https://nixos.org/download.html) / [**nix for WSL**](https://nixos.org/download.html#nix-install-windows)
- `direnv` (`nix-env -iA nixpkgs.direnv`)
- [configured direnv shell hook ](https://direnv.net/docs/hook.html), yup in your `.bashrc`
- some form of `make` (`nix-env -iA nixpkgs.gnumake`)
- Docker (available in the same environment as nix)

Hint: if something doesn't work because of missing package please add the package to `default.nix` instead of installing on your computer. Why solve the problem for one if you can solve the problem for all? ;)

### One-time setup
```
make init
```

### Everything
```
make help
```

### Resources
- [Extension yaml docs](https://www.dynatrace.com/support/help/extend-dynatrace/extensions20/extension-yaml)
- [Extension knowledge base](https://www.dynatrace.com/support/help/extend-dynatrace/extensions20)

### Internal tooling
If you're a **Dynatrace employee** you can follow [this link](https://github.com/dynatrace-extensions/precious-toolz-internal) to enable internal tooling