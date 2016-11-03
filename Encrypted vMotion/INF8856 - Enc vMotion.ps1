$viserver = "mgt-vc-01.lab1.local"
$user = "administrator@vsphere.local"
$password = "VMware1!"
Connect-VIServer $viserver -user $user -Password $password


#PPT Script
$vname = Get-VM -name "Tiny"
$vm = Get-VM $vmname
($vm | Get-View).config.migrateencryption

$spec = New-Object VMware.VIM.VirtualMachineConfigSpec
$vmview = ($vm|get-view)

$spec.MigrateEncryption = 'disabled'
$vmview.ReconfigVM($spec)
($vm | Get-View).config.migrateencryption

$spec.MigrateEncryption = 'opportunistic'
$vmview.ReconfigVM($spec)
($vm | Get-View).config.migrateencryption

$spec.MigrateEncryption = 'required'
$vmview.ReconfigVM($spec)
($vm | Get-View).config.migrateencryption

#Options are: 
#'disabled'
#'opportunistic'
#'required'