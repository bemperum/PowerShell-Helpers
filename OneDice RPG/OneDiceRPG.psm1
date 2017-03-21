<#
.SYNOPSIS  
    Create and manipulate a OneDice Charcter.
      
.DESCRIPTION  
    Create a OneDice RPG Character and apply some methods.
 
#>

function New-ODChar()
{
    param(
        [string]$Name,
        [string]$Description,
        [int]$Strong,
        [int]$Quick,
        [int]$Clever,
        [int]$Magic=0
        )

    $Health = $Strong * 3
    $Move = $Quick * 10
    $Defence = [System.Math]::Max($Strong, $Quick) * 3

    $ODChar = New-Object -TypeName PSObject -Property @{
        Name = $Name
        Description = $Description
        Strong = $Strong
        Quick = $Quick
        Clever = $Clever
        Magic = $Magic
        StuntPoints = 6
        Health = $Health
        Move = $Move
        Defence = $Defence
    }

    Return $ODChar
}