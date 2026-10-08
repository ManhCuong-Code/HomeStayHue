$content = Get-Content -Path 'c:\Users\TUF\Desktop\HomeStayHue\sync_bangchamcong\06_sequence_login.puml' -Raw -Encoding UTF8
try {
    $res = Invoke-RestMethod -Uri 'https://kroki.io/plantuml/png' -Method Post -Body $content -ContentType 'text/plain; charset=utf-8'
    Write-Host "Success!"
} catch {
    $stream = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($stream)
    Write-Host "ERROR RESPONSE:"
    Write-Host $reader.ReadToEnd()
}
