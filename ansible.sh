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
// check all information

ansible all -m setup


// palybook to deploy 
---
- name: Install nginx and deploy project
  hosts: all
  become: yes

  tasks:

    - name: Install nginx
      yum:
        name: nginx
        state: present

    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Deploy web page
      copy:
        src: index.html
        dest: /usr/share/nginx/html/index.html

    - name: Restart nginx
      service:
        name: nginx
        state: restarted

// if you put the tag in playbook then you can run the playbook with tag
ansible-playbook playbook.yml --tags "install,deploy"
 // skip the task with tag
ansible-playbook playbook.yml --skip-tags "install"

// lookup plugin to read file content
- name: Read file content
  debug:
    msg: "{{ lookup('file', '/path/to/file') }}"  
    
    // asynchronous task and polling
- name: Run long task asynchronously
  shell: /path/to/long_task.sh
  async: 3600
  poll: 0 
- name: Check result of long task
  async_status:
    jid: "{{ long_task_job_id }}"   
  register: long_task_result
  until: long_task_result.finished
  retries: 10
  delay: 30
    