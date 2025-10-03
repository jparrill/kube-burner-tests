# Kube-burner Tests for OpenShift

This repository contains comprehensive kube-burner configurations and automation scripts to perform performance and stress tests on OpenShift clusters. It includes basic tests, stress tests at multiple levels, and containerized test runners.

## Project Structure

```
kube-burner-tests/
├── scenarios/                      # Test scenarios
│   ├── basic/                      # Basic load tests
│   │   ├── basic-kubelet-density-light.yml
│   │   ├── basic-kubelet-density.yml
│   │   ├── basic-cluster-density.yml
│   │   └── basic-cluster-density-heavy.yml
│   ├── stress-small/               # Light stress tests
│   │   ├── stress-small-cpu-mem.yml
│   │   ├── stress-small-io.yml
│   │   ├── stress-small-net.yml
│   │   └── stress-small-combined.yml
│   ├── stress-medium/              # Moderate stress tests
│   │   ├── stress-medium-cpu-mem.yml
│   │   ├── stress-medium-io.yml
│   │   ├── stress-medium-net.yml
│   │   └── stress-medium-combined.yml
│   └── stress-high/                # Heavy stress tests
│       ├── stress-high-cpu-mem.yml
│       ├── stress-high-io.yml
│       ├── stress-high-net.yml
│       └── stress-high-combined.yml
├── templates/                      # Kubernetes resource templates
│   ├── basic/                      # Basic templates
│   │   ├── basic-pod.yml
│   │   ├── basic-deployment-1pod.yml
│   │   ├── basic-deployment-2pod.yml
│   │   ├── basic-service-1pod.yml
│   │   ├── basic-service-2pod.yml
│   │   ├── basic-secret.yml
│   │   └── basic-configmap.yml
│   ├── stress-small/               # Small stress templates
│   ├── stress-medium/              # Medium stress templates
│   └── stress-high/                # High stress templates
├── run-tests.sh                    # Main test runner script
├── build-images.sh                 # Docker image build script
├── Dockerfile                      # Container image definition
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

## Quick Start with run-tests.sh

The easiest way to run tests is using the provided script:

```bash
# Make script executable
chmod +x run-tests.sh

# Show all available options
./run-tests.sh help

# Basic Tests
./run-tests.sh basic                    # Light test
./run-tests.sh heavy                    # Test with load
./run-tests.sh both                     # Both basic tests sequentially

# Small Stress Tests (Light Load)
./run-tests.sh stress-small-cpu-mem     # Small CPU and Memory stress
./run-tests.sh stress-small-net         # Small Network stress
./run-tests.sh stress-small-io          # Small I/O stress
./run-tests.sh stress-small-combined    # Small Combined stress (CPU+Memory+Network+I/O)
./run-tests.sh stress-small-all         # All small stress tests sequentially

# Medium Stress Tests (Moderate Load)
./run-tests.sh stress-medium-cpu-mem    # Medium CPU and Memory stress
./run-tests.sh stress-medium-net        # Medium Network stress
./run-tests.sh stress-medium-io         # Medium I/O stress
./run-tests.sh stress-medium-combined   # Medium Combined stress (CPU+Memory+Network+I/O)
./run-tests.sh stress-medium-all        # All medium stress tests sequentially

# High Stress Tests (Heavy Load)
./run-tests.sh stress-high-cpu-mem      # High CPU and Memory stress
./run-tests.sh stress-high-net          # High Network stress
./run-tests.sh stress-high-io           # High I/O stress
./run-tests.sh stress-high-combined     # High Combined stress (CPU+Memory+Network+I/O)
./run-tests.sh stress-high-all          # All high stress tests sequentially

# Cleanup Options
./run-tests.sh cleanup                  # Cleanup all resources
./run-tests.sh cleanup-basic            # Cleanup only basic test resources
./run-tests.sh cleanup-heavy            # Cleanup only heavy test resources
./run-tests.sh cleanup-stress           # Cleanup only stress test resources
```

### Script Features

The `run-tests.sh` script provides:

- **Automated checks**: Verifies kube-burner installation and cluster connectivity
- **Colored output**: Clear logging with timestamps and status indicators
- **Error handling**: Proper error reporting and exit codes
- **Comprehensive cleanup**: Targeted cleanup options for different test types
- **Sequential execution**: Built-in pauses between stress tests to prevent resource conflicts

### Prerequisites

- `kube-burner` binary installed and in PATH
- Valid kubeconfig with cluster-admin permissions
- Sufficient cluster resources for the chosen test level

## Available Test Categories

### 1. Basic Tests

Basic performance tests without stress components:

- **basic-kubelet-density-light.yml**: Minimal pod creation test
- **basic-kubelet-density.yml**: Standard pod creation test
- **basic-cluster-density.yml**: Standard cluster density test
- **basic-cluster-density-heavy.yml**: Heavy cluster density test with deployments, services, secrets, and configmaps

### 2. Stress Tests - Small (Light Load)

Lightweight stress tests suitable for smaller clusters:

- **stress-small-cpu-mem.yml**: Light CPU and memory stress
- **stress-small-io.yml**: Light I/O stress with persistent volumes
- **stress-small-net.yml**: Light network stress with client-server communication
- **stress-small-combined.yml**: Combined light stress (CPU+Memory+I/O+Network)

### 3. Stress Tests - Medium (Moderate Load)

Moderate stress tests for medium-sized clusters:

- **stress-medium-cpu-mem.yml**: Moderate CPU and memory stress
- **stress-medium-io.yml**: Moderate I/O stress
- **stress-medium-net.yml**: Moderate network stress
- **stress-medium-combined.yml**: Combined moderate stress

### 4. Stress Tests - High (Heavy Load)

Intensive stress tests for large clusters:

- **stress-high-cpu-mem.yml**: Heavy CPU and memory stress
- **stress-high-io.yml**: Heavy I/O stress
- **stress-high-net.yml**: Heavy network stress
- **stress-high-combined.yml**: Combined heavy stress (maximum load)

## Manual Execution

You can also run tests manually with kube-burner:

```bash
# Basic tests
kube-burner init -c scenarios/basic/basic-kubelet-density-light.yml --log-level=info

