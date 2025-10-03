# Kube-burner Tests for OpenShift

This directory contains kube-burner configurations to perform performance tests on OpenShift clusters.

## Project Structure

```
kube-burner-tests/
├── basic/                    # Tests without additional load
│   ├── kubelet-density.yml          # Original configuration
│   └── kubelet-density-light.yml    # Optimized light configuration
├── with-load/               # Tests with additional load
│   ├── cluster-density.yml         # Original configuration
│   └── cluster-density-heavy.yml   # Optimized heavy configuration
├── templates/               # Kubernetes resource templates
│   ├── pod.yml
│   ├── deployment-1pod.yml
│   ├── deployment-2pod.yml
│   ├── service-deployment-1pod.yml
│   ├── service-deployment-2pod.yml
│   ├── secret.yml
│   └── configmap.yml
└── README.md
```

## Kube-burner Installation

```bash
# Download latest version
wget https://github.com/kube-burner/kube-burner/releases/latest/download/kube-burner-linux-x86_64.tar.gz
tar -xzf kube-burner-linux-x86_64.tar.gz
sudo mv kube-burner /usr/local/bin/

# Verify installation
kube-burner version
```

## Available Tests

### 1. Basic test without additional load

**File**: `basic/kubelet-density-light.yml`

**Features**:
- 10 iterations (minimal pods)
- 1 QPS (very conservative)
- Only pods with `pause` image
- Ideal for verifying basic functionality

**Execution**:
```bash
cd kube-burner-tests
kube-burner init -c basic/kubelet-density-light.yml --log-level=info
```

### 2. Test with additional load

**File**: `with-load/cluster-density-heavy.yml`

**Features**:
- 25 iterations (significant load)
- 30 QPS (high speed)
- Deployments, services, secrets, configmaps
- Simulates real applications

**Execution**:
```bash
cd kube-burner-tests
kube-burner init -c with-load/cluster-density-heavy.yml --log-level=info
```

## Collected Metrics

- **podLatency**: Pod creation latency
- **clusterHealth**: Overall cluster status
- **containerMetrics**: Container metrics (heavy test)
- **nodeMetrics**: Node metrics (heavy test)

## Monitoring with Prometheus

If you have Prometheus available:

```bash
kube-burner init -c config.yml --prometheus-url=http://prometheus-server:9090 --metrics-profile=metrics-profiles/openshift.yml
```

## Cleanup

Kube-burner includes automatic garbage collection (`gc: true`), but you can clean manually:

```bash
# Clean light test namespace
kubectl delete namespace kubelet-density-light

# Clean heavy test namespace
kubectl delete namespace cluster-density-heavy
```

## Customization

### Adjust light test load
Edit `basic/kubelet-density-light.yml`:
- `jobIterations`: Number of pods to create
- `qps`: Creation speed
- `replicas`: Replicas per iteration

### Adjust heavy test load
Edit `with-load/cluster-density-heavy.yml`:
- `jobIterations`: Number of iterations
- `qps`/`burst`: Speed and bursts
- `replicas`: Number of resources per type

## Results Interpretation

1. **Pod latency**: Time to create pods (lower is better)
2. **Errors**: Any error indicates capacity issues
3. **Cluster metrics**: CPU/memory of nodes and control plane
4. **Logs**: Review logs for specific errors

## Troubleshooting

- **Permissions**: Ensure you have cluster-admin permissions
- **Resources**: Verify the cluster has sufficient capacity
- **Network**: Confirm connectivity with the API server
- **Images**: Verify that images are available