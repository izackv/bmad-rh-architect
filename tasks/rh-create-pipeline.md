# Task: rh-create-pipeline

## Purpose

Create CI/CD pipelines for Red Hat platforms including Tekton/OpenShift
Pipelines, Jenkins, and other CI/CD tools.

## Pipeline Types

### Build Pipelines
- Container image builds
- Application compilation
- Artifact creation

### Deployment Pipelines
- Development deployment
- Staging promotion
- Production rollout

### GitOps Pipelines
- ArgoCD sync
- Configuration deployment
- Infrastructure updates

### Testing Pipelines
- Unit test execution
- Integration testing
- Security scanning

## Supported Platforms

| Platform | Use Case |
|----------|----------|
| **Tekton** | Cloud-native, Kubernetes-based |
| **OpenShift Pipelines** | Tekton with OCP integration |
| **Jenkins** | Traditional CI/CD, complex workflows |
| **GitHub Actions** | GitHub-native CI/CD |
| **GitLab CI** | GitLab-native pipelines |

## Workflow

### Step 1: Requirements Gathering

Ask user:
1. **Pipeline platform**
   - Tekton / OpenShift Pipelines
   - Jenkins
   - GitHub Actions
   - GitLab CI

2. **Pipeline purpose**
   - Build
   - Test
   - Deploy
   - Full CI/CD

3. **Application details**
   - Language/framework
   - Build requirements
   - Test requirements
   - Deployment target

4. **Integration requirements**
   - Source repository
   - Image registry
   - Deployment target
   - Notification channels

### Step 2: Design Pipeline

Plan pipeline stages:

**Typical CI/CD stages:**
```
Source → Build → Test → Scan → Push → Deploy → Verify
```

**Considerations:**
- Parallelization opportunities
- Approval gates
- Rollback capabilities
- Secret management

### Step 3: Generate Pipeline

#### Tekton Pipeline Example

```yaml
---
# Pipeline: application-ci-cd
# Purpose: Build, test, and deploy application
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: application-ci-cd
  namespace: ci-cd
spec:
  params:
    - name: git-url
      type: string
      description: Git repository URL
    - name: git-revision
      type: string
      description: Git revision to build
      default: main
    - name: image-name
      type: string
      description: Target image name
    - name: image-tag
      type: string
      description: Target image tag
      default: latest

  workspaces:
    - name: shared-workspace
    - name: git-credentials
    - name: image-registry-credentials

  tasks:
    - name: clone-repository
      taskRef:
        name: git-clone
        kind: ClusterTask
      params:
        - name: url
          value: $(params.git-url)
        - name: revision
          value: $(params.git-revision)
      workspaces:
        - name: output
          workspace: shared-workspace
        - name: basic-auth
          workspace: git-credentials

    - name: run-tests
      taskRef:
        name: run-unit-tests
      runAfter:
        - clone-repository
      workspaces:
        - name: source
          workspace: shared-workspace

    - name: build-image
      taskRef:
        name: buildah
        kind: ClusterTask
      runAfter:
        - run-tests
      params:
        - name: IMAGE
          value: $(params.image-name):$(params.image-tag)
      workspaces:
        - name: source
          workspace: shared-workspace
        - name: dockerconfig
          workspace: image-registry-credentials

    - name: deploy-to-dev
      taskRef:
        name: openshift-client
        kind: ClusterTask
      runAfter:
        - build-image
      params:
        - name: SCRIPT
          value: |
            oc set image deployment/application \
              application=$(params.image-name):$(params.image-tag) \
              -n development
            oc rollout status deployment/application -n development
---
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  generateName: application-ci-cd-run-
  namespace: ci-cd
spec:
  pipelineRef:
    name: application-ci-cd
  params:
    - name: git-url
      value: https://github.com/org/repo.git
    - name: git-revision
      value: main
    - name: image-name
      value: image-registry.openshift-image-registry.svc:5000/project/app
    - name: image-tag
      value: "1.0.0"
  workspaces:
    - name: shared-workspace
      persistentVolumeClaim:
        claimName: pipeline-workspace-pvc
    - name: git-credentials
      secret:
        secretName: git-credentials
    - name: image-registry-credentials
      secret:
        secretName: registry-credentials
```

#### Jenkins Pipeline Example

```groovy
// Jenkinsfile
// Purpose: Build, test, and deploy application
pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                  containers:
                  - name: maven
                    image: maven:3.8-openjdk-17
                    command:
                    - cat
                    tty: true
                  - name: buildah
                    image: quay.io/buildah/stable
                    command:
                    - cat
                    tty: true
                    securityContext:
                      privileged: true
            '''
        }
    }

    environment {
        IMAGE_REGISTRY = 'registry.example.com'
        IMAGE_NAME = 'project/application'
        GIT_CREDENTIALS = credentials('git-credentials')
        REGISTRY_CREDENTIALS = credentials('registry-credentials')
    }

    parameters {
        string(name: 'GIT_BRANCH', defaultValue: 'main', description: 'Git branch to build')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Image tag')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: params.GIT_BRANCH,
                    credentialsId: 'git-credentials',
                    url: 'https://github.com/org/repo.git'
            }
        }

        stage('Build') {
            steps {
                container('maven') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Test') {
            steps {
                container('maven') {
                    sh 'mvn test'
                }
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build Image') {
            steps {
                container('buildah') {
                    sh """
                        buildah bud -t ${IMAGE_REGISTRY}/${IMAGE_NAME}:${params.IMAGE_TAG} .
                        buildah push --creds ${REGISTRY_CREDENTIALS_USR}:${REGISTRY_CREDENTIALS_PSW} \
                            ${IMAGE_REGISTRY}/${IMAGE_NAME}:${params.IMAGE_TAG}
                    """
                }
            }
        }

        stage('Deploy to Dev') {
            steps {
                sh """
                    oc set image deployment/application \
                        application=${IMAGE_REGISTRY}/${IMAGE_NAME}:${params.IMAGE_TAG} \
                        -n development
                    oc rollout status deployment/application -n development --timeout=300s
                """
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

#### GitHub Actions Example

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  IMAGE_REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up JDK
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Build with Maven
        run: mvn clean package -DskipTests

      - name: Run tests
        run: mvn test

      - name: Upload test results
        uses: actions/upload-artifact@v4
        with:
          name: test-results
          path: target/surefire-reports/

  build-image:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.event_name == 'push'
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Log in to registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.IMAGE_REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ env.IMAGE_REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
            ${{ env.IMAGE_REGISTRY }}/${{ env.IMAGE_NAME }}:latest

  deploy:
    needs: build-image
    runs-on: ubuntu-latest
    environment: development
    steps:
      - name: Deploy to OpenShift
        uses: redhat-actions/oc-login@v1
        with:
          openshift_server_url: ${{ secrets.OPENSHIFT_SERVER }}
          openshift_token: ${{ secrets.OPENSHIFT_TOKEN }}

      - name: Update deployment
        run: |
          oc set image deployment/application \
            application=${{ env.IMAGE_REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
            -n development
          oc rollout status deployment/application -n development
```

## Output Format

Provide:
1. Complete pipeline definition
2. Required secrets/credentials setup
3. Trigger configuration
4. Usage instructions
5. Customization options

## Interaction Guidelines

- Confirm target platform before generating
- Ask about existing CI/CD infrastructure
- Explain pipeline stages and decisions
- Include comments in pipeline code
- Provide security recommendations
