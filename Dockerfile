FROM alpine:latest

# Metadata params
ARG BUILD_DATE
ARG ANSIBLE_VERSION
ARG ANSIBLE_LINT_VERSION
ARG MITOGEN_VERSION
ARG VCS_REF

# Metadata
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

COPY ./plantillas /ansible/plantillas/
COPY ./config /etc/ansible/
COPY ./config/pip.conf /etc/pip.conf
COPY ./entrypoint.sh /usr/bin/entrypoint.sh

RUN apk --update --no-cache add --virtual \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        python3\
        rsync \
        sshpass \
        bash \
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
 && chmod +x /usr/bin/entrypoint.sh \
 && chmod 777 -R /usr/bin/entrypoint.sh \       
 && if [ ! -z "${MITOGEN_VERSION+x}" ]; then curl -s -L https://github.com/mitogen-hq/mitogen/archive/refs/tags/v${MITOGEN_VERSION}.tar.gz | tar xzf - -C /opt/ \
 && mv /opt/mitogen-* /opt/mitogen; fi \
 && python3 -m venv /usr/local --system-site-packages \
 && pip3 install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r /etc/ansible/requirements.txt \
 && ansible-galaxy collection install -r /etc/ansible/requirements.yml --ignore-certs \
 && pip3 install -r ~/.ansible/collections/ansible_collections/community/vmware/requirements.txt \
 && pip3 install --upgrade pip \
 && rm -rf /var/cache/apk/* \
 && apk upgrade --available && sync \
 && apk del \
        .build-deps \
		curl \
 && apk cache clean \
 && mkdir -p /etc/ansible \
 && echo 'localhost ansible_connection=local' > /etc/ansible/hosts \
 && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config


#RUN pip3 install ansible-lint==${ANSIBLE_LINT_VERSION}





#ENTRYPOINT ["/bin/sh","/usr/bin/entrypoint.sh"]

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
#CMD ["/bin/sh"]

##	Probar SDK Pure Storage
##  python3 -c "import purestorage"
##  python3 -c "import py_pure_client"
##  python3 -c "import requests"

