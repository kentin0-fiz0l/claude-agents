#!/bin/bash

# FluxStudio Deployment Verification Script
# Verifies that deployment was successful and application is working correctly
# Version: 1.0

set -e

# Configuration
PROD_SERVER="root@167.172.208.61"
PROD_PATH="/var/www/fluxstudio"
PROD_URL="http://167.172.208.61"
API_URL="http://167.172.208.61:3001"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Verification functions
verify_files_deployed() {
    log "Verifying files are deployed to production server..."

    # Check if essential files exist on server
    local essential_files=("index.html" ".deployment-info")
    local missing_files=0

    for file in "${essential_files[@]}"; do
        if ssh $PROD_SERVER "test -f $PROD_PATH/$file"; then
            success "Essential file exists: $file"
        else
            error "Missing essential file: $file"
            missing_files=$((missing_files + 1))
        fi
    done

    # Check deployment info
    if ssh $PROD_SERVER "test -f $PROD_PATH/.deployment-info"; then
        DEPLOY_INFO=$(ssh $PROD_SERVER "cat $PROD_PATH/.deployment-info")
        info "Deployment information:"
        echo "$DEPLOY_INFO" | sed 's/^/   /'
    fi

    if [ $missing_files -eq 0 ]; then
        success "All essential files are deployed"
        return 0
    else
        error "$missing_files essential files are missing"
        return 1
    fi
}

verify_file_permissions() {
    log "Verifying file permissions on production server..."

    # Check if files are readable
    if ssh $PROD_SERVER "test -r $PROD_PATH/index.html"; then
        success "Files have correct read permissions"
    else
        error "Files are not readable"
        return 1
    fi

    # Check directory permissions
    if ssh $PROD_SERVER "test -d $PROD_PATH && test -x $PROD_PATH"; then
        success "Directory has correct permissions"
    else
        error "Directory permissions are incorrect"
        return 1
    fi

    return 0
}

verify_build_integrity() {
    log "Verifying build integrity..."

    # Check if build artifacts exist locally
    if [ -d "build" ] && [ -f "build/index.html" ]; then
        success "Local build artifacts are present"
    else
        error "Local build artifacts are missing"
        return 1
    fi

    # Compare file counts
    LOCAL_FILES=$(find build -type f | wc -l)
    REMOTE_FILES=$(ssh $PROD_SERVER "find $PROD_PATH -type f | wc -l" 2>/dev/null || echo "0")

    info "Local files: $LOCAL_FILES, Remote files: $REMOTE_FILES"

    if [ "$LOCAL_FILES" -gt 0 ] && [ "$REMOTE_FILES" -gt 0 ]; then
        success "Build integrity verified"
        return 0
    else
        error "Build integrity check failed"
        return 1
    fi
}

verify_frontend_loading() {
    log "Verifying frontend loads correctly..."

    # Check if main page loads
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$PROD_URL" || echo "000")

    if [ "$HTTP_CODE" = "200" ]; then
        success "Frontend loads successfully (HTTP $HTTP_CODE)"
    else
        error "Frontend failed to load (HTTP $HTTP_CODE)"
        return 1
    fi

    # Check content type
    CONTENT_TYPE=$(curl -s -I "$PROD_URL" | grep -i "content-type" | head -1 || echo "")

    if [[ "$CONTENT_TYPE" == *"text/html"* ]]; then
        success "Correct content type served"
    else
        warning "Unexpected content type: $CONTENT_TYPE"
    fi

    return 0
}

