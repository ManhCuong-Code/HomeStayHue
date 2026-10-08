$target = "c:\Users\TUF\Desktop\HomeStayHue\sync_bangchamcong\build_word_doc.ps1"
$rawBytes = [System.IO.File]::ReadAllBytes($target)
$bom = [byte[]]@(0xEF, 0xBB, 0xBF)
if ($rawBytes.Length -ge 3 -and $rawBytes[0] -eq 0xEF -and $rawBytes[1] -eq 0xBB -and $rawBytes[2] -eq 0xBF) {
    Write-Host "Already has BOM"
} else {
    $newBytes = $bom + $rawBytes
    [System.IO.File]::WriteAllBytes($target, $newBytes)
    Write-Host "Added UTF-8 BOM successfully, total bytes: $($newBytes.Length)"
}
