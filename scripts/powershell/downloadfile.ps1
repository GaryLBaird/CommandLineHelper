Param(
 [Parameter(Mandatory=$true)][string]$url = "",
 [Parameter(Mandatory=$true)][string]$file = "",
 [Parameter(Mandatory=$true)][string]$dir = "",
 [string]$Unpack = False
)

function Get-Download($url, $targetFile, $targetDir)
{
  If(!(test-path $targetDir))
  {
  New-Item -ItemType Directory -Force -Path $targetDir
  }
  $path = Join-Path $targetDir $targetFile
  "Downloading $url" 
  $uri = New-Object "System.Uri" "$url"
  $request = [System.Net.HttpWebRequest]::Create($uri)
  $request.set_Timeout(15000) #15 second timeout
  $response = $request.GetResponse()
  $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)
  $responseStream = $response.GetResponseStream()
  $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $path, Create
  $buffer = new-object byte[] 10KB
  $count = $responseStream.Read($buffer,0,$buffer.length)
  $downloadedBytes = $count
  while ($count -gt 0)
  {
    $targetStream.Write($buffer, 0, $count)
    $count = $responseStream.Read($buffer,0,$buffer.length)
    $downloadedBytes = $downloadedBytes + $count
    Write-Progress -activity "Downloading file '$($url.split('/') | Select -Last 1)'" -status "Downloaded ($([System.Math]::Floor($downloadedBytes/1024))K of $($totalLength)K): " -PercentComplete ((([System.Math]::Floor($downloadedBytes/1024)) / $totalLength)  * 100)
  }
  Write-Progress -activity "Finished downloading file '$($url.split('/') | Select -Last 1)'"
  $targetStream.Flush()
  $targetStream.Close()
  $targetStream.Dispose()
  $responseStream.Dispose()
}

Get-Download $url $file $dir
