$DEBUG = 1
$red = 12
$green = 13
$blue = 14
$colors  = @('red', 'green', 'blue')
$file = Get-Content -Path "input.txt"

$sum = 0
$powerSum = 0

Function Output-Debug($text) {
    if ($DEBUG) {
        Write-Host $text -ForegroundColor darkyellow
    }
}

for ($i = 0; $i -lt $file.Length; $i++)
{
    Output-Debug $file[$i]
    $power = 1
    $gameIdToAdd = $i + 1
    foreach ($color in $colors)
    {
        $colorMax = (Get-Variable $color).Value
        $numbers = $file[$i] 
            | Select-String -AllMatches -Pattern "\d+(?= $color)" 
            | Select-Object -ExpandProperty Matches
            | ForEach-Object { [int]$_.Value }
        $maxBlocks = $numbers[0]
        Output-Debug "$color : $numbers"
        foreach ($number in $numbers)
        {
            if ($number -gt $colorMax)
            {
                $gameIdToAdd = 0
            }
            if ($number -gt $maxBlocks)
            {
                $maxBlocks = $number
            }
        }
        Output-Debug "max $color : $maxBlocks $($maxBlocks -gt $colorMax ? '(INVALID)' : '')"
        $power *= $maxBlocks
    }
    Output-Debug "Valid game: $($gameIdToAdd -gt 0)"
    Output-Debug "Game $($i + 1) power: $power"
    $sum += $gameIdToAdd
    $powerSum += $power
    Output-Debug "Game ID sum: $sum"
    Output-Debug "Power sum: $powerSum"
    Output-Debug
}

echo "Final sum: $sum"
echo "Final power sum: $powerSum"
