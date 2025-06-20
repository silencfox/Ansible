FROM node:current-alpine
#FROM alpine:latest


# Metadata params
ARG BUILD_DATE
ARG ANSIBLE_VERSION
ARG ANSIBLE_LINT_VERSION
ARG MITOGEN_VERSION
ARG VCS_REF

# Metadata
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/local/bin/node"
LABEL maintainer="Kelvin Alcala. <kelvin.ag89@gmail.com>" \
      org.label-schema.url="https://github.com/silencfox/Ansible/blob/main/README.md" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.version=${ANSIBLE_VERSION} \
      org.label-schema.version_ansible=${ANSIBLE_VERSION} \
      org.label-schema.version_ansible_lint=${ANSIBLE_LINT_VERSION} \
      org.label-schema.version_mitogen=${MITOGEN_VERSION} \
      org.label-schema.vcs-url="https://github.com/silencfox/Ansible.git" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.description="Ansible on alpine docker image" \
      org.label-schema.schema-version="1.0"

WORKDIR /ansible 
#RUN mkdir -p /ansible

#COPY ./plantillas /ansible/plantillas/
COPY ./config /etc/ansible/
COPY ./config/pip.conf /etc/pip.conf
COPY ./entrypoint.sh /usr/bin/entrypoint.sh

RUN apk add --no-cache --virtual .pipeline-deps readline linux-pam \
  && apk add bash sudo shadow \
  && apk del .pipeline-deps
  
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v$(cut -d. -f1-2 < /etc/alpine-release)/community" >> /etc/apk/repositories \
# Install dependencies and download glibc from the community repository
 && apk add --no-cache \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libstdc++ \
    libintl \
    tzdata \
    curl \
    icu-libs \
    krb5 \
    lttng-ust \
    openssl \
    unzip \
    bash \
    && curl -Lo /etc/apk/keys/sgerrand.rsa.pub -k https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && curl -Lo glibc.apk -k https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk 
#    && apk add glibc.apk \
#    && rm glibc.apk

RUN apk --update --no-cache add --virtual \
        ca-certificates \
        git \
        openssh-client \
        python3\
        rsync \
        sshpass \
        vim \
        nano \
        wget \
 && apk --update add --virtual \
        .build-deps \
        py3-pip \		
        python3-dev \
        libffi-dev \
        openssl-dev \
        build-base \
        curl \
        tar 
RUN chmod +x /usr/bin/entrypoint.sh \
 && chmod 777 -R /usr/bin/entrypoint.sh \       
 && if [ ! -z "${MITOGEN_VERSION+x}" ]; then curl -s -L https://github.com/mitogen-hq/mitogen/archive/refs/tags/v${MITOGEN_VERSION}.tar.gz | tar xzf - -C /opt/ \
 && mv /opt/mitogen-* /opt/mitogen; fi \
 && python3 -m venv /usr/local --system-site-packages \
# && pip3 install -r ~/.ansible/collections/ansible_collections/community/vmware/requirements.txt \
 && pip3 install --upgrade pip \
 && rm -rf /var/cache/apk/*
RUN apk upgrade --available && sync \
 && apk del \
        .build-deps \
		#curl \
 && apk cache clean \
 && mkdir -p /etc/ansible \
 && echo 'localhost ansible_connection=local' > /etc/ansible/hosts \
 && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

RUN pip3 install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r /etc/ansible/requirements.txt
RUN ansible-galaxy collection install -r /etc/ansible/requirements.yml --ignore-certs -vvv


# Download and install PowerShell
RUN curl -Lk  https://github.com/PowerShell/PowerShell/releases/download/v7.2.6/powershell-7.2.6-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz \
#RUN curl -Lk  https://github.com/PowerShell/PowerShell/releases/download/v7.6.0-preview.4/powershell-7.6.0-preview.4-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz \
    && mkdir -p /opt/microsoft/powershell/7 \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
    && ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh \
    && rm /tmp/powershell.tar.gz \
# Optionally, install VMware PowerCLI via PowerShell
	&& pwsh -Command "Install-Module -Name VMware.PowerCLI -Force -AllowClobber -Scope AllUsers" 
	#&& pwsh -command "Import-Module VMware.PowerCLI" \
	#&& pwsh -command "Import-Module VMware.VimAutomation.Core" \
	#&&pwsh -command Set-PowerCLIConfiguration -scope AllUsers -ParticipateInCEIP \$false -Confirm:\$false -DisplayDeprecationWarnings \$false
	#Set-PowerCLIConfiguration -scope AllUsers -ParticipateInCEIP $false -Confirm:$false -DisplayDeprecationWarnings \$false


#ENTRYPOINT ["/bin/sh","/usr/bin/entrypoint.sh"]

# default command: display Ansible version
#CMD [ "ansible-playbook", "--version" ]
CMD [ "node" ]
#CMD ["/bin/sh"]

##	Probar SDK Pure Storage
##  python3 -c "import purestorage"
##  python3 -c "import py_pure_client"
##  python3 -c "import requests"

