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
* [License](#license)
* [Contact](#contact)
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
There are a few steps you need to complete before you can start using the CMDlets in this module.
Please make sure you've followed each one.

### Prerequisites

* Powershell 5.1
* Licensed version of DFRespons to get access to the API.
* API key and a service account provided by the vendor.

### Installation
1. Start a powershell session with the account that will be running the tasks. This is because when doing steps 4 & 5, the credential files will only be readable by the very same account that created them.
2. Download the DFResponsAPI module: `Install-Module -Name DFResponsAPI`
3. `Import-Module -Name DFResponsAPI`. You will get a warning saying that there is no settings file present, but let's skip this for now.
4. Run `New-Secret -Name <Name of the file> -Path <Path to store the secret> -Username <The API service account username>` You will be prompted to enter the password for the service account.
5. Again, run `New-Secret -Name <Name of the API key secret file> -Path <Path to store the secret>` You will once again be prompted to enter a password, which in this case would be the API key.
6. Run `Initialize-SettingsFile`. See /Docs/Initialize-SettingsFile.md for examples.
7. Finally import the module again `Import-Module DFResponsAPI -Force`. And you should be good to go!

## Changelog

`PSGestioIP` is currently only maintained by me. I will try to add as many features as possible.
- 0.0.6 -2021.04.07
  - [x] Rewrote most of the public functions to work better.
  - [x] Added support to be able to retrieve the network category list from GestióIP API in `Sync-GestioCategory` and `Get-DynamicParameter`
      - [x] Thank you [Marc Uebel](https://github.com/muebel) for updating the API in like 15 minutes after I asked the question! 😊
  - [x] Changed name on:
      - [x] `Get-GestioSettings` -> `Get-GestioCategory`
      - [x] `Sync-GestioSettings` -> `Sync-GestioCategory`
  - [x] Wrote help sections for all functions.
- 0.0.5 - 2021.04.06
  - [x] Added support for dynamic parameters to be able to use validation sets based on settings files.
  - [x] Reworked how categories and sites settings will be handled.
  - [x] New public functions:
      - [x] `Sync-GestioSettings`.
          - [x] Synchronizes either Host or Site categories. Or both of them.
          - [x] Categories will be stored in .txt files in $env:TEMP
          - [x] The categories will be used to populate category validation sets in the modules functions.
      - [x] `Get-GestioHostList`
          - [x] Utilizing the request type "listHosts", this function will retrieve a list of hosts matching the search critera entered in the different parameters.
          - [x] Parameters: `[string]`Hostname, `[string]`Comment, `[string]`Description, `[string]`Category, `[string]`Site, `[string]`Wildcard
              - [x] The wildcard parameter is kinda cool. It will allow you to search for one of the five strings with only a partial string.
      - [x] `Get-GestioNetworkList`
          - [x] Utilizing the request type "listNetworks", this function will retrieve a list of networks matching the search critera entered in the different parameters.
          - [x] Parameters: `[string]`Comment, `[string]`Description, `[string]`Category, `[string]`Site, `[string]`Wildcard
  - [x] New private functions:
      - [x] `Get-GestioSettings`
          - [x] This function will read the category and site categories from the API and store the sets in .txt files under $env:TEMP
      - [x] `Get-DynamicParameter`
          - [x] Builds parameters with validation sets based on the categories from the host and site files.
- ## 2022.02.16 - Version 0.0.1.3
    - New public CMDlets:
        - [x] [Sync-DFResponsFromADGroup](Docs/Sync-DFResponsFromADGroup.md)
        - [x] [Update-DFResponsUser](Docs/Update-DFResponsUser.md)
    - New private functions:
        - [x] `Get-ErrorMessage`
            - Handles exceptions and errors returned.
        - [x] `Format-UsedParameters`
            - Formats strings passed in parameters to match the API call structure.
- ## 2022.02.15 - Version 0.0.1.2
    - [x] Changed namne of some files and various fixes.
    - [x] Added this changelog.
    - [x] New public CMDlets:
        - [x] [Disable-DFResponsUser](Docs/Disable-DFResponsUser.md)
        - [x] [Enable-DFResponsUser](Docs/Enable-DFResponsUser.md)
    - New private function:
        - [x] `ConvertFrom-ADObject`
            - Handles `[Microsoft.ActiveDirectory.Management.ADUser]` and converts it into a PSCustomObject used for comparing and preparing json payload.
- ## 2022.02.14 - Version 0.0.1.1
    - Reworked how default settings will be handled.
        - New public CMDlet:
            - [x] [Initialize-SettingsFile](Docs/Initialize-SettingsFile.md)
- ## 2022.02.11 - Version: 0.0.1.0
    - Created this repository, first commit.
    - Available but not entirely finished public functions:
        - [x] [Get-DFResponsUser](Docs/Get-DFResponsUser.md)
        - [x] [Get-DFResponsUser](Docs/Get-DFResponsUser.md)
        - [x] [New-DFResponsUser](Docs/New-DFResponsUser.md)
        - [x] [Remove-DFResponsUser](Docs/Remove-DFResponsUser.md)
    - Kind of finished private functions:
        - `Invoke-DFResponsAPI`
            - Sort of the heart of it all. Every public function calls this one with it's formatted request string.
        - `Get-AuthenticationToken`
            - Converts the secure string to base64 to be able to pass it into the API call.

<!-- USAGE EXAMPLES -->
## Usage

Get-Help `Function-Name` -Full


<!-- ROADMAP -->
## Roadmap

 - [x] Adding compability for handling VLANs

 - [x] Adding compability for handling Networks

 - [x] Adding compability for handling users


<!-- CONTACT -->
## Contact

Mail me: [Simon Mellergård](mailto:simon.mellergardh@gmail.com)


<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
Marc Uebel who created [GestióIP](https://gestioip.net)