sudo dnf install ansible -y
// no need int amzone 2023
yum install python3 python-pip python-dlevel -y
// to insall git on localhost
ansible localhost -m dnf -a "name=git state=present" -b

// pache 
// for mudle command to inslatt git 
 ansible all -m yum -a "name=git state=present"

 // to install httpd
    ansible all -m yum -a "name=httpd state=present"
// to start httpd
    ansible all -m service -a "name=httpd state=started enabled=yes"
// to check status of httpd
    ansible all -m service -a "name=httpd state=started"
// romeve httpd
    ansible all -m yum -a "name=httpd state=absent"


// to create user
ansible all -m user -a "name=ansible state=present"
// to see the user
ansible all -a "cat /etc/passwd | grep ansible"
// to remove user
ansible all -m user -a "name=ansible state=absent"

// to create file
ansible all -m file -a "path=/tmp/ansible_file state=touch
// copy file from local to remote
ansible all -m copy -a "src=/path/to/local/file dest=/path/to/remote/file"
// to remove file
ansible all -m file -a "path=/tmp/ansible_file state=abs 


// craete playbook
run playbook
ansible-playbook playbook.yml
// check syntax of playbook
ansible-playbook playbook.yml --syntax-check