# BrewBoss — User story luồng tiền

> Phạm vi: từ vào ca → đơn hàng → voucher → thanh toán → huỷ đơn → kết ca → báo cáo.
> Nguồn: [`product-brief.md`](product-brief.md) (§4, §5, §9.2, §10.4, §11) và
> [`BrewBoss_UseCase_Specifications.docx`](BrewBoss_UseCase_Specifications.docx) (UC05, UC06, UC20–UC27, UC44–UC46).
> Mỗi story ghi mã rule/FR tương ứng. Tiền luôn là số nguyên VND.

## A. Ca làm & két tiền

### US-A1 — Vào ca có nhập tiền đầu ca (BR-STAFF-03, FR-STAFF-07)
Là **thu ngân**, tôi muốn nhập số tiền có sẵn trong két khi vào ca, để cuối ca đối chiếu được.
- Khi thu ngân hoặc Manager bấm "Vào ca" → bắt buộc nhập tiền đầu ca (≥ 0).
- Khi barista bấm "Vào ca" → không hỏi tiền.

### US-A2 — Không vào ca hai lần (BR-STAFF-01)
- Khi đang có ca mở mà bấm "Vào ca" lần nữa → hệ thống chặn.

### US-A3 — Chưa vào ca thì không được thu tiền (BR-PAY-03)
Là **quản lý**, tôi muốn mọi khoản thu đều thuộc về một ca, để không có tiền "trôi nổi".
- Khi người chưa vào ca bấm "Xác nhận thanh toán" → báo "Bạn cần vào ca trước khi thanh toán".

### US-A4 — Kết ca, két khớp (UC44, BR-STAFF-04)
- Khi thu ngân bấm "Kết ca", hệ thống hiện:
  - tiền két phải có = tiền đầu ca + tổng `cashAmount` của các đơn mình thu trong ca;
  - tổng VietQR, chỉ để tham khảo (không nằm trong két).
- Thu ngân nhập số tiền đếm được. Chênh lệch = 0 → đóng ca.

### US-A5 — Kết ca, két lệch (UC44, BR-STAFF-05)
- Khi chênh lệch ≠ 0 (âm = thiếu, dương = thừa) → bắt buộc ghi chú mới đóng được ca.
- Sau khi đóng ca → không sửa được các trường tiền.

### US-A6 — Quản lý xem báo cáo tiền theo ca (UC45, FR-STAFF-08)
Là **quản lý**, tôi muốn thấy từng ca có lệch tiền không, để biết ai làm thiếu.
- Mỗi ca hiện: tiền đầu ca, thu tiền mặt, thu VietQR, két phải có, két thực đếm, chênh lệch, ghi chú.
- Lọc theo nhân viên, theo ngày, và "Chỉ ca có chênh lệch".
- Ca đang mở vẫn hiện nhưng không cộng vào tổng. Không hiện ca của barista.

## B. Đơn hàng & phục vụ

### US-B1 — Đơn tại bàn (BR-ORD-03)
- Khi bàn trống → tạo đơn `pending`, bàn chuyển sang "Có khách".
- Khi bàn đang có đơn mở → không tạo được đơn thứ hai.

### US-B2 — Đơn mang đi (BR-PAY-04)
Là **thu ngân**, tôi muốn giao nước xong mới thu tiền, giống như đơn tại bàn.
- Đơn mang đi không có bàn và đi qua `pending → preparing → ready`.
- Giao nước cho khách → `served` → mới thanh toán. **Không có luồng trả trước.**

### US-B3 — Khách tự đặt qua QR bàn (FR-CUS-05)
- Đơn được tạo với nhãn "khách đặt", thu ngân phải xác nhận. Lưu người xác nhận và thời điểm (`confirmedBy`, `confirmedAt`).

### US-B4 — Gọi thêm món sau khi đã phục vụ (BR-ORD-04)
- Khi thêm món vào đơn `served` → đơn quay về `pending` để barista pha tiếp.

### US-B5 — Đánh dấu đã phục vụ (FR-POS-12)
- Barista báo `ready` → thu ngân mang nước ra bàn (hoặc giao khách mang đi) và bấm "Đã phục vụ" → đơn chuyển `served`.

### US-B6 — Chỉ thanh toán khi đã phục vụ (BR-PAY-04)
- Khi đơn đang ở `pending`, `preparing` hoặc `ready` → không mở được màn thanh toán.

## C. Voucher & điểm thưởng

