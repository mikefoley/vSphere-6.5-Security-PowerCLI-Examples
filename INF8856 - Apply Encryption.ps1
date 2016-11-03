#Mike Foley  @mikefoley  mike@yelof.com
#Uses Write-Menu from http://www.ps1code.com/single-post/2016/04/21/How-to-create-interactive-dynamic-Menu-in-PowerShell
#

$viserver = "mgt-vc-e-01.lab1.local"
$user = "administrator@vsphere.local"
$password = "VMware1!"
if ($global:DefaultVIServers) {
Disconnect-VIServer -Confirm:$false
} 
Connect-VIServer  $viserver -user $user -Password $password 
#
$vmname = "Tiny"
$datastore = Get-Datastore "vsanDatastore"
$cluster = Get-Cluster -name "VSANcluster"
$harddisk = (get-vm $vmname | Get-HardDisk)
$Encryptionpolicy = Get-SpbmStoragePolicy -Name "VMware VM Encryption sample storage policy"
$NoEncryptionPolicy = Get-SpbmStoragePolicy -Name "Virtual SAN Default Storage Policy"
#
clear
#
Write-Host "Display Encryption Policy for VM Home and Hard Disk for VM 'Tiny'"
$tinyenc = Get-SpbmEntityConfiguration -vm $vmname -CheckComplianceNow
$tinyhd = Get-SpbmEntityConfiguration -HardDisk (Get-HardDisk -vm $vmname)
Write-Host "Encryption Policy on $vmname VM Home files is" $tinyenc.StoragePolicy.Name
Write-Host "Encryption Policy on $vmname hard disk is" $tinyhd.StoragePolicy.Name
Write-host ""

Read-Host "Press Enter to apply the encryption policy on the hard drive for VM $vmname"
Set-SpbmEntityConfiguration  $vmname, $harddisk -StoragePolicy $Encryptionpolicy -Confirm:$false

Read-Host "Set encryption policy on just the VM Home storage object of VM $vmname"
Set-SpbmEntityConfiguration -Configuration (Get-SpbmEntityConfiguration $vmname) -StoragePolicy $Encryptionpolicy -Confirm:$false

Read-Host "Press Enter to report on the the encryption policy  of each VM"
foreach ($vm in (Get-VM)){
$enc = Get-SpbmEntityConfiguration -vm $vm -CheckComplianceNow
$hd = Get-SpbmEntityConfiguration -HardDisk (Get-HardDisk -vm $vm)
Write-Host "Encryption Policy on $vm VM Home files is" $enc.StoragePolicy.Name
Write-Host "Encryption Policy on $vm hard disk is" $hd.StoragePolicy.Name
Write-Host ""
}

#Remove the encryption policy from the VM
Read-Host "Press Enter to Remove the encryption policy from the VM $vmname"
Write-Host "Removing Encryption from the disk"
Set-SpbmEntityConfiguration -Configuration (Get-SpbmEntityConfiguration $harddisk) -StoragePolicy $null -confirm:$false
Write-Host "Removing Encryption from the VM Home files"
Set-SpbmEntityConfiguration $vmname -StoragePolicy $null -Confirm:$false