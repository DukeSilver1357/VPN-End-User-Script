

function Remote-User {
	cls
	Write-Host "================ VPN Creation Tool ================"
	[string]$Name = Read-Host -Prompt 'VPN Name'
	    
	[string]$RouterAddress =  Read-Host -Prompt 'Public Address'

	[string]$PreSharedKey =  Read-Host -Prompt 'PSK'

	[string]$ComputerAddress =  Read-Host -Prompt 'In Office Computer Address to Connect to'

	[string]$ComputerUsername =  Read-Host -Prompt 'User Principle Name in Format Domain\User'

	#Creates a Global VPN Connection with MSChap v2 enabled.
	Add-VpnConnection -RememberCredential -Name "$Name" -ServerAddress "$RouterAddress" -TunnelType L2tp -EncryptionLevel Optional -AllUserConnection -AuthenticationMethod MSChapv2 -L2tpPsk "$PreSharedKey" -Force
	REG ADD HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule /t REG_DWORD /d 0x2 /f

	#Creates a registry value that contains the username of the local computer the user will be remoting into.
	$Regvar = Test-Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client\Server'
	If ($Regvar -eq "True"){
		New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client\Servers\' -Name "$ComputerAddress"
		New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Terminal Server Client\Servers\$ComputerAddress" -Name "UsernameHint" -Value $ComputerUsername
	}
	Else{
		New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client' -Name "Servers"
		New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client\Servers\' -Name "$ComputerAddress"
		New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Terminal Server Client\Servers\$ComputerAddress" -Name "UsernameHint" -Value $ComputerUsername
	}
	
	#Creates an RDP Link with the address of the comptuer the user will be remoting into and puts it on the public desktop.
	 echo "screen mode id:i:2
		use multimon:i:0
		desktopwidth:i:1920
		desktopheight:i:1200
		session bpp:i:32
		winposstr:s:0,1,0,216,642,697
		compression:i:1
		keyboardhook:i:2
		audiocapturemode:i:0
		videoplaybackmode:i:1
		connection type:i:7
		networkautodetect:i:1
		bandwidthautodetect:i:1
		displayconnectionbar:i:1
		enableworkspacereconnect:i:0
		disable wallpaper:i:0
		allow font smoothing:i:0
		allow desktop composition:i:0
		disable full window drag:i:1
		disable menu anims:i:1
		disable themes:i:0
		disable cursor setting:i:0
		bitmapcachepersistenable:i:1
		full address:s:$ComputerAddress
		audiomode:i:0
		redirectprinters:i:1
		redirectcomports:i:0
		redirectsmartcards:i:1
		redirectclipboard:i:1
		redirectposdevices:i:0
		autoreconnection enabled:i:1
		authentication level:i:2
		prompt for credentials:i:0
		negotiate security layer:i:1
		remoteapplicationmode:i:0
		alternate shell:s:
		shell working directory:s:
		gatewayhostname:s:
		gatewayusagemethod:i:4
		gatewaycredentialssource:i:4
		gatewayprofileusagemethod:i:0
		promptcredentialonce:i:0
		gatewaybrokeringtype:i:0
		use redirection server name:i:0
		rdgiskdcproxy:i:0
		kdcproxyname:s:" > 'C:\Users\Public\Desktop\OfficeComputer.rdp'
}

Remote-User
