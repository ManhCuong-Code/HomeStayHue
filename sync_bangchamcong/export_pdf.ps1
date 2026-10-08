$word = New-Object -ComObject Word.Application
$word.Visible = $false
$doc = $word.Documents.Open('C:\Users\TUF\Desktop\BAO_CAO_SO_DO_UML_DU_AN_17.docx')
$pdf1 = 'C:\Users\TUF\Desktop\BAO_CAO_SO_DO_UML_DU_AN_17.pdf'
$pdf2 = 'C:\Users\TUF\Desktop\bangChamCong\BAO_CAO_SO_DO_UML_DU_AN_17.pdf'
$pdf3 = 'C:\Users\TUF\Desktop\HomeStayHue\BAO_CAO_SO_DO_UML_DU_AN_17.pdf'

$doc.SaveAs([ref]$pdf1, [ref]17)
$doc.SaveAs([ref]$pdf2, [ref]17)
$doc.SaveAs([ref]$pdf3, [ref]17)

$doc.Close()
$word.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
Write-Host "PDF exported successfully to Desktop, bangChamCong, and HomeStayHue!"
