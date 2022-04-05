## 2022-04-04 2.0.1 (iRon)
  - Fixed
    - Resolved [Invoke-WebRequest freezes / hangs](https://github.com/iRon7/Read-HtmlTable/issues/6) in Windows PowerShell (due to unicode?)
## 2022-04-04 2.0.0 (iRon)
  This versions has several break changes mainly in the available parameters  
  - Fixed
    - [#2 Multiple issues](https://github.com/iRon7/Read-HtmlTable/issues/5) - thanks [**@scriptingstudio**](https://github.com/scriptingstudio) for the feedback
      - `-Header` parameter not working
      - `-Uri` not working in **Windows PowerShell**
      - Trim all headers and data (by default)
  - New feature
    - [#3 Any `thead` row should be consider to be a header row](https://github.com/iRon7/Read-HtmlTable/issues/3)
    - [#4 Span overlapping](https://github.com/iRon7/Read-HtmlTable/issues/4)
    - [#5 Assume header rows by the containing th elements](https://github.com/iRon7/Read-HtmlTable/issues/5)
    - Improved (header) `rowspan` and `colspan` implementation
    - Changed parameters (including removing `-HeaderIndex`, use `-Header` parameter and `|Select-Object -Skip`)
## 2022-02-22 1.0.6 (iRon)
  - New feature
    - Implemented thead and tbody recognision
## 2021-05-29 1.0.1(iRon)
  - Fixes
    - Fixed issue with https://winreleaseinfoprod.blob.core.windows.net/winreleaseinfoprod/en-US.html
## 2021-05-09 1.0.0 (iRon)
  - First release
