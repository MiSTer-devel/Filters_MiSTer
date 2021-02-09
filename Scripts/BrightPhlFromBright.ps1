$sharpFilters = @()
$sharpFilters += Get-ChildItem '..\Filters\Scanlines (Bright)' -Filter '*_Sharp.txt' -Recurse

$softFilters = @()
$softFilters += Get-ChildItem '..\Filters\Scanlines (Bright)' -Filter '*_Soft.txt' -Recurse

$allFilters = $sharpFilters + $softFilters

$numCoeffs = 16
$maxValue = 128
$halfValue = 64

# Point where we will patch in our new curve
# Roughly the x-coordinate in the existing filters graphs, where the point has the highest slope
# Tested with results and made adjustments (increased x-coordinates) to avoid new curves leveling off too fast (avoided repeating values)
# Adjusted rows were in the 80..90 scanline pct range
# Alternative method would be to search through the points at runtime instead
# One-based index
$ptArr = @(
#     110 115 120 125 130 brightness
    @(  4,  4,  4,  4,  4), # 10 scanline pct
    @(  4,  4,  4,  4,  4), # 20
    @(  5,  5,  5,  5,  5), # 30
    @(  5,  5,  5,  5,  5), # 40
    @(  5,  5,  5,  5,  5), # 50
    @(  6,  6,  6,  6,  6), # 60
    @(  7,  7,  7,  7,  7), # 65
    @(  7,  7,  7,  7,  7), # 70
    @(  8,  8,  8,  8,  8), # 75
    @(  8,  8,  8,  9, 10), # 80
    @(  8,  8,  9, 10, 10), # 85
    @(  8, 10, 10, 10, 10)  # 90
)

# Boost slope a bit to avoid dropping brightness too much compared to the existing filters
# Tested with results and made adjustments (decreased modifier) to avoid new curves leveling off too fast (avoided repeating values)
# Adjusted rows were in the 75..90 scanline pct range
$modArr = @(
#      110  115  120  125  130 brightness
    @( 1.2, 1.2, 1.2, 1.2, 1.2), # 10 scanline pct
    @( 1.2, 1.2, 1.2, 1.2, 1.2), # 20
    @( 1.2, 1.2, 1.2, 1.2, 1.2), # 30
    @( 1.2, 1.2, 1.2, 1.2, 1.2), # 40
    @( 1.2, 1.2, 1.2, 1.2, 1.2), # 50
    @( 1.2, 1.2, 1.2, 1.2, 1.2), # 60
    @( 1.2, 1.2, 1.2, 1.2, 1.2), # 65
    @( 1.2, 1.2, 1.2, 1.2, 1.2), # 70
    @( 1.2, 1.2, 1.2, 1.1, 1.0), # 75
    @( 1.2, 1.1, 1.0, 1.0, 1.0), # 80
    @( 1.1, 1.0, 1.0, 1.0, 1.0), # 85
    @( 1.0, 1.0, 1.0, 1.0, 1.0)  # 90
)

