#!/usr/bin/env python3
"""In report.html / summary.html ra PDF bằng Chrome/Edge headless, đếm trang và kiểm tra giới hạn.
Dùng: python export_pdf.py <RUN_DIR>"""
import re, shutil, subprocess, sys
from pathlib import Path

LIMITS = {"report": (5, 6), "summary": (1, 2)}
CANDIDATES = [
    "chrome", "google-chrome", "chromium", "msedge",
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
]

def find_browser():
    for c in CANDIDATES:
        p = shutil.which(c) or (c if Path(c).exists() else None)
        if p: return p

def main(run):
    run = Path(run).resolve()
    br = find_browser()
    if not br:
        print("Không tìm thấy Chrome/Edge: bỏ qua xuất PDF và đếm trang (mở HTML và In → Lưu PDF)."); return 0
    bad = 0
    for name, (lo, hi) in LIMITS.items():
        html = run / f"{name}.html"
        if not html.exists(): print(f"THIẾU {html}"); bad += 1; continue
        pdf = run / f"{name}.pdf"
        subprocess.run([br, "--headless=new", "--disable-gpu", "--no-pdf-header-footer",
                        f"--print-to-pdf={pdf}", html.as_uri()], capture_output=True, timeout=120)
        if not pdf.exists(): print(f"Không xuất được {pdf}"); bad += 1; continue
        n = len(re.findall(rb"/Type\s*/Page[^s]", pdf.read_bytes()))
        ok = lo <= n <= hi
        print(f"{name}: {n} trang A4 (yêu cầu {lo}-{hi}) -> {'OK' if ok else 'SAI, cần rút gọn/bổ sung'}")
        bad += 0 if ok else 1
    return 1 if bad else 0

if __name__ == "__main__":
    if len(sys.argv) != 2: sys.exit(__doc__)
    sys.exit(main(sys.argv[1]))
