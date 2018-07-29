<#
.NAME
Test-Printer.ps1

.DESCRIPTION
Create a .NET PrintDocument and Print it without GUI/Default Printer Dialog.

.AUTHOR
Peter Kastberger

.DATE
2018-07-29
#>
param([String]$Printer="Send To OneNote 2016")


# forward declarations/functions
# Create Handler/Delegate
[System.Drawing.Printing.PrintPageEventHandler]$pd_printpage = {

    param(
        $sender, 
        [System.Drawing.Printing.PrintPageEventArgs]$ev
    )

    $font = New-Object System.Drawing.Font("Arial", 10)
    $ev.Graphics.DrawString(
        "Test of $Printer - $($pd.DocumentName)", 
        $font, 
        [System.Drawing.Brushes]::Black,
        $ev.MarginBounds.Left,
        $ev.MarginBounds.Top
        )
    
}


$timespan = Measure-Command -Expression {

    # Create a PrintDocument and Set it up
    $pd = New-Object System.Drawing.Printing.PrintDocument
    $pd.DocumentName = $($Printer + " Benchmark")
    $pd.PrinterSettings.PrinterName = $Printer

    # Add Handler/Delegate
    $pd.add_PrintPage($pd_printpage)
    $pd.Print()

}

$timespan | Select-Object Seconds, TotalMilliseconds, Ticks | Format-Table -AutoSize