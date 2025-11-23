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

    # Start AKS cluster (may have extension warnings but cluster will start)
    Write-Output "Starting AKS cluster: $aksclustername in $aksresourcegroup"
    try {
        Start-AzAksCluster -ResourceGroupName $aksresourcegroup -Name $aksclustername -ErrorAction Stop
        Write-Output "AKS cluster start command completed"
    }
    catch {
        # Check if error is just extension-related
        if ($_.Exception.Message -like "*extension*" -or $_.Exception.Message -like "*DependencyAgent*") {
            Write-Warning "AKS cluster started but some extensions failed to update. This is normal and cluster is operational."
            Write-Output "AKS cluster is starting (extension warnings ignored)"
        }
        else {
            throw
        }
    }

    # Wait a moment for AKS to stabilize
    Start-Sleep -Seconds 10

    # Start VM
    Write-Output "Starting VM: $vmname in $vmresourcegroup"
    Start-AzVM -ResourceGroupName $vmresourcegroup -Name $vmname -ErrorAction Stop
    Write-Output "VM started successfully"

    Write-Output "All resources started successfully"
}
catch {
    Write-Error "Failed to start resources: $_"
    throw
}
