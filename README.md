Design

A local VM is running an Ansible script, which is connecting to an AWS ec2 instance that is functioning as static mgmt server and runs the Terraform Infrastructure As Code (Cloud Formation).

1. start a server (spot) in AWS.-done
2. The server should be a Linux server with NGINX (basic configuration), with simple index.html.-done
3. the html should have your name The server will take the index.html from s3 and copy it in to the created server.
4. Setup auto scaling group to this server with 40% CPU.-TBD.
5. ind a solution for monitoring this server/service-TBD.