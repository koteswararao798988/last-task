# Install aws-iam-authenticator and kubectl on the EC2 instance
resource "remote_exec" "install_tools" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = main-key
    host        = aws_instance.app1.public_ip
  }

  inline = [
    "sudo curl -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2021-01-05/bin/linux/amd64/aws-iam-authenticator",
    "sudo chmod +x /usr/local/bin/aws-iam-authenticator",
    "sudo curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2021-01-05/bin/linux/amd64/kubectl",
    "sudo chmod +x kubectl",
    "sudo mv kubectl /usr/local/bin/",
  ]
}

# Retrieve EKS cluster endpoint and authentication token
data "aws_eks_cluster" "kubernetes_eks" {
  name = "k8s-cluster"
}

# Configure kubectl with EKS cluster endpoint and authentication token
resource "null_resource" "configure_kubectl" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = main-key
    host        = aws_instance.app1.public_ip
  }
  provisioner "local-exec" {
    command = "kubectl config set-cluster ${data.aws_eks_cluster.kubernetes_eks.name} --server=${data.aws_eks_cluster.kubernetes_eks.endpoint}"
  }

  provisioner "local-exec" {
    command = "kubectl config set-context ${data.aws_eks_cluster.kubernetes_eks.name} --cluster=${data.aws_eks_cluster.kubernetes_eks.name} --user=aws --namespace=default"
  }

  provisioner "local-exec" {
    command = "kubectl config set-credentials aws --token=$(aws eks get-token --cluster-name ${data.aws_eks_cluster.kubernetes_eks.name} --region ap-south-1 --output 'json' | jq -r '.status.token')"
  }

  provisioner "local-exec" {
    command = "kubectl config use-context ${data.aws_eks_cluster.kubernetes_eks.name}"
  }
}

