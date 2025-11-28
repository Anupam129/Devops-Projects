Step 1️⃣: Install Ansible on Master Node


sudo amazon-linux-extras install epel -y

sudo yum install ansible -y

ansible --version

Step 2️⃣: Edit Inventory (Hosts) File

cd /etc/ansible

sudo vi hosts

Purpose                    	Command

Create encrypted playbook   	ansible-vault create secure.yml

Encrypt existing playbook	    ansible-vault encrypt play.yml

View	                        ansible-vault view play.yml

Edit	                        ansible-vault edit play.yml

Decrypt	                      ansible-vault decrypt play.yml
