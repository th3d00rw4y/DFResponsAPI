---
external help file: DFResponsAPI-help.xml
Module Name: DFResponsAPI
online version:
schema: 2.0.0
---

# Enable-DFResponsUser

## SYNOPSIS
Enable a user in DFRespons

## SYNTAX

### Id
```
Enable-DFResponsUser -Id <String> [<CommonParameters>]
```

### SamAccountName
```
Enable-DFResponsUser -SamAccountName <String> [<CommonParameters>]
```

## DESCRIPTION
This CMDlet will enable a user in the DFRespons system based on that the user already exists and is in a disabled state.

## EXAMPLES

### EXAMPLE 1
```powershell
Enable-DFResponsUser -SamAccountName DEAFER01

Example response:
    id           : 10
    name         : Dean Fertita
    username     : DEAFER01
    title        : Multi instrumentalist
    email        : dean.fertita@greatmusicians.com
    organization : Queens of the Stoneage
    disabled     : False
```
### EXAMPLE 2
```powershell
Enable-DFResponsUser -Id 14

Example response:
    id           : 14
    name         : Michael Schuman
    username     : MICSCH01
    title        : Basist/Singer
    email        : michael.schuman@greatmusicians.com
    organization : Queens of the Stoneage...
    disabled     : False
```
### EXAMPLE 3
```powershell
Get-ADUser -Identity BREHIN01 | Enable-DFResponsUser

This example will fetch an AD account and pipe it to Enable-DFResponsUser
Example response:
    id           : 11
    name         : Brent Hinds
    username     : BREHIN01
    title        : Guitarist/Singer
    email        : brent.hinds@greatmusicians.com
    organization : Mastodon
    disabled     : False
```
## PARAMETERS

### -Id
Disable the user based on it's Id.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SamAccountName
Disable the user based on it's SamAccountName/Username

```yaml
Type: String
Parameter Sets: SamAccountName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Simon Mellergård | IT-avdelningen, Värnamo kommun

## RELATED LINKS
