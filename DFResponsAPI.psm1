$Script:ModuleRoot               = $PSScriptRoot
$Script:DFRCheckSettingsFilePath = "$env:TEMP\DFResponsCheck-$($env:USERNAME)_$($env:COMPUTERNAME).checkfile"
$SettingsFileExists = $false
if (-not (Test-Path $DFRCheckSettingsFilePath)) {
    Write-Warning -Message "No settings file found. Please configure the module by running Initialize-SettingsFile provided with your information."
}
elseif (-not (Test-Path -Path $(Get-Content -Path $DFRCheckSettingsFilePath))) {
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

Export-ModuleMember -Function $Public.Basename
Export-ModuleMember -Function "New-Secret", "Get-Secret"

if ($SettingsFileExists -eq $true) {
    Export-ModuleMember -Variable Settings, ADProperties
}
else {
    Export-ModuleMember -Variable DFRCheckSettingsFilePath
}