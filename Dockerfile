FROM hashicorp/terraform
RUN mkdir  -p /terraform/modules ~/.aws
WORKDIR /terraform
ADD .aws /root/.aws/
COPY main.tf .
COPY variables.tf .
COPY outputs.tf .
COPY *.tfvars .
ADD modules ./modules/
RUN terraform init
CMD ["plan"]

