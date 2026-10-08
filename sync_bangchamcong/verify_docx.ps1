$word = New-Object -ComObject Word.Application
$word.Visible = $false
$doc = $word.Documents.Open('C:\Users\TUF\Desktop\bangChamCong\BAO_CAO_SO_DO_UML_DU_AN_17.docx', $false, $true)
$pages = $doc.ComputeStatistics(2)
$shapes = $doc.InlineShapes.Count
$paras = $doc.Paragraphs.Count
$tables = $doc.Tables.Count
Write-Host "DOCX Statistics:"
Write-Host "- Total Pages: $pages"
Write-Host "- Total Embedded Shapes/Images: $shapes"
Write-Host "- Total Paragraphs: $paras"
Write-Host "- Total Tables: $tables"
$doc.Close()
$word.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
