Function Info([string] $msg) {
    Write-Host -ForegroundColor DarkGreen "`nINFO: $msg`n"
}

Function Error([string] $msg) {
  Write-Host `n`n
  Write-Error $msg
  exit 1
}

class Patcher {
  static [void] ApplyPatch([System.IO.FileInfo] $patchFile, [System.IO.FileInfo] $fileToPatch, [System.IO.FileInfo] $outputFile) {
    Info "Apply patch`n $patchFile `n to $fileToPatch"

    $bytes = [System.IO.File]::ReadAllBytes($fileToPatch);
    foreach($line in Get-Content $patchFile) {
      if($line.StartsWith("#") -or $line.StartsWith("Comparing files ")) {
        continue
      }

      $line -match "^(?<address>[0-9A-F]{8}): (?<oldByte>[0-9A-F]{2}) (?<newByte>[0-9A-F]{2}).*"
      $address = [Convert]::ToInt64($Matches["address"], 16)
      $oldByte = [Convert]::ToInt32($Matches["oldByte"], 16)
      $newByte =  [Convert]::ToInt32($Matches["newByte"] , 16)

      if ($bytes[$address] -ne $oldByte) {
        Error "while processing line '$line': mismatch between the patch and an input file"
      }

      $bytes[$address] = $newbyte
    }

    [Patcher]::_CreateFileWithContent($outputFile, $bytes)
  }

  static [void] _CreateFileWithContent([System.IO.FileInfo] $file, [byte[]] $bytes) {
    Info "Create file '$file' filled with provided bytes"
    New-Item -Force -ItemType "directory" $file.Directory.FullName > $null
    [System.IO.File]::WriteAllBytes($file, $bytes)
  }
}

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$root = Resolve-Path "$PSScriptRoot"
$buildDir = "$root/Build"
$srcDir = "$root/Src"

[Patcher]::ApplyPatch(
  "$srcDir/Handle/handle64_v5.0_UnicodeSupportPatch.txt",
  "$srcDir/Handle/handle64_v5.0_original.exe",
  "$buildDir/handle64_v5.0_Unicode.exe")

[Patcher]::ApplyPatch(
  "$srcDir/Du/du_v1.62_x86_UnicodeSupportPatch.txt",
  "$srcDir/Du/du_v1.62_original.exe",
  "$buildDir/du_v1.62_Unicode.exe")

[Patcher]::ApplyPatch(
  "$srcDir/AccessChk/accesschk_v6.15_x86_UnicodeSupportPatch.txt",
  "$srcDir/AccessChk/accesschk_v6.15_original.exe",
  "$buildDir/accesschk_v6.15_Unicode.exe")

[Patcher]::ApplyPatch(
  "$srcDir/Junction/junction_v1.07_x86_UnicodeSupportPatch.txt",
  "$srcDir/Junction/junction_v1.07_original.exe",
  "$buildDir/junction_v1.07_Unicode.exe")

[Patcher]::ApplyPatch(
  "$srcDir/Streams/streams_v1.60_x86_UnicodeSupportPatch.txt",
  "$srcDir/Streams/streams_v1.60_original.exe",
  "$buildDir/streams_v1.60_Unicode.exe")

Info "Create zip archive from patched executables"
Compress-Archive -Force -Path "$buildDir/*.exe" -DestinationPath "$buildDir/Sysinternals console utils with Unicode support.zip"
