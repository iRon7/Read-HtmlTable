<#PSScriptInfo
.VERSION 1.0.5
.GUID 6ddb4b24-29bc-4268-a62f-402b3ee28e3d
.AUTHOR iRon
.COMPANYNAME
.COPYRIGHT
.TAGS Read Extract Scrape ConvertFrom Html Table
.LICENSE https://github.com/iRon7/Read-HtmlTable/LICENSE
.PROJECTURI https://github.com/iRon7/Read-HtmlTable
.ICON https://raw.githubusercontent.com/iRon7/Read-HtmlTable/main/Read-HtmlTable.png
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

<#
.SYNOPSIS
Reads a HTML table

.DESCRIPTION
Scrapes (extracts) a HTML table from a string or the internet location

.INPUTS
String or Uri

.OUTPUTS
PSCustomObject[]

.PARAMETER InputObject
    The html content (string) that contains a html table.

    If the string is less than 2048 characters and contains a valid uri protocol, the content is downloaded
    from the concerned location.

.PARAMETER Uri
    A uri location referring to the html content that contains the html table

.PARAMETER Header
    Specifies an alternate column header row for the imported string. The column header determines the property
    names of the objects created by ConvertFrom-Csv.

    Enter column headers as a comma-separated list. Do not enclose the header string in quotation marks.
    Enclose each column header in single quotation marks.

    If you enter fewer column headers than there are data columns, the remaining data columns are discarded.
    If you enter more column headers than there are data columns, the additional column headers are created
    with empty data columns.

