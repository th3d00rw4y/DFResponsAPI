function Get-ErrorMessage {

    [CmdletBinding()]

    param (
        # Error object
        [Parameter()]
        [PSCustomobject]
        $ErrorObject
    )

    begin {

    }

    process {
        if ($ErrorObject.errors) {
            $ReturnError = [PSCustomObject]@{
                ErrorCode    = $ErrorObject.errors.code
                ErrorMessage = $ErrorObject.errors.content
            }
        }
        elseif ($ErrorObject.message) {
            $ReturnError = [PSCustomObject]@{
                ErrorMessage = $ErrorObject.message
            }
        }
    }

    end {
        return $ReturnError
    }
}