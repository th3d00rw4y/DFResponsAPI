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
        $UsedParameters = New-Object -TypeName PSCustomObject -Property ([ordered]@{
            Name = ""
            Username = ""
            Title = ""
            Email = ""
            Organization = ""
            Phone = ""
            Cellphone = ""
            Disabled = "False"
            attributeMapping = @()
        })

        <# $UsedParameters = ([ordered]@{
            Name = ""
            Username = ""
            Title = ""
            Email = ""
            Organization = ""
            Phone = ""
            Cellphone = ""
            Disabled = "False"
            attributeMapping = @()
        }) #>

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
                {$_.Name -eq "Organization"}    {
                    [string]$UsedParameters.Organization = $ADObject | Select-Object -ExpandProperty $item.Value
                    $UsedParameters.attributeMapping = @(
                        [ordered]@{"property"="Enhetskoder"; "value"="$($ADObject | Select-Object -ExpandProperty $item.Value)"}
                    )
                }
                {$_.Name -eq "Phone"}           {[string]$UsedParameters.Phone = $ADObject | Select-Object -ExpandProperty $item.Value}
                {$_.Name -eq "CellPhone"}       {[string]$UsedParameters.Cellphone = $ADObject | Select-Object -ExpandProperty $item.Value}
            }
        }

        switch ($ReturnType) {
            HashTable      {
                $ReturnObject = @{}
                $UsedParameters.psobject.Properties | ForEach-Object {$ReturnObject[$_.Name] = $_.Value}

                # $ReturnObject = $UsedParameters
            }
            PSCustomObject {
                $ReturnObject = $UsedParameters
            }
        }
    }

    end {
        # return $ReturnObject
        return $ReturnObject
    }
}