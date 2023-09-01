# rootstrap.sh 

# root user bootstrap code for system setup

ADMIN_USER_NAME=administrator

[ "`id -u`" -ne 0 ] && echo "Must be run as root!" && exit 1

apt update 
apt upgrade
apt install openssh-server ufw

adduser ${ADMIN_USER_NAME}
usermod -aG sudo ${ADMIN_USER_NAME}
echo "${ADMIN_USER_NAME} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${ADMIN_USER_NAME}

echo "AllowUsers ${ADMIN_USER_NAME}" | tee -a /etc/ssh/sshd_config
echo "PermitRootLogin no" | tee -a /etc/ssh/sshd_config
systemctl restart ssh

ufw enable 
ufw allow ssh

shutdown -r now

# EOF
