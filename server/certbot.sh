#!/bin/bash
# file representasi proses konfigurasi ssl 
# untuk domain my-zienzdn.site menggunakan certbot

# install pip
sudo apt install python3 python3-venv libaugeas0 -y

# set up python venv
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip -y

# install certbot
sudo /opt/certbot/bin/pip install certbot certbot-nginx -y

# create asymlink
sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot

# create ssl for domain
sudo certbot install --cert-name my-zienzdn.site