function Sync-DFResponsFromADGroup {
    <#
    .SYNOPSIS
    Synchronize DFrespons from an AD group.

    .DESCRIPTION
    This CMDlet will synchronize the DFRespons system with an AD group. It will check each value provided in $ADProperties and update values that differ.

    .PARAMETER ADGroup
    CN of the AD group

    .PARAMETER PathToExcludedAccountsFile
    Path to file containing accounts that will be excluded from the synchronization.

    .EXAMPLE
    Sync-DFResponsFromADGroup -ADGroup 'ACCESS-DFRespons' -PathToExcludedAccountsFile "C:\Scripts\DFRespons_ExcludedAccounts.txt"

    .NOTES
    Author: Simon Mellergård | IT-avdelningen, Värnamo kommun
    #>
    [CmdletBinding()]

    param (
        # Name of AD group to be synced with
        [Parameter(Mandatory = $true)]
        [string]
        $ADGroup,

        # Path to file holding accounts you want to exclude from the synchronization. Exclusion is based on Username in DFRespons.
        [Parameter()]
        [string]
        $PathToExcludedAccountsFile
    )

    begin {

        # Checking that provided ADGroup actually exists.
        $ADGroupExists = try {
            if (Get-ADGroup -Identity $ADGroup -ErrorAction Stop) {
                $true
            }
        }
        catch {
            $false
        }

        # Getting all current users in DFRespons
        $CurrentDFResponsUsers = Get-DFResponsUser -All -PageSize 4000 | Select-Object -ExpandProperty results

        # Getting all accounts that are to be excluded from the synchronization.
        $ExcludedAccounts = Get-Content -Path $PathToExcludedAccountsFile
    }

    process {

        switch ($ADGroupExists) {
            True  {

                # Retreiving all users that are member of provided group.
                $ADGroupMembers = Get-ADGroupMember -Identity $ADGroup

                # Formatting each AD user to match with object structure in DFRespons.
                $ADUsersFormatted = foreach ($GroupMember in $ADGroupMembers) {
                    Get-ADUser -Identity $GroupMember.SamAccountName -Properties $ADProperties | ConvertFrom-ADObject -ReturnType PSCustomObject
                }

                # Comparing AD group members with current DFRespons users to see if there are any changes to be made.
                $UsersToUpdate = foreach ($item in $ADUsersFormatted) {

                    $TMP = $CurrentDFResponsUsers | Where-Object {$_.username -eq $item.username}

                    # Compare user
                    try {
                        $Compare = Compare-Object -ReferenceObject $item -DifferenceObject $TMP -Compact -ErrorAction SilentlyContinue
                    }
                    catch {
                        Write-Error $_.Exception.Message
                    }

                    if ($Compare) {

                        $TempHash = [PSCustomObject][ordered]@{}

                        # Identifying what properties that differ
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

                            $TempHash | Add-Member -MemberType NoteProperty -Name 'SamAccountName' -Value $TMP.username

                            $TempHash | Update-DFResponsUser
                        }

                        Clear-Variable Compare, TempHash, TMP
                    }
                }

                # Comparing AD users with DFRespons users to see if any accounts are to be enabled/disabled
                try {
                    $UserCompare = Compare-Object -ReferenceObject $CurrentDFResponsUsers.username -DifferenceObject $ADUsersFormatted.Username -IncludeEqual -ErrorAction SilentlyContinue | Where-Object {$_.InputObject -notin $ExcludedAccounts}
                }
                catch {
                    Write-Error $_.Exception.Message
                }

                if ($UserCompare) {

                    $UserChanges = foreach ($ComparedUser in $UserCompare) {
                        switch ($ComparedUser) {
                            # If '=>' a new user will be created
                            {$_.SideIndicator -eq '=>'} {Get-ADUser -Identity $ComparedUser.InputObject -Properties $ADProperties | New-DFResponsUser}

                            # If '<=', user has been removed from AD group and will therefore be disabled in DFRespons.
                            {$_.SideIndicator -eq '<='} {
                                if (($CurrentDFResponsUsers | Where-Object {$_.username -eq $ComparedUser.InputObject}).disabled -eq $false) {
                                    Disable-DFResponsUser -SamAccountName $ComparedUser.InputObject
                                }
                            }

                            # If '==' and user is set to Disabled within DFRespons, the user will be reenabled.
                            {$_.SideIndicator -eq '=='} {
                                if (($CurrentDFResponsUsers | Where-Object {$_.username -eq $ComparedUser.InputObject}).disabled -eq $true) {
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