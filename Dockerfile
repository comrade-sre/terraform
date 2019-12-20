FROM hashicorp/terraform
RUN mkdir /terraform
WORKDIR /terraform
ADD .aws /root/
COPY . /terraform
RUN terraform init
CMD ["plan"]
