---
external help file: DFResponsAPI-help.xml
Module Name: DFResponsAPI
online version:
schema: 2.0.0
---

# Disable-DFResponsUser

## SYNOPSIS
Disable a user in DFRespons.

## SYNTAX

### Id
```
Disable-DFResponsUser -Id <String> [<CommonParameters>]
```

### SamAccountName
```
Disable-DFResponsUser -SamAccountName <String> [<CommonParameters>]
```

## DESCRIPTION
This CMDet will send a PATCH request to the API disabling the user provided with either Id or SamAccountName.

## EXAMPLES

### EXAMPLE 1
```powershell
# This example will disable a user in DFRespons based on the id.
Disable-DFResponsUser -Id 23
```
Example response:
```yaml
{
    id           : 23
    name         : Alain Johannes
    username     : ALAJOH01
    title        : Multi instrumentalist
    email        : alain.johannes@greatmusicians.com
    organization : Them Crooked Vultures, Queens of the Stone Age...
    disabled     : True
}
```
### EXAMPLE 2
```powershell
# This example will take an user object retreived from AD, contaning the property SamAccountName and pipe it to the Disable-DFResponsUser CMDlet.
$ADObject | Disable-DFResponsUser
```
Example response:
```yaml
{
    id           : 34
    name         : Jon Theodore
    username     : JONTHE01
    title        : Drummer
    email        : jon.theodore@greatmusicians.com
    organization : The Mars Volta, Queens of the Stone Age
    disabled     : True
}
```
### EXAMPLE 3
```powershell
# This example will disable a user in DFRespons based on the username.
Disable-DFResponsUser -SamAccountName DAVGRO01
```
Example response:
```yaml
{
    id           : 04
    name         : Dave Grohl
    username     : DAVGRO01
    title        : Drummer/Singer/Guitarist
    email        : dave.grohl@greatmusicians.com
    organization : Them Crooked Vultures, Foo Fighters
    disabled     : True
}
```
### EXAMPLE 4
```powershell
# Here we create an array that contains a number of user Id's
$Array = @(
    '45',
    '67',
    '90'
)

# The array is piped into a foreach loop that will iterate and disable each user connected to the Id's
$Array | Foreach-Object {Disable-DFResponsUser -Id $_}
```

## PARAMETERS

### -Id
Id of the user to be disabled.
Entering an id that does not exist in the system will return an error code.

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
SamAccountname/Username of the user to be disabled.
Entering an value that does not exist in the system will return an error code.

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