$allFilters | ForEach-Object {
    $filterItem = $_

    # Read the coeffs
    $contents = @()
    $coeffs = @()
    $index = 0
    $inVertical = $false
    Get-Content $filterItem.FullName | ForEach-Object {
       if ($inVertical) {
           if ($index -lt $numCoeffs) {
               $index++

               $c0 = [int]($_ -Replace '^([ 0-9]+),([ 0-9]+),([ 0-9]+),([ 0-9]+)', '$1')
               $c1 = [int]($_ -Replace '^([ 0-9]+),([ 0-9]+),([ 0-9]+),([ 0-9]+)', '$2')
               $c2 = [int]($_ -Replace '^([ 0-9]+),([ 0-9]+),([ 0-9]+),([ 0-9]+)', '$3')
               $c3 = [int]($_ -Replace '^([ 0-9]+),([ 0-9]+),([ 0-9]+),([ 0-9]+)', '$4')

               $item = New-Object -TypeName PSObject -Property @{ c0 = $c0; c1 = $c1; c2 = $c2; c3 = $c3 }
               $coeffs += $item
           }
       }
       else {
           $contents += $_
       }

       if ($_ -eq '# Vertical Coefficients') {
           $inVertical = $true
       }
    }

    # Parse brightness and scanline pct from filename
    $brightness = [int]($filterItem.BaseName -Replace '^SL_Br_([0-9]+)_([0-9]+)_.*$', '$1')
    $scanlinePct = [int]($filterItem.BaseName -Replace '^SL_Br_([0-9]+)_([0-9]+)_.*$', '$2')

    # Index into $ptArr / $modArr
    $arrX = switch ($brightness) {
        110 { 0 }
        115 { 1 }
        120 { 2 }
        125 { 3 }
        130 { 4 }
    }

    # Index into $ptArr / $modArr
    $arrY = switch ($scanlinePct) {
        10 {  0 }
        20 {  1 }
        30 {  2 }
        40 {  3 }
        50 {  4 }
        60 {  5 }
        65 {  6 }
        70 {  7 }
        75 {  8 }
        80 {  9 }
        85 { 10 }
        90 { 11 }
    }

    $currentPoint = $ptArr[$arrY][$arrX]
    $modifier = $modArr[$arrY][$arrX]

    $slope = $coeffs[$currentPoint - 1].c1 - $coeffs[$currentPoint].c1
    $midpoint = $coeffs[$currentPoint - 1].c1

    # Modify slope
    $slope = $slope * $modifier

    # Use a logistic function to level off the curve so it does not clip
    # f(x) = L / (1 + e^(-k(x-x0)))
    # where
    # x0, the x value of the sigmoid's midpoint
    # L, the curve's maximum value
    # k, the logistic growth rate or steepness of the curve

    # Calculate k for the slope at the midpoint of the existing curve
    $k = 0 - [Math]::Log(1 / ((1 / (0.5 + ($slope / $maxValue))) - 1))

    # Calculate x0 for the midpoint of the existing curve
    $x0 = 0 - ([Math]::Log(1 / ((1 / ($midpoint / $maxValue)) - 1)) / $k)

    # Calculate the curve
    $ySet = @()
    for ($x = 1 - $currentPoint; $x -le 0; $x++) {
        $y = 1 / (1 + [Math]::Exp(-$k * ($x - $x0)))
        $ySet += $y
    }

    # Scale the curve
    $firstY = $ySet[0]
    $lastY = $ySet[$ySet.Count - 1]
    $scaledYSet = @()
    $ySet | ForEach-Object {
        $scaledY = [Math]::Round(((((1 - $lastY) * ($_ - $lastY)) / ($firstY - $lastY)) + $lastY) * $maxValue)
        $scaledYSet += $scaledY
    }

    # Get existing curve
    $arrC0 = @()
    $arrC1 = @()
    $arrC2 = @()
    $arrC3 = @()
    for ($i = 0; $i -lt $numCoeffs; $i++) {
        $arrC0 += $coeffs[$i].c0
        $arrC1 += $coeffs[$i].c1
        $arrC2 += $coeffs[$i].c2
        $arrC3 += $coeffs[$i].c3
    }

    # Patch in new curve
    # Replace one less coeff in c2 than c1
    # c0/c1 go higher one coeff, and c2/c3 go lower one coeff
    # c2/c3 are opposite direction (low to high)
    $count = $scaledYSet.Count
    for ($i = 0; $i -lt $count; $i++) {
        $arrC1[$i] = $scaledYSet[$i] - $arrC0[$i]
    }

    for ($i = 1; $i -lt $count; $i++) {
        $arrC2[($numCoeffs - 1) - ($i - 1)] = $scaledYSet[$i] - $arrC3[($numCoeffs - 1) - ($i - 1)]
    }

    $outputName = $filterItem.Name -Replace '^SL_Br_(.*)$','SL_Br_PHL_$1'
    $dirName = [System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($filterItem.FullName))
    $outputFullName = "..\Filters\Scanlines (Bright PHL)\$dirName\$outputName"

    if (Test-Path $outputFullName) {
        Remove-Item $outputFullName
    }

    # Output
    # Contents before Vertical Coefficients
    $contents | ForEach-Object {
        if ($_ -Match "^# $($filterItem.Name)") {
            # Patch in new filename
            "# $outputName" | Out-File $outputFullName -Append -Encoding ascii
        }
        else {
            $_ | Out-File $outputFullName -Append -Encoding ascii
        }
    }

    # Vertical Coefficients
    for ($i = 0; $i -lt $numCoeffs; $i++) {
        ("{0,4},{1,4},{2,4},{3,4}" -f $arrC0[$i], $arrC1[$i], $arrC2[$i], $arrC3[$i]) | Out-File $outputFullName -Append -Encoding ascii
    }

    # Existing files have an extra newline at the end
    "" | Out-File $outputFullName -Append -Encoding ascii
}
