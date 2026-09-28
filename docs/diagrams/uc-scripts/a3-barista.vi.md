# Kịch bản thuyết trình: Use Case A3 — Pha chế

Sơ đồ: `../export/use-case-by-actor__03_A3-Barista.png`. Thời lượng: khoảng 1 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. Sơ đồ A3 là của pha chế, và đây là sơ đồ ngắn nhất.
2. Pha chế vẫn làm được các việc chung ở A1, còn việc riêng chỉ có một.

## Xử lý đơn

3. `[Chỉ UC30]` Việc đó là xử lý danh sách đơn cần pha.
4. Trên màn hình, đơn mới hiện lên ngay mà không cần tải lại trang.
5. Mỗi đơn ghi rõ bàn nào, món gì, size gì, topping gì, ghi chú gì, và khách đã chờ bao lâu.
6. Đơn chờ quá lâu thì được đánh dấu cảnh báo, để pha chế ưu tiên làm trước.
7. Pha chế bấm "Bắt đầu pha", pha xong thì bấm "Xong".

## Báo món xong

8. `[Chỉ mũi tên «include» tới UC31]` Lần nào bấm "Xong", hệ thống cũng báo cho thu ngân là món đã sẵn sàng.
9. Vì lần nào cũng báo, nên đây là include.
10. `[Chỉ Firebase Cloud Messaging]` Thông báo được gửi qua Firebase Cloud Messaging.

## Chốt

11. Tóm lại, pha chế không cần giấy ghi order, cũng không phải chạy ra báo món xong, mọi thứ đều nằm trên màn hình.

---

## Câu hỏi hay gặp

- **Khách gọi thêm món thì pha chế thấy thế nào?** Món gọi thêm hiện thành một lượt mới, các lượt trước được thu gọn lại, nên pha chế biết phần nào cần làm tiếp.
- **Sao pha chế không bàn giao tiền khi kết ca?** Vì pha chế không giữ két.
