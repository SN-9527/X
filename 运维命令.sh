# 初始命令
apt update -y&&apt upgrade -y
apt install -y curl wget vim git net-tools build-essential sudo
apt autoremove -y

# Debian虚拟机替换源
echo -e "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" | tee /etc/apt/sources.list > /dev/null

# 安装Docker
curl -fsSL https://get.docker.com | bash -s docker
systemctl start docker && systemctl enable docker

# 安装Docker-Compose
curl -L "https://github.com/docker/compose/releases/download/v2.35.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Sing-Box
curl -fsSL https://sing-box.app/install.sh | sh
dpkg -i singbox.deb
systemctl enable sing-box&&systemctl start sing-box
journalctl -u sing-box --output cat -f