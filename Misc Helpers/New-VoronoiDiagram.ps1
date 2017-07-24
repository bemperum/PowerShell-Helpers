<#
.SYNOPSIS
Draw a very simple Voronoi-diagram.

.DESCRIPTION
The program draws a Voronoi-diagram and saves a picture to a given location.

.PARAMETER Width
Width of the generated map.

.PARAMETER Height
Height of the generated map.

.PARAMETER NumberOfPoints
Number of Voronoi points on the map.

.PARAMETER OutputImage
Path to the output image (PNG).

#>

param(
    [Parameter(Mandatory=$true)]
    [int]$Width,

    [Parameter(Mandatory=$true)]
    [int]$Heigth,

    [Parameter(Mandatory=$true)]
    [int]$NumberOfPoints,
	
    [Parameter(Mandatory=$true)]
    [ValidateScript({Test-Path $_ -IsValid})]
    [string]$OutputImage
)

# 
Function Get-Distance2D()
{
    param(
        [Parameter(Mandatory=$true)]
        $PointA,

        [Parameter(Mandatory=$true)]
        $PointB
        )

    $delta_X = [Math]::Abs($PointA.X - $PointB.X)
    $delta_Y = [Math]::Abs($PointA.Y - $PointB.Y)

    $distance2D = [Math]::Sqrt($($delta_X * $delta_X) + ($delta_Y * $delta_Y))
    Return $distance2D
}

Function Check-VPoints()
{
    param(
        $currentPoint,
        $voronoiPoints
    )

    $currentResults = @()

    ForEach($point in $voronoiPoints){
        
        $distance = Get-Distance2D -PointA $currentPoint -PointB $point
        $currentResults += New-Object PSObject -property @{vPoint=$point; distance=$distance; point=$currentPoint}

    }
    
    $smallest = $currentResults | sort -Property distance | select -first 1
    return $smallest
}

# Load the .NET Libs
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Create a Bitmap-Object to draw on.
$bmp = New-Object Drawing.Bitmap($Width,$Heigth)

# Here is a list of sample points:
$points = @()
1..$NumberOfPoints | ForEach-Object {
    $r = Get-Random -Minimum 0 -Maximum 255
    $g = Get-Random -Minimum 0 -Maximum 255
    $b = Get-Random -Minimum 0 -Maximum 255

    $x = Get-Random -Minimum 0 -Maximum $Width
    $y = Get-Random -Minimum 0 -Maximum $Heigth

    $points += New-Object psobject -Property @{x = $x; y = $y; color=[Drawing.Color]::FromArgb(255, $r, $g, $b)}
}

$allPixels = @()

# Check each pixel vs. each v-point.
# Put the smallest distance into a new list containing the v-point (to geht the color) and the pixel itself.
For($i=0; $i -lt $Width; $i++){
    For($j=0; $j -lt $Heigth; $j++){
        $allPixels += Check-VPoints -currentPoint $(New-Object psobject -Property @{x = $i; y=$j}) -voronoiPoints $points
    }
}

# With the new list,
# we draw each pixel:
ForEach($drPoint in $allPixels){
    $drP = $drPoint.point
    $drColor = $drPoint.vPoint.color
    $bmp.SetPixel($drP.X, $drP.Y, $drColor)
}

# For Each Vpoint in our Picture, draw a BLACK dot (for ref).
$col = [System.Drawing.Color]::BLACK
ForEach($po in $points) { $bmp.SetPixel($po.X, $po.y,$col) }

# Save and Free the image.
$bmp.Save($OutputImage, ([system.drawing.imaging.imageformat]::Png))
$bmp.Dispose()