function ConvertFrom-ADObject {

    [CmdletBinding()]

    param (
        # ADObject input
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [Microsoft.ActiveDirectory.Management.ADUser]
        $ADObject,

        # Return type
        [Parameter()]
        [ValidateSet(
            'HashTable',
            'PSCustomObject'
        )]
        [string]
        $ReturnType = 'HashTable'
    )

    begin {
        $UsedParameters = New-Object -TypeName PSCustomObject -Property @{
            Name = ""
            Username = ""
            Title = ""
            Email = ""
            Organization = ""
            Phone = ""
            Cellphone = ""
            Disabled = "False"
        }
        # $UsedParameters = New-Object -TypeName PSCustomObject -Property ([ordered]@{})
    }

    process {

        foreach ($item in $Settings.PSObject.Properties | Where-Object {($_.Name -notlike '*Path') -and ($_.Name -ne 'Server')}) {
            switch ($item) {
                {$_.Name -eq "SamAccountName"}  {[string]$UsedParameters.Username = $ADObject.SamAccountName}
                {$_.Name -eq "GivenName"}       {[string]$GivenName = $ADObject | Select-Object -ExpandProperty $item.Value}
                {$_.Name -eq "Surname"}         {[string]$UsedParameters.Name = "$GivenName $($ADObject | Select-Object -ExpandProperty $item.Value)"}
                {$_.Name -eq "Email"}           {[string]$UsedParameters.Email = $ADObject | Select-Object -ExpandProperty $item.Value}
                {$_.Name -eq "Title"}           {[string]$UsedParameters.Title = $ADObject | Select-Object -ExpandProperty $item.Value}
                {$_.Name -eq "Organization"}    {[string]$UsedParameters.Organization = $ADObject | Select-Object -ExpandProperty $item.Value}
                {$_.Name -eq "Phone"}           {[string]$UsedParameters.Phone = $ADObject | Select-Object -ExpandProperty $item.Value}
                {$_.Name -eq "CellPhone"}       {[string]$UsedParameters.Cellphone = $ADObject | Select-Object -ExpandProperty $item.Value}
            }
            <# switch ($item) {
                {$_.Name -eq "SamAccountName"} {$UsedParameters | Add-Member -MemberType NoteProperty -Name "Username" -Value ($ADObject | Select-Object -ExpandProperty $item.Value)}
                {$_.Name -eq "GivenName"}      {$GivenName = $ADObject | Select-Object -ExpandProperty $item.Value}
                {$_.Name -eq "Surname"}        {$UsedParameters | Add-Member -MemberType NoteProperty -Name "Name" -Value "$GivenName $($ADObject | Select-Object -ExpandProperty $item.Value)"}
                {$_.Name -eq "Email"}          {$UsedParameters | Add-Member -MemberType NoteProperty -Name $item.Name -Value ($ADObject | Select-Object -ExpandProperty $item.Value)}
                {$_.Name -eq "Title"}          {$UsedParameters | Add-Member -MemberType NoteProperty -Name $item.Name -Value ($ADObject | Select-Object -ExpandProperty $item.Value)}
                {$_.Name -eq "Organization"}   {$UsedParameters | Add-Member -MemberType NoteProperty -Name $item.Name -Value ($ADObject | Select-Object -ExpandProperty $item.Value)}
                {$_.Name -eq "Phone"}          {$UsedParameters | Add-Member -MemberType NoteProperty -Name $item.Name -Value ($ADObject | Select-Object -ExpandProperty $item.Value)}
                {$_.Name -eq "CellPhone"}      {$UsedParameters | Add-Member -MemberType NoteProperty -Name $item.Name -Value ($ADObject | Select-Object -ExpandProperty $item.Value)}
            } #>
        }

        switch ($ReturnType) {
            HashTable      {
                $ReturnObject = @{}
                $UsedParameters.psobject.Properties | ForEach-Object {$ReturnObject[$_.Name] = $_.Value}
            }
            PSCustomObject {
                $ReturnObject = $UsedParameters
            }
        }
    }

    end {
        return $ReturnObject
    }
}