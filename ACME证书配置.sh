mkdir /ssl

curl https://get.acme.sh | sh -s email=example@example.com

reboot

acme.sh --upgrade --auto-upgrade

export CF_Key="93741d9df251e8692bcb88ac16b7a21993f45"
export CF_Email="@outlook.com"

acme.sh --issue --dns dns_cf -d nireus.cc -d '*.nireus.cc' --keylength ec-256

acme.sh --install-cert -d nireus.cc --key-file /ssl/kkk.pem  --fullchain-file /ssl/ccc.pem --reloadcmd "systemctl restart sing-box"