# Stress tests
kube-burner init -c scenarios/stress-small/stress-small-cpu-mem.yml --log-level=info
```

## Collected Metrics

- **podLatency**: Pod creation latency
- **clusterHealth**: Overall cluster status
- **containerMetrics**: Container metrics (stress and heavy tests)
- **nodeMetrics**: Node metrics (stress and heavy tests)
- **CPU and Memory stress metrics**: Resource consumption patterns
- **I/O metrics**: Disk performance and PVC operations
- **Network metrics**: Network latency, throughput, and connectivity

## Containerized Execution

The tests can also be run in a containerized environment:

### Building the Container Image

```bash
# Build and push the container image
./build-images.sh
```

This creates a container image with stress testing tools:
- **stress-ng**: CPU, memory, and I/O stress testing
- **iperf3**: Network performance testing
- **fio**: Advanced I/O testing

### Running Tests in Container

```bash
# Run container with kube-burner tests
docker run --rm -v ~/.kube:/root/.kube:ro \
  quay.io/jparrill/kube-burner-stress-tools:latest \
  ./run-tests.sh stress-small-cpu-mem
```

## Monitoring with Prometheus

If you have Prometheus available:

```bash
kube-burner init -c scenarios/basic/basic-cluster-density.yml \
  --prometheus-url=http://prometheus-server:9090 \
  --metrics-profile=metrics-profiles/openshift.yml
```

## Cleanup

The test runner script provides comprehensive cleanup options:

```bash
# Clean ALL test resources
./run-tests.sh cleanup

# Clean only basic test resources
./run-tests.sh cleanup-basic

# Clean only heavy test resources
./run-tests.sh cleanup-heavy

# Clean only stress test resources (small, medium, high)
./run-tests.sh cleanup-stress
```

Manual cleanup:
```bash
# Clean specific test namespaces
kubectl get namespaces -o name | grep "stress-" | xargs kubectl delete
kubectl get namespaces -o name | grep "kubelet-density-" | xargs kubectl delete
kubectl get namespaces -o name | grep "cluster-density-" | xargs kubectl delete

# Clean PVCs created by stress tests
kubectl delete pvc -l stress-type --all-namespaces --ignore-not-found=true
```

## Customization

### Adjust Basic Test Load
Edit files in `scenarios/basic/`:
- `jobIterations`: Number of iterations
- `qps`/`burst`: Creation speed and bursts
- `replicas`: Number of resources per iteration

### Adjust Stress Test Load
Edit files in `scenarios/stress-*/`:
- **CPU/Memory tests**: Modify `resources.requests` and `resources.limits`
- **I/O tests**: Adjust storage size and I/O patterns in PVC templates
- **Network tests**: Configure client/server replicas and traffic patterns
- **Combined tests**: Balance all resource types

### Custom Stress Levels
Create your own stress configurations by copying and modifying existing scenarios:

```bash
cp scenarios/stress-medium/stress-medium-cpu-mem.yml scenarios/custom/my-custom-test.yml
# Edit the new file with your specific requirements
```

## Results Interpretation

1. **Pod latency**: Time to create pods (lower is better)
2. **Errors**: Any error indicates capacity issues
3. **Cluster metrics**: CPU/memory of nodes and control plane
4. **Logs**: Review logs for specific errors

## Troubleshooting

### Common Issues

- **Permissions**: Ensure you have cluster-admin permissions for creating namespaces and resources
- **Resources**: Verify the cluster has sufficient capacity for the stress level chosen
- **Network**: Confirm connectivity with the API server
- **Images**: Verify that stress tool images are available and accessible
- **Storage**: For I/O tests, ensure storage classes support dynamic provisioning
- **Node resources**: High stress tests may require nodes with significant CPU/memory capacity

### Debugging Test Failures

```bash
# Check test namespaces
kubectl get namespaces | grep -E "(stress-|kubelet-density|cluster-density)"

# Check pod status in test namespaces
kubectl get pods -n <test-namespace> -o wide

# Check events for errors
kubectl get events -n <test-namespace> --sort-by='.lastTimestamp'

# Check node resource usage
kubectl top nodes

# Check PVC status for I/O tests
kubectl get pvc --all-namespaces | grep stress
```

### Performance Recommendations

- **Small clusters** (< 10 nodes): Use `stress-small-*` tests
- **Medium clusters** (10-50 nodes): Use `stress-medium-*` tests
- **Large clusters** (> 50 nodes): Use `stress-high-*` tests
- **Production clusters**: Start with basic tests, then progress to appropriate stress level