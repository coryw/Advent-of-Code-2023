$DEBUG = 0
$file = Get-Content -Path "input.txt"
$allSymbols = "!@#$%^&*()--+=/"

$script:numbersToAdd = @()
$script:numberList = @()
$script:symbolList = @()

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
            $script:numberList += $number
        }
    }
    $script:numberList = $script:numberList | Sort-Object -Property LineNumber,Index
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
            $number.FinalValue = $value 
        }
        if ($file[$number.LineNumber][$index + $number.Length] -match "[$allSymbols]") 
        {
            $number.FinalValue = $value
        }
        for ($i = [Math]::Abs($number.Index - 1); $i -lt ($number.Index + $number.Length + 1); $i++)
        {
            if ($file[$number.LineNumber - 1][$i] -match "[$allSymbols]") 
            {
               $number.FinalValue = $value 
            }
            if ($number.LineNumber + 1 -le 139) {
                if ($file[$number.LineNumber + 1][$i] -match "[$allSymbols]") 
                {
                    $number.FinalValue = $value 
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

Get-Numbers
Get-Matches

Output-Debug "Number Count: $($script:numbersToAdd)"
Output-Debug "Final Answer: $($script:numbersToAdd | Measure-Object -Property Value -sum)"
Output-Debug $script:numbersToAdd | Measure-Object -Property Value -sum

$finalTotal = ($script:numberList | Measure-Object -Property FinalValue -sum).Sum

echo "Grand total: $finalTotal"

$symbolMatrix = (Select-String -Path "input.txt" -Pattern "[$allSymbols]" -AllMatches).Matches
$output = ($file | Select-String -Pattern "[$allSymbols]" -AllMatches)

