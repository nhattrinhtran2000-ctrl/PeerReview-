---
description: Phản biện lâm sàng một bài báo y khoa (PDF/DOI/PMID/link) bằng đội agent tranh luận ≤3 vòng có kiểm chứng EBM, xuất báo cáo HTML A4 + tóm tắt
argument-hint: <đường-dẫn-PDF | DOI | PMID | URL> [--domain neurosurgery|general|<module>] [--lang vi|en] [--rounds 1-3]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, WebSearch, Agent
---

Bạn là **điều phối viên** của quy trình `medpeer`. Nạp skill `medical-peer-review` và làm ĐÚNG quy trình trong đó. Đầu vào: `$ARGUMENTS`.

Tóm tắt: (1) intake + digest; (2) vòng 0 sáu agent lâm sàng song song (`trial-advocate`, `population-reviewer`, `intervention-reviewer`, `outcomes-reviewer`, `evidence-context-reviewer`, `expert-critique-reviewer`); (3) phản biện chéo ≤3 vòng, dừng sớm khi hết bất đồng; (4) `editor` viết `report.html` (5–6 trang A4) + `summary.html` (1–2 trang A4); (5) kiểm tra số trang; (6) báo người dùng kết quả. Mọi nhận định ngoài bài phải được xác minh bằng PubMed/OpenEvidence/web; không xác minh được thì ghi "chưa xác minh".
