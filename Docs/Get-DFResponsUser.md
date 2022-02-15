---
external help file: DFResponsAPI-help.xml
Module Name: DFResponsAPI
online version:
schema: 2.0.0
---

# Get-DFResponsUser

## SYNOPSIS
Get user(s) from the DFrespons database.

## SYNTAX

### Name
```
Get-DFResponsUser [-SamAccountName] <String> [<CommonParameters>]
```

### Id
```
Get-DFResponsUser [-Id] <String> [<CommonParameters>]
```

### All
```
Get-DFResponsUser [-All] [[-PageSize] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retreives a user based on it's username or id.
Can also be called with the -All switch to retrieve all users.
PageSize can be used in conjunction with the -All switch to limit number of objects returned.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DFResponsUser -SamAccountName JIMPAG01
```
Example respone:
```yaml
{
    id           : 45
    name         : Jimmy Page
    username     : JIMPAG01
    title        : Guitarist
    email        : jimmy.page@greatguitarists.com
    organization : Led Zeppelin
    phone        : 12345
    cellPhone    : 1234567890
    disabled     : False
}
```
### EXAMPLE 2
```powershell
# This example fetches an user from the active directory and pipes the AD object into the Get-DFResponsUser
Get-ADUser JOSHOM01 | Get-DFResponsUser
```
Example respone:
```yaml
{
    id           : 01
    name         : Joshua Homme
    username     : JOSHOM01
    title        : Singer/Guitarist
    email        : joshua.homme@greatguitarists.com
    organization : Queens of the Stoneage
    phone        : 54321
    cellPhone    : 0987654321
    disabled     : True
}
```
### EXAMPLE 3
```powershell
Get-DFResponsUser -Id 02
```
Example respons:
```yaml
{
    id           : 02
    name         : Troy Van Leeuwen
    username     : TROLEE01
    title        : multi instrumentalist
    email        : troy.van.leeuwen@greatguitarists.com
    organization : Queens of the Stoneage
    disabled     : True
}
```
## PARAMETERS

### -SamAccountName
Get user object based on samaccountname/username.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
Get user object based on id.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Retrieves all user objects

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: True
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Sets the maximum number of user objects to be returned.

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: 4
Default value: 25
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Simon Mellergård | IT-avdelningen, Värnamo kommun

## RELATED LINKS
