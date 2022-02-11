function Enable-DFResponsUser {
    
    <#
    .SYNOPSIS
    Enable a user in DFRespons

    .DESCRIPTION
    This CMDlet will enable a user in the DFRespons system based on that the user already exists and is in a disabled state.

    .PARAMETER Id
    Disable the user based on it's Id. 

    .PARAMETER SamAccountName
    Disable the user based on it's SamAccountName/Username

    .EXAMPLE
    Enable-DFResponsUser -SamAccountName DEAFER01
    Example response:
        id           : 10
        name         : Dean Fertita
        username     : DEAFER01
        title        : Multi instrumentalist
        email        : dean.fertita@greatmusicians.com
        organization : Queens of the Stoneage
        disabled     : False
    
    .EXAMPLE
    Enable-DFResponsUser -Id 14
    Example response:
        id           : 14
        name         : Michael Schuman
        username     : MICSCH01
        title        : Basist/Singer
        email        : michael.schuman@greatmusicians.com
        organization : Queens of the Stoneage...
        disabled     : False

    .EXAMPLE
    Get-ADUser -Identity BREHIN01 | Enable-DFResponsUser
    This example will fetch an AD account and pipe it to Enable-DFResponsUser
    Example response:
        id           : 11
        name         : Brent Hinds
        username     : BREHIN01
        title        : Guitarist/Singer
        email        : brent.hinds@greatmusicians.com
        organization : Mastodon
        disabled     : False

    .NOTES
    Author: Simon Mellergård | IT-avdelningen, Värnamo kommun
    #>

    [CmdletBinding()]
    
    param (
        # Id of the user that will be enabled
        [Parameter(
            Mandatory                       = $true,
            ParameterSetName                = 'Id',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Id,

        # SamAccountName of the user to be enabled
        [Parameter(
            Mandatory                       = $true,
            ParameterSetName                = 'SamAccountName',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $SamAccountName
    )
    
    begin {
        $Body = [ordered]@{
            Disabled = $false
        }
    }
    
    process {
        switch ($PSCmdlet.ParameterSetName) {
            Id {
                $RequestParams = Format-APICall -Property EnableUser -Id $Id -InputObject $Body
            }
            SamAccountName {
                $RequestParams = Format-APICall -Property EnableUser -SamAccountName $SamAccountName -InputObject $Body
            }
        }

        $InvokeParams = @{
            RequestString = $RequestParams.RequestString
            Method        = $RequestParams.Method
            Body          = $RequestParams.Body
        }

        $Response = Invoke-DFResponsAPI @InvokeParams
    }
    
    end {
        # return $InvokeParams
        return $Response
    }
}