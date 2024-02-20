#!/bin/bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
dpkg --set-selections <<< "cloud-init install" || true

# Set Gloabal Variables
    # Detect OS
        OS="$(uname)"
        case $OS in
            "Linux")
                # Detect Linux Distro
                if [ -f /etc/os-release ]; then
                    . /etc/os-release
                    DISTRO=$ID
                    VERSION=$VERSION_ID
                else
                    echo "Your Linux distribution is not supported."
                    exit 1
                fi
                ;;
        esac

# Detect if an Nvidia GPU is present
NVIDIA_PRESENT=$(lspci | grep -i nvidia || true)

# Only proceed with Nvidia-specific steps if an Nvidia device is detected
if [[ -z "$NVIDIA_PRESENT" ]]; then
    echo "No NVIDIA device detected on this system."
else
# Check if nvidia-smi is available and working
    if command -v nvidia-smi &>/dev/null; then
        echo "CUDA drivers already installed as nvidia-smi works."
    else

                # Depending on Distro
                case $DISTRO in
                    "ubuntu")
                        case $VERSION in
                            "20.04")
                                # Commands specific to Ubuntu 20.04
                                 -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                 -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                 apt install linux-headers-$(uname -r) -y
				 apt del 7fa2af80 || true
                                 apt remove 7fa2af80 || true
                                 apt install build-essential cmake gpg unzip pkg-config software-properties-common ubuntu-drivers-common -y
                                 apt install libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y || true
                                 apt install libjpeg-dev libpng-dev libtiff-dev -y || true
                                 apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y || true
                                 apt install libxvidcore-dev libx264-dev -y || true
                                 apt install libopenblas-dev libatlas-base-dev liblapack-dev gfortran -y || true
                                 apt install libhdf5-serial-dev -y || true
                                 apt install python3-dev python3-tk python-imaging-tk curl cuda-keyring gnupg-agent dirmngr alsa-utils -y || true
                                 apt install libgtk-3-dev -y || true
                                 apt update -y
                                 dirmngr </dev/null
                                if  apt-add-repository -y ppa:graphics-drivers/ppa &&  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FCAE110B1118213C; then
                                    echo "Alternative method succeeded."
                                else
                                    echo "Alternative method failed. Trying the original method..."
                                     dirmngr </dev/null
                                     apt-add-repository -y ppa:graphics-drivers/ppa
                                     gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/graphics-drivers.gpg --keyserver keyserver.ubuntu.com --recv-keys FCAE110B1118213C
                                     chmod 644 /etc/apt/trusted.gpg.d/graphics-drivers.gpg
                                fi
                                 ubuntu-drivers autoinstall
                                 apt update -y
                                wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
                                 dpkg -i cuda-keyring_1.1-1_all.deb
                                 apt update -y
                                 apt -y install cuda-toolkit
                                export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
                                 apt-get update
                                ;;
                            
                            "22.04")
                                # Commands specific to Ubuntu 22.04
                                 -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                 -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                 apt install linux-headers-$(uname -r) -y
                                 apt del 7fa2af80 || true
                                 apt remove 7fa2af80 || true
                                 apt install build-essential cmake gpg unzip pkg-config software-properties-common ubuntu-drivers-common -y
                                 apt install libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y
                                 apt install libjpeg-dev libpng-dev libtiff-dev -y 
                                 apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y 
                                 apt install libxvidcore-dev libx264-dev -y
                                 apt install libopenblas-dev libatlas-base-dev liblapack-dev gfortran -y 
                                 apt install libhdf5-serial-dev -y 
                                 apt install python3-dev python3-tk curl gnupg-agent dirmngr alsa-utils -y
                                 apt install libgtk-3-dev -y 
                                 apt update -y
                                 dirmngr </dev/null
                                if  apt-add-repository -y ppa:graphics-drivers/ppa &&  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FCAE110B1118213C; then
                                    echo "Alternative method succeeded."
                                else
                                    echo "Alternative method failed. Trying the original method..."
                                     dirmngr </dev/null
                                     apt-add-repository -y ppa:graphics-drivers/ppa
                                     gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/graphics-drivers.gpg --keyserver keyserver.ubuntu.com --recv-keys FCAE110B1118213C
                                     chmod 644 /etc/apt/trusted.gpg.d/graphics-drivers.gpg
                                fi
                                 ubuntu-drivers autoinstall
                                 apt update -y
                                wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
                                 dpkg -i cuda-keyring_1.1-1_all.deb
                                 apt update -y
                                 apt -y install cuda-toolkit
                                export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
                                 apt update -y
                                ;;

                            "18.04")
                                # Commands specific to Ubuntu 18.04
                                 -- sh -c 'apt-get update; apt-get upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
                                 apt-get install linux-headers-$(uname -r) -y
                                 apt del 7fa2af80 || true
                                 apt remove 7fa2af80 || true
                                 apt install build-essential cmake gpg unzip pkg-config software-properties-common ubuntu-drivers-common alsa-utils -y
                                 apt install libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y || true
                                 apt install libjpeg-dev libpng-dev libtiff-dev -y || true
                                 apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y || true
                                 apt install libxvidcore-dev libx264-dev -y || true
                                 apt install libopenblas-dev libatlas-base-dev liblapack-dev gfortran -y || true
                                 apt install libhdf5-serial-dev -y || true
                                 apt install python3-dev python3-tk python-imaging-tk curl cuda-keyring -y || true
                                 apt install libgtk-3-dev -y || true
                                 apt update -y
                                 ubuntu-drivers install
                                 apt update -y
                                wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
                                 dpkg -i cuda-keyring_1.1-1_all.deb
                                 apt update -y
                                 apt -y install cuda-toolkit
                                export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
                                 apt update -y
                                ;;

                            *)
                                echo "This version of Ubuntu is not supported in this script."
                                exit 1
                                ;;
                        esac
                        ;;
                    
                    "debian")
                        case $VERSION in
                            "10"|"11")
                                # Commands specific to Debian 10 & 11
                                 -- sh -c 'apt update; apt upgrade -y; apt autoremove -y; apt autoclean -y'
                                 apt install linux-headers-$(uname -r) -y
                                 apt update -y
                                 apt install nvidia-driver firmware-misc-nonfree
                                wget https://developer.download.nvidia.com/compute/cuda/repos/debian${VERSION}/x86_64/cuda-keyring_1.1-1_all.deb
                                 apt install nvidia-cuda-dev nvidia-cuda-toolkit
                                 apt update -y
                                ;;

                            *)
                                echo "This version of Debian is not supported in this script."
                                exit 1
                                ;;
                        esac
                        ;;

                    *)
                        echo "Your Linux distribution is not supported."
                        exit 1
                        ;;

            "Windows_NT")
                # For Windows Subsystem for Linux (WSL) with Ubuntu
                if grep -q Microsoft /proc/version; then
                    wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb
                     dpkg -i cuda-keyring_1.1-1_all.deb
                     apt-get update
                     apt-get -y install cuda
                else
                    echo "This bash script can't be executed on Windows directly unless using WSL with Ubuntu. For other scenarios, consider using a PowerShell script or manual installation."
                    exit 1
                fi
                ;;

            *)
                echo "Your OS is not supported."
                exit 1
                ;;
        esac
	echo "System will now reboot !!! Please re-run this script after restart to complete installation !"
 	sleep 5s
         reboot
    fi
