$Script:ModuleRoot               = $PSScriptRoot
$Script:DFRCheckSettingsFilePath = "$env:TEMP\DFResponsCheck-$($env:USERNAME)_$($env:COMPUTERNAME).checkfile"
$SettingsFileExists = $false
if (-not (Test-Path $DFRCheckSettingsFilePath)) {
    Write-Warning -Message "No settings file found. Please configure the module by running Initialize-SettingsFile provided with your information."
}
else {
    $Script:Settings     = Import-Csv -Path (Get-Content -Path $DFRCheckSettingsFilePath)
    $Script:ADProperties = @($Settings.PSObject.Properties | Where-Object {($_.Name -notlike '*Path') -and ($_.Name -ne 'Server')} | Select-Object -ExpandProperty Value)
    $SettingsFileExists  = $true
}

$Private = @(Get-ChildItem -Path $ModuleRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
$Public  = @(Get-ChildItem -Path $ModuleRoot\Public\*.ps1 -ErrorAction SilentlyContinue)

foreach ($Import in @($Private + $Public)) {
    try {
        . $Import.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

<# if (-not (Test-Path $DFRSettingsFilePath)) {

    Clear-Host
    Write-Output "Select credential file for encrypted basic authentication"
    $BASecretPath = Get-FilePath

    Clear-Host
    Write-Output "Select credential file for encrypted API key"
    $APIKeyPath= Get-FilePath

    $Server = Read-Host -Prompt "Enter server URI (e.g: ""https://MYDOMAIN.dfrespons.se/api"")"

     
    do {
        $BASecretPath = Read-Host -Prompt "Enter path to credential file for encrypted basic authentication (e.g: ""C:\Secrets\DFR\DFR_BasicAuth.crd"")"
    } while ($(Test-Path $BASecretPath) -eq $false) {
        Write-Output "Path $BASecretPath is not valid."
    }

    do {
        $BASecretPath = Read-Host -Prompt "Enter path to credential file for encrypted basic authentication (e.g: ""C:\Secrets\DFR\DFR_BasicAuth.crd"")"
    } while (condition) {
    } ($(Test-Path $BASecretPath) -eq $true)

    while ((Test-Path $BASecretPath) -eq $false) {
        $BASecretPath = Read-Host -Prompt "Enter path to credential file for encrypted basic authentication (e.g: ""C:\Secrets\DFR\DFR_BasicAuth.crd"")"
    }

    $BASecretPath = Read-Host -Prompt "Enter path to credential file for encrypted basic authentication (e.g: ""C:\Secrets\DFR\DFR_BasicAuth.crd"")"
    $APIKeyPath   = Read-Host -Prompt "Enter path to credential file for encrypted API key (e.g: ""C:\Secrets\DFR\DFRKey.crd"")"
    $Server       = Read-Host -Prompt "Enter server URI (e.g: ""https://MYDOMAIN.dfrespons.se/api"")"
    

    $Table = [PSCustomObject]@{
        BASecretPath = $BASecretPath
        APIKeyPath   = $APIKeyPath
        Server       = $Server
    }

    $Table | ConvertTo-Csv -NoTypeInformation | Set-Content -Path $DFRSettingsFilePath -Encoding UTF8

    $Script:Settings = Import-Csv -Path $DFRSettingsFilePath
}
else {
    $Script:Settings = Import-Csv -Path $DFRSettingsFilePath
} #>

Export-ModuleMember -Function $Public.Basename

if ($SettingsFileExists -eq $true) {
    Export-ModuleMember -Variable Settings, ADProperties
}
else {
    Export-ModuleMember -Variable DFRCheckSettingsFilePath
}