# DFResponsAPI
<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
    * [Built With](#built-with)
* [Getting Started](#getting-started)
    * [Prerequisites](#prerequisites)
    * [Installation](#installation)
* [Usage](#usage)
* [Changelog](#Changelog)
* [Roadmap](#roadmap)
* [License](/License)
* [Acknowledgements](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## About The Project
This module was created to make user provisioning to the DFRespons system as easy as possible.
It was also created in a way that other organizations can utilize it.

### Built With
* [Powershell](https://docs.microsoft.com/en-us/powershell/)
* [VSCode](https://code.visualstudio.com/)
* [DFRespons API documentation](https://docs.digitalfox.se/api/)

<!-- GETTING STARTED -->
## Getting Started
There are a few steps you need to complete before you can start using the cmdlets in this module.
Please make sure you've followed each one.

### Prerequisites
* Powershell 5.1
* Licensed version of DFRespons to get access to the API.
* API key and a service account provided by the vendor.

### Installation
1. Start a powershell session with the account that will be running the tasks. This is because when doing steps 4 & 5, the credential files will only be readable by the very same account that created them.
2. `Install-Module -Name DFResponsAPI`
3. `Import-Module -Name DFResponsAPI`. You will get a warning saying that there is no settings file present, but let's skip this for now.
4. `New-Secret -Name <Name of the file> -Path <Path to store the secret> -Username <The API service account username>` You will be prompted to enter the password for the service account.
5. `New-Secret -Name <Name of the API key secret file> -Path <Path to store the secret>` You will once again be prompted to enter a password, which in this case would be the API key.
6. Run `Initialize-SettingsFile`. See /Docs/Initialize-SettingsFile.md for examples.
7. Finally import the module again `Import-Module DFResponsAPI -Force`. And you should be good to go!

## Changelog
`DFResponsAPI` is currently only maintained by me. I will try to add as many features as possible.
- ## 2022.03.04 - Version 0.0.1.8
    - Rewritten the sync cmdlet for better comparison between AD and DFRespons properties
    - New private functions:
        - [x] `Get-SyncData`
            - Better comparison between user objects that are returned to `Sync-DFResponsFromADGroup`
        - [x] `Write-CMTLog`
            - Writes a log file from `Sync-DFResponsFromADGroup` in CMTrace format.
        - [x] `Write-StartEndLog`
            - Writes either a starting or ending log entry.
- ## 2022.02.18 - Version 0.0.1.7
    - [x] Published module in the [PSGallery](https://www.powershellgallery.com/packages/DFResponsAPI)
- ## 2022.02.17 - Version 0.0.1.6
    - [x] Various fixes and cleanup in functions.
- ## 2022.02.16 - Version 0.0.1.5
    - [x] Wrote help docs for all public cmdlets.
- ## 2022.02.15 - Version 0.0.1.4
    - New public cmdlets:
        - [x] [Remove-DFResponsUser](Docs/Remove-DFResponsUser.md)
    - New private functions:
        - [x] `Compare-Object`
            - A proxy function for the built-in Compare-Object cmdlet, created by [DBremen](https://github.com/DBremen)
        - [x] `Get-FilePath`
            - A helper function that displays a windows form letting you pick either a directory or a file depending on what parameters where used.
- ## 2022.02.14 - Version 0.0.1.3
    - New public cmdlets:
        - [x] [Sync-DFResponsFromADGroup](Docs/Sync-DFResponsFromADGroup.md)
        - [x] [Update-DFResponsUser](Docs/Update-DFResponsUser.md)
    - New private functions:
        - [x] `Get-ErrorMessage`
            - Handles exceptions and errors returned.
        - [x] `Format-UsedParameters`
            - Formats strings passed in parameters to match the API call structure.
- ## 2022.02.11 - Version 0.0.1.2
    - [x] Changed name of some files and various fixes.
    - [x] Added this changelog.
    - [x] New public cmdlets:
        - [x] [Disable-DFResponsUser](Docs/Disable-DFResponsUser.md)
        - [x] [Enable-DFResponsUser](Docs/Enable-DFResponsUser.md)
    - New private function:
        - [x] `ConvertFrom-ADObject`
            - Handles `[Microsoft.ActiveDirectory.Management.ADUser]` and converts it into a PSCustomObject used for comparing and preparing json payload.
- ## 2022.02.09 - Version 0.0.1.1
    - Reworked how default settings will be handled.
        - New public cmdlet:
            - [x] [Initialize-SettingsFile](Docs/Initialize-SettingsFile.md)
- ## 2022.02.07 - Version: 0.0.1.0
    - Created this repository, first commit.
    - Available but not entirely finished public functions:
        - [x] [Get-DFResponsUser](Docs/Get-DFResponsUser.md)
        - [x] [New-DFResponsUser](Docs/New-DFResponsUser.md)
    - Kind of finished private functions:
        - `Invoke-DFResponsAPI`
            - Sort of the heart of it all. Every public function calls this one with it's formatted request string.
        - `Get-AuthenticationToken`
            - Converts the secure string to base64 to be able to pass it into the API call.

<!-- USAGE EXAMPLES -->
## Usage

[See cmdlet docs](/Docs/)

<!-- ROADMAP -->
## Roadmap

 - [x] Adding compability for working with datasource
 - [x] Improve error message handling

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
[Digital Fox](https://digitalfox.se) for great API documentation.