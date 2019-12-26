The ec2_proxy module creates an instance, SG and ssh key. The eks module deploys a control-plane for the kubernetes cluster in aws and an autoscaling-group for worker-nodes.\n
For use, you must first add your TF_VAR_key to the environment variables.
The following commands are used for work:
terraform init for downloading providers, initializing modules, and setting up terraform to work with s3 as storage for state.
terraform plan to see which resources are in the infrastructure and which will be created next terraform apply. Optional -out saves the plan to a file.
terraform apply to apply the entire plan to the infrastructure. Optional -target=resource for deploying not the whole plan, but only a specific resource.
Before apply, you can make taint of the resources that you want to recreate, even if they exist.
For build docker image you should run docker build -t mentoring -f Dockerfile . Dot point to the current directory as place where docker can find build context.
