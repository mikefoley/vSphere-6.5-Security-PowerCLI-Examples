#Change vMotion Encryption Policy.ps1
#This uses a function from here: 	
#http://www.ps1code.com/single-post/2016/04/21/How-to-create-interactive-dynamic-Menu-in-PowerShell
###
Clear
$viserver = "mgt-vc-01.lab1.local"
$user = "administrator@vsphere.local"
$password = "VMware1!"
Connect-VIServer $viserver -user $user -Password $password
$vmname = write-menu -menu (get-vm ) -prompt 'Select a VM' -AddExit -HeaderColor Green -TextColor Yellow 
Write-host "VM is set to " $vmname.Name

$encstatus = ""
$encstatus = (Get-AdvancedSetting -Entity $vmname -Name "migrateEncryption")
Write-Host "Encrypted vMotion policy is set to :" $encstatus.Value

$encryptiontype = ""
$encryptionchoices = "Disabled","Opportunistic","Required"
$encryptiontype = write-menu -menu $encryptionchoices -AddExit -HeaderColor Green -TextColor Yellow 
write-host "You selected " $encryptiontype
Get-AdvancedSetting -Entity $vmname -Name "migrateEncryption" |Set-AdvancedSetting -value $encryptiontype -Confirm:$false
$encstatus = (Get-AdvancedSetting -Entity $vmname -Name "migrateEncryption")
Write-Host "Encrypted vMotion policy is set to :" $encstatus.Value

