#!/bin/bash
sudo apt update
sudo apt install git make jq wget -y
sleep 1
echo -e "y\n" | sudo ufw enable
sudo ufw allow 1:65535/tcp
sudo ufw allow 1:65535/udp
sleep 1
curl -L https://github.com/ionet-official/io-net-official-setup-script/raw/main/ionet-setup.sh -o ionet-setup.sh
chmod +x ionet-setup.sh && ./ionet-setup.sh
curl -L https://github.com/ionet-official/io_launch_binaries/raw/main/launch_binary_linux -o launch_binary_linux
chmod +x launch_binary_linux
./launch_binary_linux --device_id=0d831d9b-e586-4c23-aaf5-77e24a654543 --user_id=99127fcb-8876-4d87-822e-6e428b8387d2 --operating_system="Linux" --usegpus=true --device_name=ic
