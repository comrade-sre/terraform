FROM hashicorp/terraform
RUN mkdir  /terraform/
WORKDIR /terraform
RUN whoami
RUN mkdir /root/.aws
COPY .aws/* /root/.aws/
RUN ls /root/.aws/
COPY . /terraform
RUN terraform init
CMD ["plan"]
