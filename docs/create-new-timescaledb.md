# EKS TimescaleDB Deployment Guide

This guide provides step-by-step instructions on how to create a new timescaleDB release in EKS cluster using helm charts.

## Pre-requisites

Before proceeding further make sure you have the below ready.
1. EKS cluster up and running, if not follow the steps in terraform/module-eks/examples/README.md 
2. Make sure to run the below storageClass config files from the directory helm-charts/extra-yaml/
    a. `prod-sc-gp3.yaml`
    b. `prod-sc-io1.yaml`
    c. `prod-sc-io2.yaml`

## 1. Helm Values File Setup for New Release

### i. Create a new values file

Create a new values file in the directory `helm-charts/timescaledb-single/`. Follow the current pattern for file naming conventions. Ensure that your file name indicates the environment, database number, etc.

### ii. Configure Affinity

Make sure to create your database in the same zone as your persistent volumes:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: topology.kubernetes.io/zone
          operator: In
          values:
          - ap-south-1b # Decide based on the load on the node
```
### iii. Modify the `persistentVolumes` Section

Modify the `persistentVolumes` section as per the volumes created:

```yaml
persistentVolumes:
  data:
    enabled: true
    size: 12Ti  # provide volume-size as per the requirement
    storageClass: "io2" # Preferred storagClass type
    subPath: ""
    mountPath: "/var/lib/postgresql"
    annotations: {}
    accessModes:
    - ReadWriteOnce
  wal:
    enabled: true
    size: 150Gi # provide volume-size as per the requirement
    subPath: ""
    storageClass: "io2" # Preferred storagClass type
    mountPath: "/var/lib/postgresql/wal"
    annotations: {}
    accessModes:
    - ReadWriteOnce
```
## iv. Create Additional Partitions in `tablespaces`

You can create additional partitions in `tablespaces` by adding the following configuration. Any tablespace mentioned here requires a volume that will be associated with it.

```yaml
tablespaces:
    partition1:
      size: 10Ti # volume size of partition1, as per the requirement
      storageClass: io1 # volume-type of partition1, as required
    partition2:
      size: 150Gi
      storageClass: io1
```

## 5. Create Namespace for Helm Release

Create the namespace for the Helm release:

```bash
kubectl create namespace <name-of-the-namespace>
```

## 6. Helm Release Command

Now, execute the Helm release with the following command:

```bash
helm upgrade --install <timescaledb-release-name> <helm-chart-context> -f <path-to-the-values-file> -n <name-of-the-namespace-created>
```

### Example:

Assuming I'm running the command from the root of the repository and my namespace is `timescaledb-1`, for a prod db the command would look like below:

```bash
helm upgrade --install timescaledb-1 helm-charts/timescaledb-single/. -f helm-charts/timescaledb-single/values-prod-1-new-cluster.yaml -n timescaledb-1
```

## 7. Create a network load balancer(internal) to expose the DB to the services

Create an internal NLB to expose the timescaledb, create a yaml config file in `helm-charts/extra-yaml`

Below is the sample config to create a nlb.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: < name-of-the-load-balancer > # Name of the loadbalancer, verify the existing nlb config in 
  namespace: < namespace > # should match with the namespace of the helm release
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-internal: "true"
    service.beta.kubernetes.io/aws-load-balancer-scheme: internal
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
    service.beta.kubernetes.io/aws-load-balancer-attributes: deletion_protection.enabled=true
spec:
  type: LoadBalancer
  selector:
    release: < > # should match with the release name of the timescaledb
    app: < > # should match with the release name of the timescaledb
  ports:
  - port: 5432
    targetPort: 5432
```

Apply the above config to create the NLB using the below command.

```bash
kubectl apply -f <path-to-the-nlb-config-file>
```
