[string]$Username =  Read-Host -Prompt 'User Principle Name'

# Enable Remote Desktop
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-TCP" /v UserAuthentication /t REG_DWORD /d "0" /f

# Allow Inbound 3389
New-NetFirewallRule -DisplayName "RDP TCP Inbound" -Direction Inbound -LocalPort 3389 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "RDP UDP Inbound" -Direction Inbound -LocalPort 3389 -Protocol UDP -Action Allow

#Add User to Remote Desktop Users Group
net localgroup "Remote Desktop Users" "$Username" /add