### US-C1 — Áp voucher (BR-DIS-01, BR-DIS-02)
- Voucher còn hiệu lực, chưa hết hạn, còn lượt dùng, đơn đạt mức tối thiểu → được trừ tiền.
- Voucher phần trăm: số tiền giảm không vượt `maxDiscount`.
- Mỗi đơn chỉ dùng 1 voucher.
- Voucher hết hạn, hết lượt hoặc đơn chưa đủ mức tối thiểu → từ chối và báo lý do.

### US-C2 — Không có giảm giá tay (BR-DIS-03)
- Khách xin giảm → thu ngân không có ô nhập giảm giá. Cách duy nhất để giảm là nhập voucher.

### US-C3 — Đổi điểm (BR-LOY-02)
- Số điểm đổi không vượt số dư của khách và không làm tổng tiền bị âm.

## D. Thanh toán

### US-D1 — Tiền mặt (FR-POS-07, BR-PAY-02)
Là **thu ngân**, tôi muốn nhập tiền khách đưa và thấy ngay tiền thối.
- Đơn 95.000 ₫, khách đưa 100.000 ₫ → tiền thối 5.000 ₫.
- Lưu `cashAmount = 95000`, `qrAmount = 0`, `paidBy` = uid thu ngân. Tiền thối không lưu.

### US-D2 — Chuyển khoản VietQR (FR-POS-08)
- Hiện QR đúng số tiền, nội dung chuyển khoản là mã đơn (`shortId`). Thu ngân bấm "Đã nhận tiền".
- Lưu `qrAmount = 95000`, `cashAmount = 0`.

### US-D3 — Kết hợp tiền mặt + chuyển khoản (UC46, FR-POS-14, BR-PAY-01)
- Đơn 95.000 ₫, khách chuyển 50.000 ₫ → QR chỉ hiện 50.000 ₫, phần tiền mặt còn lại là 45.000 ₫.
- Phần chuyển khoản < 0 hoặc > tổng → từ chối.
- Phần chuyển khoản = 0 hoặc = tổng → chuyển thành thanh toán một phương thức.

### US-D4 — Đơn 0 đồng (BR-ORD-02)
- Voucher + điểm trừ hết tiền, tổng = 0 → xác nhận được luôn, cả hai trường tiền đều = 0.

### US-D5 — Thanh toán "tất cả hoặc không" (NFR-REL-01, BR-LOY-01, BR-INV-01)
- Thành công → trong cùng một giao dịch:
  - đơn chuyển `paid`;
  - trừ kho theo công thức;
  - cộng điểm `floor(total / pointsPerVnd)`;
  - voucher tăng lượt đã dùng;
  - bàn trống.
- Mất mạng giữa chừng → không bước nào được ghi.
- Kho bị âm → vẫn cho thanh toán, Manager thấy cảnh báo.

## E. Huỷ đơn

### US-E1 — Thu ngân huỷ đơn chưa pha (FR-POS-11)
- Đơn `pending` → huỷ được, bắt buộc nhập lý do. Không trừ kho.
- Mọi lần huỷ đều lưu lý do và người huỷ (`cancelledBy`).

### US-E2 — Manager huỷ đơn đang pha hoặc đã pha (BR-ORD-05, BR-INV-02)
- Đơn `preparing`, `ready` hoặc `served` → chỉ Manager được huỷ, bắt buộc có lý do.
- Ô "Đã pha" được tick sẵn với `ready`/`served`, bỏ tick với `preparing`. Nếu tick → trừ kho, ghi thành hao hụt.

### US-E3 — Đơn đã thanh toán không sửa, không huỷ
- `paid` là trạng thái cuối cùng.

## F. Báo cáo doanh thu

### US-F1 — Doanh thu hôm nay (FR-RPT-01)
- Doanh thu = tổng `total` của các đơn `paid`, cập nhật realtime. Đơn huỷ không tính.

### US-F2 — Doanh thu theo phương thức (FR-RPT-05)
- Tiền mặt = tổng `cashAmount`, VietQR = tổng `qrAmount`.
- Đơn kết hợp được tính vào cả hai phía theo đúng số tiền của mỗi phía.

## Các trường hợp hệ thống chưa xử lý

| Trường hợp | Hiện trạng |
|---|---|
| Thu nhầm, cần hoàn tiền | Đơn `paid` bị khoá, chưa có luồng hoàn tiền |
| Bấm "Đã nhận tiền" VietQR khi tiền chưa về | Không có gì chặn; chỉ phát hiện khi Manager đối soát sao kê |
