---
external help file: DFResponsAPI-help.xml
Module Name: DFResponsAPI
online version:
schema: 2.0.0
---

# Sync-DFResponsFromADGroup

## SYNOPSIS
Synchronize DFrespons from an AD group.

## SYNTAX

```
Sync-DFResponsFromADGroup [-ADGroup] <String> [[-PathToExcludedAccountsFile] <String>] [<CommonParameters>]
```

## DESCRIPTION
This CMDlet will synchronize the DFRespons system with an AD group.
It will check each value provided in $ADProperties and update values that differ.

## EXAMPLES

### EXAMPLE 1
```powershell
Sync-DFResponsFromADGroup -ADGroup 'ACCESS-DFRespons' -PathToExcludedAccountsFile "C:\Scripts\DFRespons_ExcludedAccounts.txt"
```

## PARAMETERS

### -ADGroup
CN of the AD group

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

### -PathToExcludedAccountsFile
Path to file containing accounts that will be excluded from the synchronization.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
