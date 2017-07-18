param (
  [string]$server = "http://defaultserver",
  [string]$filename = "",
  [string]$outputdir = ""
  # [string]$extractfile = ""
 )

# global variables
$global:lastpercentage = -1
$global:are = New-Object System.Threading.AutoResetEvent $false
file = [System.IO.Path]::GetFileName($server)
# [System.IO.Path]::GetFileNameWithoutExtension("c:\foo.txt") returns foo


# web client
# (!) output is buffered to disk -> great speed
$wc = New-Object System.Net.WebClient

Register-ObjectEvent -InputObject $wc -EventName DownloadProgressChanged -Action {
    # (!) getting event args
    $percentage = $event.sourceEventArgs.ProgressPercentage
    if($global:lastpercentage -lt $percentage)
    {
        $global:lastpercentage = $percentage
        # stackoverflow.com/questions/3896258
        Write-Host -NoNewline "`r$percentage%"
    }
} > $null

Register-ObjectEvent -InputObject $wc -EventName DownloadFileCompleted -Action {
    $global:are.Set()
    Write-Host
} > $null

$wc.DownloadFileAsync($server, "$outputdir\$filename");
# ps script runs probably in one thread only (event is reised in same thread - blocking problems)
# $global:are.WaitOne() not work
# If [IO.Path]::GetExtension("$outputdir\$filename") -eq '.7z' {
  # If not $extractfile = "" Unzip "$outputdir\$filename" "$extractfile"
# }
while(!$global:are.WaitOne(500)) {}

function Unzip
{
  param(
    [string]$zipfile,
    [string]$outpath
  )
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}