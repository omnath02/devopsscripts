EC2 - KOPS Management machine/ AL2023 OS/ IAM Role attached/ c7flex.large/ 

ec2-user
sudo -s

vi kops-setup.sh
---------------------------------------------------------------------

#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Step 1: Updating PATH and environment ==="
export PATH=$PATH:/usr/local/bin/

# Define bucket name early so it can be used globally
BUCKET_NAME="reyaz-kops-testbkt14333314s.k8s.local"
REGION="ap-south-1"

# Export and persist KOPS_STATE_STORE right away
export KOPS_STATE_STORE="s3://$BUCKET_NAME"
if ! grep -q "KOPS_STATE_STORE" ~/.bashrc; then
    echo "export KOPS_STATE_STORE=s3://$BUCKET_NAME" >> ~/.bashrc
fi

echo "=== Step 2: Generating SSH Key Pair ==="
# Automatically generate an SSH key without prompting
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa
fi

# Copy and set permissions for the public key
cp /root/.ssh/id_rsa.pub ./my-keypair.pub
chmod 777 ./my-keypair.pub

echo "=== Step 3: Downloading and Installing kubectl and kops ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
wget https://github.com/kubernetes/kops/releases/download/v1.32.0/kops-linux-amd64

chmod +x kops-linux-amd64 kubectl
mv kubectl /usr/local/bin/kubectl
mv kops-linux-amd64 /usr/local/bin/kops

echo "=== Step 4: Creating S3 State Store Bucket ==="
# Check if bucket already exists before trying to create it
if ! aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$REGION" \
        --create-bucket-configuration LocationConstraint="$REGION"
    
    aws s3api put-bucket-versioning \
        --bucket "$BUCKET_NAME" \
        --region "$REGION" \
        --versioning-configuration Status=Enabled
else
    echo "S3 bucket already exists, skipping creation."
fi

echo "=== Step 5: Creating K8s Cluster via Kops ==="
kops create cluster \
    --name=reyaz.k8s.local \
    --zones=ap-south-1a,ap-south-1b \
    --control-plane-count=1 \
    --control-plane-size=t3.small \
    --node-count=2 \
    --node-size=t3.small \
    --node-volume-size=40 \
    --control-plane-volume-size=40 \
    --ssh-public-key=my-keypair.pub \
    --image=ami-02d26659fd82cf299 \
    --networking=calico

echo "=== Step 6: Updating Cluster Configuration ==="
kops update cluster --name reyaz.k8s.local --yes --admin

echo "=== Step 7: Validating Cluster ==="
echo "Waiting for the cluster to become ready (this may take a few minutes)..."
kops validate cluster --wait 10m

echo "=== Cluster setup and validation complete! ==="

-------------------------------------------------------------------
#Make the script executable:
chmod +x kops-setup.sh

#Run the script:
./kops-setup.sh

#wait for 15 min --- check infra created -----
```bash
kubectl get nodes
kubectl get nodes -o wide
kubectl get pods -A
kops get cluster
```
#Delete the Kubernetes cluster and all AWS resources (EC2 instances, VPC, ELB, security groups):
kops delete cluster --name reyaz.k8s.local --yes
#Delete the S3 State Store bucket (since kops leaves the bucket behind by default):
aws s3 rb s3://reyaz-kops-testbkt14333314s.k8s.local --force



