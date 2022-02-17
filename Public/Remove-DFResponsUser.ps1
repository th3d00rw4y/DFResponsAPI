function Remove-DFResponsUser {
    <#
    .SYNOPSIS
    Removes a user in DFRespons

    .DESCRIPTION
    This CMDlet will remove a user within the DFRespons system. Use with caution as this action is irreversible.
    It is recommended that you utilize Disable-DFResponsUser instead of this CMDlet.

    .PARAMETER Id
    Id of the user in DFRespons that is to be removed.

    .PARAMETER SamAccountName
    SamACcountName/Username of the user in DFRespons that is to be removed.

    .EXAMPLE
    # This example will remove the user based on it's Id
    Remove-DFResponsUser -Id 45

    .EXAMPLE
    # This example will remove the user based on it's SamAccountName/Username
    Remove-DFResponsUser -SamAccountName BRADAI01

    .EXAMPLE
    # This example will fetch an user from AD and utilize the ValueFromPipeline and remove given user based on it's SamAccountName
    Get-ADUser BRADAI01 | Remove-DFResponsUser

    .EXAMPLE
    # In this example we have an array of Id's that we pipe into an foreach loop that will then remove the users from DFRespons
    $Array = @(
        '45'
        '78'
        '110'
    )
    $Array | ForEach-Object {Remove-DFResponsUser -Id $_}

    .NOTES
    Author: Simon Mellergård | IT-avdelningen, Värnamo kommun
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]

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
        # Switch that determines what parameter that has been used.
        switch ($PSCmdlet.ParameterSetName) {
            # The ValidateRemoval variable is used to both check that the user exists and also prompt with user information before removal.
            # The RequestString is the payload that is to be sent to the API when removing the user.
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

        # Checking that given user actually exists.
        $GetUserObject = Invoke-DFResponsAPI @ValidateRemoval

        # Prompt user for removal
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
# End function.