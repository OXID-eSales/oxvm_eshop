FROM ansible/ubuntu14.04-ansible:stable

# Add playbooks to the Docker image
ADD ansible /opt/ansible
ADD ansible.cfg /opt/ansible.cfg
ADD base_vm /opt/base_vm
WORKDIR /opt/

VOLUME ['/var/www/oxideshop']

# Run Ansible to configure the Docker image
RUN /usr/bin/python2 -u /usr/bin/ansible-playbook ansible/oxid.yml -c local --extra-vars "docker=true"

# Other Dockerfile directives are still valid
EXPOSE 80
ENTRYPOINT ["/usr/sbin/apachectl", "-DFOREGROUND"]
