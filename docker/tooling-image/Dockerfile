####################################################################
# Docker Image for Managing EKS Clusters from Desktop or CI Pipeline
# 
# Contains:
#  - Terraform
#  - KubeCTL
#  - Helm
#  - AWS CLI
#  - EKSCtl CLI
#
# Note: software versions are latest as of 05-Nov-2020
# Maintainer:  Daniel Auld | NeuralEssence LTD

FROM golang:alpine as build

# Terraform Latest Release Tag: https://github.com/hashicorp/terraform/tags
ENV TERRAFORM_VERSION=v0.13.5

RUN apk add --update git bash openssh curl

ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout ${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh

# Helm Install: https://github.com/helm/helm/releases
ENV HELM_VERSION=v3.4.0
RUN curl -o helm-package.tgz https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -xzvf helm-package.tgz && \
    mv ./linux-amd64/helm /go/bin/. && \
    chmod +x /go/bin/helm

# In our final image, we don't need the artifacts from the build command, so
# we start again with the base image and only copy over the desired binaries

FROM node:lts-alpine
MAINTAINER "Daniel Auld | NeuralEssence LTD"

# AWS CLI Latest Release: https://github.com/aws/aws-cli/releases
ENV AWSCLI_VERSION=1.18.171

COPY --from=build /go/bin/* /usr/local/bin/

RUN apk --no-cache --update add python \
  python3 \
  py-pip \
  ca-certificates \
  groff \
  less \
  curl \
  make \
  bash \
  nano \
  jq \
  git \
  zip \
  openssh && \
pip3 install --upgrade pip && \
pip3 --no-cache-dir install awscli==${AWSCLI_VERSION} && \
update-ca-certificates

# KUBECTL Version: https://github.com/kubernetes/kubernetes/releases
ENV KUBECTL_VERSION=v1.18.10
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl /usr/local/bin/

# EKSCTL Version: https://github.com/weaveworks/eksctl/releases/
ENV EKSCTL_VERSION=0.32.0-rc.0
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C ./ && \
  chmod +x ./eksctl && \
  mv ./eksctl /usr/local/bin

COPY assume-rol* /usr/local/bin/
RUN chmod +x /usr/local/bin/assume-rol*

WORKDIR /opt/app

CMD ["bash"]
