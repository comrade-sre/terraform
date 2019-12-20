FROM hashicorp/terraform
RUN mkdir /terraform && mkdir /root/.kube
WORKDIR /terraform
ADD .aws /root/
COPY . /terraform
RUN terraform init
CMD ["plan"]
