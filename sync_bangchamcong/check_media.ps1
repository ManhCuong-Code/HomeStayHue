Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('C:\Users\TUF\Desktop\bangChamCong\BAO_CAO_SO_DO_UML_DU_AN_17.docx')
Write-Host "Media files inside docx:"
foreach ($entry in $zip.Entries) {
    if ($entry.FullName -like 'word/media/*') {
        Write-Host " - $($entry.FullName): $($entry.Length) bytes"
    }
}
$zip.Dispose()
