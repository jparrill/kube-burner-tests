#!/bin/bash

# Script to run kube-burner tests on OpenShift
# Usage: ./run-tests.sh [basic|stress-small-*|stress-medium-*|stress-high-*|both]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function for logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

# Verify that kube-burner is installed
check_kube_burner() {
    if ! command -v kube-burner &> /dev/null; then
        error "kube-burner is not installed"
        echo "Install it from: https://github.com/kube-burner/kube-burner/releases"
        exit 1
    fi
    log "kube-burner found: $(kube-burner version)"
}

# Verify cluster connectivity
check_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        error "Cannot connect to Kubernetes/OpenShift cluster"
        echo "Check your kubeconfig and connectivity"
        exit 1
    fi
    log "Connected to cluster: $(kubectl config current-context)"
}

# Execute basic test
run_basic_test() {
    log "Running basic test without additional load..."
    log "Configuration: basic-kubelet-density-light.yml"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/basic/basic-kubelet-density-light.yml --log-level=info; then
        log "✅ Basic test completed successfully"
    else
        error "❌ Basic test failed"
        return 1
    fi
}

# Execute heavy test
run_heavy_test() {
    log "Running test with additional load..."
    log "Configuration: basic-cluster-density-heavy.yml"
    warn "This test will create significant load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/basic/basic-cluster-density-heavy.yml --log-level=info; then
        log "✅ Heavy test completed successfully"
    else
        error "❌ Heavy test failed"
        return 1
    fi
}

# Execute stress tests - high level
run_stress_high_cpu_mem() {
    log "Running High CPU and Memory stress test..."
    log "Configuration: stress-high-cpu-mem.yml"
    warn "This test will create significant CPU and memory load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-high/stress-high-cpu-mem.yml --log-level=info; then
        log "✅ High CPU-Memory stress test completed successfully"
    else
        error "❌ High CPU-Memory stress test failed"
        return 1
    fi
}

run_stress_high_network() {
    log "Running High Network stress test..."
    log "Configuration: stress-high-net.yml"
    warn "This test will create significant network load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-high/stress-high-net.yml --log-level=info; then
        log "✅ High Network stress test completed successfully"
    else
        error "❌ High Network stress test failed"
        return 1
    fi
}

run_stress_high_io() {
    log "Running High I/O stress test..."
    log "Configuration: stress-high-io.yml"
    warn "This test will create significant I/O load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-high/stress-high-io.yml --log-level=info; then
        log "✅ High I/O stress test completed successfully"
    else
        error "❌ High I/O stress test failed"
        return 1
    fi
}

run_stress_high_combined() {
    log "Running High Combined stress test (CPU+Memory+Network+I/O)..."
    log "Configuration: stress-high-combined.yml"
    warn "This test will create VERY SIGNIFICANT load on ALL cluster resources"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-high/stress-high-combined.yml --log-level=info; then
        log "✅ High Combined stress test completed successfully"
    else
        error "❌ High Combined stress test failed"
        return 1
    fi
}

run_stress_medium_cpu_mem() {
    log "Running Medium CPU and Memory stress test..."
    log "Configuration: stress-medium-cpu-mem.yml"
    warn "This test will create moderate CPU and memory load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-medium/stress-medium-cpu-mem.yml --log-level=info; then
        log "✅ Medium CPU-Memory stress test completed successfully"
    else
        error "❌ Medium CPU-Memory stress test failed"
        return 1
    fi
}

run_stress_medium_network() {
    log "Running Medium Network stress test..."
    log "Configuration: stress-medium-net.yml"
    warn "This test will create moderate network load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-medium/stress-medium-net.yml --log-level=info; then
        log "✅ Medium Network stress test completed successfully"
    else
        error "❌ Medium Network stress test failed"
        return 1
    fi
}

run_stress_medium_io() {
    log "Running Medium I/O stress test..."
    log "Configuration: stress-medium-io.yml"
    warn "This test will create moderate I/O load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-medium/stress-medium-io.yml --log-level=info; then
        log "✅ Medium I/O stress test completed successfully"
    else
        error "❌ Medium I/O stress test failed"
        return 1
    fi
}

