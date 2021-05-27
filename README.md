# Read-HtmlTable
Reads a HTML table from a string or the internet location

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
