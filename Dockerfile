FROM ubuntu:latest

LABEL maintainer="robdefeo@gmail.com"

COPY . /

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
RUN curl -o /usr/local/bin/swagger -L'#' https://github.com/go-swagger/go-swagger/releases/download/v0.29.0/swagger_linux_amd64 \
    && chmod +x /usr/local/bin/swagger

# install protobuf
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v21.6/protoc-21.6-linux-x86_64.zip \
    && unzip protoc-21.6-linux-x86_64.zip -d $HOME/.local && export \
    PATH="$PATH:$HOME/.local/bin"

# install nx
RUN npm install -g nx@14.7.5

ENTRYPOINT ["/entrypoint.sh"]
