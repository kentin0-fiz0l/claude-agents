#!/bin/bash

# FluxStudio Automated Production Deployment Script
# Ensures ALL updates are deployed to production with safety checks
# Version: 2.0
# Author: Claude Code Assistant

set -e  # Exit on any error

# ===== CONFIGURATION =====
PROD_SERVER="root@167.172.208.61"
PROD_PATH="/var/www/fluxstudio"
LOCAL_BUILD_DIR="build"
BACKUP_DIR="/var/www/fluxstudio/backups"
DEPLOYMENT_LOG="/var/www/fluxstudio/deployment.log"
HEALTH_CHECK_URL="http://167.172.208.61"
MAX_RETRIES=3
DEPLOYMENT_ID=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ===== LOGGING FUNCTIONS =====
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a deploy.log
}

success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a deploy.log
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a deploy.log
}

error() {
    echo -e "${RED}❌ $1${NC}" | tee -a deploy.log
}

info() {
    echo -e "${CYAN}ℹ️  $1${NC}" | tee -a deploy.log
}

# ===== BANNER =====
print_banner() {
    echo -e "${PURPLE}"
    echo "██████╗ ██╗     ██╗   ██╗██╗  ██╗    ███████╗████████╗██╗   ██╗██████╗ ██╗ ██████╗ "
    echo "██╔════╝ ██║     ██║   ██║╚██╗██╔╝    ██╔════╝╚══██╔══╝██║   ██║██╔══██╗██║██╔═══██╗"
    echo "█████╗   ██║     ██║   ██║ ╚███╔╝     ███████╗   ██║   ██║   ██║██║  ██║██║██║   ██║"
    echo "██╔══╝   ██║     ██║   ██║ ██╔██╗     ╚════██║   ██║   ██║   ██║██║  ██║██║██║   ██║"
    echo "██║      ███████╗╚██████╔╝██╔╝ ██╗    ███████║   ██║   ╚██████╔╝██████╔╝██║╚██████╔╝"
    echo "╚═╝      ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚══════╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ "
    echo ""
    echo "                         🚀 AUTOMATED PRODUCTION DEPLOYMENT 🚀"
    echo "                                Deployment ID: $DEPLOYMENT_ID"
    echo -e "${NC}"
    echo "═══════════════════════════════════════════════════════════════════════════════════"
}

# ===== SAFETY CHECKS =====
check_git_status() {
    log "Checking Git repository status..."

    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        error "Not in a Git repository"
        exit 1
    fi

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        warning "You have uncommitted changes"
        if [[ "$FORCE_DEPLOY" != "true" ]]; then
            error "Deployment aborted. Commit your changes or use --force"
            exit 1
        fi
    fi

    # Get current commit info
    CURRENT_COMMIT=$(git rev-parse HEAD)
    CURRENT_BRANCH=$(git branch --show-current)

    success "Git status OK - Branch: $CURRENT_BRANCH, Commit: ${CURRENT_COMMIT:0:8}"
}

check_dependencies() {
    log "Checking dependencies..."

    # Check if rsync is available
    if ! command -v rsync &> /dev/null; then
        error "rsync is required but not installed"
        exit 1
    fi

    # Check if ssh is available and can connect
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes $PROD_SERVER "echo 'Connection test'" &> /dev/null; then
        error "Cannot connect to production server: $PROD_SERVER"
        exit 1
    fi

    success "Dependencies check passed"
}

# ===== BUILD PROCESS =====
run_build() {
    log "Starting production build..."

    # Clean previous build
    if [ -d "$LOCAL_BUILD_DIR" ]; then
        rm -rf "$LOCAL_BUILD_DIR"
        info "Cleaned previous build directory"
    fi

    # Run build with error handling
    if ! npm run build; then
        error "Build failed! Deployment aborted."
        exit 1
    fi

    # Verify build output
    if [ ! -d "$LOCAL_BUILD_DIR" ] || [ ! -f "$LOCAL_BUILD_DIR/index.html" ]; then
        error "Build directory or index.html not found after build"
        exit 1
    fi

    # Add deployment metadata
    cat > "$LOCAL_BUILD_DIR/.deployment-info" << EOF
{
    "deploymentId": "$DEPLOYMENT_ID",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "commit": "$CURRENT_COMMIT",
    "branch": "$CURRENT_BRANCH",
    "buildSize": "$(du -sh $LOCAL_BUILD_DIR | cut -f1)"
}
EOF

    BUILD_SIZE=$(du -sh $LOCAL_BUILD_DIR | cut -f1)
    success "Build completed successfully - Size: $BUILD_SIZE"
}

# ===== BACKUP & DEPLOYMENT =====
create_backup() {
    log "Creating backup of current production..."

    ssh $PROD_SERVER << EOF
        mkdir -p $BACKUP_DIR
        if [ -d "$PROD_PATH" ]; then
            BACKUP_NAME="backup_\$(date +%Y%m%d_%H%M%S)"
            tar -czf "$BACKUP_DIR/\$BACKUP_NAME.tar.gz" -C "$PROD_PATH" . 2>/dev/null || true
            # Keep only last 5 backups
            cd $BACKUP_DIR && ls -t *.tar.gz | tail -n +6 | xargs rm -f
            echo "Backup created: \$BACKUP_NAME.tar.gz"
        fi
EOF

    success "Backup created successfully"
}

deploy_files() {
    log "Deploying files to production..."

    # Deploy with rsync
    rsync -avz --delete \
        --exclude=node_modules \
        --exclude=.git \
        --exclude=.env.local \
        --exclude=.env \
        --exclude=*.log \
        --exclude=.DS_Store \
        --progress \
        "$LOCAL_BUILD_DIR/" "$PROD_SERVER:$PROD_PATH/"

    if [ $? -eq 0 ]; then
        success "Files deployed successfully"
    else
        error "File deployment failed"
        exit 1
    fi
}

