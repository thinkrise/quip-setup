If SSH is already configured: 
ssh -p <port> <user>@<host> "bash -s" < provision.sh

If SSH is not configured pass along your public key:
ssh -p <port> <user>@<host> "bash -s '$(cat ~/.ssh/id_rsa.pub)'" < provision.sh