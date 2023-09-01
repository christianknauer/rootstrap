# rootstrap.sh 

# root user bootstrap code for system setup

[ "`id -u`" -ne 0 ] && echo "Must be run as root!" && exit 1

echo "Upgrading system."
echo "CAVE:"
echo "- Select the option to overwrite sshd_config with the maintainer's version."

sleep 3

apt update 
apt upgrade
apt install openssh-server ufw

read -p "Enter admin username [administrator]: " ADMIN_USERNAME
ADMIN_USERNAME=${ADMIN_USERNAME:-administrator}

read -p "Enter admin full name [Administrator]: " ADMIN_NAME
ADMIN_NAME=${ADMIN_NAME:-Administrator}

echo "Creating admin user $ADMIN_NAME ($ADMIN_USERNAME)"

adduser ${ADMIN_USERNAME} --gecos "$ADMIN_USERNAME"
usermod -aG sudo ${ADMIN_USERNAME}
echo "${ADMIN_USERNAME} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${ADMIN_USERNAME}

echo "AllowUsers ${ADMIN_USERNAME}" | tee -a /etc/ssh/sshd_config
echo "PermitRootLogin no" | tee -a /etc/ssh/sshd_config
systemctl restart ssh

ufw enable 
ufw allow ssh

cd ; rm -rf rootstrap 

shutdown -r now

# EOF
