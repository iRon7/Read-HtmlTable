<#PSScriptInfo
.VERSION 1.0.0
.GUID 6ddb4b24-29bc-4268-a62f-402b3ee28e3d
.AUTHOR iRon
.DESCRIPTION Reads a HTML table from a string or the internet location
.COMPANYNAME
.COPYRIGHT
.TAGS Join-Object Join InnerJoin LeftJoin RightJoin FullJoin CrossJoin Update Merge Combine Table
.LICENSE https://github.com/iRon7/Read-HtmlTable/LICENSE
.PROJECTURI https://github.com/iRon7/Read-HtmlTable
.ICON
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

Function Read-HtmlTable {
    [CmdletBinding(DefaultParameterSetName = 'Html')][OutputType([Object[]])] param(
        [Parameter(ParameterSetName='HtmlSet', ValueFromPipeLine = $True, Mandatory = $True)][String]$Html,
        [Parameter(ParameterSetName='UriSet',  ValueFromPipeLine = $True, Mandatory = $True)][Uri]$Uri,
        [Int[]]$TableIndex,
        [Int]$RowIndex
    )
    Begin {
        function Get-TopElements {
            [CmdletBinding()][OutputType([__ComObject[]])] param(
                [Parameter(Mandatory = $True)][String]$TagName,
                [Parameter(Mandatory = $True, ValueFromPipeLine = $True)]$Element
            )
            if ($Element.tagName -eq $TagName) { $Element }
            else { $Element.Children | Foreach-Object { $_ | Get-TopElements $TagName } } 
        }
    }
    Process {
        if (!$Uri -and $Html.Length -le 2048 -and ([Uri]$Html).AbsoluteUri) { $Uri = [Uri]$Html }
        if ($Uri.AbsoluteUri) { $Html = [System.Net.Webclient]::New().DownloadString($Uri) }
        $Unicode = [System.Text.Encoding]::Unicode.GetBytes($Html)
        $Document = New-Object -Com 'HTMLFile'
        if ($Document.IHTMLDocument2_Write) { $Document.IHTMLDocument2_Write($Unicode) } else { $Document.write($Unicode) }
        $Index = 0 
        foreach($Table in ($Document.Body | Get-TopElements 'table')) {
            if (!$PSBoundParameters.ContainsKey('TableIndex') -or $Index++ -In $TableIndex) {
                $Names = $Null
                $THead = $Table | Get-TopElements 'thead'
                $TBody = $Table | Get-TopElements 'tbody'
                $TableHead = if ($THead) { $THead } else { $Table }
                $TableBody = if ($TBody) { $TBody } else { $Table }
                $HeaderRows = $TableHead | Get-TopElements 'tr'
                if ($PSBoundParameters.ContainsKey('RowLocation')) { $Rows[$RowIndex] }
                else {
                    foreach ($HeaderRow in $HeaderRows) { 
                        $TH = $HeaderRow | Get-TopElements 'th'
                        if (!$Names -or $TH -and $TH.Count -gt $Names.Count) { $Names = @($TH.innerText) }
                        elseif ($Names -and $TH) {break }
                        if (!$TH -or !$Names -or $Names[0].TagName -ne 'th') {
                            $TD = $HeaderRow | Get-TopElements 'td'
                            if (!$Names -or $TD -and $TD.Count -gt $Names.Count) {$Names = @($TD.innerText) }
                            elseif ($Names -and $TD) { break }
                        }
                    }
                }
                foreach ($TableRow in ($TableBody | Get-TopElements 'tr')) {
                    if ($THead -or $TBody -or $TableRow.rowIndex -ge $HeaderRow.RowIndex) {
                        $Values = @(($TableRow | Get-TopElements 'td').innerText)
                        $Properties = [Ordered]@{}
                        $Count = [Math]::Min($Names.Count, $Values.Count)
                        for ($i = 0; $i -lt $Count; $i++) { $Properties[$Names[$i]] = $Values[$i] }
                        if ($Properties.Count -gt 0) { [pscustomobject]$Properties }
                    }
                }
            }
        }
    }
}
