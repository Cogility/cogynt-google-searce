# Workload Identity Commands

## To create a kubernetes Service account, use below command :

``` 
kubectl create serviceaccount k8s_sa_name --namespace namespace_name

```


## To annotate the kubernetes service account with GCP service account, use below command :

```
kubectl annotate serviceaccount k8s_sa_name --namespace namespace_name \
    iam.gke.io/gcp-service-account=gcp_sa_name@cogynt.iam.gserviceaccount.com

```


## To Ensure that the Kubernetes service account is annotated correctly :

```
kubectl describe serviceaccount --namespace namespace_name k8s_sa_name

```
 
### The output contains an annotation similar to the following :

```
iam.gke.io/gcp-service-account: gcp_sa_name@cogynt.iam.gserviceaccount.com
```


## To ensure the IAM service account is configured correctly :

```
gcloud iam service-accounts get-iam-policy \
 gcp_sa_name@cogynt.iam.gserviceaccount.com

```

### The output contains a binding similar to the following :

```
- members:
  - serviceAccount:cogynt.svc.id.goog[namespace_name/k8s_sa_name]
  role: roles/iam.workloadIdentityUser

```


## To remove the annotation from the Kubernetes service account :

```
kubectl annotate serviceaccount k8s_sa_name \
    --namespace namespace_name iam.gke.io/gcp-service-account-

```
