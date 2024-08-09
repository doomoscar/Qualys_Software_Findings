# Function to check installed software
function Get-InstalledSoftware {
    param (
        [string[]]$SoftwareNames
    )
    
    $softwarePaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $installedSoftware = @()

    foreach ($path in $softwarePaths) {
        $installedSoftware += Get-ItemProperty $path | Where-Object {
            $found = $false
            foreach ($name in $SoftwareNames) {
                if ($_.DisplayName -like "*$name*") {
                    $found = $true
                    break
                }
            }
            $found
        }
    }

    return $installedSoftware
}

# Check if 'Devolutions' or 'Remote Desktop Manager' is installed
$softwareToFind = @("Devolutions", "Remote Desktop Manager")
$installed = Get-InstalledSoftware -SoftwareNames $softwareToFind

if ($installed) {
    Write-Output "Software matching '$($softwareToFind -join " or ")' is installed on this computer."
    $installed | Select-Object DisplayName, DisplayVersion, Publisher
} else {
    Write-Output "Neither 'Devolutions' nor 'Remote Desktop Manager' is installed on this computer."
}
