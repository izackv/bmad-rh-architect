# Task: rh-create-manifest

## Purpose

Create Kubernetes/OpenShift manifests following cloud-native
best practices and Red Hat conventions.

## Manifest Types

### Workloads
- Deployment
- StatefulSet
- DaemonSet
- Job / CronJob

### Networking
- Service
- Route (OpenShift)
- Ingress
- NetworkPolicy

### Configuration
- ConfigMap
- Secret
- PersistentVolumeClaim

### Security
- ServiceAccount
- Role / ClusterRole
- RoleBinding / ClusterRoleBinding
- SecurityContextConstraints (OpenShift)

### Custom Resources
- Operator CRs
- Application-specific CRDs

## Workflow

### Step 1: Requirements Gathering

Ask user:
1. **What resource type?**
   - Workload, networking, config, etc.

2. **Application details**
   - Name and namespace
   - Container image
   - Resource requirements

3. **Environment**
   - OpenShift or vanilla Kubernetes
   - Version (for API compatibility)
   - Production or non-production

4. **Special requirements**
   - High availability needs
   - Security constraints
   - Integration requirements

### Step 2: Design Manifest

Plan manifest structure:
- Determine required resources
- Identify dependencies between resources
- Plan labels and selectors

### Step 3: Generate Manifest

Create manifest following best practices:

**Deployment Example:**
```yaml
---
# Deployment: application-name
# Purpose: [description]
# Namespace: [namespace]
apiVersion: apps/v1
kind: Deployment
metadata:
  name: application-name
  namespace: application-namespace
  labels:
    app.kubernetes.io/name: application-name
    app.kubernetes.io/instance: production
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/component: backend
    app.kubernetes.io/part-of: application-suite
    app.kubernetes.io/managed-by: manual
  annotations:
    description: "Application description"
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app.kubernetes.io/name: application-name
      app.kubernetes.io/instance: production
  template:
    metadata:
      labels:
        app.kubernetes.io/name: application-name
        app.kubernetes.io/instance: production
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
    spec:
      serviceAccountName: application-sa
      securityContext:
        runAsNonRoot: true
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: application
          image: registry.example.com/app:1.0.0
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          env:
            - name: ENV_VAR
              valueFrom:
                configMapKeyRef:
                  name: application-config
                  key: env-var
            - name: SECRET_VAR
              valueFrom:
                secretKeyRef:
                  name: application-secret
                  key: secret-var
          resources:
            requests:
              memory: "256Mi"
              cpu: "100m"
            limits:
              memory: "512Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /health/live
              port: http
            initialDelaySeconds: 30
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /health/ready
              port: http
            initialDelaySeconds: 5
            periodSeconds: 5
            timeoutSeconds: 3
            failureThreshold: 3
          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop:
                - ALL
            readOnlyRootFilesystem: true
          volumeMounts:
            - name: tmp
              mountPath: /tmp
            - name: config
              mountPath: /etc/app/config
              readOnly: true
      volumes:
        - name: tmp
          emptyDir: {}
        - name: config
          configMap:
            name: application-config
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 100
              podAffinityTerm:
                labelSelector:
                  matchLabels:
                    app.kubernetes.io/name: application-name
                topologyKey: kubernetes.io/hostname
```

**Service Example:**
```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: application-name
  namespace: application-namespace
  labels:
    app.kubernetes.io/name: application-name
spec:
  type: ClusterIP
  ports:
    - name: http
      port: 80
      targetPort: http
      protocol: TCP
  selector:
    app.kubernetes.io/name: application-name
    app.kubernetes.io/instance: production
```

**Route Example (OpenShift):**
```yaml
---
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: application-name
  namespace: application-namespace
  labels:
    app.kubernetes.io/name: application-name
spec:
  host: app.example.com
  to:
    kind: Service
    name: application-name
    weight: 100
  port:
    targetPort: http
  tls:
    termination: edge
    insecureEdgeTerminationPolicy: Redirect
```

### Step 4: Best Practices Checklist

Verify manifest follows best practices:

- [ ] Uses recommended labels (app.kubernetes.io/*)
- [ ] Includes resource requests and limits
- [ ] Has liveness and readiness probes
- [ ] Runs as non-root user
- [ ] Drops all capabilities
- [ ] Uses read-only root filesystem where possible
- [ ] Secrets reference external sources (not inline)
- [ ] Includes pod anti-affinity for HA
- [ ] Uses appropriate update strategy

### Step 5: Generate Related Resources

As needed, create:
- ConfigMap for configuration
- Secret (template only, no real secrets)
- ServiceAccount
- NetworkPolicy
- PersistentVolumeClaim

## Output Format

Provide:
1. All manifest YAML files
2. Deployment order/dependencies
3. kubectl/oc apply commands
4. Verification commands
5. Notes on customization

## Interaction Guidelines

- Ask about target platform (OCP vs K8s)
- Verify image availability
- Explain security settings
- Offer HA configuration options
- Never include real secrets in output
