Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('C:\Users\TUF\Desktop\HomeStayHue\BAO_CAO_THIET_KE_UML_HOMESTAY_HUE.docx')
Write-Host "Images in BAO_CAO_THIET_KE_UML_HOMESTAY_HUE.docx:"
$count = 0
foreach ($entry in $zip.Entries) {
    if ($entry.FullName -like 'word/media/*') {
        $count++
        Write-Host " - $($entry.FullName): $($entry.Length) bytes"
    }
}
Write-Host "Total images: $count"
$zip.Dispose()
