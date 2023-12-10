$DEBUG = 1
$file = Get-Content -Path "input.txt"
$allSymbols = "!@#$%^&*()--+="
$numbersToAdd = @()
$numberList = @()
$symbolList = @()

Function Output-Debug($text) {
    if ($DEBUG) {
        Write-Host $text -ForegroundColor darkyellow
    }
}

Function Get-NumberMatches($symbol) {
    $lineNumber = $symbol.LineNumber
    $index = $symbol.Index
    Output-Debug "* Get-NumberMatches $($symbol.Value)"
    if ($file[$lineNumber][[Math]::Abs($index - 1)] -match "\d")
    {
        $result = $numberList 
            | Where-Object { $_.LineNumber -eq $lineNumber -and $_.Index -eq ($index - $_.Length) }
        $numbersToAdd += @($lineNumber, $result.Index)
        Output-Debug "Found left $($result.Value)$($symbol.Value)"
        Output-Debug "$numbersToAdd"
    }
    if ($file[$lineNumber][$index + 1] -match "\d")
    {
        $result = $numberList 
            | Where-Object { $_.LineNumber -eq $lineNumber -and $_.Index -eq ($index + 1) }
        $numbersToAdd += @($result)
        Output-Debug "Found right $($symbol.Value)$($result.Value)"
    }
    if (($file[[Math]::Abs($lineNumber - 1)][$index] -match "\d") -Or
        ($file[[Math]::Abs($lineNumber - 1)][[Math]::Abs($index - 1)] -match "\d") -Or
        ($file[[Math]::Abs($lineNumber - 1)][$index + 1] -match "\d"))
    {
        $result = $numberList | Where-Object {
                $_.LineNumber -eq ($lineNumber - 1) -and $index -ge ($_.Index - 1) -and $index -le ($_.Index + $_.Length + 1)
            }
        $numbersToAdd += @($result)
        Output-Debug "Found top $($result.Value)/$($symbol.Value)"
    }
    if (($file[$lineNumber + 1][$index] -match "\d") -Or
        ($file[$lineNumber + 1][[Math]::Abs($index - 1)] -match "\d") -Or
        ($file[$lineNumber + 1][$index + 1] -match "\d"))
    {
        $result = $numberList | Where-Object {
                $_.LineNumber -eq ($lineNumber + 1) -and $index -ge ($_.Index - 1) -and $index -le ($_.Index + $_.Length + 1)
            }
        $numbersToAdd += @($result)
        Output-Debug "Found bottom $($symbol.Value)/$($result.Value)"
    }
    Output-Debug ""
}

for ($i = 0; $i -lt $file.Length; $i++)
{
    $numbers = ($file[$i] | Select-String -Pattern "\d+" -AllMatches).Matches
    $symbols = ($file[$i] | Select-String -Pattern "[$allSymbols]" -AllMatches).Matches
    foreach ($number in $numbers)
    {
        Output-Debug "Line $i : $($number.Value)"
        $number | Add-Member -Name LineNumber -Value $i -MemberType NoteProperty
        $numberList += $number
    }
    foreach ($symbol in $symbols)
    {
        Output-Debug "Line $i : $($symbol.Value)"
        $symbol | Add-Member -Name LineNumber -Value $i -MemberType NoteProperty
        $symbolList += $symbol
    }
    Output-Debug ""
}

foreach ($symbol in $symbolList)
{
    Get-NumberMatches $symbol
}

Output-Debug "Number Count: $($numbersToAdd)"

$symbolMatrix = (Select-String -Path "input.txt" -Pattern "[$allSymbols]" -AllMatches).Matches
$output = ($file | Select-String -Pattern "[$allSymbols]" -AllMatches)

