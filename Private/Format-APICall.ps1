function Format-APICall {

    [CmdletBinding()]

    param (
        # Property to be used
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'GetUser',
            'CreateUser',
            'UpdateUser',
            'EnableUser',
            'DisableUser',
            'RemoveUser'
        )]
        [string]
        $Property,

        # Searches DFRespons based on samAccountName.
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Name'
        )]
        <# [ValidateScript({
            try {
                Get-ADUser $_ -ErrorAction Stop
            }
            catch {
                Write-Error $_.Exception.Message
            }
        })] #>
        [string]
        $SamAccountName,

        # Id of the user
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Id'
        )]
        [string]
        $Id,

        # Number of objects returned. If not provided, defaults to 25.
        [Parameter()]
        [string]
        $PageSize = '25',

        # Switch that retrieves all users in the system.
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'All'
        )]
        [switch]
        $All,

        #
        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Id'
        )]
        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Hashtable'
        )]
        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Name'
        )]
        [System.Collections.Hashtable]
        $InputObject,

        # Server
        [Parameter(
            Mandatory = $false,
            DontShow  = $true
        )]
        [string]
        $Server = $Settings.Server
    )

    begin {

        $RequestParams = switch ($Property) {

            GetUser {
                switch ($All) {
                    True {
                        @{
                            RequestString = "$Server/user?pagesize=$PageSize&returnExtent=15"
                            Method        = "GET"
                        }
                    }
                    False {
                        if ($Id) {
                            @{
                                RequestString = "$Server/user/$($Id)?returnExtent=15"
                                Method        = "GET"
                            }
                        }
                        elseif ($SamAccountName) {
                            @{
                                RequestString = "$Server/user/$($SamAccountName)?returnExtent=15"
                                Method        = "GET"
                            }
                        }
                    }
                }
            }
            CreateUser {
                @{
                    RequestString = "$Server/user"
                    Method        = "POST"
                    Body          = $InputObject
                }
            }
            {($_ -eq "UpdateUser") -or ($_ -eq "EnableUser") -or ($_ -eq "DisableUser")} {
                switch ($PSCmdlet.ParameterSetName) {
                    Name {
                        @{
                            RequestString = "$Server/user/$SamAccountName"
                            Method        = "PATCH"
                            Body          = $InputObject
                        }
                    }
                    Id   {
                        @{
                            RequestString = "$Server/user/$Id"
                            Method        = "PATCH"
                            Body          = $InputObject
                        }
                    }
                    Hashtable {
                        @{
                            RequestString = "$Server/user/$($InputObject.UserName)"
                            Method        = "PATCH"
                            Body          = $InputObject
                        }
                    }
                }
            }
            RemoveUser {
                if ($Id) {
                    @{
                        RequestString = "$Server/user/$Id"
                        Method        = "DELETE"
                    }
                }
                elseif ($SamAccountName) {
                    @{
                        RequestString = "$Server/user/$SamAccountName"
                        Method        = "DELETE"
                    }
                }
            }
        }
    }

    process {
        # Write-Host $RequestParams.RequestString -ForegroundColor Green
    }

    end {
        return $RequestParams
    }
}
# End function.