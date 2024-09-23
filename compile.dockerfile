FROM silencfox-ansible-ansible:latest AS base

FROM base AS compile-image

#RUN apk add curl
#RUN apk del ca-certificates py3-pip 
#RUN curl -sSL https://install.python-poetry.org | python3 -

# specify path to poetry binary
ENV export PATH="/root/.local/bin:$PATH"
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false
	
# Ideally, we should declare PIP_REQUIREMENTS at the first line (as we use it in both build and runtime stages).
# However, RUN commands run when an arg is changed, even if they don't use it: https://stackoverflow.com/a/57017745/13340988
# There is no problem we re-declare an arg, so we declare it as late as we can.
#ARG PIP_REQUIREMENTS=common,task_initiator


#COPY poetry.lock pyproject.toml ./
#RUN poetry install --with $PIP_REQUIREMENTS

#COPY --from=compile-image --chown=example /opt/venv /opt/venv

WORKDIR /ansible

#ENTRYPOINT ["entrypoint.sh"]

# default command: display Ansible version
#CMD [ "ansible-playbook", "--version" ]
CMD ["/bin/sh"]

