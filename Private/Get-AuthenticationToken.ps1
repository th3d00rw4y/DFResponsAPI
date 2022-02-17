function Get-AuthenticationToken() {

	[CmdletBinding()]
	[OutputType([System.String])]

	param (
		# Credential object
		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$Credential
	)

	begin {

    }

	process {
		$key = [string]::Format("{0}:{1}", $Credential.UserName, $Credential.GetNetworkCredential().Password)
	}

	end {
        return [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($key))
    }
}
# End function.