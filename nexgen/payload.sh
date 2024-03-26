#!/bin/env bash

sudo SSH_PUBLIC_KEY="${SSH_PUBLIC_KEY:-ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5ybW/0rquFoLSBtMrFytPH75MbTj0uS3WKD/I7OjHu admin (during setup only)}" USERNAME="$USER" bash <<"EOF"

echo "Setting timezone & locale ..."
# set timezone
timedatectl set-timezone Europe/Berlin
# set locale
apt install language-pack-de
localectl set-locale LC_MESSAGES=de_DE.utf8 LANG=de_DE.UTF-8
update-locale

echo "Disable phased updates ..."
echo "APT::Get::Always-Include-Phased-Updates True;" > /etc/apt/apt.conf.d/99-Phased-Updates

echo "Upgrading system ..."
apt update -y &> /dev/null
apt upgrade -y &> /dev/null

echo "Installing essential packages ..."
apt install -y openssh-server git ufw curl

echo "Disable sudo password requirement for $USERNAME ..."
usermod -aG sudo "$USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USERNAME}

echo "Configure ssh ..."
install -o ${USERNAME} -g ${USERNAME} -d /home/$USERNAME/.ssh
echo "$SSH_PUBLIC_KEY" | tee /home/$USERNAME/.ssh/authorized_keys
chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh/authorized_keys
chmod 700 /home/${USERNAME}/.ssh
chmod 600 /home/${USERNAME}/.ssh/authorized_keys

if [ ! -f "/etc/ssh/sshd_config.original" ]; then
  cp "/etc/ssh/sshd_config" "/etc/ssh/sshd_config.original" 
  sed -i 's/^Include/#Include/g' /etc/ssh/sshd_config
  sed -i 's/^AllowUsers/#AllowUsers/g' /etc/ssh/sshd_config
  sed -i 's/^PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
  sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
  echo 'PermitRootLogin no' | tee -a /etc/ssh/sshd_config
  echo 'PasswordAuthentication no' | tee -a /etc/ssh/sshd_config
  echo "AllowUsers $USERNAME" | tee -a /etc/ssh/sshd_config
else
  echo "not patching /etc/ssh/sshd_config"
fi

rm -rf /root/.ssh
rm -f /etc/ssh/sshd_config.d/*.conf

systemctl restart sshd

echo "y" | ufw enable
ufw allow ssh

EOF