run_stress_medium_combined() {
    log "Running Medium Combined stress test (CPU+Memory+Network+I/O)..."
    log "Configuration: stress-medium-combined.yml"
    warn "This test will create moderate load on ALL cluster resources"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-medium/stress-medium-combined.yml --log-level=info; then
        log "✅ Medium Combined stress test completed successfully"
    else
        error "❌ Medium Combined stress test failed"
        return 1
    fi
}

# Small stress tests
run_stress_small_cpu_mem() {
    log "Running Small CPU and Memory stress test..."
    log "Configuration: stress-small-cpu-mem.yml"
    warn "This test will create light CPU and memory load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-small/stress-small-cpu-mem.yml --log-level=info; then
        log "✅ Small CPU-Memory stress test completed successfully"
    else
        error "❌ Small CPU-Memory stress test failed"
        return 1
    fi
}

run_stress_small_network() {
    log "Running Small Network stress test..."
    log "Configuration: stress-small-net.yml"
    warn "This test will create light network load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-small/stress-small-net.yml --log-level=info; then
        log "✅ Small Network stress test completed successfully"
    else
        error "❌ Small Network stress test failed"
        return 1
    fi
}

run_stress_small_io() {
    log "Running Small I/O stress test..."
    log "Configuration: stress-small-io.yml"
    warn "This test will create light I/O load on the cluster"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-small/stress-small-io.yml --log-level=info; then
        log "✅ Small I/O stress test completed successfully"
    else
        error "❌ Small I/O stress test failed"
        return 1
    fi
}

run_stress_small_combined() {
    log "Running Small Combined stress test (CPU+Memory+Network+I/O)..."
    log "Configuration: stress-small-combined.yml"
    warn "This test will create light load on ALL cluster resources"

    cd "$(dirname "$0")"

    if kube-burner init -c scenarios/stress-small/stress-small-combined.yml --log-level=info; then
        log "✅ Small Combined stress test completed successfully"
    else
        error "❌ Small Combined stress test failed"
        return 1
    fi
}

run_all_stress_high_tests() {
    log "Running all high stress tests sequentially..."
    warn "This will run all high stress scenarios one by one - this may take a long time"

    run_stress_high_cpu_mem
    sleep 60  # Pause between stress tests

    run_stress_high_network
    sleep 60

    run_stress_high_io
    sleep 60

    run_stress_high_combined
}

run_all_stress_medium_tests() {
    log "Running all medium stress tests sequentially..."
    warn "This will run all medium stress scenarios one by one"

    run_stress_medium_cpu_mem
    sleep 45  # Shorter pause for medium tests

    run_stress_medium_network
    sleep 45

    run_stress_medium_io
    sleep 45

    run_stress_medium_combined
}

run_all_stress_small_tests() {
    log "Running all small stress tests sequentially..."
    warn "This will run all small stress scenarios one by one"

    run_stress_small_cpu_mem
    sleep 30  # Short pause for small tests

    run_stress_small_network
    sleep 30

    run_stress_small_io
    sleep 30

    run_stress_small_combined
}

