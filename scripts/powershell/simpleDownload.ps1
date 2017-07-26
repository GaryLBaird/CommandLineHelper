Param(
  [string]$url = "",
  [string]$file = ""
)
$targetFile = [io.path]::GetFileName($file)
$targetDir = [io.path]::GetDirectoryName($file)
If(!(test-path $targetDir))
{
New-Item -ItemType Directory -Force -Path $targetDir
}

$path = Join-Path $targetDir $targetFile
$client = New-Object System.Net.WebClient
$client.DownloadFile($url, $path)