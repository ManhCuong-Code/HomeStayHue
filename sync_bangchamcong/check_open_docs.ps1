try {
    $word = [System.Runtime.InteropServices.Marshal]::GetActiveObject('Word.Application')
    Write-Host "Word application is running. Open documents:"
    foreach ($doc in $word.Documents) {
        Write-Host " - FullName: $($doc.FullName)"
        Write-Host "   Saved: $($doc.Saved)"
        Write-Host "   ReadOnly: $($doc.ReadOnly)"
    }
} catch {
    Write-Host "Could not get active Word object: $($_.Exception.Message)"
}
