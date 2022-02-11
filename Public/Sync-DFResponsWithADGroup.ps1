function Sync-DFResponsWithADGroup {

    [CmdletBinding()]

    param (
        # Name of AD group to be synced with
        [Parameter(Mandatory = $true)]
        [string]
        $ADGroup
    )
    
    begin {
        
        $ADGroupExists = try {
            if (Get-ADGroup -Identity $ADGroup -ErrorAction Stop) {
                $true
            }
        }
        catch {
            $false
        }

        # $CurrentDFResponsUsers = Get-DFResponsUser -All -PageSize 4000 | Select-Object -ExpandProperty results

        $ExcludedAccounts = @(
            'linus@digitalfox.se',
            'sysadmin',
            'emil.odepark@digitalfox.se',
            'mia.havinder@digitalfox.se',
            'tom.ragnartz@digitalfox.se',
            'lisa.olausson@digitalfox.se',
            'integrator',
            'Rektor',
            'Utredare'
        )
    }
    
    process {
        
        switch ($ADGroupExists) {
            True  {

                <# $ADProperties = @(
                    'Surname',
                    'GivenName',
                    'SamAccountName',
                    'Title',
                    'Mail',
                    'PhysicalDeliveryOfficeName',
                    'extensionAttribute5',
                    'extensionAttribute6',
                    'telephonenumber'
                ) #>

                $ADGroupMembers = Get-ADGroupMember -Identity $ADGroup

                $ADUsersFormatted = foreach ($GroupMember in $ADGroupMembers) {
                    Get-ADUser -Identity $GroupMember.SamAccountName -Properties $ADProperties | ConvertFrom-ADObject -ReturnType PSCustomObject
                }

                <# $CompareProperties = @(
                    'name',
                    'username',
                    'title',
                    'email',
                    'organization',
                    'phone',
                    'cellphone'
                ) #>

                $UsersToUpdate = foreach ($item in $ADUsersFormatted | Where-Object {$_.Username -eq 'BSKPASL'}) {

                    $TMP = $CurrentDFResponsUsers | Where-Object {$_.username -eq $item.username}

                    try {
                        $Compare = Compare-Object -ReferenceObject $item -DifferenceObject $TMP -ErrorAction SilentlyContinue
                    }
                    catch {
                        # Write-Error $_.Exception.Message
                    }

                    if ($Compare) {

                        $ReturnHash = [PSCustomObject][ordered]@{}

                        $TempHash = [PSCustomObject][ordered]@{}

                        foreach ($Found in $Compare) {
                            switch ($Found.Property) {
                                Email        {$TempHash | Add-Member -MemberType NoteProperty -Name 'Email' -Value $Found.ReferenceValue}
                                Title        {$TempHash | Add-Member -MemberType NoteProperty -Name 'Title' -Value $Found.ReferenceValue}
                                Organization {$TempHash | Add-Member -MemberType NoteProperty -Name 'Organization' -Value $Found.ReferenceValue}
                                Phone        {$TempHash | Add-Member -MemberType NoteProperty -Name 'Phone' -Value $Found.ReferenceValue}
                                CellPhone    {$TempHash | Add-Member -MemberType NoteProperty -Name 'CellPhone' -Value $Found.ReferenceValue}
                            }
                        }

                        
                        if ($TempHash | get-member | Where-Object {$_.MemberType -contains 'NoteProperty'}) {

                            foreach ($Property in ($TempHash | get-member | Where-Object {$_.MemberType -contains 'NoteProperty'})) {
                                if (-not ($TempHash.$($Property.Name).Length -gt 0)) {
                                    $TempHash.$($Property.Name) = ""
                                }
                            }
                            # Write-Host "JA!" -ForegroundColor Yellow
                            $TempHash | Add-Member -MemberType NoteProperty -Name 'SamAccountName' -Value $TMP.username

                            $TempHash #| Update-DFResponsUser
                        }

                        #Clear-Variable Compare, TempHash, TMP
                    }
                }

                try {
                    $UserCompare = Compare-Object -ReferenceObject $CurrentDFResponsUsers.username -DifferenceObject $ADUsersFormatted.Username -IncludeEqual -ErrorAction SilentlyContinue | Where-Object {$_.InputObject -notin $ExcludedAccounts}
                }
                catch {
                    #
                }

                if ($UserCompare) {

                    $UserChanges = foreach ($ComparedUser in $UserCompare) {
                        switch ($ComparedUser) {
                            {$_.SideIndicator -eq '=>'} {Get-ADUser -Identity $ComparedUser.InputObject -Properties $ADProperties | New-DFResponsUser}
                            {$_.SideIndicator -eq '<='} {
                                if (($CurrentDFResponsUsers | Where-Object {$_.username -eq $ComparedUser.InputObject}).disabled -eq $false) {
                                    # Write-Host "Disabled $($ComparedUser.InputObject)"
                                    Disable-DFResponsUser -SamAccountName $ComparedUser.InputObject
                                }
                            }
                            {$_.SideIndicator -eq '=='} {
                                if (($CurrentDFResponsUsers | Where-Object {$_.username -eq $ComparedUser.InputObject}).disabled -eq $true) {
                                    # Write-Host "Enabled $($ComparedUser.InputObject)"
                                    Enable-DFResponsUser -SamAccountName $ComparedUser.InputObject
                                }
                            }
                        }
                    }
                }
            }
            False {}
        }

        $ReturnHash = @()
        $ReturnHash += $UsersToUpdate
        $ReturnHash += $UserChanges
    }
    
    end {
        return $ReturnHash
    }
}
# End function.