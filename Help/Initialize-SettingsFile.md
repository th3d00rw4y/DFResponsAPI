---
external help file: DFResponsAPI-help.xml
Module Name: DFResponsAPI
online version:
schema: 2.0.0
---

# Initialize-SettingsFile

## SYNOPSIS
Build a settings file and store it on the computer.

## SYNTAX

```
Initialize-SettingsFile [-Server] <String> [[-SamAccountName] <String>] [[-GivenName] <String>]
 [[-Surname] <String>] [[-Mail] <String>] [[-Phone] <String>] [[-CellPhone] <String>] [[-Title] <String>]
 [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION
This CMDlet will build a CSV file with information on how to connect to your organizations instance of DFRespons.
The ADProperty parameters are there for you to provide your organizations property names.
e.g: In organization A, cellphone number can be found in \`extensionAttribute6´  and organization is found under \`physicalDeliveryOfficeName´
You will also be prompted to select path to 2 different credential files.
If you haven't generated these credential files, please refer to the module documentation.
Lastly you will be prompted to select a folder where the settings file will be stored.

## EXAMPLES

### EXAMPLE 1
```
Initialize-SettingsFile -SamAccountName 'UserPrincipalName' -
```

## PARAMETERS

### -Server
Your organizations API instance of DFRespons.
e.g: https://DomainName.dfrespons.se/api

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SamAccountName
What property value in AD you want to refer to as the DFRespons \`UserName´

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: SamAccountName
Accept pipeline input: False
Accept wildcard characters: False
```

### -GivenName
What property value in AD you want to refer to as the DFRespons \`Name´ This parameter defaults to AD property \`GivenName´.
It will also work in conjunction with the \`Surname´ parameter to build the DFRespons name as follows: \`$GivenName $Surname´

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: GivenName
Accept pipeline input: False
Accept wildcard characters: False
```

### -Surname
What property value in AD you want to refer to as the DFRespons \`Name´ This parameter defaults to AD property \`Surname´.
It will also work in conjunction with the \`GivenName´ parameter to build the DFRespons name as follows: \`$GivenName $Surname´

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Surname
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mail
What property value in AD you want to refer to as the DFRespons \`Mail´.
Defaults to AD property \`Mail´

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Mail
Accept pipeline input: False
Accept wildcard characters: False
```

### -Phone
What property value in AD you want to refer to as the DFRespons \`Phone´

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CellPhone
What property value in AD you want to refer to as the DFRespons \`CellPhone´

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
What property value in AD you want to refer to as the DFRespons \`Title´ Defaults to AD property \`Title´

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: Title
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
What property value in AD you want to refer to as the DFRespons \`Organization´ Defaults to \`physicalDeliveryOfficeName´

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: PhysicalDeliveryOfficeName
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
