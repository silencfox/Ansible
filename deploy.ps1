cls
cd "path/to/proyect"

docker build --build-arg VCS_REF=`git rev-parse --short HEAD` \
             --build-arg BUILD_DATE=`date -u +”%Y-%m-%dT%H:%M:%SZ”` \
             --build-arg ANSIBLE_VERSION=${ANSIBLE_VERSION:=6.0.0} \
             --build-arg ANSIBLE_LINT_VERSION=${ANSIBLE_LINT_VERSION:=6.2.2} \
             --build-arg MITOGEN_VERSION=${MITOGEN_VERSION:=0.3.0-rc.0} \
             -t ${IMAGE_NAME:=silencfox/ansible:6.0.0} .
docker tag silencfox/ansible:6.0.0 silencfox/ansible:latest

docker run -it --rm \
  -v ${PWD}:/ansible \
  silencfox/ansible:latest \
  ansible-playbook --version

docker run -it --rm -v ${PWD}:/ansible cc6c024dcc95 /bin/bash


pip3 install -r ~/.ansible/collections/ansible_collections/community/vmware/requirements.txt