# ===== HEALTH CHECKS =====
run_health_checks() {
    log "Running health checks..."

    local retry_count=0
    local max_retries=5
    local wait_time=3

    while [ $retry_count -lt $max_retries ]; do
        info "Health check attempt $((retry_count + 1))/$max_retries"

        # Check HTTP response
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_CHECK_URL" || echo "000")

        if [ "$HTTP_CODE" = "200" ]; then
            success "Health check passed - HTTP $HTTP_CODE"
            return 0
        else
            warning "Health check failed - HTTP $HTTP_CODE"
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                info "Waiting ${wait_time}s before retry..."
                sleep $wait_time
            fi
        fi
    done

    error "Health checks failed after $max_retries attempts"
    return 1
}

verify_deployment() {
    log "Verifying deployment..."

    # Check if deployment info exists
    ssh $PROD_SERVER "test -f $PROD_PATH/.deployment-info" || {
        error "Deployment info file not found on server"
        return 1
    }

    # Get deployment info from server
    DEPLOYED_INFO=$(ssh $PROD_SERVER "cat $PROD_PATH/.deployment-info")
    info "Deployed version info: $DEPLOYED_INFO"

    # Verify assets exist
    ssh $PROD_SERVER "test -f $PROD_PATH/index.html && test -d $PROD_PATH/assets" || {
        error "Essential assets missing on server"
        return 1
    }

    success "Deployment verification passed"
}

# ===== ROLLBACK FUNCTION =====
rollback() {
    log "Initiating rollback..."

    LATEST_BACKUP=$(ssh $PROD_SERVER "cd $BACKUP_DIR && ls -t *.tar.gz | head -n 1" 2>/dev/null || echo "")

    if [ -z "$LATEST_BACKUP" ]; then
        error "No backup found for rollback"
        return 1
    fi

    info "Rolling back to: $LATEST_BACKUP"

    ssh $PROD_SERVER << EOF
        cd $PROD_PATH
        rm -rf ./*
        tar -xzf $BACKUP_DIR/$LATEST_BACKUP
        echo "Rollback completed from $LATEST_BACKUP"
EOF

    if run_health_checks; then
        success "Rollback completed successfully"
    else
        error "Rollback failed - manual intervention required"
    fi
}

# ===== DEPLOYMENT LOGGING =====
log_deployment() {
    local status=$1
    local message=$2

    ssh $PROD_SERVER << EOF
        echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) | $DEPLOYMENT_ID | $status | $message" >> $DEPLOYMENT_LOG
EOF
}

# ===== NOTIFICATION =====
send_notification() {
    local status=$1
    local message=$2

    # Log notification (could be extended to send emails, Slack, etc.)
    info "📢 Notification: $status - $message"
}

# ===== MAIN DEPLOYMENT FLOW =====
main() {
    print_banner

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --force)
                FORCE_DEPLOY="true"
                warning "Force deploy enabled - skipping safety checks"
                shift
                ;;
            --no-health-check)
                SKIP_HEALTH_CHECK="true"
                warning "Health checks disabled"
                shift
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --force            Deploy even with uncommitted changes"
                echo "  --no-health-check  Skip health checks after deployment"
                echo "  --help            Show this help message"
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    log "🚀 Starting FluxStudio production deployment..."
    log_deployment "STARTED" "Deployment initiated"

    # Pre-deployment checks
    check_git_status
    check_dependencies

    # Build process
    run_build

    # Create backup
    create_backup

    # Deploy files
    deploy_files

    # Post-deployment verification
    if ! verify_deployment; then
        error "Deployment verification failed"
        if [[ "$FORCE_DEPLOY" != "true" ]]; then
            log "Initiating automatic rollback..."
            rollback
            log_deployment "FAILED" "Deployment failed, rolled back"
            send_notification "FAILED" "Deployment failed and was rolled back"
            exit 1
        else
            warning "Verification failed but continuing due to --force flag"
        fi
    fi

    # Health checks
    if [[ "$SKIP_HEALTH_CHECK" != "true" ]]; then
        if ! run_health_checks; then
            error "Health checks failed"
            if [[ "$FORCE_DEPLOY" != "true" ]]; then
                log "Initiating automatic rollback..."
                rollback
                log_deployment "FAILED" "Health checks failed, rolled back"
                send_notification "FAILED" "Health checks failed and was rolled back"
                exit 1
            else
                warning "Health checks failed but continuing due to --force flag"
            fi
        fi
    fi

    # Success!
    log_deployment "SUCCESS" "Deployment completed successfully"
    send_notification "SUCCESS" "Deployment completed successfully"

    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════════════"
    success "🎉 DEPLOYMENT COMPLETED SUCCESSFULLY!"
    echo ""
    info "📊 Deployment Summary:"
    echo "   • Deployment ID: $DEPLOYMENT_ID"
    echo "   • Commit: $CURRENT_COMMIT"
    echo "   • Branch: $CURRENT_BRANCH"
    echo "   • Build Size: $BUILD_SIZE"
    echo "   • Server: $PROD_SERVER"
    echo ""
    info "🔗 Access Your Application:"
    echo "   • Production URL: $HEALTH_CHECK_URL"
    echo "   • Deployment Log: $DEPLOYMENT_LOG"
    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════════════"
}

# ===== ERROR HANDLING =====
trap 'error "Script interrupted"; exit 1' INT TERM

# ===== EXECUTE MAIN FUNCTION =====
main "$@"