fi
# For testing purposes, this should output NVIDIA's driver version
if [[ ! -z "$NVIDIA_PRESENT" ]]; then
    nvidia-smi
fi

# Check if Docker is installed
if command -v docker &>/dev/null; then
    echo "Docker is already installed."
else
    echo "Docker is not installed. Proceeding with installations..."
    # Install Docker-ce keyring
     apt update -y
     apt install -y ca-certificates curl gnupg
     install -m 0755 -d /etc/apt/keyrings
    FILE=/etc/apt/keyrings/docker.gpg
    if [ -f "$FILE" ]; then
         rm "$FILE"
    fi
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  gpg --dearmor -o "$FILE"
     chmod a+r /etc/apt/keyrings/docker.gpg

    # Add Docker-ce repository to Apt sources and install
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release; echo "$VERSION_CODENAME") stable" | \
       tee /etc/apt/sources.list.d/docker.list > /dev/null
     apt update -y
     apt -y install docker-ce
fi

# Check if docker-compose is installed
if command -v docker-compose &>/dev/null; then
    echo "Docker-compose is already installed."
else
    echo "Docker-compose is not installed. Proceeding with installations..."

    # Install docker-compose subcommand
     apt -y install docker-compose-plugin
     ln -sv /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/docker-compose
    docker-compose --version
fi

# Test / Install nvidia-docker
if [[ ! -z "$NVIDIA_PRESENT" ]]; then
    if  docker run --gpus all nvidia/cuda:11.0.3-base-ubuntu18.04 nvidia-smi &>/dev/null; then
        echo "nvidia-docker is enabled and working. Exiting script."
    else
        echo "nvidia-docker does not seem to be enabled. Proceeding with installations..."
        distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
        curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |  apt-key add
        curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list |  tee /etc/apt/sources.list.d/nvidia-docker.list
         apt-get update &&  apt-get install -y nvidia-container-toolkit
         systemctl restart docker 
         docker run --gpus all nvidia/cuda:11.0.3-base-ubuntu18.04 nvidia-smi
    fi
fi
 apt-mark hold nvidia* libnvidia*
# Add docker group and user to group docker
 groupadd docker || true
 usermod -aG docker $USER || true
newgrp docker || true
# Workaround for NVIDIA Docker Issue
echo "Applying workaround for NVIDIA Docker issue as per https://github.com/NVIDIA/nvidia-docker/issues/1730"
# Summary of issue and workaround:
# The issue arises when the host performs daemon-reload, which may cause containers using systemd to lose access to NVIDIA GPUs.
# To check if affected, run ` systemctl daemon-reload` on the host, then check GPU access in the container with `nvidia-smi`.
# If affected, proceed with the workaround below.

# Workaround Steps:
# Disable cgroups for Docker containers to prevent the issue.
# Edit the Docker daemon configuration.
 bash -c 'cat <<EOF > /etc/docker/daemon.json
{
   "runtimes": {
       "nvidia": {
           "path": "nvidia-container-runtime",
           "runtimeArgs": []
       }
   },
   "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
EOF'

# Restart Docker to apply changes.
 systemctl restart docker
echo "Workaround applied. Docker has been configured to use 'cgroupfs' as the cgroup driver."
