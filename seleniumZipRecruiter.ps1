Add-Type -Path "C:\automation\Selenium.WebDriverBackedSelenium.3.14.0\lib\net45\Selenium.WebDriverBackedSelenium.dll"
Add-Type -Path "C:\automation\Selenium.WebDriver.3.14.0\lib\net45\WebDriver.dll"
Add-Type -Path "C:\automation\Selenium.Support.3.14.0\lib\net45\WebDriver.Support.dll"

cls
Clear-Content -Path "E:\test\jobs.html"

$urls = @()
$csv = Import-Csv -Path "C:\users\amica\onedrive\documents\movingMap.csv"

foreach($line in $csv){
    if($line.url -like "*ziprecruiter*"){
        $urls += $line.url
    }
}

foreach($url in $urls){

    write-host "$url" -ForegroundColor Yellow
    Add-Content -Value "<b>$url</b><br>" -Path "E:\test\jobs.html"

    $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
    $driver.Navigate().gotoURL($url)
    Start-Sleep -Seconds 5

    $driver.Navigate().refresh()

    Start-Sleep -Seconds 2

    $loadJobsButton = $driver.FindElementByClassName("load_more_jobs")
    
    if($loadJobsButton){
        $loadJobsButton.click()
    
        Start-Sleep -Seconds 2

        do{
            $articles = $driver.FindElementsByTagName("article")
            $initCount = $articles.Count
            $lastArticle = $articles | select -Last 1 
            $driver.ExecuteScript("arguments[0].scrollIntoView(true)",$lastArticle)
            Start-Sleep -Seconds 5
            $articles = $driver.FindElementsByTagName("article")
            $loadedCount = $articles.Count
        }while($initCount -ne $loadedCount)
    }

    foreach($article in $articles){
        $jobTitle = $article.FindElementsByTagName("h2") | select Text -ExpandProperty Text
        $jobOrg = $article.FindElementsByClassName("job_org") | select Text -ExpandProperty Text
        $jobLink = $article.FindElementsByTagName("a")[0]
        $link = $jobLink.GetAttribute("href")
        Add-Content -Value "<a href=$link>$jobTitle</a> $jobOrg <br>" -Path "E:\test\jobs.html"
        Start-Sleep -Milliseconds 100
    }

    $driver.Quit()
}