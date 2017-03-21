<#
.SYNOPSIS  
    OneDiceRPG TESTER
      
.DESCRIPTION  
    Test OneDiceRPG Module
 
#>


$IMPORT_PATH = Join-Path $(Split-Path $PSCommandPath) "OneDiceRPG.psm1"
Import-Module $IMPORT_PATH

$tChar = New-ODChar -Name "Grimbart Dinglewood" `
                    -Description "Clumsy dwarfen fighter" `
                    -Strong 3 `
                    -Quick 2 `
                    -Clever 1

$tChar