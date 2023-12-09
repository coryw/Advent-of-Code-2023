$DEBUG = 1
$red = 12
$green = 13
$blue = 14
$colors  = @('red', 'green', 'blue')
$file = Get-Content -Path "input.txt"

$sum = 0

Function Output-Debug($text) {
    if ($DEBUG) {
        Write-Host $text -ForegroundColor darkyellow
    }
}

for ($i = 0; $i -lt $file.Length; $i++)
{
    $gameIdToAdd = $i + 1
    foreach ($color in $colors)
    {
        $colorMax = (Get-Variable $color).Value
        $numbers = $file[$i] 
            | Select-String -AllMatches -Pattern "\d+(?= $color)" 
            | Select-Object -ExpandProperty Matches
            | ForEach-Object { [int]$_.Value }
        foreach ($number in $numbers)
        {
            if ($number -gt $colorMax)
            {
                $gameIdToAdd = 0
            }
        }
    }
    $sum += $gameIdToAdd
}

echo "Final sum: $sum"

