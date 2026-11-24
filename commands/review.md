---
description: Phản biện một bài báo y khoa (PDF/DOI/PMID/link) bằng đội sub-agent, tranh luận ≤3 vòng, xuất báo cáo HTML A4 + tóm tắt
argument-hint: <đường-dẫn-PDF | DOI | PMID | URL> [--domain neurosurgery|general|<module>] [--lang vi|en] [--rounds 1-3]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, WebSearch, Agent
---

Bạn là **điều phối viên (orchestrator)** của quy trình phản biện `medpeer`. Hãy nạp skill `medical-peer-review` và làm theo ĐÚNG quy trình trong đó. Đầu vào: `$ARGUMENTS`.

Tóm tắt các bước (chi tiết ở skill):

1. **Phân tích tham số**: nguồn bài báo, `--domain` (mặc định `neurosurgery`), `--lang` (mặc định `vi`), `--rounds` (mặc định 3, tối đa 3 — không bao giờ vượt quá 3).
2. **Intake**: gọi sub-agent `paper-intake` để tạo `peerreview-runs/<slug>/manuscript.md` (có số dòng) và `intake.json` (thiết kế nghiên cứu, bộ checklist áp dụng).
3. **Vòng 0 – phản biện độc lập**: gọi SONG SONG 5 reviewer: `methodology-reviewer`, `statistics-reviewer`, `clinical-reviewer`, `bias-reviewer`, `literature-ethics-reviewer`. Mỗi người ghi `round0/<agent>.md`.
4. **Vòng 1..N – phản biện chéo** (N ≤ 3): mỗi reviewer đọc phát hiện của bốn người còn lại, rồi đồng ý / bác bỏ / nâng-hạ mức độ có dẫn chứng. Dừng sớm nếu một vòng không còn bất đồng mới.
5. **Editor**: gọi `editor` để hợp nhất, giải quyết bất đồng, ra quyết định và viết `report.html` (5–6 trang A4) + `summary.html` (1–2 trang A4) + bản `.md`.
6. **Kiểm tra độ dài**: chạy `scripts/export_pdf.py` để đếm trang; nếu vượt giới hạn, yêu cầu editor rút gọn rồi chạy lại (tối đa 2 lần).
7. Báo cho người dùng đường dẫn các file đầu ra và 5 dòng tóm lược kết luận.
