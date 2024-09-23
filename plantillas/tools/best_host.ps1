# Conectarse al servidor de vCenter
$vcenter_server = "lovsrvvc04.local.bsc.com"
$vcenter_user = "useransible@vsphere.local"
$vcenter_password = "U3r@ns1bL4"
Connect-VIServer -Server $vcenter_server -User $vcenter_user -Password $vcenter_password

# Obtener la lista de todos los hosts ESXi
$hosts = Get-VMHost

# Crear un objeto con los recursos disponibles de cada host
$hostResources = $hosts | ForEach-Object {
    $vmHost = $_
    [PSCustomObject]@{
        Name = $vmHost.Name
        CPU_Free = $vmHost.CpuTotalMhz - $vmHost.CpuUsageMhz
        Memory_Free = $vmHost.MemoryTotalMB - $vmHost.MemoryUsageMB
    }
}

# Seleccionar el host con más memoria libre
$bestHost = $hostResources | Sort-Object -Property Memory_Free -Descending | Select-Object -First 1

# Guardar el nombre del mejor host en un archivo de texto
$bestHost.Name | Out-File -FilePath "C:\path\to\best_host.txt"

# Desconectarse de vCenter
Disconnect-VIServer -Confirm:$false
