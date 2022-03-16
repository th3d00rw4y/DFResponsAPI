function Sync-DFResponsFromADGroup {
    <#
    .SYNOPSIS
    Synchronize DFRespons from an AD group.

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
        $PathToExcludedAccountsFile = "C:\TMP\Secrets\DFResponsExcludedAccounts.txt",

        # Log file path
        [Parameter()]
        [string]
        $LogFilePath = "C:\TMP\DFResponsLog.log"
    )

    begin {

        $Component = $MyInvocation.MyCommand
        Write-StartEndLog -Action Start -LogFilePath $LogFilePath

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
        $CurrentDFResponsUsers = Get-DFResponsUser -All -PageSize 2000

        # Getting all accounts that are to be excluded from the synchronization.
        $ExcludedAccounts = Get-Content -Path $PathToExcludedAccountsFile
    }

    process {

        switch ($ADGroupExists) {
            True  {

                # Retreiving all users that are member of provided group.
                $ADGroupMembers = Get-ADGroupMember -Identity $ADGroup -Recursive

                # Formatting each AD user to match with object structure in DFRespons.
                $ADUsersFormatted = foreach ($GroupMember in $ADGroupMembers) {
                    Get-ADUser -Identity $GroupMember.SamAccountName -Properties $ADProperties | ConvertFrom-ADObject -ReturnType PSCustomObject
                }

                # Comparing AD group members with current DFRespons users to see if there are any changes to be made.
                $UsersToUpdate = Get-SyncData -CurrentDFResponsUsers $CurrentDFResponsUsers -InputObject $ADUsersFormatted -ExcludedAccounts $ExcludedAccounts

                switch ($UsersToUpdate) {
                    
                    {$_.StatusChanges} {
                        foreach ($Change in $_.StatusChanges) {
                            switch ($Change.action) {
                                Update {
                                    switch ($Change.disabled) {
                                        False  {
                                            Enable-DFResponsUser -SamAccountName $Change.username
                                            # $ReturnHash.Enabled = $Change.email
                                            Write-CMTLog -Message "Username: $($Change.username) has been enabled" -LogLevel Normal -Component $Component -LogFilePath $LogFilePath
                                        }
                                        True {
                                            Disable-DFResponsUser -SamAccountName $Change.username
                                            # Clear-DFResponsUser -Email $Change.email
                                            # $ReturnHash.Disabled = $Change.email
                                            Write-CMTLog -Message "Username: $($Change.username) has been disabled and user properties cleared." -LogLevel Normal -Component $Component -LogFilePath $LogFilePath
                                        }
                                    }
                                }
                                New {
                                    $NewDFResponsUser = Get-ADUser $Change.username -Properties $ADProperties | New-DFResponsUser
                                    Write-CMTLog -Message "User created: id = $($NewDFResponsUser.id) - email = $($NewDFResponsUser.email) - samaccountname = $($NewDFResponsUser.username)" -LogLevel Normal -Component $Component -LogFilePath $LogFilePath
                                    Clear-Variable NewDFResponsUser
                                }
                            }
                        }
                    }
                    {$_.Updates} {

                        foreach ($item in $_.Updates) {

                            if ((Get-DFResponsUser -Id $item.id).disabled -eq $false) {
                                
                                $UpdateParams = @{}
                                $item.psobject.Properties | ForEach-Object {$UpdateParams[$_.Name] = $_.Value}
                                # Write-Host "Hoppp!" -ForegroundColor Red
                                Update-DFResponsUser @UpdateParams
                                # $ReturnHash.Updates = $item.id

                                foreach ($Property in $item.psobject.Properties | Where-Object {($_.Name -ne 'id') -and ($_.Name -ne 'samaccountname')}) {

                                    if ($Property.Name -eq 'attributeMapping') {
                                        Write-CMTLog -Message "User: $($item.samaccountname) has been updated with $($Property.Name) = $($UpdateParams.attributeMapping.Value)" -LogLevel Normal -Component $Component -LogFilePath $LogFilePath
                                    }
                                    else {
                                        Write-CMTLog -Message "User: $($item.samaccountname) has been updated with $($Property.Name) = $($Property.Value)" -LogLevel Normal -Component $Component -LogFilePath $LogFilePath
                                    }
                                }
                            }
                        }
                    }
                }
            }
            False {}
        }
    }

    end {
        Write-StartEndLog -Action Stop -LogFilePath $LogFilePath
    }
}
# End function.