.PARAMETER TableIndex
    Specifies which tables should be selected from the html content (where 0 refers to the first table).
    By default, all tables are extracted from the content.

    Note: the tables headers should be unified to properly output or diplay the tables.
    (see: https://github.com/PowerShell/PowerShell/issues/13906)

.PARAMETER HeaderIndex
    Specifies which header row should be used for the property name. In case the header resides in the same
    table block container as the data, the data is presumed to start right after the last header index.
    Default: 0, meaning the first row in the table is presumed the header row

    Note: To skip any data rows, use `|Select-Object -Skip ...`.

.PARAMETER DefaultNameFormat
    The format used for in case there is no header defined in the HTML table. Where "{0}" refers to the column index.
    Default: 'Column {0}'

.EXAMPLE

    Read-HTMLTable https://github.com/iRon7/Read-HtmlTable

    Product            Invoice           Invoice    Invoice
    Item               Qauntity          @          Price
    -------------      ----------------- ---------- --------------
    Paperclips (Box)   100               1.15       115.00
    Paper (Case)       10                45.99      459.90
    Wastepaper Baskets 10                17.99      35.98
    Subtotal           Subtotal          Subtotal   610.88
    Tax                Tax               7%         42.76
    Total              Total             Total      653.64

.LINK
    https://github.com/iRon7/Read-HtmlTable
#>
[CmdletBinding(DefaultParameterSetName='Html')][OutputType([Object[]])] param(
    [Parameter(ParameterSetName='Html', ValueFromPipeLine = $True, Mandatory = $True, Position = 0)][String]$InputObject,
    [Parameter(ParameterSetName='Uri', ValueFromPipeLine = $True, Mandatory = $True)][Uri]$Uri,
    [String[]]$Header,
    [Int[]]$TableIndex,
    [Int[]]$HeaderIndex = 0,
    [String]$DefaultNameFormat = 'Column {0}'
)
Begin {
    function Get-TopElements {
        [CmdletBinding()][OutputType([__ComObject[]])] param(
            [Parameter(Mandatory = $True)][String[]]$TagName,
            [Parameter(Mandatory = $True, ValueFromPipeLine = $True)]$Element
        )
        Process {
            if ($TagName -Contains $Element.tagName) { $Element }
            else { $Element.Children |Where-Object { $_ } |Foreach-Object { $_ |Get-TopElements $TagName } }
        }
    }
}
Process {
    if (!$Uri -and $InputObject.Length -le 2048 -and ([Uri]$InputObject).AbsoluteUri) { $Uri = [Uri]$InputObject }
    if ($Uri.AbsoluteUri) { $InputObject = [System.Net.Webclient]::New().DownloadString($Uri) }
    $Unicode = [System.Text.Encoding]::Unicode.GetBytes($InputObject)
    $Document = New-Object -Com 'HTMLFile'
    if ($Document.IHTMLDocument2_Write) { $Document.IHTMLDocument2_Write($Unicode) } else { $Document.write($Unicode) }
    $Document.Close()
    $Index = 0
    foreach($Table in ($Document.Body |Get-TopElements 'table')) {
        if (!$PSBoundParameters.ContainsKey('TableIndex') -or $Index++ -In $TableIndex) {
            $THead = $Table |Get-TopElements 'thead'
            $TableHead = if ($THead) { $THead } else { $Table }
            $HeadRows = @($TableHead |Get-TopElements 'tr')
            $TBody = $Table |Get-TopElements 'tbody'
            $TableBody = if ($TBody) { $TBody } else { $Table }
            $BodyRows = @($TableBody |Get-TopElements 'tr')
            $Names = [System.Collections.Generic.List[string]]::new()
            if ($Header) { $DataIndex = 0 }
            else {
                if ($THead -and !$PSBoundParameters.ContainsKey('HeaderIndex')) { $HeaderIndex = 0..($HeadRows.Count - 1) }
                foreach ($TR in $HeadRows[$HeaderIndex]) {
                    $i = 0
                    foreach ($TH in ($TR |Get-TopElements 'th', 'td')) {
                        for ($ColSpan = 0; $ColSpan -lt $TH.colspan; $ColSpan++) {
                            if ($i -ge $Names.Count) { $Names.Add($TH.innerText) }
                            else { $Names[$i] += [Environment]::NewLine + $TH.innerText }
                            $i++
                        }
                    }
                }
                for ($i = 0; $i -lt $Names.Count; $i++) { if (!$Names[$i]) { $Names[$i] = $DefaultNameFormat -f ($i + 1) } }
                $DataIndex = if (!$THead -and $HeadRows.Count -eq $BodyRows.Count) { $HeadRows[$HeaderIndex[-1]].rowIndex + 1 }
            }
            If ($Names) {
                $RowSpan = @(1) * ($Names.Count + 1)
                foreach ($TableRow in $BodyRows) {
                    if ($TableRow.rowIndex -ge $DataIndex) {
                        $ColSpan = 1
                        $Data = $TableRow |Get-TopElements 'th', 'td'
                        $Data = for ($i = 0; $i -lt $Data.Count) {
                            $DT = if ($ColSpan -gt 1) { $Data[$i - 1] } elseif ($RowSpan[$i] -gt 1) { $Data1[$i] }
                            if (--$ColSpan -lt 1) { $ColSpan = $Data[$i].colspan }
                            if (--$RowSpan[$i] -lt 1) { $RowSpan[$i] = $Data[$i].rowspan }
                            if ($DT) { $DT } else { $Data[$i++] }
                        }
                        $Data1 = $Data
                        $Properties = [Ordered]@{}
                        for ($i = 0; $i -lt $Names.Count; $i++) {
                            $Name = $Names[$i]
                            $Value = if ($i -lt $Data.Count) { $Data[$i].innerText }
                            if (!$Properties.Contains($Name)) { $Properties[$Name] = $Value }
                            elseif ($Null -ne $Value) {
                                if ($Null -eq $Properties[$Name]) { $Properties[$Name] = $Value }
                                else { $Properties[$Name] = @($Properties[$Name]) + $Value }
                            }
                        }
                        if ($Properties.Count -gt 0) { [pscustomobject]$Properties }
                    }
                }
            }
        }
    }
}