# Clean resources
cleanup() {
    log "Cleaning test resources..."

    # Basic test namespaces (these create namespaced iterations)
    log "Cleaning basic test namespaces..."
    kubectl get namespaces -o name | grep "namespace/kubelet-density-light-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/kubelet-density-" | grep -v "light" | xargs -r kubectl delete --ignore-not-found=true

    # Heavy test namespaces (these create namespaced iterations)
    log "Cleaning heavy test namespaces..."
    kubectl get namespaces -o name | grep "namespace/cluster-density-heavy-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/cluster-density-" | grep -v "heavy" | xargs -r kubectl delete --ignore-not-found=true

    # High stress test namespaces (these create namespaced iterations)
    log "Cleaning high stress test namespaces..."
    kubectl get namespaces -o name | grep "namespace/stress-high-cpu-mem-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-high-net-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-high-io-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-high-combined-" | xargs -r kubectl delete --ignore-not-found=true

    # Medium stress test namespaces (these create namespaced iterations)
    log "Cleaning medium stress test namespaces..."
    kubectl get namespaces -o name | grep "namespace/stress-medium-cpu-mem-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-medium-net-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-medium-io-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-medium-combined-" | xargs -r kubectl delete --ignore-not-found=true

    # Small stress test namespaces (these create namespaced iterations)
    log "Cleaning small stress test namespaces..."
    kubectl get namespaces -o name | grep "namespace/stress-small-cpu-mem-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-small-net-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-small-io-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-small-combined-" | xargs -r kubectl delete --ignore-not-found=true

    # Clean up any PVCs that might be left behind
    log "Cleaning up any remaining PVCs..."
    kubectl delete pvc -l stress-type --all-namespaces --ignore-not-found=true

    log "Cleanup completed"
}

# Clean only basic test resources
cleanup_basic() {
    log "Cleaning basic test resources..."
    kubectl get namespaces -o name | grep "namespace/kubelet-density-light-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/kubelet-density-" | grep -v "light" | xargs -r kubectl delete --ignore-not-found=true
    log "Basic test cleanup completed"
}

# Clean only heavy test resources
cleanup_heavy() {
    log "Cleaning heavy test resources..."
    kubectl get namespaces -o name | grep "namespace/cluster-density-heavy-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/cluster-density-" | grep -v "heavy" | xargs -r kubectl delete --ignore-not-found=true
    log "Heavy test cleanup completed"
}

# Clean only stress test resources (high, medium, and small)
cleanup_stress() {
    log "Cleaning stress test resources..."

    # High stress tests
    kubectl get namespaces -o name | grep "namespace/stress-high-cpu-mem-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-high-net-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-high-io-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-high-combined-" | xargs -r kubectl delete --ignore-not-found=true

    # Medium stress tests
    kubectl get namespaces -o name | grep "namespace/stress-medium-cpu-mem-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-medium-net-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-medium-io-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-medium-combined-" | xargs -r kubectl delete --ignore-not-found=true

    # Small stress tests
    kubectl get namespaces -o name | grep "namespace/stress-small-cpu-mem-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-small-net-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-small-io-" | xargs -r kubectl delete --ignore-not-found=true
    kubectl get namespaces -o name | grep "namespace/stress-small-combined-" | xargs -r kubectl delete --ignore-not-found=true

    # Clean up any PVCs that might be left behind
    log "Cleaning up any remaining PVCs..."
    kubectl delete pvc -l stress-type --all-namespaces --ignore-not-found=true

    log "Stress test cleanup completed"
}

