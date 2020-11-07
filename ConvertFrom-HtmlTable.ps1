Function ConvertFrom-HtmlTable {
    [CmdletBinding()][OutputType([Object[]])] param(
        [Parameter(ValueFromPipeLine = $True, Mandatory = $True)][String]$html
    )
    Begin {
        Function Get-TopElements { # Get elements by (insensitive) name that do not have a (grand)parent with the same name
            [CmdletBinding()][OutputType([Xml.XmlElement[]])] param(
                [Parameter(Mandatory = $True)][String]$Name,
                [Parameter(Mandatory = $True, ValueFromPipeLine = $True)][Xml.XmlElement]$Element
            )
            if ($Element.Name -eq $Name) { $Element }
            else { $Element.SelectNodes('*') | Foreach-Object { $_ | Get-TopElements $Name } } 
        }
    }
    Process {
        $body = ([Xml]($html -Replace '^[\s\S]*(?=\<body\>)' -Replace '(?<=\<\/body\>)[\s\S]*$')).body
        foreach($table in ($body | Get-TopElements 'table')) {
            $Names = $Null
            foreach ($tr in $table.GetElementsByTagName('tr')) {
                if (!$Names) { $Names = ($tr | Get-TopElements 'th').'#text' }
                if (!$Names) { $Names = ($tr | Get-TopElements 'td').'#text' }
                else {
                    $Values = ($tr | Get-TopElements 'td').'#text'
                    $Properties = @{}; $i = 0
                    Foreach ($Value in $Values) { $Properties[$Names[$i++]] = $Value }
                    [pscustomobject]$Properties
                }
            }
        }
    }
}
