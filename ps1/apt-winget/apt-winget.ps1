function Get-WinGetList {
    $listResult = &winget list

    # only output those lines ending on "winget" (most likely installed via winget?!)
    foreach ($line in $listResult) {
        if ($line.EndsWith('winget')) {
            $line
        }
    }
}

function Get-WinGetResultDelimiterArrayNumber($wingetResult) {
    $counter = 0
    foreach ($line in $searchResult) {
        if ($line.StartsWith('----------')) {
            return $counter
        }
        $counter++
    }
    a
    # if not found it's most likely there is no result or an error
    return -1
}

function Get-WingetHeaderPositionArray($wingetHeader) {
    $counter = 0
    foreach ($char in $wingetHeader.ToCharArray()) {
        if ($char -cmatch "^[A-Z]*$") {
            $counter
        }
        $counter++
    }
}

function Get-WinGetResultLineSplitObject($line, $headerArray, $headerPositionArray) {
    $arrayElement = 0
    $resultHashTable = @{}
    foreach ($header in $headerArray) {
        $startPosition = $headerPositionArray[$arrayElement]

        if ($headerArray[-1] -eq $header) {
            $endPosition = $line.Length
        }
        else {
            $endPosition = $headerPositionArray[$arrayElement + 1] - 1
        }
        $length = $endPosition - $startPosition

        $text = $line.Substring($startPosition, $length).Trim()

        $arrayElement++

        $resultHashTable.Add($header, $text)
    }

    New-Object psobject -Property $resultHashTable
}

function Get-WinGetResultObject($wingetResult) {
    $delimiterArrayNumber = Get-WinGetResultDelimiterArrayNumber -wingetResult $wingetResult
    if ($delimiterArrayNumber -gt 0) {
        $wingetHeader = $wingetResult[$delimiterArrayNumber - 1]
        $wingetHeaderPositionArray = Get-WingetHeaderPositionArray -wingetHeader $wingetHeader
        $wingetHeaderArray = $wingetHeader.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)

        $counter = 0
        foreach ($line in $wingetResult) {
            if (($counter -gt $delimiterArrayNumber) -and (-not([String]::IsNullOrEmpty($line.Trim())))) {
                Get-WinGetResultLineSplitObject -line $line -headerArray $wingetHeaderArray -headerPositionArray $wingetHeaderPositionArray
            }
            $counter++
        }
    }
}

function Invoke-WinGetQuery($searchString, $autoInstallIfOnlyOneFound = $false) {
    $searchResult = &winget search $searchString

    # cast the result explicitly to array - else one result would not count as 1 ?!
    $wingetResultObject = @(Get-WinGetResultObject -wingetResult $searchResult)

    if (($wingetResultObject.Count -eq 1) -and ($autoInstallIfOnlyOneFound -eq $true)) {
        Install-WinGetPackage -Id $wingetResultObject.Id
    }
    else {
        # show prompt and ask if any should be installed
        $counter = 1

        $wingetResultObjectLength = $wingetResultObject.Count.ToString().Length
        $selectionArray = foreach ($wingetObject in $wingetResultObject) {
            if ($wingetObject.Source -eq 'winget') {
                $counterLength = $counter.ToString().Length
                $padding = ''
                $paddingCount = $wingetResultObjectLength - $counterLength
                for ($i = 0; $i -lt $paddingCount; $i++) {
                    $padding = '{0} ' -f $padding
                }
                $string = '{0}[{1}] :: {2} - ({3})' -f $padding, $counter, $wingetObject.Name, $wingetObject.Id
                Write-Host $string
                [pscustomobject]@{
                    $counter = $wingetObject.Id
                }
                $counter++
            }
        }

        try {
            [uint16]$userinput = Read-Host -Prompt 'enter number to install package (ENTER to exit)'

            if (($userinput -lt $counter) -and ($userinput -ge 1)) {
                Install-WinGetPackage -Id $selectionArray.$userinput
            } else {
                if($userinput -ne 0) {
                    Write-Error 'wrong input'
                }
            }
        }
        catch {
            Write-Error 'only numbers allowed'
        }
    }
}

function Install-WinGetPackage($Id) {
    Write-Host "installing $Id"
    &winget install $Id
}

function Invoke-WinGet {
    [Alias("apt")]
    PARAM () # empty PARAM is needed to make alias work and still make use of args

    if ($args.Length -gt 0) {
        $command, $paramterArray = $args

        switch -regex ($command) {
            "list" {
                Get-WinGetList
            }
            "^(search|install)$" {
                $autoinstall = $false
                if ($command -eq 'install') {
                    $autoinstall = $true
                }

                foreach ($parameter in $paramterArray) {
                    Invoke-WinGetQuery -searchString $parameter -autoInstallIfOnlyOneFound $autoinstall
                }
            }
            default {
                Write-Error "command ""$command"" not valid"
            }
        }
    } else {
        Write-Error 'command (and parameter) missing'
    }
}
