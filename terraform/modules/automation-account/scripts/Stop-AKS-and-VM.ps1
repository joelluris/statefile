param(
    [Parameter(Mandatory=$false)]
    [string]$aksresourcegroup = "rg-lnt-eip-aks-nonprd-uaen-01",
    
    [Parameter(Mandatory=$false)]
    [string]$aksclustername = "aks-lnt-eip-nonprd-uaen-01",
    
    [Parameter(Mandatory=$false)]
    [string]$vmresourcegroup = "rg-lnt-eip-vm-nonprd-uaen-01",
    
    [Parameter(Mandatory=$false)]
    [string]$vmname = "vm-lnt-wvm1-np1"
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

    # Stop VM
    Write-Output "Starting to stop VM: $vmname in $vmresourcegroup"
    Stop-AzVM -ResourceGroupName $vmresourcegroup -Name $vmname -Force -ErrorAction Stop
    Write-Output "VM stopped successfully"

    Write-Output "All resources stopped successfully"
}
catch {
    Write-Error "Failed to stop resources: $_"
    throw
}
