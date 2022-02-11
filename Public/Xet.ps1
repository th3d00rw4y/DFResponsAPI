function Xet {
    
    <#
    .SYNOPSIS
    Get user(s) from the DFrespons database.
    
    .DESCRIPTION
    Retreives a user based on it's username or id. Can also be called with the -All switch to retrieve all users. PageSize can be used in conjunction with the -All switch to limit number of objects returned.
    
    .PARAMETER SamAccountName
    Get user object based on samaccountname/username.
    
    .PARAMETER Id
    Get user object based on id.
    
    .PARAMETER All
    Retrieves all user objects
    
    .PARAMETER PageSize
    Sets the maximum number of user objects to be returned.
    
    .EXAMPLE
    Get-DFResponsUser -SamAccountName User01
    Example respone:
        id           : 45
        name         : Jimmy Page
        username     : JIMPAG01
        title        : Guitarist
        email        : jimmy.page@greatguitarists.com
        organization : Led Zeppelin
        phone        : 12345
        cellPhone    : 1234567890
        disabled     : False
    
    .Example
    Get-ADUser JOSHOM01 | Get-DFResponsUser
    This example fetches an user from the active directory and pipes the AD object into the Get-DFResponsUser
    Example respone:
        id           : 01
        name         : Joshua Homme
        username     : JOSHOM01
        title        : Singer/Guitarist
        email        : joshua.homme@greatguitarists.com
        organization : Queens of the Stoneage
        phone        : 54321
        cellPhone    : 0987654321
        disabled     : True
    
    .EXAMPLE
    Get-DFResponsUser -Id 02
    Example respons:
        id           : 02
        name         : Troy Van Leeuwen
        username     : TROLEE01
        title        : multi instrumentalist
        email        : troy.van.leeuwen@greatguitarists.com
        organization : Queens of the Stoneage
        disabled     : True
    
    .NOTES
    Author: Simon Mellergård | IT-avdelningen, Värnamo kommun
    #>

    [CmdletBinding()]

    param (
        # Searches DFRespons based on samAccountName.
        [Parameter(
            Position  = 0,
            Mandatory = $true,
            ParameterSetName = 'Name',
            ValueFromPipelineByPropertyName = $true
        )]
        #[ValidateScript({Get-ADUser $_})]
        [string]
        $SamAccountName,

        # Searches DFRespons based on Id
        [Parameter(
            Position  = 1,
            Mandatory = $true,
            ParameterSetName = 'Id'
        )]
        [string]
        $Id,

        # Switch that retrieves all users in the system.
        [Parameter(
            Position  = 2,
            Mandatory = $true,
            ParameterSetName = 'All'
        )]
        [switch]
        $All,

        # Number of objects to be returned
        [Parameter(
            Position  = 3,
            Mandatory = $false,
            ParameterSetName = 'All'
        )]
        [string]
        $PageSize = '25'
    )
    
    begin {

    }
    
    process {

        # Switch that identifies what parameter that has been used and sends the parameter data to the Format-APICall cmdlet.
        # The object returned will contain an object with invoke uri and method for the request.
        $RequestProperties = switch ($PSCmdlet.ParameterSetName) {
            Name     {Format-APICall -Property GetUser -SamAccountName $SamAccountName}
            Id       {Format-APICall -Property GetUser -Id $Id}
            All      {Format-APICall -Property GetUser -All -PageSize $PageSize}
        }

        # Passing the invoke parameters to the Invoke-DFResponsAPI cmdlet.
        $Response = Invoke-DFResponsAPI @RequestProperties
    }
    
    end {
        # Returning what comes from the Invoke-DFResponsAPI cmdlet.
        return $Response
    }
}