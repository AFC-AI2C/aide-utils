#!/bin/bash
#
# install.sh
#
# This script performs the following operations:
# - Downloads and installs the root CA for AIDE clusters in the trusted store
# - Writes the required entries to the hosts file

# Download and install the mkcert binary
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 && \
    chmod +x mkcert-v1.4.4-linux-amd64 && \
    sudo mv mkcert-v1.4.4-linux-amd64 /usr/local/bin/mkcert

# Download the root CA certificate
wget https://raw.githubusercontent.com/AFC-AI2C/aide-utils/refs/heads/main/files/test/rootCA.crt

# Move the certificate to the proper location
mkdir -p $(mkcert -CAROOT) && \
    mv rootCA.crt $(mkcert -CAROOT)

# Install the certificate in the trusted store
mkcert -install

# Update the hosts file; ensure that CRLF is converted to LF for UNIX
sudo cp /etc/hosts /etc/hosts.bak && \
    wget -q -O - https://raw.githubusercontent.com/AFC-AI2C/aide-utils/refs/heads/main/files/test/hosts.txt | tr -d '\r' | sudo tee -a /etc/hosts > /dev/null && \
    echo '' | sudo tee -a /etc/hosts > /dev/null

exit 0
