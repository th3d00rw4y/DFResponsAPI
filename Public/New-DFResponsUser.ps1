function New-DFResponsUser {

    <#
    .SYNOPSIS
    Create a new user in DFRespons

    .DESCRIPTION
    This CMDlet will let you create a new user in DFRespons. Works with either providing data manually to parameter set `ManualSet` or by piping an ADObject to the CMDlet.

    .PARAMETER Surname
    Lastname of the user to be created - Mandatory!

    .PARAMETER GivenName
    Firstname of the user to be created - Mandatory!

    .PARAMETER SamAccountName
    SamAccountName/Username of the user to be created - Mandatory!

    .PARAMETER Email
    Email of the user to be created - Mandatory!

    .PARAMETER Title
    Title of the user to be created

    .PARAMETER Cellphone
    Cellphone number of the user to be created

    .PARAMETER ADObject
    ADObject of a user to be created. Must include GivenName, Surname, Mail/UserPrincipalName

    .PARAMETER OnlySamAccountName
    Create user object in DFRespons based only on the SamAccountName of an AD user.
    Using this parameter will leverage the ActiveDirectory module and fetch information on the user from your AD.
    Can be used in conjunction with the ADProperties parameter.

    .PARAMETER ADProperties
    Provide what AD properties you want to pass along with the OnlySamAccountName parameter.
    Recommended ones are the ones holding information on your users title, phone, cellphone and organization.

    .EXAMPLE
    In this example we manually build our user object and then create the user based on the parameters used.
    Note that all four parameters are mandatory.
    $DFResponsUserParams = @{
        Surname         = "Dailor"
        GivenName       = "Brann"
        SamAccountName  = "BRADAI01"
        Email           = "brann.dailor@greatmusicians.com"

    }
    New-DFResponsUser @DFResponsUserParams
    Example response:
        id           : 17
        name         : Brann Dailor
        username     : BRANDAI01
        email        : alain.johannes@greatmusicians.com
        disabled     : False
    
    .EXAMPLE
    This example will create the user in DFRespons based only on a SamAccountName from the active directory along with provided properties
    $ADProperties = @(
        'Title'
        'Organization',
        'ExtensionAttribute5' # <- let's pretend that this AD attribute hold information about our user's work phone number.
        'TelephoneNumber' # <- This AD attribute in this case holds information about our user's cellphone number
        'SamAccountName'
        'GivenName'
        'Surname'
        'Mail'
    )
    New-DFResponsUser -OnlySamAccountName BRADAI01 -ADProperties @ADProperties
    Example response:
        id           : 17
        name         : Brann Dailor
        username     : BRANDAI01
        email        : brann.dailor@greatmusicians.com
        title        : Drummer/Singer
        organization : Mastodon
        phone        : 09087
        cellphone    : 0986785423
        disabled     : False

    .EXAMPLE
    In this example will will get a user from the AD and pipe it to the CMDlet for creating a new DFRespons user.
    Get-ADUser -Identity BRANDAI01 | New-DFResponsUser
    Example response:
        id           : 17
        name         : Brann Dailor
        username     : BRANDAI01
        email        : alain.johannes@greatmusicians.com
        disabled     : False

    .NOTES
    Author: Simon Mellergård | IT-avdelningen, Värnamo kommun
    #>

    [CmdletBinding()]
    
    param (
        # Surname of the user
        [Parameter(
            Mandatory                       = $true,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Surname,

        # Given name of the user
        [Parameter(
            Mandatory                       = $true,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $GivenName,

        # SamAccountName for the user
        [Parameter(
            Mandatory                       = $true,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $SamAccountName,

        # The user's mail
        [Parameter(
            Mandatory                       = $true,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Email,

        # Title of the user
        [Parameter(
            Mandatory                       = $false,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Title,

        # Cellphone of the user
        [Parameter(
            Mandatory                       = $false,
            ParameterSetName                = 'ManualSet',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Cellphone,

        # Object containing all properties required for user creation.
        [Parameter(
            Mandatory         = $true,
            ParameterSetName  = 'ObjectSet',
            ValueFromPipeline = $true
        )]
        [Microsoft.ActiveDirectory.Management.ADAccount]
        $ADObject,

        # Create user based only on AD samaccountname property
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
            'GivenName',
            'Surname',
            'Mail',
            'Title',
            'TelephoneNumber',
            'extensionAttribute5',
            'extensionAttribute6',
            'PhysicalDeliveryOfficeName'
        )]
        [string[]]
        $ADProperties #>
    )
    
    begin {
        $Parameters = $MyInvocation.BoundParameters.Keys
    }
    
    process {

        $UsedParameters = switch ($PSCmdlet.ParameterSetName) {

            ManualSet {
                Format-UsedParameter -SetName ManualSet -InputObject $Parameters
            }
            ObjectSet {
                # $UsedParameters = Format-UsedParameter -SetName ObjectSet -InputObject $ADObject
                ConvertFrom-ADObject -ADObject $ADObject
            }
            OnlySamAccountName {
                $ADObject = Get-ADUser -Identity $OnlySamAccountName -Properties $ADProperties
                #$UsedParameters = Format-UsedParameter -SetName OnlySamAccountName -InputObject $ADObject
                ConvertFrom-ADObject -ADObject $ADObject
            }
        }

        <# switch ($PSCmdlet.ParameterSetName) {
            ManualSet {

                $UserObject = @{}

                $FullName = "$($UsedParameters | Where-Object {$_.Name -eq 'GivenName'} | Select-Object -ExpandProperty Value) $($UsedParameters | Where-Object {$_.Name -eq 'Surname'} | Select-Object -ExpandProperty Value)"

                <# foreach ($Parameter in $UsedParameters) {
                    if (-not ($Parameter.Name -eq 'GivenName') -or -not ($Parameter.Name -eq 'Surname')) {
                        $UserObject.Add("$($Parameter.Name)","$($Parameter.Value)")
                    }
                    else {
                        $UserObject.Add("Name","$FullName")
                    }
                    
                    # $($Parameter.Name) = $Parameter.Value
                } #>
                    
                    

                <# $UserObject = [PSCustomObject][ordered]@{
                    name      = "$($GivenName) $($Surname)"
                    username  = $SamAccountName
                    email     = $Mail
                    title     = $Title
                    cellphone = $Cellphone

                }
            }
            ObjectSet {
                
                $UserObject = [PSCustomObject][ordered]@{
                    name      = "$($InputObject.GivenName) $($InputObject.Surname)"
                    username  = $InputObject.SamAccountName
                    email     = $InputObject.Mail
                    title     = $InputObject.Title
                    cellphone = $InputObject.Cellphone
                }
            }
            OnlySamAccountName {
                
                $Properties = @(
                    "Surname"
                    "GivenName"
                    "SamAccountName"
                    "Mail"
                    "Title"
                    "TelephoneNumber"
                )

                $ADObject = Get-ADUser $OnlySamAccountName -Properties $Properties | Select-Object $Properties

                $UserObject = [ordered]@{
                    Name      = "$($ADObject.GivenName) $($ADObject.Surname)"
                    UserName  = $ADObject.SamAccountName
                    Email     = $ADObject.Mail
                    Title     = $ADObject.Title
                    CellPhone = $ADObject.TelephoneNumber
                }
            }
        } #>

        $RequestParams = Format-APICall -Property CreateUser -InputObject $UsedParameters
        
        $InvokeParams = @{
            RequestString = $RequestParams.RequestString
            Method        = $RequestParams.Method
            Body          = $RequestParams.Body
        }

        $Response = Invoke-DFResponsAPI @InvokeParams
    }
    
    end {
        return $Response
        # return $InvokeParams.Body
    }
}
# End function.