#Requires -Modules @{ModuleName="Pester"; ModuleVersion="5.0.0"}

Describe 'Read-HtmlTable' {

    BeforeAll {

        Set-StrictMode -Version Latest

        Get-Module -Name JoinModule | Remove-Module
        Set-Alias -Name Read-HtmlTable -Value .\Read-HtmlTable.ps1

        Function Compare-PSObject([Object[]]$ReferenceObject, [Object[]]$DifferenceObject) {
            $Property = ($ReferenceObject  | Select-Object -First 1).PSObject.Properties.Name +
                        ($DifferenceObject | Select-Object -First 1).PSObject.Properties.Name | Select-Object -Unique
                        Compare-Object $ReferenceObject $DifferenceObject -Property $Property
        }
    }

    Context 'Basic text tests' {

        It 'Html table with table headers (th)' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>Company</th>
                    <th>Contact</th>
                    <th>Country</th>
                  </tr>
                  <tr>
                    <td>Alfreds Futterkiste</td>
                    <td>Maria Anders</td>
                    <td>Germany</td>
                  </tr>
                  <tr>
                    <td>Centro comercial Moctezuma</td>
                    <td>Francisco Chang</td>
                    <td>Mexico</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{Company = 'Alfreds Futterkiste'; Contact = 'Maria Anders'; Country = 'Germany'},
                [pscustomobject]@{Company = 'Centro comercial Moctezuma'; Contact = 'Francisco Chang'; Country = 'Mexico'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }


        It 'Html table with only table data (td)' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <td>Company</td>
                    <td>Contact</td>
                    <td>Country</td>
                  </tr>
                  <tr>
                    <td>Alfreds Futterkiste</td>
                    <td>Maria Anders</td>
                    <td>Germany</td>
                  </tr>
                  <tr>
                    <td>Centro comercial Moctezuma</td>
                    <td>Francisco Chang</td>
                    <td>Mexico</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{Company = 'Alfreds Futterkiste'; Contact = 'Maria Anders'; Country = 'Germany'},
                [pscustomobject]@{Company = 'Centro comercial Moctezuma'; Contact = 'Francisco Chang'; Country = 'Mexico'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Html table with table head (thead) and table body (tbody)' {

            $Actual = Read-HTMLTable '
                <table>
                  <thead>
                    <tr>
                      <th>Company</th>
                      <th>Contact</th>
                      <th>Country</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Alfreds Futterkiste</td>
                      <td>Maria Anders</td>
                      <td>Germany</td>
                    </tr>
                    <tr>
                      <td>Centro comercial Moctezuma</td>
                      <td>Francisco Chang</td>
                      <td>Mexico</td>
                    </tr>
                  </tbody>
                </table>'

            $Expected =
                [pscustomobject]@{Company = 'Alfreds Futterkiste'; Contact = 'Maria Anders'; Country = 'Germany'},
                [pscustomobject]@{Company = 'Centro comercial Moctezuma'; Contact = 'Francisco Chang'; Country = 'Mexico'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Html table with a table head (thead) but no table body (tbody)' {

            $Actual = Read-HTMLTable '
                <table>
                  <thead>
                    <tr>
                      <th>Company</th>
                      <th>Contact</th>
                      <th>Country</th>
                    </tr>
                  </thead>
                  <tr>
                    <td>Alfreds Futterkiste</td>
                    <td>Maria Anders</td>
                    <td>Germany</td>
                  </tr>
                  <tr>
                    <td>Centro comercial Moctezuma</td>
                    <td>Francisco Chang</td>
                    <td>Mexico</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{Company = 'Alfreds Futterkiste'; Contact = 'Maria Anders'; Country = 'Germany'},
                [pscustomobject]@{Company = 'Centro comercial Moctezuma'; Contact = 'Francisco Chang'; Country = 'Mexico'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Html table with table body (tbody) but no table head (thead)' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>Company</th>
                    <th>Contact</th>
                    <th>Country</th>
                  </tr>
                  <tbody>
                    <tr>
                      <td>Alfreds Futterkiste</td>
                      <td>Maria Anders</td>
                      <td>Germany</td>
                    </tr>
                    <tr>
                      <td>Centro comercial Moctezuma</td>
                      <td>Francisco Chang</td>
                      <td>Mexico</td>
                    </tr>
                  </tbody>
                </table>'

            $Expected =
                [pscustomobject]@{Company = 'Alfreds Futterkiste'; Contact = 'Maria Anders'; Country = 'Germany'},
                [pscustomobject]@{Company = 'Centro comercial Moctezuma'; Contact = 'Francisco Chang'; Country = 'Mexico'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Html table everything in the table head (thead)' {

            $Actual = Read-HTMLTable '
                <table>
                  <thead>
                    <tr>
                      <th>Company</th>
                      <th>Contact</th>
                      <th>Country</th>
                    </tr>
                    <tr>
                      <td>Alfreds Futterkiste</td>
                      <td>Maria Anders</td>
                      <td>Germany</td>
                    </tr>
                    <tr>
                      <td>Centro comercial Moctezuma</td>
                      <td>Francisco Chang</td>
                      <td>Mexico</td>
                    </tr>
                  </thead>
                </table>'

            $Expected =
                [pscustomobject]@{Company = 'Alfreds Futterkiste'; Contact = 'Maria Anders'; Country = 'Germany'},
                [pscustomobject]@{Company = 'Centro comercial Moctezuma'; Contact = 'Francisco Chang'; Country = 'Mexico'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Html table everything in the table body (tbody)' {

            $Actual = Read-HTMLTable '
                <table>
                  <tbody>
                    <tr>
                      <th>Company</th>
                      <th>Contact</th>
                      <th>Country</th>
                    </tr>
                    <tr>
                      <td>Alfreds Futterkiste</td>
                      <td>Maria Anders</td>
                      <td>Germany</td>
                    </tr>
                    <tr>
                      <td>Centro comercial Moctezuma</td>
                      <td>Francisco Chang</td>
                      <td>Mexico</td>
                    </tr>
                  </tbody>
                </table>'

            $Expected =
                [pscustomobject]@{Company = 'Alfreds Futterkiste'; Contact = 'Maria Anders'; Country = 'Germany'},
                [pscustomobject]@{Company = 'Centro comercial Moctezuma'; Contact = 'Francisco Chang'; Country = 'Mexico'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }
    }


    Context 'Header spanning tests' {

        It 'Multi line header column spanning' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A1</th>
                    <th colspan="2">B1</th>
                  </tr>
                  <tr>
                    <th>A2</th>
                    <th>B2</th>
                    <th>C2</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>a2</td>
                    <td>b2</td>
                    <td>c2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{"A1`r`nA2" = 'a1'; "B1`r`nB2" = 'b1'; "B1`r`nC2" = 'c1'},
                [pscustomobject]@{"A1`r`nA2" = 'a2'; "B1`r`nB2" = 'b2'; "B1`r`nC2" = 'c2'},
                [pscustomobject]@{"A1`r`nA2" = 'a3'; "B1`r`nB2" = 'b3'; "B1`r`nC2" = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Multi line header row spanning' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A1</th>
                    <th rowspan="2">B1</th>
                    <th>C1</th>
                  </tr>
                  <tr>
                    <th>A2</th>
                    <th>C2</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>a2</td>
                    <td>b2</td>
                    <td>c2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{"A1`r`nA2" = 'a1'; B1 = 'b1'; "C1`r`nC2" = 'c1'},
                [pscustomobject]@{"A1`r`nA2" = 'a2'; B1 = 'b2'; "C1`r`nC2" = 'c2'},
                [pscustomobject]@{"A1`r`nA2" = 'a3'; B1 = 'b3'; "C1`r`nC2" = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

       It 'Multi line header block (row and span) spanning' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th rowspan="2">A1</th>
                    <th colspan="2">B1</th>
                  </tr>
                  <tr>
                    <th>B2</th>
                    <th>C2</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>a2</td>
                    <td>b2</td>
                    <td>c2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A1 = 'a1'; "B1`r`nB2" = 'b1'; "B1`r`nC2" = 'c1'},
                [pscustomobject]@{A1 = 'a2'; "B1`r`nB2" = 'b2'; "B1`r`nC2" = 'c2'},
                [pscustomobject]@{A1 = 'a3'; "B1`r`nB2" = 'b3'; "B1`r`nC2" = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

       It 'Multi line header block spanning' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A1</th>
                    <th>B1</th>
                    <th>C1</th>
                  </tr>
                  <tr>
                    <th>A2</th>
                    <th colspan="2"  rowspan="2">B2</th>
                  </tr>
                  <tr>
                    <th>A3</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>a2</td>
                    <td>b2</td>
                    <td>c2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{"A1`r`nA2`r`nA3" = 'a1'; "B1`r`nB2" = 'b1'; "C1`r`nB2" = 'c1'},
                [pscustomobject]@{"A1`r`nA2`r`nA3" = 'a2'; "B1`r`nB2" = 'b2'; "C1`r`nB2" = 'c2'},
                [pscustomobject]@{"A1`r`nA2`r`nA3" = 'a3'; "B1`r`nB2" = 'b3'; "C1`r`nB2" = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Data spanning tests' {

        It 'data column spanning' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A</th>
                    <th>B</th>
                    <th>C</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td colspan="3">a2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'; C = 'c1'},
                [pscustomobject]@{A = 'a2'; B = 'a2'; C = 'a2'},
                [pscustomobject]@{A = 'a3'; B = 'b3'; C = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'data row spanning' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A</th>
                    <th>B</th>
                    <th>C</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td rowspan="3">b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>a2</td>
                    <td>c2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'; C = 'c1'},
                [pscustomobject]@{A = 'a2'; B = 'b1'; C = 'c2'},
                [pscustomobject]@{A = 'a3'; B = 'b1'; C = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'data column spanning and row spanning' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A</th>
                    <th>B</th>
                    <th>C</th>
                  </tr>
                  <tr>
                    <td colspan="2">a1</td>
                    <td rowspan="2">c1</td>
                  </tr>
                  <tr>
                    <td rowspan="2">a2</td>
                    <td>b2</td>
                  </tr>
                  <tr>
                    <td colspan="2">b3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'a1'; C = 'c1'},
                [pscustomobject]@{A = 'a2'; B = 'b2'; C = 'c1'},
                [pscustomobject]@{A = 'a2'; B = 'b3'; C = 'b3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'data block (row and span) spanning' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A</th>
                    <th>B</th>
                    <th>C</th>
                  </tr>
                  <tr>
                    <td colspan="2" rowspan="2">a1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>c2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'a1'; C = 'c1'},
                [pscustomobject]@{A = 'a1'; B = 'a1'; C = 'c2'},
                [pscustomobject]@{A = 'a3'; B = 'b3'; C = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'data row spanning and column spanning overlap' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A</th>
                    <th>B</th>
                    <th>C</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td rowspan="3">b1</td>
                    <td>c2</td>
                  </tr>
                  <tr>
                    <td colspan="3">a2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'; C = 'c2'},
                [pscustomobject]@{A = 'a2'; B = 'b1', 'a2'; C = 'a2'},
                [pscustomobject]@{A = 'a3'; B = 'b1'; C = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Table (column) spanning tests' {

        It 'data column spanning' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th colspan="2">A</th>
                    <th>B</th>
                    <th>C</th>
                  </tr>
                  <tr>
                    <td colspan="2">a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>a2a</td>
                    <td>a2b</td>
                    <td>b2</td>
                    <td>c2</td>
                  </tr>
                  <tr>
                    <td colspan="2">a3</td>
                    <td>b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'; C = 'c1'},
                [pscustomobject]@{A = 'a2a', 'a2b'; B = 'b2'; C = 'c2'},
                [pscustomobject]@{A = 'a3'; B = 'b3'; C = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Data overflow tests' {

        It 'Column overflow' { # Column data exceeds column header

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A</th>
                    <th>B</th>
                    <th>C</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>a2</td>
                    <td>b2</td>
                    <td>c2</td>
                    <td>d2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'; C = 'c1'; '1' = $Null},
                [pscustomobject]@{A = 'a2'; B = 'b2'; C = 'c2'; '1' = 'd2'},
                [pscustomobject]@{A = 'a3'; B = 'b3'; C = 'c3'; '1' = $Null}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Column span overflow' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A</th>
                    <th>B</th>
                    <th>C</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>a2</td>
                    <td>b2</td>
                    <td colospan="2">c2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td>b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'; C = 'c1'},
                [pscustomobject]@{A = 'a2'; B = 'b2'; C = 'c2'},
                [pscustomobject]@{A = 'a3'; B = 'b3'; C = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Row span overflow' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>A</th>
                    <th>B</th>
                    <th>C</th>
                  </tr>
                  <tr>
                    <td>a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td>a2</td>
                    <td>b2</td>
                    <td>c2</td>
                  </tr>
                  <tr>
                    <td>a3</td>
                    <td rowspan="2">b3</td>
                    <td>c3</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'; C = 'c1'},
                [pscustomobject]@{A = 'a2'; B = 'b2'; C = 'c2'},
                [pscustomobject]@{A = 'a3'; B = 'b3'; C = 'c3'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Custom header tests' {

        beforeall {

            $Html = '
                <table>
                  <tr>
                    <td>a1</td>
                    <td>b1</td>
                    <td>c1</td>
                  </tr>
                  <tr>
                    <td colspan="2">a2</td>
                    <td>c2</td>
                  </tr>
                </table>'
        }

        It 'Headers equals columns' {

            $Actual = Read-HTMLTable -Header A,B,C $Html

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'; C = 'c1'},
                [pscustomobject]@{A = 'a2'; B = 'a2'; C = 'c2'}

           Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'More headers than columns' {

            $Actual = Read-HTMLTable -Header A,B,C,D $Html

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'; C = 'c1'; D = $Null},
                [pscustomobject]@{A = 'a2'; B = 'a2'; C = 'c2'; D = $Null}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Less headers than columns' {

            $Actual = Read-HTMLTable -Header A,B $Html

            $Expected =
                [pscustomobject]@{A = 'a1'; B = 'b1'},
                [pscustomobject]@{A = 'a2'; B = 'a2'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Single header' {

            $Actual = Read-HTMLTable -Header A $Html

            $Expected =
                [pscustomobject]@{A = 'a1'},
                [pscustomobject]@{A = 'a2'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Spanned column header' {

            $Actual = Read-HTMLTable -Header A,$Null,C $Html

            $Expected =
                [pscustomobject]@{A = 'a1', 'b1'; C = 'c1'},
                [pscustomobject]@{A = 'a2'; C = 'c2'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Multiline spanned column header' {

            $Actual = Read-HTMLTable -Header @('A','1'),@('A','2'),$Null $Html

            $Expected =
                [pscustomobject]@{"A`r`n1" = 'a1'; "A`r`n2" = 'b1', 'c1'},
                [pscustomobject]@{"A`r`n1" = 'a2'; "A`r`n2" = 'a2', 'c2'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Exception tests' {

        It 'Empty headers' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th></th>
                    <th></th>
                    <th></th>
                  </tr>
                  <tr>
                    <td>Alfreds Futterkiste</td>
                    <td>Maria Anders</td>
                    <td>Germany</td>
                  </tr>
                  <tr>
                    <td>Centro comercial Moctezuma</td>
                    <td>Francisco Chang</td>
                    <td>Mexico</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{'1' = 'Alfreds Futterkiste'; '2' = 'Maria Anders'; '3' = 'Germany'},
                [pscustomobject]@{'1' = 'Centro comercial Moctezuma'; '2' = 'Francisco Chang'; '3' = 'Mexico'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'Duplicate headers' {

            $Actual = Read-HTMLTable '
                <table>
                  <tr>
                    <th>Column008</th>
                    <th>Column008</th>
                    <th>Column008</th>
                  </tr>
                  <tr>
                    <td>Alfreds Futterkiste</td>
                    <td>Maria Anders</td>
                    <td>Germany</td>
                  </tr>
                  <tr>
                    <td>Centro comercial Moctezuma</td>
                    <td>Francisco Chang</td>
                    <td>Mexico</td>
                  </tr>
                </table>'

            $Expected =
                [pscustomobject]@{Column008 = 'Alfreds Futterkiste'; Column009 = 'Maria Anders'; Column010 = 'Germany'},
                [pscustomobject]@{Column008 = 'Centro comercial Moctezuma'; Column009 = 'Francisco Chang'; Column010 = 'Mexico'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

    }

    Context 'Readme Examples' {

        It 'https://github.com/iRon7/Read-HtmlTable' {

            $Actual = Read-HTMLTable https://github.com/iRon7/Read-HtmlTable

            $Expected =
                [pscustomobject]@{"Product`r`nItem" = 'Paperclips (Box)'; "Invoice`r`nQauntity" = '100'; "Invoice`r`n@" = '1.15'; "Invoice`r`nPrice" = '115.00'},
                [pscustomobject]@{"Product`r`nItem" = 'Paper (Case)'; "Invoice`r`nQauntity" = '10'; "Invoice`r`n@" = '45.99'; "Invoice`r`nPrice" = '459.90'},
                [pscustomobject]@{"Product`r`nItem" = 'Wastepaper Baskets'; "Invoice`r`nQauntity" = '10'; "Invoice`r`n@" = '17.99'; "Invoice`r`nPrice" = '35.98'},
                [pscustomobject]@{"Product`r`nItem" = 'Subtotal'; "Invoice`r`nQauntity" = 'Subtotal'; "Invoice`r`n@" = 'Subtotal'; "Invoice`r`nPrice" = '610.88'},
                [pscustomobject]@{"Product`r`nItem" = 'Tax'; "Invoice`r`nQauntity" = 'Tax'; "Invoice`r`n@" = '7%'; "Invoice`r`nPrice" = '42.76'},
                [pscustomobject]@{"Product`r`nItem" = 'Total'; "Invoice`r`nQauntity" = 'Total'; "Invoice`r`n@" = 'Total'; "Invoice`r`nPrice" = '653.64'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Internet Tables' {

        It 'http://www.bcra.gob.ar/PublicacionesEstadisticas/Cotizaciones_por_fecha_2.asp?tipo=E&date2=2021-05-01' {

            $Uri = 'http://www.bcra.gob.ar/PublicacionesEstadisticas/Cotizaciones_por_fecha_2.asp?tipo=E&date2=2021-05-01'
            $Actual = Read-HtmlTable -Header Currency, Pass, Exchange -Uri $Uri |Select-Object -Skip 2

            $Expected =
                [pscustomobject]@{Currency = 'Bol?var Venezolano'; Pass = '0,000001'; Exchange = '0,00008'},
                [pscustomobject]@{Currency = 'Cordoba Nicaraguense'; Pass = '0,028671'; Exchange = '2,431605'},
                [pscustomobject]@{Currency = 'Corona Checa'; Pass = '0,047013'; Exchange = '3,987194'},
                [pscustomobject]@{Currency = 'Corona Danesa'; Pass = '0,165336'; Exchange = '14,022122'},
                [pscustomobject]@{Currency = 'Corona Noruega'; Pass = '0,117975'; Exchange = '10,005427'},
                [pscustomobject]@{Currency = 'Corona Sueca'; Pass = '0,122284'; Exchange = '10,370887'},
                [pscustomobject]@{Currency = 'Derecho Especial de Giro'; Pass = '1,44796'; Exchange = '122,801488'},
                [pscustomobject]@{Currency = 'Dinar Serbia'; Pass = '0,010459'; Exchange = '0,887026'},
                [pscustomobject]@{Currency = 'Dolar Australiano'; Pass = '0,7765'; Exchange = '65,854965'},
                [pscustomobject]@{Currency = 'Dolar Canadiense'; Pass = '0,78883'; Exchange = '66,900686'},
                [pscustomobject]@{Currency = 'Dolar de Singapur'; Pass = '0,759071'; Exchange = '64,376803'},
                [pscustomobject]@{Currency = 'Dolar Estadounidense'; Pass = '------------------'; Exchange = '84,81'},
                [pscustomobject]@{Currency = 'Dolar Hong Kong'; Pass = '0,128976'; Exchange = '10,938427'},
                [pscustomobject]@{Currency = 'Dolar Neozelandes'; Pass = '0,7254'; Exchange = '61,521174'},
                [pscustomobject]@{Currency = 'Dolar Referencia Com 3500'; Pass = '------------------'; Exchange = '84,7967'},
                [pscustomobject]@{Currency = 'Dong Vietnam (c/1.000 u.)'; Pass = '0,043328'; Exchange = '3,67461'},
                [pscustomobject]@{Currency = 'Euro (Unidad Monetaria Europe'; Pass = '1,2299'; Exchange = '104,307819'},
                [pscustomobject]@{Currency = 'Florin (Antillas Holandesas)'; Pass = '0,558659'; Exchange = '47,379888'},
                [pscustomobject]@{Currency = 'Franco Suizo'; Pass = '1,138952'; Exchange = '96,594533'},
                [pscustomobject]@{Currency = 'Guaran? Paraguayo'; Pass = '0,000145'; Exchange = '0,01232'},
                [pscustomobject]@{Currency = 'Libra Esterlina'; Pass = '1,3631'; Exchange = '115,604511'},
                [pscustomobject]@{Currency = 'Lira Turca'; Pass = '0,135252'; Exchange = '11,470731'},
                [pscustomobject]@{Currency = 'Nuevo Sol Peruano'; Pass = '0,275459'; Exchange = '23,361706'},
                [pscustomobject]@{Currency = 'Oro - Onza Troy'; Pass = '1950,38'; Exchange = '------------------'},
                [pscustomobject]@{Currency = 'Peso'; Pass = '0,011791'; Exchange = '------------------'},
                [pscustomobject]@{Currency = 'Peso Boliviano'; Pass = '0,145258'; Exchange = '12,319335'},
                [pscustomobject]@{Currency = 'Peso Chileno'; Pass = '0,001431'; Exchange = '0,121343'},
                [pscustomobject]@{Currency = 'Peso Colombiano'; Pass = '0,00029'; Exchange = '0,024609'},
                [pscustomobject]@{Currency = 'Peso Mexicano'; Pass = '0,050164'; Exchange = '4,254433'},
                [pscustomobject]@{Currency = 'Peso Uruguayo'; Pass = '0,023641'; Exchange = '2,004965'},
                [pscustomobject]@{Currency = 'Plata - Onza Troy'; Pass = '27,4937'; Exchange = '------------------'},
                [pscustomobject]@{Currency = 'Rand Sudafricano'; Pass = '0,066669'; Exchange = '5,654226'},
                [pscustomobject]@{Currency = 'Real (Brasil)'; Pass = '0,189437'; Exchange = '16,066151'},
                [pscustomobject]@{Currency = 'Rublo (Rusia)'; Pass = '0,01352'; Exchange = '1,146627'},
                [pscustomobject]@{Currency = 'Rupia (India)'; Pass = '0,013665'; Exchange = '1,158923'},
                [pscustomobject]@{Currency = 'Shekel (Israel)'; Pass = '0,312305'; Exchange = '26,486571'},
                [pscustomobject]@{Currency = 'Yen (Jap?n)'; Pass = '0,009742'; Exchange = '0,826206'},
                [pscustomobject]@{Currency = 'Yuan- China CNY'; Pass = '0,154892'; Exchange = '13,136414'},
                [pscustomobject]@{Currency = 'Yuan-China Off Shore CNH'; Pass = '0,155446'; Exchange = '13,18338'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'https://winreleaseinfoprod.blob.core.windows.net/winreleaseinfoprod/en-US.html' {

            $Url = 'https://winreleaseinfoprod.blob.core.windows.net/winreleaseinfoprod/en-US.html'
            $Actual = Read-HTMLTable $Url -TableIndex 2

            $Expected =
                [pscustomobject]@{'OS build' = '19043.1266'; 'Availability date' = '2021-09-30'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5005611'},
                [pscustomobject]@{'OS build' = '19043.1237'; 'Availability date' = '2021-09-14'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5005565'},
                [pscustomobject]@{'OS build' = '19043.1202'; 'Availability date' = '2021-09-01'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5005101'},
                [pscustomobject]@{'OS build' = '19043.1165'; 'Availability date' = '2021-08-10'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5005033'},
                [pscustomobject]@{'OS build' = '19043.1151'; 'Availability date' = '2021-07-29'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5004296'},
                [pscustomobject]@{'OS build' = '19043.1110'; 'Availability date' = '2021-07-13'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5004237'},
                [pscustomobject]@{'OS build' = '19043.1083'; 'Availability date' = '2021-07-06'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5004945'},
                [pscustomobject]@{'OS build' = '19043.1082'; 'Availability date' = '2021-06-29'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5004760'},
                [pscustomobject]@{'OS build' = '19043.1081'; 'Availability date' = '2021-06-21'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5003690'},
                [pscustomobject]@{'OS build' = '19043.1055'; 'Availability date' = '2021-06-11'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5004476'},
                [pscustomobject]@{'OS build' = '19043.1052'; 'Availability date' = '2021-06-08'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5003637'},
                [pscustomobject]@{'OS build' = '19043.1023'; 'Availability date' = '2021-05-25'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5003214'},
                [pscustomobject]@{'OS build' = '19043.985' ; 'Availability date' = '2021-05-18'; 'Servicing option' = 'Semi-Annual Channel'; 'Kb article' = 'KB 5003173'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'https://en.wikipedia.org/wiki/Color' {

            $Uri = 'https://en.wikipedia.org/wiki/Color'
            $Actual = Read-HTMLTable -Uri $Uri -TableIndex 1

            $Expected =
                [pscustomobject]@{Color = $Null, 'Red'; "Wavelength`r`ninterval" = "~ 700$([char]0x2013)635 nm"; "Frequency`r`ninterval" = "~ 430$([char]0x2013)480 THz"},
                [pscustomobject]@{Color = $Null, 'Orange'; "Wavelength`r`ninterval" = "~ 635$([char]0x2013)590 nm"; "Frequency`r`ninterval" = "~ 480$([char]0x2013)510 THz"},
                [pscustomobject]@{Color = $Null, 'Yellow'; "Wavelength`r`ninterval" = "~ 590$([char]0x2013)560 nm"; "Frequency`r`ninterval" = "~ 510$([char]0x2013)540 THz"},
                [pscustomobject]@{Color = $Null, 'Green'; "Wavelength`r`ninterval" = "~ 560$([char]0x2013)520 nm"; "Frequency`r`ninterval" = "~ 540$([char]0x2013)580 THz"},
                [pscustomobject]@{Color = $Null, 'Cyan'; "Wavelength`r`ninterval" = "~ 520$([char]0x2013)490 nm"; "Frequency`r`ninterval" = "~ 580$([char]0x2013)610 THz"},
                [pscustomobject]@{Color = $Null, 'Blue'; "Wavelength`r`ninterval" = "~ 490$([char]0x2013)450 nm"; "Frequency`r`ninterval" = "~ 610$([char]0x2013)670 THz"},
                [pscustomobject]@{Color = $Null, 'Violet'; "Wavelength`r`ninterval" = "~ 450$([char]0x2013)400 nm"; "Frequency`r`ninterval" = "~ 670$([char]0x2013)750 THz"}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'https://en.wikipedia.org/wiki/Web_colors' {

            $Uri = 'https://en.wikipedia.org/wiki/Web_colors'
            $Actual = Read-HTMLTable -Uri $Uri -TableIndex 1

            $Expected =
                [pscustomobject]@{Name = 'White'; "Hex`r`n(RGB)" = '#FFFFFF'; "Red`r`n(RGB)" = '100%'; "Green`r`n(RGB)" = '100%'; "Blue`r`n(RGB)" = '100%'; "Hue`r`n(HSL/HSV)" = "0$([char]0x00b0)"; "Satur.`r`n(HSL)" = '0%'; "Light`r`n(HSL)" = '100%'; "Satur.`r`n(HSV)" = '0%'; "Value`r`n(HSV)" = '100%'; 'CGA number (name); alias' = '15 (white)'},
                [pscustomobject]@{Name = 'Silver'; "Hex`r`n(RGB)" = '#C0C0C0'; "Red`r`n(RGB)" = '75%'; "Green`r`n(RGB)" = '75%'; "Blue`r`n(RGB)" = '75%'; "Hue`r`n(HSL/HSV)" = "0$([char]0x00b0)"; "Satur.`r`n(HSL)" = '0%'; "Light`r`n(HSL)" = '75%'; "Satur.`r`n(HSV)" = '0%'; "Value`r`n(HSV)" = '75%'; 'CGA number (name); alias' = '07 (light gray)'},
                [pscustomobject]@{Name = 'Gray'; "Hex`r`n(RGB)" = '#808080'; "Red`r`n(RGB)" = '50%'; "Green`r`n(RGB)" = '50%'; "Blue`r`n(RGB)" = '50%'; "Hue`r`n(HSL/HSV)" = "0$([char]0x00b0)"; "Satur.`r`n(HSL)" = '0%'; "Light`r`n(HSL)" = '50%'; "Satur.`r`n(HSV)" = '0%'; "Value`r`n(HSV)" = '50%'; 'CGA number (name); alias' = '08 (dark gray)'},
                [pscustomobject]@{Name = 'Black'; "Hex`r`n(RGB)" = '#000000'; "Red`r`n(RGB)" = '0%'; "Green`r`n(RGB)" = '0%'; "Blue`r`n(RGB)" = '0%'; "Hue`r`n(HSL/HSV)" = "0$([char]0x00b0)"; "Satur.`r`n(HSL)" = '0%'; "Light`r`n(HSL)" = '0%'; "Satur.`r`n(HSV)" = '0%'; "Value`r`n(HSV)" = '0%'; 'CGA number (name); alias' = '00 (black)'},
                [pscustomobject]@{Name = 'Red'; "Hex`r`n(RGB)" = '#FF0000'; "Red`r`n(RGB)" = '100%'; "Green`r`n(RGB)" = '0%'; "Blue`r`n(RGB)" = '0%'; "Hue`r`n(HSL/HSV)" = "0$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '50%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '100%'; 'CGA number (name); alias' = '12 (high red)'},
                [pscustomobject]@{Name = 'Maroon'; "Hex`r`n(RGB)" = '#800000'; "Red`r`n(RGB)" = '50%'; "Green`r`n(RGB)" = '0%'; "Blue`r`n(RGB)" = '0%'; "Hue`r`n(HSL/HSV)" = "0$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '25%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '50%'; 'CGA number (name); alias' = '04 (low red)'},
                [pscustomobject]@{Name = 'Yellow'; "Hex`r`n(RGB)" = '#FFFF00'; "Red`r`n(RGB)" = '100%'; "Green`r`n(RGB)" = '100%'; "Blue`r`n(RGB)" = '0%'; "Hue`r`n(HSL/HSV)" = "60$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '50%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '100%'; 'CGA number (name); alias' = '14 (yellow)'},
                [pscustomobject]@{Name = 'Olive'; "Hex`r`n(RGB)" = '#808000'; "Red`r`n(RGB)" = '50%'; "Green`r`n(RGB)" = '50%'; "Blue`r`n(RGB)" = '0%'; "Hue`r`n(HSL/HSV)" = "60$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '25%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '50%'; 'CGA number (name); alias' = '06 (brown)'},
                [pscustomobject]@{Name = 'Lime'; "Hex`r`n(RGB)" = '#00FF00'; "Red`r`n(RGB)" = '0%'; "Green`r`n(RGB)" = '100%'; "Blue`r`n(RGB)" = '0%'; "Hue`r`n(HSL/HSV)" = "120$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '50%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '100%'; 'CGA number (name); alias' = '10 (high green); green'},
                [pscustomobject]@{Name = 'Green'; "Hex`r`n(RGB)" = '#008000'; "Red`r`n(RGB)" = '0%'; "Green`r`n(RGB)" = '50%'; "Blue`r`n(RGB)" = '0%'; "Hue`r`n(HSL/HSV)" = "120$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '25%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '50%'; 'CGA number (name); alias' = '02 (low green)'},
                [pscustomobject]@{Name = 'Aqua'; "Hex`r`n(RGB)" = '#00FFFF'; "Red`r`n(RGB)" = '0%'; "Green`r`n(RGB)" = '100%'; "Blue`r`n(RGB)" = '100%'; "Hue`r`n(HSL/HSV)" = "180$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '50%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '100%'; 'CGA number (name); alias' = '11 (high cyan); cyan'},
                [pscustomobject]@{Name = 'Teal'; "Hex`r`n(RGB)" = '#008080'; "Red`r`n(RGB)" = '0%'; "Green`r`n(RGB)" = '50%'; "Blue`r`n(RGB)" = '50%'; "Hue`r`n(HSL/HSV)" = "180$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '25%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '50%'; 'CGA number (name); alias' = '03 (low cyan)'},
                [pscustomobject]@{Name = 'Blue'; "Hex`r`n(RGB)" = '#0000FF'; "Red`r`n(RGB)" = '0%'; "Green`r`n(RGB)" = '0%'; "Blue`r`n(RGB)" = '100%'; "Hue`r`n(HSL/HSV)" = "240$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '50%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '100%'; 'CGA number (name); alias' = '09 (high blue)'},
                [pscustomobject]@{Name = 'Navy'; "Hex`r`n(RGB)" = '#000080'; "Red`r`n(RGB)" = '0%'; "Green`r`n(RGB)" = '0%'; "Blue`r`n(RGB)" = '50%'; "Hue`r`n(HSL/HSV)" = "240$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '25%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '50%'; 'CGA number (name); alias' = '01 (low blue)'},
                [pscustomobject]@{Name = 'Fuchsia'; "Hex`r`n(RGB)" = '#FF00FF'; "Red`r`n(RGB)" = '100%'; "Green`r`n(RGB)" = '0%'; "Blue`r`n(RGB)" = '100%'; "Hue`r`n(HSL/HSV)" = "300$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '50%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '100%'; 'CGA number (name); alias' = '13 (high magenta); magenta'},
                [pscustomobject]@{Name = 'Purple'; "Hex`r`n(RGB)" = '#800080'; "Red`r`n(RGB)" = '50%'; "Green`r`n(RGB)" = '0%'; "Blue`r`n(RGB)" = '50%'; "Hue`r`n(HSL/HSV)" = "300$([char]0x00b0)"; "Satur.`r`n(HSL)" = '100%'; "Light`r`n(HSL)" = '25%'; "Satur.`r`n(HSV)" = '100%'; "Value`r`n(HSV)" = '50%'; 'CGA number (name); alias' = '05 (low magenta)'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'https://html.com/tables/rowspan-colspan/ -TableIndex 0' {

            $Uri = 'https://html.com/tables/rowspan-colspan/'
            $Actual = Read-HTMLTable -Uri $Uri -TableIndex 0

            $Expected = [pscustomobject]@{"65`r`nMen" = "82"; "65`r`nWomen" = "85"; "40`r`nMen" = "78"; "40`r`nWomen" = "82"; "20`r`nMen" = "77"; "20`r`nWomen" = "81"}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'https://html.com/tables/rowspan-colspan/ -TableIndex 1' {

            $Uri = 'https://html.com/tables/rowspan-colspan/'
            $Actual = Read-HTMLTable -Uri $Uri -TableIndex 1

            $Expected =
                [pscustomobject]@{'Item / Desc.' = 'Paperclips (Box)'; 'Qty.' = '100'; '@' = '1.15'; Price = '115.00'},
                [pscustomobject]@{'Item / Desc.' = 'Paper (Case)'; 'Qty.' = '10'; '@' = '45.99'; Price = '459.90'},
                [pscustomobject]@{'Item / Desc.' = 'Wastepaper Baskets'; 'Qty.' = '2'; '@' = '17.99'; Price = '35.98'},
                [pscustomobject]@{'Item / Desc.' = 'Subtotal'; 'Qty.' = 'Subtotal'; '@' = 'Subtotal'; Price = '610.88'},
                [pscustomobject]@{'Item / Desc.' = 'Tax'; 'Qty.' = 'Tax'; '@' = '7%'; Price = '42.76'},
                [pscustomobject]@{'Item / Desc.' = 'Total'; 'Qty.' = 'Total'; '@' = 'Total'; Price = '653.64'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'https://html.com/tables/rowspan-colspan/ -TableIndex 2' {

            $Uri = 'https://html.com/tables/rowspan-colspan/'
            $Actual = Read-HTMLTable -Uri $Uri -TableIndex 2

            $Expected =
                [pscustomobject]@{'1' = 'Favorite'; '2' = 'Color'; Bob = 'Blue'; Alice = 'Purple'},
                [pscustomobject]@{'1' = 'Favorite'; '2' = 'Flavor'; Bob = 'Banana'; Alice = 'Chocolate'},
                [pscustomobject]@{'1' = "Least`r`nFavorite"; '2' = 'Color'; Bob = 'Yellow'; Alice = 'Pink'},
                [pscustomobject]@{'1' = "Least`r`nFavorite"; '2' = 'Flavor'; Bob = 'Mint'; Alice = 'Walnut'}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }
        
        It 'https://www.intel.com/content/www/us/en/products/details/nuc/kits.html-' {

            $Uri = 'https://www.intel.com/content/www/us/en/products/details/nuc/kits.html'
            $Actual = Read-HTMLTable -Uri $Uri

            $Expected =
                [pscustomobject]@{"Product Name" = "Intel$([char]0x00AE) NUC 12 Extreme Kit - NUC12DCMi9"; Status = "Launched"; "Processor Included" = "Intel$([char]0x00ae) Core$([char]0x2122) i9-12900 Processor (30M Cache, up to 5.10 GHz)"; "Graphics Output" = "2x Thunderbolt 4, HDMI 2.0b"; "Integrated Wireless$([char]0x2021)" = "Intel$([char]0x00AE) Wi-Fi 6E AX211(Gig+)"; Price = $Null},
                [pscustomobject]@{"Product Name" = "Intel$([char]0x00AE) NUC 12 Extreme Kit - NUC12DCMi7"; Status = "Launched"; "Processor Included" = "Intel$([char]0x00AE) Core$([char]0x2122) i7-12700 Processor (25M Cache, up to 4.90 GHz)"; "Graphics Output" = "2x Thunderbolt 4, HDMI 2.0b"; "Integrated Wireless$([char]0x2021)" = "Intel$([char]0x00AE) Wi-Fi 6E AX211(Gig+)"; Price = $Null}

            Compare-PSObject $Actual $Expected |Should -BeNullOrEmpty
        }

        It 'https://www.x-rates.com/table/?from=USD&amount=1' {

            $Uri = 'https://www.x-rates.com/table/?from=USD&amount=1'
            $Actual = Read-HTMLTable -Uri $Uri -TableIndex 1
            $Euro = $Actual |Where-Object 'US Dollar' -eq Euro
            [double]$Euro.'1.00 USD' |Should -BeGreaterThan 0
            [double]$Euro.'1.00 USD' |Should -BeLessThan $Euro.'inv. 1.00 USD'
        }
    }
}

