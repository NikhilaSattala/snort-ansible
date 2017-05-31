The deployment and configuration process of Snort server is automated using Ansible. 

This Ansible project consists of following roles,

- daq

- snort

- barnyard2

- pulledpork

- crontab

- mysql

- snorby

- passenger

- alerts

- supress_events 

Deployment:
=========== 

1]     Install Ansible 2.0

2]     Perform following configurations on NIC:

Some network cards have features named “Large Receive Offload” (lro) and “Generic Receive Offload” (gro) which needs to turned off by following the below steps for Snort server:

`sudo apt-get install -y ethtool`

Append the following two lines for each network interface (making sure to change eth0 to match the interface you are working on, since your interface names may be different):

`post-up ethtool -K eth0 gro off`

`post-up ethtool -K eth0 lro off`

`sudo ifconfig eth0 down && sudo ifconfig eth0 up

ethtool -k eth0 | grep receive-offload`

[These steps are also automated using nic_config role in the ansible, but will loose network connectivity to the server(as eth0 will be made down) and requires to reconnect to the server to execute the ansible playbook with the other roles] 

3]     Required variables need to be updated in group_vars/snortserver file based on your environment.

4]     Execute the ansible playbook using below command
          
`ansible-playbook -i hosts site.yml --ask-become-pass`
       
`where,`
       
`site.yml file : containing the above mentioned roles`
      
`hosts file : specifies the localhost as snortserver`
       
`--ask-become-pass to provide SUDO password of your localhost.`
          
5]     After complete execution of playbook, login to the snorby GUI (https://localhost_ip) using the following credentials:
       
`Email: snorby@snorby.org`
       
`Password: snorby`
       
  It takes a while for Barnyard2 service to update the Database and Snorby_worker to populate the events in GUI.
     
Maintenance:
============
Alerts for HIGH SEVERE events will be received to the mail address mentioned in group_vars/snortserver ansible file.

The unthreatening events can be supressed to avoid unnecessary noise using the script provided at /root/supressSnortEvents.sh (which requires Event name, Sigature ID and Generator ID as parameters).

An automated Cronjob will be executed weekly to cleanup archived logs.

