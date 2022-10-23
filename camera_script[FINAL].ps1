[bool] $debug = $false
$FileType = "*.mp4";
$typeFile = ".mp4"
$Length = @()
$DeleteList = @()
$Folder = "$env:USERPROFILE\Documents\powershell_shit"
$dividerLine = "---------------------------------------------------------"
$logDate = Get-Date -Format "dddd_MM-dd-yyyy_hh-mm-ss"
$Length += $dividerLine
$Length += $($logdate)
$logFileLocation = 'C:\cam_logs'
$timeLen = "00:00:40"
$daysNpast = -30
$day_30DaysInPast = (Get-Date).AddDays($daysNpast)
$mp4 = Get-ChildItem -Path $Folder -Force `
    | Where-Object {
        if ($_ -isnot [System.IO.DirectoryInfo])
        {
            foreach ($pattern in $FileType)
            {
                if ($_.Name -like $pattern)
                {
                    return $true;
                }
            }
        }
        return $false;
    }

if($mp4){
    foreach ($file in Get-ChildItem $Folder) {
        $Name = $file.Name
        $objShell = New-Object -ComObject Shell.Application
        $objFolder = $objShell.Namespace($Folder)
        $objFile = $objFolder.ParseName($Name)
        if($objFolder.GetDetailsOf($objFile, 164) -eq $typeFile){
            $LengthNum = 27
            $typeNum = 164
            $Len = $objFolder.GetDetailsOf($objFile, $LengthNum)
            $fileExtension = $objFolder.GetDetailsOf($objFile, $typeNum)
            $path = $Folder + '\' + $Name
            $FileDate = (Get-ChildItem $path).CreationTime
            if($Len -lt $timeLen -or ($FileDate -lt $day_30DaysInPast)){
                $Object = New-Object System.Object
                $Object | Add-Member -type NoteProperty -Name FileName -Value $Name
                $DeleteList += $Name
                $Object | Add-Member -type NoteProperty -Name Length -Value $len
                $Object | Add-Member -type NoteProperty -Name FileType -Value $fileExtension
                $Object | Add-Member -type NoteProperty -Name Age -Value $FileDate
                $Length += $Object
            } 
        }
    }

    $Length | Out-File -FilePath $logFileLocation\"log_$logDate.txt" -append
    if($debug){
        Write-Output $day_30DaysInPast
        Write-Host `r`n$logDate`r`n
        Write-Output $Length
        Write-Output "--------------`n--DeleteList--`n--------------"
        Write-Output $DeleteList
        Write-Output "--------------`n--OtherData--`n--------------"
    }

    foreach($node in $DeleteList){
        $path = $Folder + "\" + $node
        Remove-Item -path $path -Force
    }
} 
else{
write-Host "there are no mp4 files in this directory`r`n"
}