## Create your cluster[AKS]
[https://docs.gitlab.com/ee/user/infrastructure/clusters/connect/new_aks_cluster.html](https://docs.gitlab.com/ee/user/infrastructure/clusters/connect/new_aks_cluster.html)

## Create A directory and a config.yaml file in that directory: 
[.gitlab/agents/cafanwi-agent]

file in dorectory: .gitlab/agents/cafanwi-agent/config.yaml
[config.yaml]

## Return to gitlab --> Operator --> Kubernetes cluster 
- It will provide you a token, copy and paste some where

hHbxTzHq6Yeux_6FwiRsVt544wZADsDnet5msBE-QpM2gzZ5Tw

## You can use this option with Helm
```
helm repo add gitlab https://charts.gitlab.io
helm repo update

helm upgrade --install aks-agent gitlab/gitlab-agent \
    --namespace gitlab-agent-aks-agent \
    --create-namespace \
    --set image.tag=v16.3.0-rc6 \
    --set config.token=hHbxTzHq6Yeux_6FwiRsVt544wZADsDnet5msBE-QpM2gzZ5Tw \
    --set config.kasAddress=wss://kas.gitlab.com
```

[You will see the Agent is now connected]

AZURE_CLIENT_ID    7c9fa614-3d6e-4a10-afe8-0130af8007a3
AZURE_CLIENT_SECRET  tGx8Q~RSM8.gzWHAmn3_Iuw~W13wzb9O~xSbwdpi
AZURE_TENANT_ID   6c5864a4-4b20-4b29-810e-3fb0ca8ca942
TF_VAR_agent_token   hHbxTzHq6Yeux_6FwiRsVt544wZADsDnet5msBE-QpM2gzZ5Tw
TF_VAR_kas_address   wss://kas.gitlab.com

***Copy the Values.yaml and edit***

```yml
## For RBAC support:
rbac:
  create: true

  ## Define list of rules to be added to the rbac role permissions.
  ## Each rule supports the keys:
  ## - apiGroups: default "" (indicates the core API group) if missing or empty.
  ## - resources: default "*" if missing or empty.
  ## - verbs: default "*" if missing or empty.
  ##
  ## Read more about the recommended rules on the following link
  ##
  ## ref: https://docs.gitlab.com/runner/executors/kubernetes.html#configuring-executor-service-account
  ##
  rules: 
  - resources: ["configmaps", "pods", "pods/attach", "secrets", "services"]
    verbs: ["get", "list", "watch", "create", "patch", "update", "delete"]
  - apiGroups: [""]
    resources: ["pods/exec"]
    verbs: ["create", "patch", "delete"]

  ## Run the gitlab-bastion container with the ability to deploy/manage containers of jobs
  ## cluster-wide or only within namespace
  clusterWideAccess: false

  ## Use the following Kubernetes Service Account name if RBAC is disabled in this Helm chart (see rbac.create)
  ##
  # serviceAccountName: default
  # serviceAccountName: 137701313909-compute@developer.gserviceaccount.com
```

the service account to

```yaml
serviceAccountName: cafanwi-gitlab-runner-sa

serviceAccountAnnotations:
  iam.gke.io/gcp-service-account: "137701313909-compute@developer.gserviceaccount.com"
```

next 

```
kubectl create ns cafanwi-gitlab-runner
helm repo add gitlab https://charts.gitlab.io
helm init
helm repo update gitlab
helm search repo -l gitlab/gitlab-runner

helm install --namespace cafanwi-gitlab-runner gitlab-runner -f values.yaml gitlab/gitlab-runner

```

https://gitlab.com/gitlab-org/charts/gitlab-runner/-/tree/main/


NOTE: Configure RBAC For the service account that GitLab is gonna need to configure new pods
- serviceAccountName: 137701313909-compute@developer.gserviceaccount.com

AFTER CREATING
