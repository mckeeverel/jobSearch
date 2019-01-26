cls

$csv = Import-Csv C:\users\amica\OneDrive\Documents\movingMap.csv

$n = 0 

$ie = New-Object -ComObject InternetExplorer.Application
$ie.visible = $true

$BackgroundTab = 0x1000

foreach($line in $csv){
$url = $line.url
$company = $line.Company

    if($n -lt 0){
        "skip $company"
        $n++
    }

    elseif($url){
        if($n % 5){
            $ie.Navigate2($url, $BackgroundTab)
            $n++
        }
        else{
            read-host "continue"
            $ie.Navigate2($url, $BackgroundTab)
            $n++
        }
    }
    else{
        Write-Host "no url $company"
    }

}