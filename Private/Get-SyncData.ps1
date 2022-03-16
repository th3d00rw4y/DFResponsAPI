function Get-SyncData {

    [CmdletBinding()]

    param (
        # Source object (All DFRespons users)
        [Parameter(Mandatory = $true)]
        [System.Object]
        $CurrentDFResponsUsers,

        # Input object to be processed
        [Parameter(Mandatory = $true)]
        [System.Object]
        $InputObject,

        # List of excluded accounts
        [Parameter(Mandatory = $true)]
        [System.Object]
        $ExcludedAccounts
    )

    begin {
        $SyncChanges = New-Object -TypeName PSCustomObject -Property ([ordered]@{
            Updates       = [PSCustomObject]@{}
            StatusChanges = [PSCustomObject]@{}
        })
    }

    process {

        $SyncChanges.Updates = foreach ($ADObject in $InputObject) {
            $DFResponsObject = $CurrentDFResponsUsers | Where-Object {$_.username -eq $ADObject.username}

            if ($DFResponsObject) {
                # Compare user
                try {
                    $Compare = Compare-Object -ReferenceObject $ADObject -DifferenceObject $DFResponsObject -Compact -ErrorAction SilentlyContinue

                    if ($Compare) {
                        $TempHash = [PSCustomObject][ordered]@{}

                        try {
                            $CompareAttrib = Compare-Object -ReferenceObject $ADObject.attributeMapping.value -DifferenceObject $DFResponsObject.attributeMapping.value -Compact -ErrorAction SilentlyContinue
                        }
                        catch {
                            $AttribExists = $false
                            # Write-CMTLog -Message $_.Exception.Message -LogLevel Error -Component $Component -LogFilePath $LogFilePath
                        }

                        if ($attribExists -eq $false) {
                            $TempHash | Add-Member -MemberType NoteProperty -Name 'attributeMapping' -Value $ADObject.attributeMapping

                            Clear-Variable CompareAttrib
                        }
                        elseif ($CompareAttrib.SideIndicator -contains '<=') {
                            $TempHash | Add-Member -MemberType NoteProperty -Name 'attributeMapping' -Value $ADObject.attributeMapping

                            Clear-Variable CompareAttrib
                        }
            
                        # Identifying what properties that differ
                        foreach ($Found in $Compare) {
                            switch ($Found.Property) {
                                Email        {$TempHash | Add-Member -MemberType NoteProperty -Name 'Email' -Value $Found.ReferenceValue}
                                Title        {$TempHash | Add-Member -MemberType NoteProperty -Name 'Title' -Value $Found.ReferenceValue}
                                Organization {$TempHash | Add-Member -MemberType NoteProperty -Name 'Organization' -Value $Found.ReferenceValue}
                                Phone        {$TempHash | Add-Member -MemberType NoteProperty -Name 'Phone' -Value $Found.ReferenceValue}
                                CellPhone    {$TempHash | Add-Member -MemberType NoteProperty -Name 'CellPhone' -Value $Found.ReferenceValue}
                                # attributeMapping {$TempHash | Add-Member -MemberType NoteProperty -Name 'attributeMapping' -Value $Found.ReferenceValue}
                            }
                        }
        
                        if ($TempHash | Get-Member | Where-Object {$_.MemberType -contains 'NoteProperty'}) {
        
                            foreach ($Property in ($TempHash | get-member | Where-Object {$_.MemberType -contains 'NoteProperty'})) {
                                if (-not ($TempHash.$($Property.Name).Length -gt 0)) {
                                    $TempHash.$($Property.Name) = ""
                                }
                            }
        
                            $TempHash | Add-Member -MemberType NoteProperty -Name 'SamAccountName' -Value $DFResponsObject.Username
                            $TempHash | Add-Member -MemberType NoteProperty -Name 'id' -Value $DFResponsObject.id
                            # $TempHash | Add-Member -MemberType NoteProperty -Name 'action' -Value 'Update'
        
                            # $UpdateParams = @{}
                            # $TempHash.psobject.Properties | ForEach-Object {$UpdateParams[$_.Name] = $_.Value}
        
                            # $UpdateParams
                            # ! Logga här!!
                            # Update-DFResponsUser @UpdateParams
        
                            $TempHash
                            Clear-Variable Compare, TempHash, DFResponsObject
                        }
                    }
                }
                catch {
                    Write-Error $_.Exception.Message
                }
            }
        }

        $SyncChanges.StatusChanges = try {
            $UserCompare = Compare-Object -ReferenceObject $CurrentDFResponsUsers.username -DifferenceObject $ADUsersFormatted.username -IncludeEqual -ErrorAction SilentlyContinue | Where-Object {$_.InputObject -notin $ExcludedAccounts}

            if ($UserCompare) {

                foreach ($ComparedUser in $UserCompare) {
    
                    $CompareUserObject = $CurrentDFResponsUsers | Where-Object {$_.username -eq $ComparedUser.InputObject}
    
                    if ((-not ((Get-ADUser $($ComparedUser.InputObject)).Enabled) -eq $true) -and ($CompareUserObject.disabled -eq $false)) {
                        
                        [PSCustomObject]@{
                            action   = "Update"
                            disabled = $true
                            username  = $ComparedUser.InputObject
                        }
    
                    }
                    else {
                        switch ($ComparedUser) {
                            # If '=>' a new user will be created
                            {$_.SideIndicator -eq '=>'} {
                                
                                if ((Get-ADUser $($ComparedUser.InputObject)).Enabled -eq $true) {
                                    [PSCustomObject]@{
                                        action = "New"
                                        disabled = $false
                                        username  = $ComparedUser.InputObject
                                    }
                                }
                            }
    
                            # If '<=', user has been removed from AD group and will therefore be disabled in DFRespons.
                            {$_.SideIndicator -eq '<='} {
                                if (($CompareUserObject).disabled -eq $false) {
                                    
                                    [PSCustomObject]@{
                                        action = "Update"
                                        disabled = $true
                                        username  = $ComparedUser.InputObject
                                    }
                                }
                            }
    
                            # If '==' and user is set to Disabled within DFRespons, the user will be reenabled.
                            {$_.SideIndicator -eq '=='} {
                                if (($CompareUserObject).disabled -eq $true) {
                                    
                                    [PSCustomObject]@{
                                        action = "Update"
                                        disabled = $false
                                        username  = $ComparedUser.InputObject
                                    }
                                }
                            }
                        }
                    }
    
                    Clear-Variable CompareUserObject
                }
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }

    end {
        return $SyncChanges
    }
}