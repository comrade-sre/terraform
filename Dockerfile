FROM hashicorp/terraform
USER comrade
RUN mkdir /terraform
WORKDIR /terraform
COPY . /terraform
RUN terraform init
CMD ["version"]
