FROM ubuntu:latest

LABEL maintainer="robdefeo@gmail.com"

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# install base
RUN echo "Y" | apt update \
    && echo "Y" | apt upgrade \
    && echo "Y" | dpkg --purge --force-depends ca-certificates-java \
    && echo "Y" | apt-get install ca-certificates-java \
    && echo "Y" | apt-get install wget curl unzip software-properties-common gnupg2 -y \
    && echo "Y" | apt-get install build-essential \
    && echo "Y" | apt-get install git \
    && echo "Y" | apt-get install openjdk-8-jdk

# install go
RUN wget https://dl.google.com/go/go1.17.5.linux-amd64.tar.gz \
    && tar -xvf go1.17.5.linux-amd64.tar.gz \
    && mv go /usr/local

# install node & npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \ 
    && echo "Y" | apt-get install -y nodejs \
    && npm install --global yarn@1.22.19

# install terraform
RUN wget https://releases.hashicorp.com/terraform/1.2.9/terraform_1.2.9_linux_amd64.zip \
    && unzip terraform_1.2.9_linux_amd64.zip\
    && mv terraform /usr/local/bin/

# install swagger
RUN curl -o /usr/bin/swagger -L'#' https://github.com/go-swagger/go-swagger/releases/download/v0.29.0/swagger_linux_amd64 \
    && chmod +x /usr/bin/swagger

# set go path
ENV PATH="$PATH:/usr/local/go/bin"

# install protobuf
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v21.6/protoc-21.6-linux-x86_64.zip \
    && unzip -o protoc-21.6-linux-x86_64.zip -d /usr bin/protoc \
    && unzip -o protoc-21.6-linux-x86_64.zip -d /usr 'include/*' \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26 \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1

# install nx
RUN npm install -g nx@14.7.5

# set path permanently
ENV PATH="$PATH:$(go env GOPATH)/bin"

ENTRYPOINT ["/entrypoint.sh"]
