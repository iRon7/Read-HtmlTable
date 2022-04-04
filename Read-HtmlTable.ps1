<#PSScriptInfo
.VERSION 2.0.0
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

    A $Null instead of a column name, will span the respective column with previous column.

    Note: To select specific columns or skip any data (or header) rows, use Select-Object cmdlet

.PARAMETER TableIndex
    Specifies which tables should be selected from the html content (where 0 refers to the first table).
    By default, all tables are extracted from the content.

    Note: in case of multiple tables, the headers should be unified to properly output or display of each table.
    (see: https://github.com/PowerShell/PowerShell/issues/13906)

.PARAMETER Separator
    Specifies the characters used to join a header with is spanned over multiple columns
    (default: space character)

.PARAMETER Delimiter
    Specifies the characters used to join a header with is spanned over multiple rows
    (default: the newline characters used by the operating system)

.PARAMETER NoTrim
    By default, all header - and data text is trimmed, to disable automatic trimming, use the -NoTrim parameter.

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
    [Object[]]$Header,
    [Int[]]$TableIndex,
    [String]$Separator = ' ',
    [String]$Delimiter = [System.Environment]::NewLine,
    [Switch]$NoTrim
)
Begin {
    function ParseHtml($String) {
        $Unicode = [System.Text.Encoding]::Unicode.GetBytes($String)
        $Html = New-Object -Com 'HTMLFile'
        if ($Html.PSObject.Methods.Name -Contains 'IHTMLDocument2_Write') { $Html.IHTMLDocument2_Write($Unicode) } else { $Html.write($Unicode) }
        $Html.Close()
        $Html
    }
    filter GetTopElement([String[]]$TagName) {
        if ($TagName -Contains $_.tagName) { $_}
        else { @($_.Children).Where{ $_ } | GetTopElement -TagName $TagName }
    }
    function GetUnit($Data, [int]$x, [int]$y) {
        if ($x -lt $Data.Count -and $y -lt $Data[$x].Count) { $Data[$x][$y] }
    }
    function SetUnit($Data, [int]$x, [int]$y, [HashTable]$Unit) {
        while ($x -ge $Data.Count) { $Data.Add([System.Collections.Generic.List[HashTable]]::new()) }
        while ($y -ge $Data[$x].Count) { $Data[$x].Add($Null) }
        $Data[$x][$y] = $Unit
    }
    function GetData([__ComObject[]]$TRs) {
        $Data = [System.Collections.Generic.List[System.Collections.Generic.List[HashTable]]]::new()
        $y = 0
        foreach($TR in $TRs) {
            $x = 0
            foreach($TD in ($TR |GetTopElement 'th', 'td')) {
                while ($True) { # Skip any row spans
                    $Unit = GetUnit -Data $Data -x $x -y $y
                    if (!$Unit) { break }
                    $x++
                }
                $Text = if ($Null -ne $TD.innerText) { if ($NoTrim) { $TD.innerText } else { $TD.innerText.Trim() } }
                for ($r = 0; $r -lt $TD.rowspan; $r++) {
                    $y1 = $y + $r
                    for ($c = 0; $c -lt $TD.colspan; $c++) {
                        $x1 = $x + $c
                        $Unit = GetUnit -Data $Data -x $x1 -y $y1
                        if ($Unit) { SetUnit -Data $Data -x $x1 -y $y1 -Unit @{ ColSpan = $True; Text = $Unit.Text, $Text } } # RowSpan/ColSpan overlap
                        else { SetUnit -Data $Data -x $x1 -y $y1 -Unit @{ ColSpan = $c -gt 0; RowSpan = $r -gt 0; Text = $Text } }
                    }
                }
                $x++
            }
            $y++
        }
        ,$Data
    }
}
Process {
    if (!$Uri -and $InputObject.Length -le 2048 -and ([Uri]$InputObject).AbsoluteUri) { $Uri = [Uri]$InputObject }
    $Response = if ($Uri -is [Uri] -and $Uri.AbsoluteUri) { Try { Invoke-WebRequest $Uri } Catch { Throw $_ } }
    $Html = if ($Response) {
        if ($Response.PSObject.Properties.Name -Contains 'ParsedHtml') { $Response.ParsedHtml }
        else { ParseHtml $Response.RawContent }
    } else { ParseHtml $InputObject }
    $i = 0
    foreach($Table in ($Html.Body |GetTopElement 'table')) {
        if (!$PSBoundParameters.ContainsKey('TableIndex') -or $i++ -In $TableIndex) {
            $Rows = $Table |GetTopElement 'tr'
            if (!$Rows) { return }
            if ($PSBoundParameters.ContainsKey('Header')) {
                $HeadRows = @()
                $Data = GetData $Rows
            }
            else {
                for ($i = 0; $i -lt $Rows.Count; $i++) { $Rows[$i].id = "id_$i" }
                $THead = $Table |GetTopElement 'thead'
                $HeadRows = @(
                    if ($THead) { $THead |GetTopElement 'tr' }
                    else { $Rows.Where({ !($_ |GetTopElement 'th') }, 'Until' ) }
                )
                if (!$HeadRows -or $HeadRows.Count -eq $Rows.Count) { $HeadRows = $Rows[0] }
                $Head = GetData $HeadRows
                $Data = GetData ($Rows.Where{ $_.id -notin $HeadRows.id })
                $Header = @(
                    for ($x = 0; $x -lt $Head.Count; $x++) {
                        if ($Head[$x].Where({ !$_.ColSpan }, 'First') ) {
                            ,@($Head[$x].Where{ !$_.RowSpan }.ForEach{ $_.Text })
                        }
                        else { $Null } # aka spanned header column
                    }
                    for ($x = $Head.Count; $x -lt $Data.Count; $x++) {
                        if ($Null -ne $Data[$x].Where({ $_ -and !$_.ColSpan }, 'First') ) { '' }
                    }
                )
            }
            $Header = $Header.ForEach{
                if ($Null -eq $_) { $Null }
                else {
                    $Name = [String[]]$_
                    $Name = if ($NoTrim) { $Name -Join $Delimiter }
                            else { (($Name.ForEach{ $_.Trim() }) -Join $Delimiter).Trim() }
                    if ($Name) { $Name } else { '1' }
                }
            }
            $Unique = [System.Collections.Generic.HashSet[String]]::new([StringComparer]::InvariantCultureIgnoreCase)
            $Duplicates = @( for ($i = 0; $i -lt $Header.Count; $i++) { if ($Null -ne $Header[$i] -and !$Unique.Add($Header[$i])) { $i } } )
            $Duplicates.ForEach{
                do {
                    $Name, $Number = ([Regex]::Match($Header[$_], '^([\s\S]*?)(\d*)$$')).Groups.Value[1, 2]
                    $Digits = '0' * $Number.Length
                    $Header[$_] = "$Name{0:$Digits}" -f (1 + $Number)
                } while (!$Unique.Add($Header[$_]))
            }
            for ($y = 0; $y -lt ($Data |ForEach-Object Count |Measure-Object -Maximum).Maximum; $y++) {
                $Name = $Null # (custom) -Header parameter started with a spanned ($Null) column
                $Properties = [ordered]@{}
                for ($x = 0; $x -lt $Header.Count; $x++) {
                    $Unit = GetUnit -Data $Data -x $x -y $y -Unit
                    if ($Null -ne $Header[$x]) {
                        $Name = $Header[$x]
                        $Properties[$Name] = if ($Unit) { $Unit.Text } # else $Null (align column overflow)
                    }
                    elseif ($Name -and !$Unit.ColSpan) {
                        $Properties[$Name] = $Properties[$Name], $Unit.Text
                    }
                }
                [pscustomobject]$Properties
            }
        }
    }
    $Null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Html)
}

