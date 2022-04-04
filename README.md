# Read-HtmlTable
Reads (extracts) a HTML table from a string or the internet location

## Example

<table>
    <caption>Invoice information</caption>
    <thead>
        <tr>
            <th>Product</th>
            <th colspan="3">Invoice</th>
        </tr> 
        <tr>
            <th>Item</th>
            <th>Qauntity</th>
            <th>@</th>
            <th>Price</th>
        </tr> 
    </thead>
    <tbody>
        <tr>
            <td>Paperclips (Box)</td>
            <td>100</td>
            <td>1.15</td>
            <td>115.00</td>
        </tr>
            <tr>
            <td>Paper (Case)</td>
            <td rowspan="2">10</td>
            <td>45.99</td>
            <td>459.90</td>
        </tr>
        <tr> 
            <td>Wastepaper Baskets</td>
            <td>17.99</td>
            <td>35.98</td>
        </tr>
            <tr>
            <th colspan="3">Subtotal</th>
            <td>610.88</td>
        </tr>
        <tr>
            <th colspan="2">Tax</th>
            <td>7%</td>
            <td>42.76</td>
        </tr> <tr>
        <th colspan="3">Total</th>
            <td>653.64</td>
        </tr>
    </tbod>
</table>

<details><summary>HTML code</summary>

```html
<table>
    <caption>Invoice</caption>
    <thead>
        <tr>
            <th>Product</th>
            <th colspan="3">Invoice</th>
        </tr> 
        <tr>
            <th>Item</th>
            <th>Qauntity</th>
            <th>@</th>
            <th>Price</th>
        </tr> 
    </thead>
    <tbody>
        <tr>
            <td>Paperclips (Box)</td>
            <td>100</td>
            <td>1.15</td>
            <td>115.00</td>
        </tr>
            <tr>
            <td>Paper (Case)</td>
            <td rowspan="2">10</td>
            <td>45.99</td>
            <td>459.90</td>
        </tr>
        <tr> 
            <td>Wastepaper Baskets</td>
            <td>17.99</td>
            <td>35.98</td>
        </tr>
            <tr>
            <th colspan="3">Subtotal</th>
            <td>610.88</td>
        </tr>
        <tr>
            <th colspan="2">Tax</th>
            <td>7%</td>
            <td>42.76</td>
        </tr> <tr>
        <th colspan="3">Total</th>
            <td>653.64</td>
        </tr>
    </tbod>
</table>
```
</details>

Scraping the above html table:

```PowerShell
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
```

**Inputs**  
String or Uri

**Outputs**  
`PSCustomObject[]`

### Parameters

**`-InputObject <string>`**  
The html content (string) that contains a html table.

If the string is less than 2048 characters and contains a valid uri protocol, the content is downloaded
from the concerned location.

**`-uri <Uri>`**  
A uri location referring to the html content that contains the html table

**`-Header <string[]>`**  
Specifies an alternate column header row for the imported string. The column header determines the property
names of the objects created by `ConvertFrom-Csv`.

Enter column headers as a comma-separated list. Do not enclose the header string in quotation marks.
Enclose each column header in single quotation marks.

If you enter fewer column headers than there are data columns, the remaining data columns are discarded.
If you enter more column headers than there are data columns, the additional column headers are created
with empty data columns.

A `$Null` instead of a column name, will span the respective column with previous column.

> Note: To select specific columns or skip any data (or header) rows, use `Select-Object` cmdlet

**`-TableIndex <int[]>`**  
Specifies which tables should be selected from the html content (where 0 refers to the first table).
By default, all tables are extracted from the content.

> Note: in case of multiple tables, the headers should be unified to properly output or display of each table.  
(see: https://github.com/PowerShell/PowerShell/issues/13906)

**`-Separator <string>`**  
Specifies the characters used to join a header with is spanned over multiple columns.  
**default:** space character

**`-Delimiter <string>`**  
Specifies the characters used to join a header with is spanned over multiple rows.  
**default:** the newline characters used by the operating system

**`-NoTrim`**  
By default, all header - and data text is trimmed, to disable trimming, use the -NoTrim parameter.
