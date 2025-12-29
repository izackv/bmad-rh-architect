# Task: rh-create-operator-config

## Purpose

Create Operator subscriptions, custom resources, and configurations
for Red Hat and community operators on OpenShift.

## Operator Types

### Red Hat Operators
- OpenShift GitOps (ArgoCD)
- OpenShift Pipelines (Tekton)
- OpenShift Serverless
- OpenShift Service Mesh
- AMQ Streams (Kafka)
- Red Hat SSO
- Ansible Automation Platform

### Certified Operators
- Elasticsearch
- Prometheus
- Grafana

### Community Operators
- Various community-maintained operators

## Workflow

### Step 1: Requirements Gathering

Ask user:
1. **Which operator?**
   - Operator name
   - Source catalog (redhat-operators, certified, community)

2. **Configuration needs**
   - Instance configuration
   - Resource requirements
   - Integration settings

3. **Environment**
   - Namespace strategy
   - High availability requirements
   - Security requirements

### Step 2: Generate Subscription

Create operator subscription:

```yaml
---
# Operator Subscription: operator-name
# Purpose: Install operator-name from OperatorHub
#
# Prerequisites:
#   - Namespace exists
#   - OperatorHub accessible
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: operator-name
  namespace: openshift-operators  # or specific namespace
spec:
  channel: stable  # or specific channel
  installPlanApproval: Automatic  # or Manual
  name: operator-name
  source: redhat-operators  # or certified-operators, community-operators
  sourceNamespace: openshift-marketplace
  # Optional: pin to specific version
  # startingCSV: operator-name.v1.0.0
```

### Step 3: Generate OperatorGroup (if namespace-scoped)

```yaml
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: operator-name-group
  namespace: target-namespace
spec:
  targetNamespaces:
    - target-namespace
```

### Step 4: Generate Custom Resource

Based on operator, create custom resource:

#### OpenShift GitOps (ArgoCD)

```yaml
---
apiVersion: argoproj.io/v1beta1
kind: ArgoCD
metadata:
  name: argocd
  namespace: openshift-gitops
spec:
  server:
    autoscale:
      enabled: false
    grpc:
      ingress:
        enabled: false
    ingress:
      enabled: false
    resources:
      limits:
        cpu: 500m
        memory: 256Mi
      requests:
        cpu: 125m
        memory: 128Mi
    route:
      enabled: true
      tls:
        termination: reencrypt
  applicationSet:
    resources:
      limits:
        cpu: '2'
        memory: 1Gi
      requests:
        cpu: 250m
        memory: 512Mi
  controller:
    resources:
      limits:
        cpu: '2'
        memory: 2Gi
      requests:
        cpu: 250m
        memory: 1Gi
  ha:
    enabled: false
  rbac:
    defaultPolicy: ''
    policy: |
      g, system:cluster-admins, role:admin
    scopes: '[groups]'
  repo:
    resources:
      limits:
        cpu: '1'
        memory: 1Gi
      requests:
        cpu: 250m
        memory: 256Mi
  redis:
    resources:
      limits:
        cpu: 500m
        memory: 256Mi
      requests:
        cpu: 250m
        memory: 128Mi
  sso:
    dex:
      openShiftOAuth: true
      resources:
        limits:
          cpu: 500m
          memory: 256Mi
        requests:
          cpu: 250m
          memory: 128Mi
    provider: dex
```

#### OpenShift Pipelines (Tekton)

```yaml
---
apiVersion: operator.tekton.dev/v1alpha1
kind: TektonConfig
metadata:
  name: config
spec:
  profile: all
  targetNamespace: openshift-pipelines
  pruner:
    resources:
      - pipelinerun
      - taskrun
    keep: 100
    schedule: "0 8 * * *"
  addon:
    params:
      - name: clusterTasks
        value: "true"
      - name: pipelineTemplates
        value: "true"
```

#### AMQ Streams (Kafka)

```yaml
---
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: my-cluster
  namespace: kafka
spec:
  kafka:
    version: 3.6.0
    replicas: 3
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
      - name: tls
        port: 9093
        type: internal
        tls: true
    config:
      offsets.topic.replication.factor: 3
      transaction.state.log.replication.factor: 3
      transaction.state.log.min.isr: 2
      default.replication.factor: 3
      min.insync.replicas: 2
    storage:
      type: persistent-claim
      size: 100Gi
      class: gp3-csi
    resources:
      requests:
        memory: 2Gi
        cpu: 500m
      limits:
        memory: 4Gi
        cpu: "2"
  zookeeper:
    replicas: 3
    storage:
      type: persistent-claim
      size: 10Gi
      class: gp3-csi
    resources:
      requests:
        memory: 1Gi
        cpu: 250m
      limits:
        memory: 2Gi
        cpu: "1"
  entityOperator:
    topicOperator: {}
    userOperator: {}
```

#### Red Hat SSO (Keycloak)

```yaml
---
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
  namespace: keycloak
spec:
  instances: 2
  db:
    vendor: postgres
    host: postgres-db
    usernameSecret:
      name: keycloak-db-secret
      key: username
    passwordSecret:
      name: keycloak-db-secret
      key: password
  hostname:
    hostname: keycloak.example.com
  http:
    tlsSecret: keycloak-tls-secret
  ingress:
    enabled: true
```

### Step 5: Verification Commands

Provide verification:

```bash
# Check subscription status
oc get subscription operator-name -n namespace

# Check CSV (ClusterServiceVersion) status
oc get csv -n namespace

# Check operator pod
oc get pods -n namespace -l name=operator-name

# Check custom resource status
oc get <cr-kind> -n namespace
oc describe <cr-kind> <cr-name> -n namespace
```

## Output Format

Provide:
1. Namespace creation (if needed)
2. OperatorGroup (if namespace-scoped)
3. Subscription YAML
4. Custom Resource YAML
5. Verification commands
6. Post-installation configuration

## Interaction Guidelines

- Verify operator availability in target OCP version
- Ask about resource sizing requirements
- Explain configuration options
- Include comments in YAML
- Provide both minimal and production-ready examples
