Function Read-HtmlTable {
    [CmdletBinding()][OutputType([Object[]])] param(
        [Parameter(ValueFromPipeLine = $True, Mandatory = $True)][String]$Html,
        [Int[]]$TableIndex
    )
    Begin {
        Function Get-Elements { # Get closed descendants by tag name
            [CmdletBinding()][OutputType([__ComObject[]])] param(
                [Parameter(Mandatory = $True)][String]$TagName,
                [Parameter(Mandatory = $True, ValueFromPipeLine = $True)]$Element
            )
            if ($Element.tagName -eq $TagName) { $Element }
            else { $Element.Children | Foreach-Object { $_ | Get-Elements $TagName } } 
        }
    }
    Process {
        $Unicode = [System.Text.Encoding]::Unicode.GetBytes($Html)
        $Document = New-Object -Com 'HTMLFile'
        if ($Document.IHTMLDocument2_Write) { $Document.IHTMLDocument2_Write($Unicode) } else { $Document.write($Unicode) }
        $Index = 0 
        foreach($table in ($Document.Body | Get-Elements 'table')) {
            if (!$PSBoundParameters.ContainsKey('TableIndex') -or $Index++ -In $TableIndex) {
                $Names = $Null
                foreach ($tr in ($table | Get-Elements 'tr')) {
                    if ($Null -eq $Names) { $Names = ($tr | Get-Elements 'th').innerText }
                    else {
                        $Values = ($tr | Get-Elements 'td').innerText
                        $Properties = [Ordered]@{}
                        $Count = [Math]::Min($Names.Count, $Values.Count)
                        for ($i = 0; $i -lt $Count; $i++) { $Properties[$Names[$i]] = $Values[$i] }
                        if ($Properties.Count -gt 0) { [pscustomobject]$Properties }
                    }
                    if ($Null -eq $Names) { $Names = ($tr | Get-Elements 'td').innerText }
                }
            }
        }
    }
}
