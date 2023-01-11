REM
REM   - Guide: https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc732459(v=ws.11)
REM   - POSH Searching: https://devblogs.microsoft.com/scripting/use-an-easy-powershell-command-to-search-files-for-information/
REM
REM
REM
REM Keywords to search:
REM
REM             IP types:       strap, QBR, Key Account Data (or KA), Privileged, Attorney, Attorney Work Product, Strategy
REM
REM     FINDSTR [/B] [/E] [/L] [/R] [/S] [/I] [/X] [/V] [/N] [/M] [/O] [/P] [/F:file]
REM        [/C:string] [/G:file] [/D:dir list] [/A:color attributes] [/OFF[LINE]]
REM        strings [[drive:][path]filename[ ...]]
REM
REM             /s                      search for matching files in curdir and all subdirs
REM             /i                      case-insensitive
REM             /C:string       Use specified string as a literal search string
REM             /F:file         Input file list to search as targets
REM             /G:files        Input file of keywords to search for
REM             /D:dir;dir      Search in provided directories, ; separated
REM
REM ======================================================================================
REM
REM
REM password in french = "mot de passe"
REM
REM
REM ==========================================================================================




REM Find files of interest on a Windows system
findstr /si password *.xml *.ini *.sql *.txt *.vbs *.cmd *.ps1 *.bat *.inf *.eml *.msg *.config *.pdf *.xls *.xlsx *.xlsm *.doc *.docx *.ppt *.pptx *.vsdx
findstr /si RSA *.xml *.ini *.sql *.txt *.vbs *.cmd *.ps1 *.bat *.inf *.eml *.config


REM what about .rar or .zip? -- findstr can't search for strings
REM   inside archive files, it's a known limitation


REM Search for all PDFs
dir /a /s /b c:\*.pdf*
REM Search for all zip's
dir /a /s /b c:\*.zip*



REM Output a complete tree dir listing of the system
tree /F /A c:\ > tree.txt



REM Looking for passwords in C:\ drive
cd C:\ & findstr /SI /M /X /N "password" *.xml *.ini *.txt
findstr /si password *.xml *.ini *.txt *.config
findstr /spin "password" *.*

REM Looking for other credentials in C:\ drive
cd C:\ & findstr /SI /M "admin" *.xml *.ini *.txt
findstr /si admin *.xml *.ini *.txt *.config
findstr /spin "admin" *.*

REM Looking for interesting information in the registry
reg query HKLM /f password /t REG_SZ /s

REM If output too long, can pipe the results into a file for later parsing, as follows
findstr /SI /M "password" *.xml *.ini *.txt > PC1_output.txt



REM Look for confidential files (will search all files if you leave off file extensions like above)
findstr /SI /M "confidential"




REM ----------------
REM   PowerShell
REM ----------------


REM Get the host's powershell version
Get-Host | Select-Object Version


REM Search for strings using POSH instead of CMD, only searches in filenames
Get-Childitem -Path C:\ -Include *.docx *.xlsx *.pdf -Recurse -File -force -ErrorAction SilentlyContinue >> C:\Windows\Temp\search-results1.csv



REM My search string for real world use
REM Search files but only those modified in past 1 year
Get-Childitem -Path D:\ -Include *.docx, *.xlsx, *.pdf -Recurse -File -force -ErrorAction SilentlyContinue | ? {$_.LastWriteTime -gt (Get-Date).AddDays(-365)} | Select-String "confidential" -ErrorAction SilentlyContinue >> C:\Windows\Temp\search-results-conf.csv



Get-Childitem -Path D:\ -Include *.txt, *.doc, *.docx, *.xlsx, *.xls, *.xlsm, *.pdf, *.msg, *.eml, *.vsdx, *.ppt, *.pptx, *.dwg -Recurse -File -force -ErrorAction SilentlyContinue | ? {$_.LastWriteTime -gt (Get-Date).AddDays(-365)} | Select-String "password" -ErrorAction SilentlyContinue



REM Searching file contents for keywords examples
Get-ChildItem C:\temp -Filter *.log -Recurse | Select-String "sensitive"

REM If you have to copy all the files with specific content, you can simply add a Copy-Item cmdlet
Get-ChildItem C:\temp -Filter *.log -Recurse | Select-String "sensitive" | Copy-Item -Destination C:\temp2


REM Get files modified in the past year
(Get-ChildItem -Path c:\pstbak\*.* -Filter *.pst | ? {
  $_.LastWriteTime -gt (Get-Date).AddDays(-3)
}).Count

REM or this way
Get-ChildItem -Path . -Recurse | ? {$_.LastWriteTime -gt (Get-Date).AddDays(-4)}

Get-ChildItem -Path C:\ -Include y.js -File -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path C:\ -Include *.sql * -File -Recurse -ErrorAction SilentlyContinue




REM ==========================================================================================



REM -- Select-String Syntax
REM
REM Select-String [-Path] <string[]> [-Pattern] <string[]> [-AllMatches] [-CaseSensitive] [-Context <Int32[]>] [-Encoding <string>] [-Exclude <string[]>] [-Include <string[]>] [-List] [-NotMatch] [-Quiet] [-SimpleMatch] [<CommonParameters>]

REM Select-String -InputObject <psobject> [-Pattern] <string[]> [-AllMatches] [-CaseSensitive] [-Context <Int32[]>] [-Encoding <string>] [-Exclude <string[]>] [-Include <string[]>] [-List] [-NotMatch] [-Quiet] [-SimpleMatch] [<CommonParameters>]




REM -- FINDSTR Syntax
REM
REM     FINDSTR [/B] [/E] [/L] [/R] [/S] [/I] [/X] [/V] [/N] [/M] [/O] [/P] [/F:file]
REM        [/C:string] [/G:file] [/D:dir list] [/A:color attributes] [/OFF[LINE]]
REM        strings [[drive:][path]filename[ ...]]

REM             /s                      search for matching files in curdir and all subdirs
REM             /i                      case-insensitive
REM             /C:string       Use specified string as a literal search string
REM             /F:file         Input file list to search as targets
REM             /G:files        Input file of keywords to search for
REM             /D:dir;dir      Search in provided directories, ; separated
REM             /M                      Prints only the filename if a file contains a match
REM             /N                      Print line number before each line that matches
REM             /X                      Print the lines that match exactly


REM ==========================================================================================
