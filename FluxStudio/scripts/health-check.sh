#!/bin/bash

# FluxStudio Health Check Script
# Comprehensive health verification for production deployment
# Version: 1.0

set -e

# Configuration
PROD_URL="http://167.172.208.61"
API_URL="http://167.172.208.61:3001"
TIMEOUT=10
MAX_RETRIES=3
HEALTH_LOG="/tmp/fluxstudio-health.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$HEALTH_LOG"
}

success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$HEALTH_LOG"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$HEALTH_LOG"
}

error() {
    echo -e "${RED}❌ $1${NC}" | tee -a "$HEALTH_LOG"
}

# Health check functions
check_frontend() {
    log "Checking frontend availability..."

    local retry=0
    while [ $retry -lt $MAX_RETRIES ]; do
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout $TIMEOUT "$PROD_URL" || echo "000")

        if [ "$HTTP_CODE" = "200" ]; then
            success "Frontend is responding (HTTP $HTTP_CODE)"
            return 0
        else
            warning "Frontend check failed (HTTP $HTTP_CODE) - Attempt $((retry + 1))/$MAX_RETRIES"
            retry=$((retry + 1))
            [ $retry -lt $MAX_RETRIES ] && sleep 2
        fi
    done

    error "Frontend health check failed after $MAX_RETRIES attempts"
    return 1
}

check_api() {
    log "Checking API availability..."

    local retry=0
    while [ $retry -lt $MAX_RETRIES ]; do
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout $TIMEOUT "$API_URL/health" || echo "000")

        if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "404" ]; then
            success "API is responding (HTTP $HTTP_CODE)"
            return 0
        else
            warning "API check failed (HTTP $HTTP_CODE) - Attempt $((retry + 1))/$MAX_RETRIES"
            retry=$((retry + 1))
            [ $retry -lt $MAX_RETRIES ] && sleep 2
        fi
    done

    error "API health check failed after $MAX_RETRIES attempts"
    return 1
}

check_assets() {
    log "Checking static assets..."

    # Check for common assets
    local assets=("favicon.ico" "assets/index.css" "assets/index.js")
    local failed=0

    for asset in "${assets[@]}"; do
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout $TIMEOUT "$PROD_URL/$asset" || echo "000")

        if [ "$HTTP_CODE" = "200" ]; then
            success "Asset $asset is available"
        else
            warning "Asset $asset is not available (HTTP $HTTP_CODE)"
            failed=$((failed + 1))
        fi
    done

    if [ $failed -eq 0 ]; then
        success "All critical assets are available"
        return 0
    else
        warning "$failed assets failed to load"
        return 1
    fi
}

check_performance() {
    log "Checking performance metrics..."

    # Measure response time
    RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" --connect-timeout $TIMEOUT "$PROD_URL" || echo "0")

    if (( $(echo "$RESPONSE_TIME < 2.0" | bc -l) )); then
        success "Good response time: ${RESPONSE_TIME}s"
    elif (( $(echo "$RESPONSE_TIME < 5.0" | bc -l) )); then
        warning "Acceptable response time: ${RESPONSE_TIME}s"
    else
        error "Poor response time: ${RESPONSE_TIME}s"
        return 1
    fi

    return 0
}

check_ssl() {
    log "Checking SSL/TLS configuration..."

    # Skip SSL check if using HTTP
    if [[ "$PROD_URL" == http://* ]]; then
        warning "SSL check skipped (HTTP URL)"
        return 0
    fi

    SSL_STATUS=$(curl -s -o /dev/null -w "%{ssl_verify_result}" "$PROD_URL" || echo "1")

    if [ "$SSL_STATUS" = "0" ]; then
        success "SSL certificate is valid"
        return 0
    else
        error "SSL certificate verification failed"
        return 1
    fi
}

check_deployment_info() {
    log "Checking deployment information..."

    # Try to get deployment info
    DEPLOY_INFO=$(curl -s --connect-timeout $TIMEOUT "$PROD_URL/.deployment-info" || echo "")

    if [ -n "$DEPLOY_INFO" ]; then
        success "Deployment info available"
        echo "$DEPLOY_INFO" | tee -a "$HEALTH_LOG"
        return 0
    else
        warning "Deployment info not available"
        return 1
    fi
}

# Main health check routine
main() {
    echo "════════════════════════════════════════════════════════════════"
    echo "🏥 FluxStudio Production Health Check"
    echo "📊 Starting comprehensive health verification..."
    echo "════════════════════════════════════════════════════════════════"

    # Initialize log
    echo "Health check started at $(date)" > "$HEALTH_LOG"

    local failed_checks=0
    local total_checks=6

    # Run all health checks
    check_frontend || failed_checks=$((failed_checks + 1))
    check_api || failed_checks=$((failed_checks + 1))
    check_assets || failed_checks=$((failed_checks + 1))
    check_performance || failed_checks=$((failed_checks + 1))
    check_ssl || failed_checks=$((failed_checks + 1))
    check_deployment_info || failed_checks=$((failed_checks + 1))

    echo ""
    echo "════════════════════════════════════════════════════════════════"

    if [ $failed_checks -eq 0 ]; then
        success "🎉 All health checks passed! ($total_checks/$total_checks)"
        echo ""
        log "✨ FluxStudio is healthy and ready for production use"
        echo "📊 Health report saved to: $HEALTH_LOG"
        echo "🔗 Application URL: $PROD_URL"
        echo "════════════════════════════════════════════════════════════════"
        exit 0
    else
        error "⚠️  Some health checks failed ($((total_checks - failed_checks))/$total_checks passed)"
        echo ""
        error "🚨 FluxStudio may have issues in production"
        echo "📊 Health report saved to: $HEALTH_LOG"
        echo "🔧 Please review the failed checks above"
        echo "════════════════════════════════════════════════════════════════"
        exit 1
    fi
}

# Execute main function
main "$@"