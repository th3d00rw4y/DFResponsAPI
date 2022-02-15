---
external help file: DFResponsAPI-help.xml
Module Name: DFResponsAPI
online version:
schema: 2.0.0
---

# Update-DFResponsUser

## SYNOPSIS
Updates a DFRespons user

## SYNTAX

### ManualSet
```
Update-DFResponsUser [-SamAccountName <String>] [-Id <String>] [-EMail <String>] [-Title <String>]
 [-Phone <String>] [-CellPhone <String>] [-Organization <String>] [<CommonParameters>]
```

### SamAccountSet
```
Update-DFResponsUser -SamAccountName <String> [<CommonParameters>]
```

### IdSet
```
Update-DFResponsUser -Id <String> [<CommonParameters>]
```

### ObjectSet
```
Update-DFResponsUser -ADObject <ADAccount> [<CommonParameters>]
```

### OnlySamAccountName
```
Update-DFResponsUser [-OnlySamAccountName <String>] [<CommonParameters>]
```

## DESCRIPTION
This CMDlet will let you update a user within DFRespons.

## EXAMPLES

### EXAMPLE 1
```powershell
# This example will update a user in DFRespons with the following properties: title, cellphone and organization
Update-DFResponsUser -SamAccountName BREHIN01 -Title "Singer/Guitarist" -CellPhone "098765453421" -Organization "Mastodon"
```
Example response:
```yaml
{
    id           : 11
    name         : Brent Hinds
    username     : BREHIN01
    title        : Guitarist/Singer
    email        : brent.hinds@greatmusicians.com
    cellphone    : 098765453421
    organization : Mastodon
}
```

### EXAMPLE 2
```powershell
# This example will update a user in DFRespons based only on the SamAccountName
Update-DFResponsUser -OnlySamAccountName BREHIN01
# Again, AD properties are determined by what you provided to your settings file when running Initialize-SettingsFile
```
Example response:
```yaml
{
    id           : 11
    name         : Brent Hinds
    username     : BREHIN01
    title        : Guitarist/Singer
    email        : brent.hinds@greatmusicians.com
    cellphone    : 098765453421
    organization : Mastodon
}
```

## PARAMETERS

### -SamAccountName
SamAccountName/Username of the user to be updated

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: SamAccountSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
Id of the user to be updated

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: IdSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EMail
Updates the email for a user

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Title
Updates the title of a user

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Phone
Updates the phone number of a user

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CellPhone
Updates the cellphone number of a user

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Organization
Updates the organization of a user

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ADObject
AD object of a user.
Each of the properties in the AD object that match what you set as property identifiers in your settings file will be updated

```yaml
Type: ADAccount
Parameter Sets: ObjectSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OnlySamAccountName
Update a user based on the users AD SamAccountName.
Will utilize the property identifiers that you set in your settings file and update the user in DFRespons

```yaml
Type: String
Parameter Sets: OnlySamAccountName
Aliases:

Required: False
Position: Named
Default value: None
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
