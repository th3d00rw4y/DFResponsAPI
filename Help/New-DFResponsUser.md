---
external help file: DFResponsAPI-help.xml
Module Name: DFResponsAPI
online version:
schema: 2.0.0
---

# New-DFResponsUser

## SYNOPSIS
Create a new user in DFRespons

## SYNTAX

### ManualSet
```
New-DFResponsUser -Surname <String> -GivenName <String> -SamAccountName <String> -Email <String>
 [-Title <String>] [-Cellphone <String>] [<CommonParameters>]
```

### ObjectSet
```
New-DFResponsUser -ADObject <ADAccount> [<CommonParameters>]
```

### OnlySamAccountName
```
New-DFResponsUser [-OnlySamAccountName <String>] [<CommonParameters>]
```

## DESCRIPTION
This CMDlet will let you create a new user in DFRespons.
Works with either providing data manually to parameter set \`ManualSet\` or by piping an ADObject to the CMDlet.

## EXAMPLES

### EXAMPLE 1
```powershell
# In this example we manually build our user object and then create the user based on the parameters used.
# Note that all four parameters are mandatory.
$DFResponsUserParams = @{
    Surname         = "Dailor"
    GivenName       = "Brann"
    SamAccountName  = "BRADAI01"
    Email           = "brann.dailor@greatmusicians.com"

}
New-DFResponsUser @DFResponsUserParams
```
Example response:
```yaml
{
    id           : 17
    name         : Brann Dailor
    username     : BRANDAI01
    email        : brann.dailor@greatmusicians.com
    password     : <Random generated password>
    disabled     : False
}
```
### EXAMPLE 2
```powershell
# This example will create the user in DFRespons based only on a SamAccountName from the active directory along with provided properties
$ADProperties = @(
    'Title'
    'Organization',
    'ExtensionAttribute5' # Let's pretend that this AD attribute hold information about our user's work phone number.
    'TelephoneNumber' # This AD attribute in this case holds information about our user's cellphone number
    'SamAccountName'
    'GivenName'
    'Surname'
    'Mail'
)
New-DFResponsUser -OnlySamAccountName BRADAI01 -ADProperties @ADProperties
```
Example response:
```yaml
{
    id           : 17
    name         : Brann Dailor
    username     : BRANDAI01
    email        : brann.dailor@greatmusicians.com
    title        : Drummer/Singer
    organization : Mastodon
    phone        : 09087
    cellphone    : 0986785423
    disabled     : False
}
```
### EXAMPLE 3
```powershell
# In this example will will get a user from the AD and pipe it to the CMDlet for creating a new DFRespons user.
Get-ADUser -Identity BRANDAI01 | New-DFResponsUser
```
Example response:
```yaml
{
    id           : 17
    name         : Brann Dailor
    username     : BRANDAI01
    email        : brann.dailor@greatmusicians.com
    disabled     : False
}
```
## PARAMETERS

### -Surname
Lastname of the user to be created - Mandatory!

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GivenName
Firstname of the user to be created - Mandatory!

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SamAccountName
SamAccountName/Username of the user to be created - Mandatory!

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Email
Email of the user to be created - Mandatory!

```yaml
Type: String
Parameter Sets: ManualSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Title
Title of the user to be created

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

### -Cellphone
Cellphone number of the user to be created

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
ADObject of a user to be created.
Must include GivenName, Surname, Mail/UserPrincipalName

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
Create user object in DFRespons based only on the SamAccountName of an AD user.
Using this parameter will leverage the ActiveDirectory module and fetch information on the user from your AD.
Can be used in conjunction with the ADProperties parameter.

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
