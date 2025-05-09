mkdir /ssl

curl https://get.acme.sh | sh -s email=example@example.com

reboot

acme.sh --upgrade --auto-upgrade

export CF_Key=""
export CF_Email=""

acme.sh --issue --dns dns_cf -d kunlun.asia -d '*.kunlun.asia' --keylength ec-256

acme.sh --install-cert -d kunlun.asia --key-file /ssl/key1.pem  --fullchain-file /ssl/cert1.pem --reloadcmd "systemctl restart sing-box"