verify_assets_loading() {
    log "Verifying static assets load correctly..."

    # Get the actual asset files from the HTML
    HTML_CONTENT=$(curl -s "$PROD_URL" || echo "")

    if [ -z "$HTML_CONTENT" ]; then
        error "Could not fetch HTML content"
        return 1
    fi

    # Extract CSS and JS files from HTML
    CSS_FILES=$(echo "$HTML_CONTENT" | grep -oP 'href="[^"]*\.css[^"]*"' | sed 's/href="//;s/"//' || echo "")
    JS_FILES=$(echo "$HTML_CONTENT" | grep -oP 'src="[^"]*\.js[^"]*"' | sed 's/src="//;s/"//' || echo "")

    local failed_assets=0

    # Check CSS files
    for css_file in $CSS_FILES; do
        # Handle relative URLs
        if [[ "$css_file" == /* ]]; then
            FULL_URL="$PROD_URL$css_file"
        else
            FULL_URL="$PROD_URL/$css_file"
        fi

        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$FULL_URL" || echo "000")
        if [ "$HTTP_CODE" = "200" ]; then
            success "CSS asset loaded: $css_file"
        else
            error "CSS asset failed: $css_file (HTTP $HTTP_CODE)"
            failed_assets=$((failed_assets + 1))
        fi
    done

    # Check JS files
    for js_file in $JS_FILES; do
        # Handle relative URLs
        if [[ "$js_file" == /* ]]; then
            FULL_URL="$PROD_URL$js_file"
        else
            FULL_URL="$PROD_URL/$js_file"
        fi

        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$FULL_URL" || echo "000")
        if [ "$HTTP_CODE" = "200" ]; then
            success "JS asset loaded: $js_file"
        else
            error "JS asset failed: $js_file (HTTP $HTTP_CODE)"
            failed_assets=$((failed_assets + 1))
        fi
    done

    if [ $failed_assets -eq 0 ]; then
        success "All assets are loading correctly"
        return 0
    else
        error "$failed_assets assets failed to load"
        return 1
    fi
}

verify_api_connectivity() {
    log "Verifying API connectivity..."

    # Test API endpoint
    API_HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/health" 2>/dev/null || echo "000")

    if [ "$API_HTTP_CODE" = "200" ] || [ "$API_HTTP_CODE" = "404" ]; then
        success "API is responding (HTTP $API_HTTP_CODE)"
        return 0
    else
        warning "API connectivity check inconclusive (HTTP $API_HTTP_CODE)"
        return 1
    fi
}

verify_deployment_metadata() {
    log "Verifying deployment metadata..."

    # Check if deployment info exists and is valid
    if ssh $PROD_SERVER "test -f $PROD_PATH/.deployment-info"; then
        DEPLOY_JSON=$(ssh $PROD_SERVER "cat $PROD_PATH/.deployment-info" 2>/dev/null || echo "{}")

        # Basic JSON validation
        if echo "$DEPLOY_JSON" | python3 -m json.tool >/dev/null 2>&1; then
            success "Deployment metadata is valid JSON"

            # Extract deployment info
            DEPLOY_ID=$(echo "$DEPLOY_JSON" | python3 -c "import sys, json; print(json.load(sys.stdin).get('deploymentId', 'unknown'))" 2>/dev/null || echo "unknown")
            DEPLOY_TIMESTAMP=$(echo "$DEPLOY_JSON" | python3 -c "import sys, json; print(json.load(sys.stdin).get('timestamp', 'unknown'))" 2>/dev/null || echo "unknown")

            info "Deployment ID: $DEPLOY_ID"
            info "Deployment Time: $DEPLOY_TIMESTAMP"

            return 0
        else
            error "Deployment metadata is invalid JSON"
            return 1
        fi
    else
        error "Deployment metadata file missing"
        return 1
    fi
}

# Main verification routine
main() {
    echo "════════════════════════════════════════════════════════════════"
    echo "🔍 FluxStudio Deployment Verification"
    echo "📋 Verifying production deployment integrity..."
    echo "════════════════════════════════════════════════════════════════"

    local failed_checks=0
    local total_checks=7

    # Run all verification checks
    verify_files_deployed || failed_checks=$((failed_checks + 1))
    verify_file_permissions || failed_checks=$((failed_checks + 1))
    verify_build_integrity || failed_checks=$((failed_checks + 1))
    verify_frontend_loading || failed_checks=$((failed_checks + 1))
    verify_assets_loading || failed_checks=$((failed_checks + 1))
    verify_api_connectivity || failed_checks=$((failed_checks + 1))
    verify_deployment_metadata || failed_checks=$((failed_checks + 1))

    echo ""
    echo "════════════════════════════════════════════════════════════════"

    if [ $failed_checks -eq 0 ]; then
        success "🎉 All verification checks passed! ($total_checks/$total_checks)"
        echo ""
        success "✨ Deployment verification completed successfully"
        info "🔗 Application URL: $PROD_URL"
        echo "════════════════════════════════════════════════════════════════"
        exit 0
    else
        error "⚠️  Some verification checks failed ($((total_checks - failed_checks))/$total_checks passed)"
        echo ""
        error "🚨 Deployment verification failed"
        warning "🔧 Please review the failed checks above"
        echo "════════════════════════════════════════════════════════════════"
        exit 1
    fi
}

# Execute main function
main "$@"