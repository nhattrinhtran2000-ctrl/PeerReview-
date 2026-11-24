# In report.html / summary.html ra PDF bằng Edge/Chrome headless và đếm trang. Dùng: .\export_pdf.ps1 <RUN_DIR>
param([Parameter(Mandatory=$true)][string]$RunDir)
$limits = @{ report = @(5,6); summary = @(1,2) }
$cands = @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe","${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe","${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe","$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe")
$br = $cands | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $br) { Write-Output "Không tìm thấy Chrome/Edge: mở HTML rồi In -> Lưu PDF."; exit 0 }
$run = (Resolve-Path $RunDir).Path; $bad = 0
foreach ($n in $limits.Keys) {
  $html = Join-Path $run "$n.html"; $pdf = Join-Path $run "$n.pdf"
  if (-not (Test-Path $html)) { Write-Output "THIẾU $html"; $bad++; continue }
  Remove-Item $pdf -ErrorAction SilentlyContinue
  & $br --headless=new --disable-gpu --no-pdf-header-footer "--print-to-pdf=$pdf" ([uri]$html).AbsoluteUri | Out-Null
  for ($i=0; $i -lt 30 -and -not (Test-Path $pdf); $i++) { Start-Sleep -Milliseconds 500 }
  if (-not (Test-Path $pdf)) { Write-Output "Không xuất được $pdf"; $bad++; continue }
  $txt = [Text.Encoding]::GetEncoding(28591).GetString([IO.File]::ReadAllBytes($pdf))
  $cnt = ([regex]::Matches($txt, '/Type\s*/Page[^s]')).Count
  $lo,$hi = $limits[$n]; $ok = ($cnt -ge $lo -and $cnt -le $hi)
  Write-Output ("{0}: {1} trang A4 (yêu cầu {2}-{3}) -> {4}" -f $n,$cnt,$lo,$hi,$(if($ok){"OK"}else{"SAI, cần chỉnh độ dài"}))
  if (-not $ok) { $bad++ }
}
exit $(if ($bad) {1} else {0})
