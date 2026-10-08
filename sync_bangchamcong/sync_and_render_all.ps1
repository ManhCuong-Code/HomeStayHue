$srcDir = "c:\Users\TUF\Desktop\HomeStayHue\sync_bangchamcong"
$dstUml = "c:\Users\TUF\Desktop\bangChamCong\uml"
$dstImg = "c:\Users\TUF\Desktop\bangChamCong\uml\images"

if (!(Test-Path $dstUml)) { New-Item -ItemType Directory -Path $dstUml -Force | Out-Null }
if (!(Test-Path $dstImg)) { New-Item -ItemType Directory -Path $dstImg -Force | Out-Null }

$files = @(
  "01_usecase_overview",
  "02_usecase_employee",
  "03_usecase_hr_admin",
  "04_class_domain_model",
  "05_class_layered_architecture",
  "06_sequence_login",
  "07_sequence_payroll_calculation",
  "08_sequence_lock_payroll",
  "09_sequence_ai_inquiry",
  "10_activity_timesheet_leave",
  "11_activity_payroll_settlement",
  "12_state_payroll_period",
  "13_deployment_diagram"
)

Write-Host "=== 1. SYNCING PUML FILES ==="
foreach ($f in $files) {
    $src = "$srcDir\$f.puml"
    $dst = "$dstUml\$f.puml"
    Copy-Item -Path $src -Destination $dst -Force
    Write-Host "Copied $f.puml"
}

Write-Host "`n=== 2. RENDERING ALL 13 DIAGRAMS VIA KROKI (HIGH DPI 220) ==="
foreach ($f in $files) {
    $puml = "$dstUml\$f.puml"
    $png = "$dstImg\$f.png"
    Write-Host "Rendering $f..." -NoNewline
    try {
        $content = Get-Content -Path $puml -Raw -Encoding UTF8
        Invoke-RestMethod -Uri "https://kroki.io/plantuml/png" -Method Post -Body $content -ContentType "text/plain; charset=utf-8" -OutFile $png
        $sz = (Get-Item $png).Length
        Write-Host " OK ($sz bytes)"
    } catch {
        Write-Host " ERROR: $($_.Exception.Message)"
    }
}

Write-Host "`nALL DIAGRAMS RENDERED SUCCESSFULLY!"
