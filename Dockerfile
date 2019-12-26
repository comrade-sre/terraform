FROM hashicorp/terraform
RUN mkdir  -p /terraform/modules
WORKDIR /terraform
COPY main.tf .
COPY variables.tf .
COPY outputs.tf .
COPY *.tfvars .
ADD modules ./modules/
RUN ls -lR
RUN terraform init -backend=false
CMD ["plan"]
