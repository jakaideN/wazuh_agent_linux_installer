[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.3.0-1.msi -OutFile ${env:tmp}\wazuh-agent-4.3.0.msi; msiexec.exe /i ${env:tmp}\wazuh-agent-4.3.0.msi /q WAZUH_MANAGER='10.62.6.25' WAZUH_REGISTRATION_SERVER='10.62.6.25'; sleep(5); restart-service -name Wazuh