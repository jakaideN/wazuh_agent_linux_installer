#!/bin/bash

sys_a=""
distro="$(cat /etc/os-release | grep ID_LIKE | cut -d"=" -f 2)"
#manager_or_balancer_ip="10.62.6.25"
manager_or_balancer_ip="172.26.26.246"



apt-get update
apt-get install curl -y

if [[ $distro  ==  "debian" || $distro  ==  "ubuntu" ]]; then
    
    #set cpu archhitecture
    if [[ $(arch)  ==  "x86_64" ]]; then
        sys_a="amd64"
    elif [[ $(arch)  ==  "aarch64" ]]; then
        sys_a="arm64"
    else
        sys_a="$(arch)"
    fi
    #set cpu archhitecture

    curl -so wazuh-agent-4.2.6.deb "https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.2.6-1_$sys_a.deb" && sudo WAZUH_MANAGER="$manager_or_balancer_ip" dpkg -i ./wazuh-agent-4.2.6.deb

    if [[ $(which systemctl) == "/usr/bin/systemctl" ]]; then
        sudo systemctl daemon-reload
        sudo systemctl enable wazuh-agent
        sudo systemctl start wazuh-agent
        sudo systemctl status wazuh-agent --no-pager
    else
        sudo update-rc.d wazuh-agent defaults 95 10
        sudo service wazuh-agent start
    fi

elif [[ $distro  !=  "debian" || $distro  !=  "ubuntu" ]]; then

    #set cpu archhitecture
    if [[ $(arch)  ==  "armhf" ]]; then
        sys_a="armv7hl"
    else
        sys_a="$(arch)"
    fi
    #set cpu archhitecture
    
    sudo WAZUH_MANAGER="$manager_or_balancer_ip" yum install "https://packages.wazuh.com/4.x/yum/wazuh-agent-4.2.6-1.$sys_a.rpm"

    if [[ $(which systemctl) == "/usr/bin/systemctl" ]]; then
        sudo systemctl daemon-reload
        sudo systemctl enable wazuh-agent
        sudo systemctl start wazuh-agent
        sudo systemctl status wazuh-agent --no-pager
    else
        sudo update-rc.d wazuh-agent defaults 95 10
        sudo service wazuh-agent start
    fi

fi



