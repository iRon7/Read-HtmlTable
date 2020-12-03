Function Read-HtmlTable {
    [CmdletBinding()][OutputType([Object[]])] param(
        [Parameter(ValueFromPipeLine = $True, Mandatory = $True)][String]$Html
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
        foreach($table in ($Document.Body | Get-Elements 'table')) {
            $Names = $Null
            foreach ($tr in ($table | Get-Elements 'tr')) {
                if (!$Names) { $Names = ($tr | Get-Elements 'th').innerText }
                if (!$Names) { $Names = ($tr | Get-Elements 'td').innerText }
                else {
                    $Values = ($tr | Get-Elements 'td').innerText
                    $Properties = @{}; $i = 0
                    Foreach ($Value in $Values) { $Properties[$Names[$i++]] = $Value }
                    [pscustomobject]$Properties
                }
            }
        }
    }
}
