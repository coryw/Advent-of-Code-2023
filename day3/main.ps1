$DEBUG = 0
$file = Get-Content -Path "input.txt"
$allSymbols = "!@#$%^&*()--+=/"

$script:numbersToAdd = @()
$script:numberList = @()
$script:symbolList = @()
$script:asteriskList = @()

Function Output-Debug($text) {
    if ($DEBUG) {
        Write-Host $text -ForegroundColor darkyellow
    }
}

Function Get-Numbers {
    for ($i = 0; $i -lt $file.Length; $i++)
    {
        $numbers = ($file[$i] | Select-String -Pattern "\d+" -AllMatches).Matches
        foreach ($number in $numbers)
        {
            Output-Debug "Line $i : $($number.Value)"
            $number | Add-Member -Name LineNumber -Value $i -MemberType NoteProperty
            $number | Add-Member -Name FinalValue -Value $i -MemberType NoteProperty
            $number | Add-Member -Name Symbols -Value @() -MemberType NoteProperty
            $number | Add-Member -Name SymbolCoords -Value @() -MemberType NoteProperty
            $script:numberList += $number
        }
    }
    $script:numberList = $script:numberList | Sort-Object -Property LineNumber,Index
    Output-Debug ""
}

Function Get-Symbols
{
    for ($i = 0; $i -lt $file.Length; $i++)
    {
        $symbols = ($file[$i] | Select-String -Pattern "[$allSymbols]" -AllMatches).Matches
        foreach ($symbol in $symbols)
        {
            Output-Debug "Line $i : $($symbol.Value)"
            $symbol | Add-Member -Name LineNumber -Value $i -MemberType NoteProperty
            $symbol | Add-Member -Name Symbols -Value @() -MemberType NoteProperty
            $script:symbolList += $symbol
        }
    }
    $script:symbolList = $script:symbolList | Sort-Object -Property LineNumber,Index
    Output-Debug ""
}

Function Get-Matches {
    foreach ($number in $script:numberList | Sort-Object -Property LineNumber,Index)
    {
        $value = $number.Value
        $number.FinalValue = 0
        $index = $number.Index
        if ($file[$number.LineNumber][[Math]::Abs($index - 1)] -match "[$allSymbols]") 
        {
            if ($file[$number.LineNumber][[Math]::Abs($index - 1)] -match "\*") 
            {
               $number.Symbols += @{LineNumber = $number.LineNumber; Index = ($index - 1)}
               $number.SymbolCoords += @($number.LineNumber, ($index - 1), $value)
            }
            $number.FinalValue = $value 
        }
        if ($file[$number.LineNumber][$index + $number.Length] -match "[$allSymbols]") 
        {
            $number.FinalValue = $value
            if ($file[$number.LineNumber][$index + $number.Length] -match "\*") 
            {
                $number.Symbols += @{LineNumber = $number.LineNumber; Index = ($index + $number.Length)}
               $number.SymbolCoords += @($number.LineNumber, ($index + $number.Length), $value)
            }
        }
        for ($i = [Math]::Abs($number.Index - 1); $i -lt ($number.Index + $number.Length + 1); $i++)
        {
            if ($file[$number.LineNumber - 1][$i] -match "[$allSymbols]") 
            {
                $number.FinalValue = $value 
                if ($file[$number.LineNumber - 1][$i] -match "\*") 
                {
                    $number.Symbols += @{LineNumber = $number.LineNumber - 1; Index = $i}
                    $number.SymbolCoords += @(($number.LineNumber - 1), $i, $value)
                }
            }
            if ($number.LineNumber + 1 -le 139) {
                if ($file[$number.LineNumber + 1][$i] -match "[$allSymbols]") 
                {
                    $number.FinalValue = $value 
                    if ($file[$number.LineNumber + 1][$i] -match "[$allSymbols]") 
                    {
                        $number.Symbols += @{LineNumber = $number.LineNumber + 1; Index = $i}
                        $number.SymbolCoords += @(($number.LineNumber + 1), $i, $value)
                    }
                }
            }
        }
        #$symbols = ($file[$i] | Select-String -Pattern "[$allSymbols]" -AllMatches).Matches
        if ($number.FinalValue -ne 0)
        {
            #echo "+ $($number.Value) is valid on line $($number.LineNumber)"
            #echo $number
        }
        if ($number.FinalValue -eq 0)
        {
            Output-Debug "- $($number.Value) is NOT valid on line $($number.LineNumber)"
            Output-Debug $number
        }
    }
}

Function Get-Cogs {
    $numbers = @()
    foreach ($symbol in $script:symbolList)
    {
        $lineNumber = $symbol.LineNumber
        $index = $symbol.Index
    }
}

Get-Numbers
Get-Matches

foreach ($number in $script:numberList)
{
    echo $number.SymbolCoords
    foreach ($symbol in $number.SymbolCoords)
    {
        echo $symbol
    }
    echo ""
}

$potentialGears = $script:numberList | Where { $_.SymbolCoords[0] -gt 0 -and 1 -ne $null }
echo ($potentialGears | Select SymbolCoords)
#| Select SymbolCoords #| Sort-Object -Property 1,2,3

foreach ($element in $potentialGears)
{
    $script:asteriskList += @{LineNumber = $element.SymbolCoords[0]; Index = $element.SymbolCoords[1]; Number = $element.SymbolCoords[2]}
}

$asteriskFinds = $script:asteriskList | Sort-Object -Property LineNumber, Index, Number

$line = $asteriskFinds[0].LineNumber
$index = $asteriskFinds[0].Index
$number = $asteriskFinds[0].Number
$matchCount = 1
$numbersToMultiply = @($asteriskFinds[0].Number)
$product = [int]$asteriskFinds[0].Number
$grandProduct = 0

for ($i = 1; $i -lt $asteriskFinds.Length; $i++)
{
    #echo "Line: $line  |  Index: $index  |  Number: $number  |  Matches: $matchCount  |  Product: $product"
    if ($asteriskFinds[$i].LineNumber -eq $line -and $asteriskFinds[$i].Index -eq $index) 
    {
        $matchCount += 1
        $numbersToMultiply += $asteriskFinds[$i].Number
        $product *= [int]$asteriskFinds[$i].Number
        $grandProduct += $product
        echo "Line $line : $number and $($asteriskFinds[$i].Number)"
        #echo "Line: $($asteriskFinds[$i].LineNumber)  |  Index: $($asteriskFinds[$i].Index)  |  Number: $number  |  Matches: $matchCount  |  Product: $product"
    } 
    else
    {
            #echo "Matches: $matches  |  Product: $product |  Numbers: $numbersToMultiply"
            $numbersToMultiply= @()
            $matchCount = 1
            $product = [int]$asteriskFinds[$i].Number
            #echo " - Matches: 1  |  Product: 1"
    }
    $line = $asteriskFinds[$i].LineNumber
    $index = $asteriskFinds[$i].Index
    $number = $asteriskFinds[$i].Number
}

foreach ($find in $asteriskFinds)
{
    
}

Output-Debug "Number Count: $($script:numbersToAdd)"
Output-Debug "Final Answer: $($script:numbersToAdd | Measure-Object -Property Value -sum)"
Output-Debug $script:numbersToAdd | Measure-Object -Property Value -sum

$finalTotal = ($script:numberList | Measure-Object -Property FinalValue -sum).Sum

echo "Grand total: $finalTotal"
echo "Grand gear total: $grandProduct"

$symbolMatrix = (Select-String -Path "input.txt" -Pattern "[$allSymbols]" -AllMatches).Matches
$output = ($file | Select-String -Pattern "[$allSymbols]" -AllMatches)

