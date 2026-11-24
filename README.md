# PeerReview- (`medpeer`)

Plugin Claude Code **phản biện lâm sàng** bài báo y khoa bằng nhóm sub-agent tranh luận, có kiểm chứng EBM (guideline các hiệp hội, PubMed/OpenEvidence/web, chỉ trích của chuyên gia đầu ngành). Mặc định chuyên ngành **ngoại thần kinh**, mở rộng được.

```
paper-intake → study-interpreter (digest) → 6 agent lâm sàng song song
   → phản biện chéo (≤ 3 vòng, dừng sớm khi hết bất đồng) → editor
   → report.html (5–6 trang A4) + summary.html (1–2 trang A4)
```

| Agent | Vai trò |
|---|---|
| `paper-intake` | Trích PDF/DOI/PMID → `manuscript.md` có số dòng, `intake.json` |
| `study-interpreter` | Tóm tắt thiết kế + kết quả kèm diễn giải (nguy cơ tuyệt đối, NNT, theo năm) |
| `trial-advocate` | Biện hộ: điểm mạnh, điều đáng tin, đóng góp |
| `population-reviewer` | Chọn lọc bệnh nhân, phân độ nặng (vd Spetzler-Martin), khái quát hoá |
| `intervention-reviewer` | Tính đồng nhất của nhóm can thiệp, chọn phương thức, kinh nghiệm, so chuẩn thực hành |
| `outcomes-reviewer` | Kết cục, an toàn, thời gian theo dõi so với diễn tiến tự nhiên |
| `evidence-context-reviewer` | Guideline hiệp hội trước/sau bài, bằng chứng sau đó; bài thay đổi gì |
| `expert-critique-reviewer` | Điểm yếu do tác giả nêu + phê bình của chuyên gia đầu ngành (có nguồn) |
| `editor` | Hợp nhất, phán quyết bất đồng, viết báo cáo |

Phương pháp luận/thống kê/đạo đức chỉ được nêu khi ảnh hưởng đến diễn giải lâm sàng.

## Cấu trúc báo cáo
Bối cảnh → Thiết kế (diễn giải) → Kết quả + diễn giải → Điểm mạnh → Điều rút ra và vị trí so với quan điểm hiện nay → Điểm yếu (tác giả nêu / chuyên gia phê bình / hội đồng, kèm nguồn) → Bất đồng và phán quyết → Thông điệp thực hành → Tài liệu tham khảo (đã xác minh / chưa xác minh).

## Cài đặt
```
/plugin marketplace add nhattrinhtran2000-ctrl/PeerReview-
/plugin install medpeer@medpeer-marketplace
```

## Dùng
```
/medpeer:review D:\papers\bai-bao.pdf
/medpeer:review 10.1016/S0140-6736(13)62302-8 --domain neurosurgery --rounds 3
```
Kết quả ở `peerreview-runs/<slug>/`. Mọi nhận định ngoài bài phải có nguồn xác minh; không xác minh được thì ghi "chưa xác minh" và không dùng để kết luận.

## Thêm chuyên ngành
Sao chép `skills/medical-peer-review/references/domains/_template.md` → `<tên>.md`, rồi `--domain <tên>`.

## Kiểm tra số trang
`scripts/export_pdf.py` (cần Python) hoặc `scripts/export_pdf.ps1` (Windows; có thể cần cho phép chạy script PowerShell; chưa kiểm chứng). Hoặc đo trong trình duyệt: nội dung rộng 180 mm, mỗi trang A4 ≈ 263 mm.

> Báo cáo do AI tạo, cần chuyên gia kiểm chứng; không thay thế phán đoán lâm sàng. Tham khảo kiến trúc từ PeerReviewAgents và Agentic_Paper (MIT).
