function Update-DFResponsUser {
    <#
    .SYNOPSIS
    Updates a DFRespons user
    
    .DESCRIPTION
    This CMDlet will let you update a user within DFRespons.
    
    .PARAMETER SamAccountName
    SamAccountName/Username of the user to be updated
    
    .PARAMETER Id
    Id of the user to be updated
    
    .PARAMETER EMail
    Updates the email for a user
    
    .PARAMETER Title
    Updates the title of a user
    
    .PARAMETER Phone
    Updates the phone number of a user
    
    .PARAMETER CellPhone
    Updates the cellphone number of a user
    
    .PARAMETER Organization
    Updates the organization of a user
    
    .PARAMETER ADObject
    AD object of a user. Each of the properties in the AD object that match what you set as property identifiers in your settings file will be updated
    
    .PARAMETER OnlySamAccountName
    Update a user based on the users AD SamAccountName. Will utilize the property identifiers that you set in your settings file and update the user in DFRespons
    
    .EXAMPLE
    # This example will update a user in DFRespons with the following properties: title, cellphone and organization
    Update-DFResponsUser -SamAccountName BREHIN01 -Title "Singer/Guitarist" -CellPhone "098765453421" -Organization "Mastodon"
    Example response:
    {
        id           : 11
        name         : Brent Hinds
        username     : BREHIN01
        title        : Guitarist/Singer
        email        : brent.hinds@greatmusicians.com
        cellphone    : 098765453421
        organization : Mastodon
    }

    .EXAMPLE
    # This example will update a user in DFRespons based only on the SamAccountName
    Update-DFResponsUser -OnlySamAccountName BREHIN01
    # Again, AD properties are determined by what you provided to your settings file when running Initialize-SettingsFile
    Example response:
    {
        id           : 11
        name         : Brent Hinds
        username     : BREHIN01
        title        : Guitarist/Singer
        email        : brent.hinds@greatmusicians.com
        cellphone    : 098765453421
        organization : Mastodon
    }
    
    .NOTES
    Author: Simon Mellergård | IT-avdelningen, Värnamo kommun
    #>
    [CmdletBinding()]
    
    param (

        # SamAccountName for the user
        [Parameter(
            Mandatory                       = $true,
            ParameterSetName                = 'SamAccountSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [Parameter(
            Mandatory                       = $false,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({
            try {
                Get-ADUser $_ -ErrorAction Stop
            }
            catch {
                Write-Error $_.Exception.Message
            }
        })]
        [string]
        $SamAccountName,

        # Id of the user
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'IdSet'
        )]
        [Parameter(
            Mandatory                       = $false,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Id,

        [Parameter(
            Mandatory                       = $false,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $EMail,

        # Title of the user
        [Parameter(
            Mandatory                       = $false,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Title,

        # Phone number for the user
        [Parameter(
            Mandatory                       = $false,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Phone,

        # Cellphone of the user
        [Parameter(
            Mandatory                       = $false,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $CellPhone,

        # Users organization
        [Parameter(
            Mandatory                       = $false,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Organization,

        # Object containing all properties required for user creation.
        [Parameter(
            Mandatory         = $true,
            ParameterSetName  = 'ObjectSet',
            ValueFromPipeline = $true
        )]
        [ValidateScript({Get-ADUser $_.SamAccountName})]
        [Microsoft.ActiveDirectory.Management.ADAccount]
        $ADObject,

        # Update user based only on AD samaccountname property
        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'OnlySamAccountName'
        )]
        [ValidateScript({Get-ADUser $_})]
        [string]
        $OnlySamAccountName
    )
    
    begin {
        $Parameters = $MyInvocation.BoundParameters.Keys
    }
    
    process {

        switch ($PSCmdlet.ParameterSetName) {

            ManualSet {
                $UsedParameters = Format-UsedParameter -SetName ManualSet -InputObject $Parameters
            }
            ObjectSet {
                $UsedParameters = ConvertFrom-ADObject -ADObject $ADObject
                # $UsedParameters = Format-UsedParameter -SetName ObjectSet -InputObject $InputObject
            }
            OnlySamAccountName {
                $ADObject = Get-ADUser -Identity $OnlySamAccountName -Properties $ADProperties
                $UsedParameters = ConvertFrom-ADObject -ADObject $ADObject
                # $UsedParameters = Format-UsedParameter -SetName OnlySamAccountName -InputObject $ADObject
            }
        }

        $RequestParams = Format-APICall -Property UpdateUser -InputObject $UsedParameters
        
        $InvokeParams = @{
            RequestString = $RequestParams.RequestString
            Method        = $RequestParams.Method
            Body          = $RequestParams.Body
        }

        $Response = Invoke-DFResponsAPI @InvokeParams
    }
    
    end {
        return $Response
        # return $InvokeParams
    }
}