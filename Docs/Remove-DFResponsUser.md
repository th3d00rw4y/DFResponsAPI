---
external help file: DFResponsAPI-help.xml
Module Name: DFResponsAPI
online version:
schema: 2.0.0
---

# Remove-DFResponsUser

## SYNOPSIS
Removes a user in DFRespons

## SYNTAX

### Id
```
Remove-DFResponsUser -Id <String> [<CommonParameters>]
```

### SamAccountName
```
Remove-DFResponsUser -SamAccountName <String> [<CommonParameters>]
```

## DESCRIPTION
This CMDlet will remove a user within the DFRespons system.
Use with caution as this action is irreversible.
It is recommended that you utilize Disable-DFResponsUser instead of this CMDlet.

## EXAMPLES

### EXAMPLE 1
```powershell
# This example will remove the user based on it's Id
Remove-DFResponsUser -Id 45
```

### EXAMPLE 2
```powershell
# This example will remove the user based on it's SamAccountName/Username
Remove-DFResponsUser -SamAccountName BRADAI01
```

### EXAMPLE 3
```powershell
# This example will fetch an user from AD and utilize the ValueFromPipeline and remove given user based on it's SamAccountName
Get-ADUser BRADAI01 | Remove-DFResponsUser
```

### EXAMPLE 4
```powershell
# In this example we have an array of Id's that we pipe into an foreach loop that will then remove the users from DFRespons
$Array = @(
    '45'
    '78'
    '110'
)
$Array | ForEach-Object {Remove-DFResponsUser -Id $_}
```

## PARAMETERS

### -Id
Id of the user in DFRespons that is to be removed.

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
SamACcountName/Username of the user in DFRespons that is to be removed.

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
