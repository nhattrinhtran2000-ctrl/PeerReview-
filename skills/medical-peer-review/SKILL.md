---
name: medical-peer-review
description: Quy trình điều phối phản biện LÂM SÀNG một bài báo y khoa bằng nhiều sub-agent tranh luận ≤3 vòng, có kiểm chứng EBM (guideline, PubMed, chuyên gia), editor tổng hợp thành báo cáo HTML A4. Dùng khi người dùng yêu cầu phản biện/critical appraisal/journal club một bài báo y khoa (đặc biệt ngoại thần kinh).
---

# Quy trình `medpeer` (phản biện lâm sàng)

`PLUGIN_ROOT` = thư mục chứa `.claude-plugin/plugin.json`. Luôn truyền đường dẫn tuyệt đối `PLUGIN_ROOT` và `RUN_DIR` cho mọi sub-agent.

## 0. Chuẩn bị
`slug` ngắn từ tiêu đề; `RUN_DIR=./peerreview-runs/<slug>/` (tạo `round0/ round1/ round2/ round3/`). Tham số: `--domain` (mặc định `neurosurgery`; không có module thì `general`), `--lang` (mặc định `vi`), `--rounds` (1–3; trần cứng 3).

## 1. Intake và digest
1. `paper-intake` → `manuscript.md`, `intake.json`.
2. `study-interpreter` → `digest.md` (thiết kế + kết quả + diễn giải lâm sàng, giới hạn do tác giả nêu).

## 2. Vòng 0 — sáu agent song song, độc lập
Trong MỘT tin nhắn, gọi: `trial-advocate`, `population-reviewer`, `intervention-reviewer`, `outcomes-reviewer`, `evidence-context-reviewer`, `expert-critique-reviewer`. Mỗi agent ghi `round0/<tên>.md`. Nhắc rõ: đọc nguyên văn, kiểm chứng EBM bằng công cụ, không bịa nguồn.

## 3. Vòng phản biện chéo K = 1..N (N ≤ 3)
Gọi song song cả sáu; mỗi agent đọc NGUYÊN VĂN `round(K-1)/*.md` của tất cả và ghi `roundK/<tên>.md`. Cách dặn: "đọc bằng Bash `cat`, không dùng công cụ trả về bản tóm tắt".
**Dừng sớm** nếu sau vòng K không còn "Còn tranh cãi" mới và không mức độ nào đổi. Còn tranh cãi thì chạy vòng kế, **không bao giờ quá vòng 3**. Điểm không giải quyết được từ bản thảo/nguồn → editor ghi "chưa xác minh".

## 4. Editor
Gọi `editor` → `report.html` (5–6 trang A4), `summary.html` (1–2 trang A4), `.md`.

## 5. Kiểm tra độ dài
`python "$PLUGIN_ROOT/scripts/export_pdf.py" "$RUN_DIR"` (Windows không có Python: `powershell -File "$PLUGIN_ROOT/scripts/export_pdf.ps1" "$RUN_DIR"`). Hoặc đo trong trình duyệt: đặt body rộng 180 mm, mỗi trang A4 ≈ 263 mm nội dung. Sai giới hạn → editor sửa (≤2 lần).

## 6. Báo cáo cho người dùng
Đường dẫn file, quyết định/thông điệp lâm sàng chính, số vòng và lý do dừng, các điểm "chưa xác minh". Nhắc: do AI tạo, cần chuyên gia kiểm chứng.

## Mở rộng chuyên ngành
Sao chép `references/domains/_template.md` → `<tên>.md`; dùng `--domain <tên>`.
