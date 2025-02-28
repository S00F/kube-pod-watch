#!/bin/bash

# Load configuration
source config.env

# Ensure log directory exists
mkdir -p logs

LOG_FILE="logs/pod_monitor.log"

send_alert() {
    local MESSAGE="$1"
    echo "[ALERT] $MESSAGE" | tee -a "$LOG_FILE"
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$MESSAGE\"}" "$SLACK_WEBHOOK_URL"
}

monitor_pods() {
    echo "Monitoring pods in namespace: $NAMESPACE..."
    
    kubectl get pods --namespace "$NAMESPACE" --watch | while read line; do
        POD_NAME=$(echo "$line" | awk '{print $1}')
        STATUS=$(echo "$line" | awk '{print $3}')
        
        echo "$(date) - Pod: $POD_NAME Status: $STATUS" >> "$LOG_FILE"

        if [[ "$STATUS" == "Error" || "$STATUS" == "CrashLoopBackOff" ]]; then
            send_alert "Pod $POD_NAME is failing with status $STATUS!"
        fi
    done
}

check_deployments() {
    echo "Checking deployments..."
    
    kubectl get deployments -n "$NAMESPACE" -o json | jq -r '.items[] | "\(.metadata.name) \(.status.availableReplicas) / \(.status.replicas)"' | while read line; do
        DEPLOYMENT_NAME=$(echo "$line" | awk '{print $1}')
        READY_REPLICAS=$(echo "$line" | awk '{print $2}')
        TOTAL_REPLICAS=$(echo "$line" | awk '{print $4}')
        
        echo "$(date) - Deployment: $DEPLOYMENT_NAME Ready: $READY_REPLICAS / $TOTAL_REPLICAS" >> "$LOG_FILE"

        if [[ "$READY_REPLICAS" -lt "$TOTAL_REPLICAS" ]]; then
            send_alert "Deployment $DEPLOYMENT_NAME is unhealthy! ($READY_REPLICAS/$TOTAL_REPLICAS pods ready)"
        fi
    done
}

monitor_resources() {
    echo "Checking resource usage..."
    
    kubectl top pods -n "$NAMESPACE" | while read line; do
        echo "$(date) - Resource usage: $line" >> "$LOG_FILE"
    done
}

monitor_pods &  
while true; do
    check_deployments
    monitor_resources
    sleep 60
done
