# rootstrap (bootstrap code for system setup)

Run the following commands as root:
clone the repo:

`git clone https://github.com/christianknauer/rootstrap.git`

create admin user (if necessary):

`./rootstrap.sh host.domain.de knauer "Christian Knauer" super_secret_password`

bootstrap with default ssh key:

`./bootstrap.sh knauer@host.domain.de`

bootstrap with alternate ssh key:

`./bootstrap.sh knauer@host.domain.de "$(cat ~/.ssh/authorized_keys)"`
