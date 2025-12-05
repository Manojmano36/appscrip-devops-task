🚀 **DevOps Assignment – AWS EKS + Terraform + ArgoCD + GitOps + NGINX**

This project fully implements a production-grade Kubernetes environment on AWS using Infrastructure as Code (Terraform) and GitOps (ArgoCD).
It satisfies all requirements in the assignment PDF and includes clear documentation for interview evaluation.

📌 **1. Architecture Overview**

**This project deploys:**

**AWS Infrastructure (via Terraform)**

**VPC (CIDR, public + private subnets, NAT, routing)**

**Internet Gateway + NAT Gateway**

**IAM Roles + Policies for:**

**EKS Cluster**

**Node Groups**

**ALB Ingress Controller (AWSLoadBalancerControllerIAMPolicy)**

**EKS Control Plane**

**EKS Worker Node Groups**

**Kubernetes Layer**

ArgoCD installation (GitOps engine)

**Application manifests (deployment, service, ingress)**

**Auto-sync pipeline from GitHub**

**ALB Ingress Controller**

**GitOps Workflow**

**ArgoCD watches your Git repo**

**Any code change = automatic deployment to EKS**

<img width="766" height="495" alt="image" src="https://github.com/user-attachments/assets/15e82ee0-56aa-4731-9c73-bff6a71304af" />


🛑 **Folders to Ignore / Not Commit**

**Add these to .gitignore:**

.terraform/
terraform.tfstate
terraform.tfstate.backup
*.tfvars
.terraform.lock.hcl

🔧 **3. Terraform – EKS Provisioning**
Initialize:
terraform init

Validate:
terraform validate

Plan:
terraform plan

Apply:
terraform apply -auto-approve

🧠 4. **IAM Permissions Used**
✔ IAM Role for EKS Cluster

Attached policies:

AmazonEKSClusterPolicy

AmazonEKSVPCResourceController

✔ **IAM Role for Worker Nodes**

Attached policies:

AmazonEKSWorkerNodePolicy

AmazonEKS_CNI_Policy

AmazonEC2ContainerRegistryReadOnly

✔ **IAM Policy for AWS Load Balancer Controller**

File: iam_policy.json (FROM AWS documentation)
Commands used:

curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json


Create policy:

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json

✔ **IAM OIDC Provider**

Required for assigning IAM roles to service accounts:

eksctl utils associate-iam-oidc-provider \
  --region us-east-1 \
  --cluster demo-eks \
  --approve

✔ **IAM Service Account for ALB Controller**
eksctl create iamserviceaccount \
  --cluster=demo-eks \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::<ACCOUNT-ID>:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

📡 **5. Configure kubectl**
aws eks update-kubeconfig --name demo-eks --region us-east-1


Verify:

kubectl get nodes
kubectl get pods -A

🎯 6. Install ArgoCD (GitOps Engine)
kubectl create namespace argocd
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


**Check:**

kubectl get pods -n argocd

🔐 7. Expose ArgoCD (NodePort - FREE & Simple)
kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "NodePort"}}'


**Get NodePort:**

kubectl get svc -n argocd argocd-server


Login (port forwarding):

kubectl port-forward svc/argocd-server -n argocd 8080:443


**Open UI:**

https://localhost:8080


**Get password:**

kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d

🚀 8. **Deploy Application Using ArgoCD**

ArgoCD watches this repo:

https://github.com/Manojmano36/appscrip-devops-task

**Your application file:**

📄 argocd/application.yaml

repoURL: https://github.com/Manojmano36/appscrip-devops-task.git
path: manifests


**Apply:**

kubectl apply -f argocd/application.yaml


**Check:**

kubectl get applications -n argocd


**ArgoCD UI shows:**

Synced

Healthy

Pods running

Service and Ingress created

🌐 **9. Access the NGINX Application**
Option A — NodePort (Free)
kubectl get svc nginx-service


**Open:**

http://<node-ip>:30080

Option B — ALB Ingress
kubectl get ingress nginx-ingress


**Open the ALB DNS name.**

🧪 10. ArgoCD CLI Commands (For Interview)

Install CLI:

sudo curl -sSL -o /usr/local/bin/argocd \
  https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd


**Login:**

argocd login localhost:8080 --username admin --password <pwd> --insecure


**Get app:**

argocd app get myapp


**Sync:**

argocd app sync myapp


**Rollback**:

argocd app rollback myapp <revision>

> 📸 **Here attached My Output — [Click here to view the screenshot](./Screenshot_README.md)**  


