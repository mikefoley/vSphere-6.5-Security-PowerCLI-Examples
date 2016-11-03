$viserver = "mgt-vc-01.lab1.local"
$user = "administrator@vsphere.local"
$password = "VMware1!"
Connect-VIServer $viserver -user $user -Password $password
$vmname = "yVM-1"
$vm = Get-View (Get-VM $vmname).ID
$CfgSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
$CfgSpec.extraconfig = New-Object VMware.Vim.optionvalue
$CfgSpec.extraconfig[0].Key="migrateEncryption"
#Values are Disabled, Opportunistic and Required
$CfgSpec.extraconfig[0].Value="Required"
$vm.ReconfigVM($CfgSpec)