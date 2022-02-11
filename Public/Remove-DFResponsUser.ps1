function Remove-DFResponsUser {

    [CmdletBinding()]
    
    param (
        # Id of the user that will be removed
        [Parameter(
            Mandatory                       = $true,
            ParameterSetName                = 'Id',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Id,

        # SamAccountName of the user to be removed
        [Parameter(
            Mandatory                       = $true,
            ParameterSetName                = 'SamAccountName',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $SamAccountName
    )
    
    begin {
        switch ($PSCmdlet.ParameterSetName) {
            Id {
                $ValidateRemoval = Format-APICall -Property GetUser -Id $Id
                $RequestString   = Format-APICall -Property RemoveUser -Id $Id
            }
            SamAccountName {
                $ValidateRemoval = Format-APICall -Property GetUser -SamAccountName $SamAccountName
                $RequestString   = Format-APICall -Property RemoveUser -SamAccountName $SamAccountName
            }
        }
    }
    
    process {

        $GetUserObject = Invoke-DFResponsAPI @ValidateRemoval

        do {
            $YesOrNo = Read-Host "Are you sure you want to remove the following user:`n`nName: $($GetUserObject.name)`nUsername: $($GetUserObject.username)`n`n(y/n) ?"
        } 
        while ("y","n" -notcontains $YesOrNo)

        switch ($YesOrNo) {
            y {$Response = Invoke-DFResponsAPI @RequestString}
            n {$Response = "Removal process canceled by user"}
        }
    }
    
    end {
        if ($Response) {
            return $Response
        }
    }
}