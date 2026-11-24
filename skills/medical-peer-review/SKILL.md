---
name: medical-peer-review
description: Quy trình điều phối phản biện bài báo y khoa bằng nhiều sub-agent, tranh luận chéo tối đa 3 vòng, editor tổng hợp thành báo cáo HTML A4. Dùng khi người dùng yêu cầu phản biện/critical appraisal/journal club một bài báo y khoa (đặc biệt ngoại thần kinh).
---

# Quy trình `medpeer`

`PLUGIN_ROOT` = thư mục chứa `.claude-plugin/plugin.json` (cha của `skills/`). Luôn truyền đường dẫn tuyệt đối `PLUGIN_ROOT` và `RUN_DIR` cho mọi sub-agent.

## 0. Chuẩn bị
- `slug` = tên rút gọn từ tiêu đề/DOI; `RUN_DIR` = `./peerreview-runs/<slug>/` (tạo `round0/ round1/ round2/ round3/`).
- Tham số: `--domain` (mặc định `neurosurgery`; module nằm ở `references/domains/<module>.md`, nếu không có thì dùng `general.md`), `--lang` (mặc định `vi`), `--rounds` (1–3, trần cứng là 3).

## 1. Intake
Gọi `paper-intake` → `manuscript.md`, `intake.json`. Nếu chỉ có abstract, cảnh báo người dùng và ghi hạn chế vào báo cáo.

## 2. Vòng 0 (song song, độc lập)
Gọi trong MỘT tin nhắn 5 sub-agent: `methodology-reviewer`, `statistics-reviewer`, `clinical-reviewer`, `bias-reviewer`, `literature-ethics-reviewer`. Prompt mỗi agent gồm: RUN_DIR, PLUGIN_ROOT, ngôn ngữ, "ghi vào round0/<tên>.md". Agent không thấy bài của nhau ở vòng này (tránh anchoring).

## 3. Vòng phản biện chéo K = 1..N (N ≤ 3)
Với mỗi K, gọi song song 5 reviewer, đưa cho mỗi người: các file `round(K-1)/*.md` của TẤT CẢ reviewer, yêu cầu viết `roundK/<tên>.md` (Đồng ý / Bác bỏ / Điều chỉnh mức độ / Còn tranh cãi).
**Điều kiện dừng sớm**: sau vòng K, lập bảng bất đồng; nếu không còn mục "Còn tranh cãi" mới hoặc không mức độ nào thay đổi so với vòng trước → dừng. **Tuyệt đối không chạy vòng thứ 4.**

## 4. Editor
Gọi `editor` với RUN_DIR, PLUGIN_ROOT, ngôn ngữ. Đầu ra: `report.html`, `summary.html`, `report.md`, `summary.md`.

## 5. Kiểm tra độ dài
`python "$PLUGIN_ROOT/scripts/export_pdf.py" "$RUN_DIR"` (hoặc trên Windows không có Python: `powershell -File "$PLUGIN_ROOT/scripts/export_pdf.ps1" "$RUN_DIR"`) — in số trang của mỗi file và xuất PDF nếu có Chrome/Edge. Yêu cầu: report 5–6 trang, summary 1–2 trang. Sai → editor sửa (≤2 lần).

## 6. Báo cáo cho người dùng
Đường dẫn file, quyết định tổng, 3 vấn đề nghiêm trọng nhất, số vòng đã chạy và lý do dừng. Nhắc: kết quả do AI tạo, cần chuyên gia kiểm chứng.

## Mở rộng chuyên ngành
Sao chép `references/domains/_template.md` thành `<chuyên-ngành>.md`, điền các mục, rồi dùng `--domain <chuyên-ngành>`.

## Lưu ý đã rút ra từ thử nghiệm (ARUBA 2014)
- Reviewer ở vòng phản biện chéo phải đọc nguyên văn file của người khác (xem "Cách đọc file" trong mỗi agent). Điều phối viên nên dặn thêm trong prompt và, nếu một agent báo chỉ đọc được bản tóm tắt, chạy lại agent đó hoặc ghi hạn chế vào báo cáo.
- Điều kiện dừng: nếu còn mục "Còn tranh cãi" sau vòng 1 thì chạy vòng chốt (vòng 2), tối đa vòng 3; mọi điểm không giải quyết được từ bản thảo phải được editor ghi là "chưa xác minh".
- Không dùng tài liệu ngoài bản thảo để ra quyết định nếu chưa xác minh trực tiếp (ví dụ hồ sơ đăng ký trial).
