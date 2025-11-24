param(
    [Parameter(Mandatory=$false)]
    [string]$aksresourcegroup = "rg-lnt-eip-aks-nonprd-uaen-01",
    
    [Parameter(Mandatory=$false)]
    [string]$aksclustername = "aks-lnt-eip-nonprd-uaen-01",
    
    [Parameter(Mandatory=$false)]
    [string]$vmresourcegroup = "rg-lnt-eip-vm-nonprd-uaen-01",
    
    [Parameter(Mandatory=$false)]
    [string[]]$vmname = @("vm-lnt-wvm1-np1", "vm-lnt-ubn1-np1")
)

try {
    # Connect using managed identity
    Write-Output "Connecting to Azure using managed identity..."
    Connect-AzAccount -Identity -ErrorAction Stop
    Write-Output "Successfully connected to Azure"

    # Stop AKS cluster
    Write-Output "Starting to stop AKS cluster: $aksclustername in $aksresourcegroup"
    Stop-AzAksCluster -ResourceGroupName $aksresourcegroup -Name $aksclustername -ErrorAction Stop
    Write-Output "AKS cluster stopped successfully"

    # Define VMs with their resource groups
    $vmsToStop = @(
        @{Name="vm-lnt-wvm1-np1"; ResourceGroup="rg-lnt-eip-vm-nonprd-uaen-01"},
        @{Name="vm-lnt-ubn1-np1"; ResourceGroup="rg-lnt-eip-mft-nonprd-uaen-01"}
    )

    # Stop each VM
    foreach ($vm in $vmsToStop) {
        Write-Output "Starting to stop VM: $($vm.Name) in $($vm.ResourceGroup)"
        Stop-AzVM -ResourceGroupName $vm.ResourceGroup -Name $vm.Name -Force -ErrorAction Stop
        Write-Output "VM $($vm.Name) stopped successfully"
    }

    Write-Output "All resources stopped successfully"
}
catch {
    Write-Error "Failed to stop resources: $_"
    throw
}