# Show help
show_help() {
    echo "Usage: $0 [basic|heavy|both|stress-small-*|stress-medium-*|stress-high-*|cleanup-*]"
    echo ""
    echo "Basic Options:"
    echo "  basic           - Run only basic test without additional load"
    echo "  heavy           - Run only test with additional load"
    echo "  both            - Run both basic tests sequentially"
    echo ""
    echo "Small Stress Test Options (Light Load):"
    echo "  stress-small-cpu-mem  - Run small CPU and Memory stress test"
    echo "  stress-small-net      - Run small Network stress test"
    echo "  stress-small-io       - Run small I/O stress test"
    echo "  stress-small-combined - Run small Combined stress test (CPU+Memory+Network+I/O)"
    echo "  stress-small-all      - Run all small stress tests sequentially"
    echo ""
    echo "Medium Stress Test Options (Moderate Load):"
    echo "  stress-medium-cpu-mem  - Run medium CPU and Memory stress test"
    echo "  stress-medium-net      - Run medium Network stress test"
    echo "  stress-medium-io       - Run medium I/O stress test"
    echo "  stress-medium-combined - Run medium Combined stress test (CPU+Memory+Network+I/O)"
    echo "  stress-medium-all      - Run all medium stress tests sequentially"
    echo ""
    echo "High Stress Test Options (Heavy Load):"
    echo "  stress-high-cpu-mem  - Run high CPU and Memory stress test"
    echo "  stress-high-net      - Run high Network stress test"
    echo "  stress-high-io       - Run high I/O stress test"
    echo "  stress-high-combined - Run high Combined stress test (CPU+Memory+Network+I/O)"
    echo "  stress-high-all      - Run all high stress tests sequentially"
    echo ""
    echo "Cleanup Options:"
    echo "  cleanup         - Clean ALL test resources"
    echo "  cleanup-basic   - Clean only basic test resources"
    echo "  cleanup-heavy   - Clean only heavy test resources"
    echo "  cleanup-stress  - Clean only stress test resources (small, medium, and high)"
    echo "  help            - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 basic                    # Light test"
    echo "  $0 heavy                    # Test with load"
    echo "  $0 both                     # Both basic tests"
    echo "  $0 stress-small-cpu-mem     # Small CPU and Memory stress"
    echo "  $0 stress-medium-cpu-mem    # Medium CPU and Memory stress"
    echo "  $0 stress-high-cpu-mem      # High CPU and Memory stress"
    echo "  $0 stress-small-all         # All small stress tests sequentially"
    echo "  $0 stress-medium-all        # All medium stress tests sequentially"
    echo "  $0 stress-high-all          # All high stress tests sequentially"
    echo "  $0 cleanup                  # Cleanup all resources"
    echo "  $0 cleanup-stress           # Cleanup only stress test resources"
}

# Main
main() {
    local test_type="${1:-help}"

    case $test_type in
        basic)
            check_kube_burner
            check_cluster
            run_basic_test
            ;;
        heavy)
            check_kube_burner
            check_cluster
            run_heavy_test
            ;;
        both)
            check_kube_burner
            check_cluster
            log "Running both basic tests sequentially"
            run_basic_test
            sleep 30  # Pause between tests
            run_heavy_test
            ;;
        stress-small-cpu-mem)
            check_kube_burner
            check_cluster
            run_stress_small_cpu_mem
            ;;
        stress-small-net)
            check_kube_burner
            check_cluster
            run_stress_small_network
            ;;
        stress-small-io)
            check_kube_burner
            check_cluster
            run_stress_small_io
            ;;
        stress-small-combined)
            check_kube_burner
            check_cluster
            run_stress_small_combined
            ;;
        stress-small-all)
            check_kube_burner
            check_cluster
            run_all_stress_small_tests
            ;;
        stress-medium-cpu-mem)
            check_kube_burner
            check_cluster
            run_stress_medium_cpu_mem
            ;;
        stress-medium-net)
            check_kube_burner
            check_cluster
            run_stress_medium_network
            ;;
        stress-medium-io)
            check_kube_burner
            check_cluster
            run_stress_medium_io
            ;;
        stress-medium-combined)
            check_kube_burner
            check_cluster
            run_stress_medium_combined
            ;;
        stress-medium-all)
            check_kube_burner
            check_cluster
            run_all_stress_medium_tests
            ;;
        stress-high-cpu-mem)
            check_kube_burner
            check_cluster
            run_stress_high_cpu_mem
            ;;
        stress-high-net)
            check_kube_burner
            check_cluster
            run_stress_high_network
            ;;
        stress-high-io)
            check_kube_burner
            check_cluster
            run_stress_high_io
            ;;
        stress-high-combined)
            check_kube_burner
            check_cluster
            run_stress_high_combined
            ;;
        stress-high-all)
            check_kube_burner
            check_cluster
            run_all_stress_high_tests
            ;;
        cleanup)
            check_cluster
            cleanup
            ;;
        cleanup-basic)
            check_cluster
            cleanup_basic
            ;;
        cleanup-heavy)
            check_cluster
            cleanup_heavy
            ;;
        cleanup-stress)
            check_cluster
            cleanup_stress
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            error "Invalid option: $test_type"
            show_help
            exit 1
            ;;
    esac
}

# Execute main with all arguments
main "$@"