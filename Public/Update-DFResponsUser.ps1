function Update-DFResponsUser {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER SamAccountName
    Parameter description
    
    .PARAMETER Id
    Parameter description
    
    .PARAMETER EMail
    Parameter description
    
    .PARAMETER Title
    Parameter description
    
    .PARAMETER Phone
    Parameter description
    
    .PARAMETER CellPhone
    Parameter description
    
    .PARAMETER Organization
    Parameter description
    
    .PARAMETER ADObject
    Parameter description
    
    .PARAMETER OnlySamAccountName
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
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
        <# [Parameter(
            Mandatory         = $true,
            ParameterSetName  = 'SamAccountSet',
            ValueFromPipeline = $true
        )]
        [Parameter(
            Mandatory         = $true,
            ParameterSetName  = 'IdSet',
            ValueFromPipeline = $true
        )] #>
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

        <# # Set of properties to be used with the AD request
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'OnlySamAccountName'
        )]
        [ValidateSet(
            'SamAccountName',
            'GivenName',
            'Surname',
            'Mail',
            'Title',
            'TelephoneNumber',
            'PhysicalDeliveryOfficeName'
        )]
        [string[]]
        $ADProperties #>
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