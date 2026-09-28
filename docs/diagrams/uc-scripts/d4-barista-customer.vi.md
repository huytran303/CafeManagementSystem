# Kịch bản thuyết trình: Use Case D4 — Pha chế & Khách đặt món

Sơ đồ: `../export/use-case-diagrams__05_D4-Barista-Customer.png`. Thời lượng: khoảng 2 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. D4 là sơ đồ nhỏ nhất, chỉ có 4 use case, chia làm hai nửa.
2. Nửa trên là của pha chế, nửa dưới là của khách.

## Pha chế

3. `[Chỉ UC30]` Pha chế xem hàng đợi đơn, đơn cũ nhất nằm trên cùng.
4. Mỗi thẻ đơn ghi số bàn, món, size, topping, ghi chú và đã chờ bao lâu.
5. Đơn chờ quá 10 phút thì thẻ đổi màu cảnh báo.
6. Đơn khách tự đặt mà thu ngân chưa xác nhận thì không hiện ở đây.
7. Pha chế bấm "Bắt đầu" rồi bấm "Xong".
8. `[Chỉ UC30 → UC31]` Lần nào bấm "Xong", hệ thống cũng báo cho thu ngân là món đã xong.
9. Lần nào cũng báo, nên đây là include.
10. `[Chỉ UC31 → Firebase Cloud Messaging]` Thông báo được gửi qua Firebase Cloud Messaging.

## Khách hàng

11. `[Chỉ UC32]` Khách quét mã QR trên bàn để tự đặt món.
12. `[Chỉ UC32 → Firebase Auth]` Khách không cần tạo tài khoản, hệ thống đăng nhập ẩn danh qua Firebase Auth.
13. `[Chỉ UC32 → UC10]` Đặt món luôn phải chọn từ menu, nên đây là include.
14. Đơn gửi đi sẽ chờ thu ngân xác nhận, như đã nói ở D3.
15. `[Chỉ UC33 → UC32]` Đặt xong, khách có thể theo dõi đơn đang chờ, đang pha hay đã xong.
16. Khách không bắt buộc phải xem, nên đây là extend.

## Chốt

17. Tóm lại, D4 nối ba người với nhau: khách đặt món, pha chế làm món, thu ngân nhận thông báo để mang món ra.

---

## Câu hỏi hay gặp

- **Sao báo món xong là include mà không phải extend?** Vì lần nào bấm "Xong" cũng báo, không có điều kiện nào để bỏ qua.
- **Khách gọi thêm món bằng QR thì sao?** Món mới được thêm vào đơn đang có của bàn, và thẻ pha chế chỉ hiện đợt món mới.
