$user = "administrator@vsphere.local"
$password = "VMware1!"
Connect-VIServer $viserver -user $user -Password $password
$vmname = get-vm -name "ESXi 6.5"
$SBchoices = "$true","$false"
$SBtype = write-menu -menu $SBchoices -AddExit -HeaderColor Green -TextColor Yellow 


$SecureBootValue = (Get-AdvancedSetting -Entity $vmname -Name "uefi.secureBoot.Enabled")
Write-host "Secure Boot is: " $SecureBootValue
Write-Host "Setting SecureBoot to True"
$SecureBootValue = (Get-AdvancedSetting -Entity $vmname -Name "uefi.secureBoot.Enabled" | Set-AdvancedSetting -Value:$SBtype)
