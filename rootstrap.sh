# rootstrap.sh 

# root user bootstrap code for system setup

[ "`id -u`" -ne 0 ] && echo "Must be run as root!" && exit 1

echo "Upgrading system."
echo "CAVE:"
echo "- Select the option to overwrite sshd_config with the maintainer's version."

sleep 3

apt update -y
apt upgrade -y
apt install -y openssh-server ufw

read -p "Enter admin username [administrator]: " ADMIN_USERNAME
ADMIN_USERNAME=${ADMIN_USERNAME:-administrator}

# check if the admin user already exists
if ! id -u "$ADMIN_USERNAME" >/dev/null 2>&1; then
    read -p "Enter admin full name [Administrator]: " ADMIN_NAME
    ADMIN_NAME=${ADMIN_NAME:-Administrator}
    echo "Creating admin user $ADMIN_NAME ($ADMIN_USERNAME)"
    adduser ${ADMIN_USERNAME} --gecos "$ADMIN_USERNAME"
fi

usermod -aG sudo ${ADMIN_USERNAME}
echo "${ADMIN_USERNAME} ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${ADMIN_USERNAME}

install -o ${ADMIN_USERNAME} -g ${ADMIN_USERNAME} -d /home/${ADMIN_USERNAME}/.ssh
install -o ${ADMIN_USERNAME} -g ${ADMIN_USERNAME} -t /home/${ADMIN_USERNAME}/.ssh rootstrap/ssh/authorized_keys
chmod 700 /home/${ADMIN_USERNAME}/.ssh
chmod 600 /home/${ADMIN_USERNAME}/.ssh/authorized_keys

echo "AllowUsers ${ADMIN_USERNAME}" | tee -a /etc/ssh/sshd_config

rm -rf /root/.ssh
rm -f /etc/ssh/sshd_config.d/*.conf

sed -i 's/^Include/#Include/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

systemctl restart sshd

ufw enable 
ufw allow ssh

cd ; rm -rf rootstrap 

shutdown -r now

# EOF
