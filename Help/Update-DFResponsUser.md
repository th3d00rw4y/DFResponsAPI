---
external help file: DFResponsAPI-help.xml
Module Name: DFResponsAPI
online version:
schema: 2.0.0
---

# Update-DFResponsUser

## SYNOPSIS
Short description

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
Long description

## EXAMPLES

### EXAMPLE 1
```
An example
```

## PARAMETERS

### -SamAccountName
Parameter description

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
Parameter description

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
Parameter description

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
Parameter description

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
Parameter description

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
Parameter description

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
Parameter description

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
Parameter description

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
Parameter description

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
General notes

## RELATED LINKS
