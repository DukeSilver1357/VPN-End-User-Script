#Adds an L2TP VPN connection.

function Add-Remotesetup {
	Clear-Host
	Write-Host "================ Remote User Setup Tool ================"
	[string]$Name = Read-Host -Prompt 'VPN Name'
	    
	[string]$RouterAddress =  Read-Host -Prompt 'Public Address'

	[string]$PreSharedKey =  Read-Host -Prompt 'PSK'

	#Creates a Global VPN Connection with MSChap v2 enabled.
	Add-VpnConnection -RememberCredential -Name "$Name" -ServerAddress "$RouterAddress" -TunnelType L2tp -EncryptionLevel Optional -AllUserConnection -AuthenticationMethod MSChapv2 -L2tpPsk "$PreSharedKey" -Force
	REG ADD HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule /t REG_DWORD /d 0x2 /f
}

Add-Remotesetup
