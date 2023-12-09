$sum = 0
$num = ""

foreach ($line in Get-Content -Path "input.txt")
{
    $digits = $line -Replace "[A-Za-z]", ""
    $num = $digits[0] + $digits[$digits.Length - 1]
    $sum = $sum + $num
}

echo "Step 1 Final Sum:" $sum

# Part two

$sum = 0

foreach ($line in Get-Content -Path "input.txt")
{
    $digits = $line
    $digits = $digits -Replace "one", "o1ne"
    $digits = $digits -Replace "two", "t2wo"
    $digits = $digits -Replace "three", "t3hree"
    $digits = $digits -Replace "four", "f4our"
    $digits = $digits -Replace "five", "f5ive"
    $digits = $digits -Replace "six", "s6ix"
    $digits = $digits -Replace "seven", "s7even"
    $digits = $digits -Replace "eight", "e8ight"
    $digits = $digits -Replace "nine", "n9ine"
    $digits = $digits -Replace "[A-Za-z]", ""
    $num = $digits[0] + $digits[$digits.Length - 1]
    $sum = $sum + $num
}

echo "Step 2 Final Sum:" $sum
