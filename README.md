# home-ops

Kubernetes cluster based on [`onedr0p/cluster-template`](https://github.com/onedr0p/cluster-template).

## Stack

- **OS**: Talos Linux (immutable, API-managed)
- **GitOps**: Flux, syncing from this repo
- **Networking**: Cilium (CNI + LoadBalancer IPAM/L2), Envoy Gateway (Gateway
  API ingress), k8s_gateway (internal split-DNS), external-dns
- **External access**: Cloudflare Tunnel, no inbound ports forwarded
- **Secrets**: SOPS + age
- **Image mirroring**: Spegel (peer-to-peer between nodes)
- **Storage**: Longhorn, dedicated disk per node
- **Observability**: VictoriaMetrics k8s stack (metrics + Grafana + alerting)

## Apps

Home Assistant, ESPHome, Mosquitto, MariaDB, Frigate, UniFi Controller, AirConnect

## Maintenance

```sh
just talos apply-node <node>     # apply updated machine config
just talos upgrade-node <node>   # upgrade Talos on a node
just talos upgrade-k8s           # upgrade Kubernetes version
just talos shutdown-node <node>  # gracefully power off a node before physical work
just kube reconcile               # force Flux to sync
```

### Powering off a node for physical work

Before unplugging a node (moving hardware, swapping a disk, etc.), shut it
down cleanly rather than pulling power — this stops etcd and unmounts
filesystems properly instead of risking an unclean etcd/XFS state:

```sh
just talos shutdown-node <node>
```

This runs `talosctl shutdown --wait`, which cordons/drains first (usually a
no-op — most nodes only run static/DaemonSet pods that can't be evicted
anyway) then waits for the node to fully power off before returning control,
so it's safe to disconnect once the command completes.

**With fewer than 3 control-plane nodes, this causes a temporary full
control-plane outage** (etcd loses quorum below a majority) until the node
is back — `kubectl`/Flux/Grafana will be unavailable, though already-running
application pods on other nodes keep serving traffic. Not a concern once the
cluster reaches its 3-node target.

`mise`'s pinned tool versions (`talosctl` included) only resolve inside this
repo's directory tree — run `just` commands from within the repo, not from
your home directory or elsewhere.

## Credit

Built from [`onedr0p/cluster-template`](https://github.com/onedr0p/cluster-template).
