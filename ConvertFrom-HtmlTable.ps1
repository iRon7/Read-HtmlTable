$Page = @'
<!DOCTYPE html>
    <html>
    <head>
        <link rel="icon" href="data:,">
        <meta name="google" content="notranslate">        
    </head> 
    <title>"Results</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        /* W3.CSS 4.13 June 2019 by Jan Egil and Borge Refsnes */
        html{box-sizing:border-box}*,*:before,*:after{box-sizing:inherit}
        /* Extract from normalize.css by Nicolas Gallagher and Jonathan Neal git.io/normalize */
        .w3-table,.w3-table-all{border-collapse:collapse;border-spacing:0;width:100%;display:table}.w3-table-all{border:1px solid #ccc}
        .w3-bordered tr,.w3-table-all tr{border-bottom:1px solid #ddd}.w3-striped tbody tr:nth-child(even){background-color:#f1f1f1}
        .w3-table-all tr:nth-child(odd){background-color:#fff}.w3-table-all tr:nth-child(even){background-color:#f1f1f1}
        .w3-hoverable tbody tr:hover,.w3-ul.w3-hoverable li:hover{background-color:#ccc}.w3-centered tr th,.w3-centered tr td{text-align:center}
        .w3-table td,.w3-table th,.w3-table-all td,.w3-table-all th{padding:8px 8px;display:table-cell;text-align:left;vertical-align:top}
        .w3-table th:first-child,.w3-table td:first-child,.w3-table-all th:first-child,.w3-table-all td:first-child{padding-left:16px}
        .container2 {
            position: relative;
            width: 99%;
            height: 100%;
            overflow: hidden;
            padding-top: 37%; /* 16:9 Aspect Ratio */
        }
        .responsive-iframe2 {
            position: absolute;
            top: 1%;
            left: 0;
            bottom: 0;
            right: 0;
            width: 99.5%;
            height: 98%;
            border: none;
        } 
    </style>
    <body>
    <div style="overflow-x:auto;">
        <table class="w3-table-all w3-hoverable">
            <thead>
                <tr class="w3-light-grey">
                    <th>collation_name</th>
                    <th>compatibility_level</th>
                    <th>ConnectionString</th>
                    <th>DBname</th>
                </tr>
            </thead>        
            <tr> 
                <td>SQL_Latin1_General_CP1_CI_AS</td>
                <td>140</td>
                <td>server.domain.com,1433</td>
                <td>Database_1</td>
            </tr>  
            <tr> 
                <td>SQL_Latin1_General_CP1_CI_AS</td>
                <td>140</td>
                <td>server.domain.com,1433</td>
                <td>Database_2</td>
            </tr>  
            <tr> 
                <td>SQL_Latin1_General_CP1_CI_AS</td>
                <td>140</td>
                <td>server.domain.com,1433</td>
                <td>Database_3</td>
            </tr>  
         </table>
    </div>
        <p></p>      
    </body>
</html>
'@

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

$Page | ConvertFrom-HtmlTable