function Invoke-DFResponsAPI {

    [CmdletBinding()]

    param (
        # Path to credential object for basic authentication.
        [Parameter(DontShow = $true)]
        [string]
        $BASecretPath = $Settings.BASecretPath,

        # Path to encrypted API key
        [Parameter(DontShow = $true)]
        [string]
        $APIKeyPath = $Settings.APIKeyPath,

        # Request string to be passed.
        [Parameter(Mandatory = $true)]
        [string]
        $RequestString,

        # Method used in the API call.
        [Parameter(Mandatory = $true)]
        [string]
        $Method,

        # Json body when creating, updating and disabling users(s).
        [Parameter(Mandatory = $false)]
        [System.Object]
        $Body
    )

    begin {

        $Headers = @{
            "Authorization" = "Basic $(Get-AuthenticationToken -Credential $(Get-Secret -LiteralPath $BASecretPath))"
            "X-Apikey" = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($(Get-Secret -LiteralPath $APIKeyPath)))
        }

        if ($Body) {
            $InvokeParams = @{
                Uri         = $RequestString
                Headers     = $Headers
                Body        = $Body | ConvertTo-Json
                Method      = $Method
                ContentType = 'application/json;charset=utf-8'
            }
        }
        else {
            $InvokeParams = @{
                Uri         = $RequestString
                Headers     = $Headers
                Method      = $Method
                ContentType = 'application/json;charset=utf-8'
            }
        }
    }

    process {

        try {
            $Response = Invoke-RestMethod @InvokeParams -ErrorAction Stop
        }
        catch {
            # $_.Exception.Message
            $RequestError = $_.ErrorDetails | ConvertFrom-Json
            # Clear-Host
            Get-ErrorMessage -ErrorObject $RequestError
        }
    }

    end {
        if ($Response.results) {
            return $Response.results
        }
        else {
            return $Response
        }
        # return $InvokeParams
        # return $Response
    }
}