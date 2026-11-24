# PeerReview- (`medpeer`)

Plugin Claude Code phản biện bài báo y khoa bằng đội sub-agent (mặc định chuyên ngành **ngoại thần kinh**, mở rộng được).

```
paper-intake ─► 5 reviewer song song ─► phản biện chéo (≤ 3 vòng) ─► editor ─► report.html (5–6 trang A4) + summary.html (1–2 trang A4)
```

| Agent | Vai trò |
|---|---|
| `paper-intake` | Trích PDF/DOI/PMID → `manuscript.md` có số dòng, phân loại thiết kế, chọn checklist |
| `methodology-reviewer` | PICO, thiết kế, kết cục, theo dõi |
| `statistics-reviewer` | Power, kiểm định, tính lại số liệu, MCID |
| `clinical-reviewer` | Phản biện lâm sàng theo module chuyên ngành |
| `bias-reviewer` | RoB 2 / ROBINS-I / QUADAS-2 / PROBAST, CONSORT/STROBE/PRISMA |
| `literature-ethics-reviewer` | Văn liệu, tính mới, đạo đức, COI |
| `editor` | Giải quyết bất đồng, quyết định, viết báo cáo |

## Cài đặt
```
/plugin marketplace add nhattrinhtran2000-ctrl/PeerReview-
/plugin install medpeer@medpeer-marketplace
```

## Dùng
```
/medpeer:review D:\papers\bai-bao.pdf
/medpeer:review 10.1056/NEJMoa0000000 --domain neurosurgery --rounds 3
```
Kết quả ở `peerreview-runs/<slug>/`: `report.html`, `summary.html`, `.md`, và PDF nếu có Chrome/Edge.
Mỗi phát hiện đều kèm trích dẫn + số dòng bản thảo. Không bao giờ quá 3 vòng tranh luận (dừng sớm khi hết bất đồng).

## Thêm chuyên ngành
Sao chép `skills/medical-peer-review/references/domains/_template.md` → `<tên>.md`, rồi `--domain <tên>`.

## Kiểm tra số trang
`scripts/export_pdf.py` (cần Python) hoặc `scripts/export_pdf.ps1` (Windows; có thể cần cho phép chạy script PowerShell; chưa kiểm chứng). Nếu không có, mở HTML và In → Lưu PDF; số trang có thể đo ước lượng trong trình duyệt (nội dung rộng 180 mm, mỗi trang ~263 mm).

> Báo cáo do AI tạo, cần chuyên gia kiểm chứng; không thay thế phán đoán lâm sàng. Tham khảo kiến trúc từ PeerReviewAgents và Agentic_Paper (MIT).
