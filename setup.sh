#!/usr/bin/env bash
set -euo pipefail

APP_MANIFEST="argocd/playground-app.yaml"
ARGOCD_NS="argocd"
PORT=8080

echo "==> Applying Argo CD Application manifest..."
kubectl apply -f "$APP_MANIFEST" -n "$ARGOCD_NS"

echo "==> Retrieving Argo CD admin password..."
ADMIN_PASSWORD=$(kubectl -n "$ARGOCD_NS" get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Argo CD admin password: $ADMIN_PASSWORD"

echo "==> Port-forwarding Argo CD server on https://localhost:$PORT ..."
echo "Press Ctrl+C to stop port-forwarding."
kubectl port-forward svc/argocd-server -n "$ARGOCD_NS" "$PORT":443
