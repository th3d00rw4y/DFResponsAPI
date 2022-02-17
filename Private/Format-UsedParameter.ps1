function Format-UsedParameter {

    [CmdletBinding()]

    param (

        # What parameter set that has been used.
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'ManualSet',
            'ObjectSet',
            'OnlySamAccountName'
        )]
        [string]
        $SetName,

        # Inputobject containing the $PSCmdlet
        [Parameter(Mandatory = $true)]
        [System.Object]
        $InputObject
    )

    begin {
        # $UsedParameters = New-Object -TypeName PSCustomObject
        $UsedParameters = [PSCustomObject][ordered]@{}
    }

    process {

        switch ($SetName) {
            ManualSet {

                $TMPHash = foreach ($key in $InputObject) {
                    $value = (get-variable $key).Value
                    @{
                        "$key" = "$value"
                    }
                }

                foreach ($item in $TMPHash) {
                    switch ($item.Keys) {
                        GivenName      {$script:GivenName = $item.GivenName}
                        Surname        {
                            $Surname = $item.Surname
                            $Fullname = "$GivenName $SurName"
                            $UsedParameters | Add-Member -MemberType NoteProperty -Name 'Name' -Value $Fullname
                        }
                        SamAccountName {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'UserName' -Value $item.SamAccountName}
                        UserName       {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'UserName' -Value $item.username}
                        EMail          {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'Email' -Value $item.Email}
                        Title          {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'Title' -Value $item.Title}
                        Phone          {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'Phone' -Value $item.Phone}
                        Cellphone      {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'CellPhone' -Value $item.Cellphone}
                        Organization   {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'Organization' -Value $item.Organization}
                    }
                }
            }
            {($_ -eq 'ObjectSet') -or ($_ -eq 'OnlySamAccountName')} {

                switch ($InputObject.PropertyNames) {
                    GivenName       {}
                    Surname         {
                        $FullName = "$($InputObject.GivenName) $($InputObject.Surname)"
                        $UsedParameters | Add-Member -MemberType NoteProperty -Name 'Name' -Value $Fullname
                    }
                    SamAccountName             {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'UserName' -Value $InputObject.SamAccountName}
                    Mail                       {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'Email' -Value $InputObject.Mail}
                    Title                      {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'Title' -Value $InputObject.Title}
                    TelephoneNumber            {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'Phone' -Value $InputObject.TelephoneNumber}
                    PhysicalDeliveryOfficeName {$UsedParameters | Add-Member -MemberType NoteProperty -Name 'Organization' -Value $InputObject.PhysicalDeliveryOfficeName}
                }
            }
        }

        $Body = @{}
        $UsedParameters.psobject.Properties | ForEach-Object {$Body[$_.Name] = $_.Value}
    }

    end {
        return $Body
    }
}
# End function.