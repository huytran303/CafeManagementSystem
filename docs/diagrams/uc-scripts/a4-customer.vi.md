# Kịch bản thuyết trình: Use Case A4 — Khách hàng

Sơ đồ: `../export/use-case-by-actor__04_A4-Customer.png`. Thời lượng: khoảng 1–2 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. Sơ đồ A4 là của khách hàng.
2. Khách hàng không phải nhân viên, nên không kế thừa từ Staff.

## Xem menu

3. `[Chỉ UC10]` Khách ngồi vào bàn thì xem được menu ngay trên điện thoại của mình.
4. Khách tìm được món, xem giá và xem các size.

## Đặt món qua QR

5. `[Chỉ UC32]` Muốn gọi món, khách quét mã QR dán trên bàn.
6. Mã QR chứa sẵn số bàn, nên hệ thống biết khách đang ngồi ở đâu.
7. `[Chỉ Firebase Auth]` Khách không cần tạo tài khoản, hệ thống tự cho khách vào dưới dạng ẩn danh qua Firebase Auth.
8. `[Chỉ «include» tới UC10]` Muốn đặt thì phải chọn món từ menu, nên đặt món include xem menu.
9. Khách chọn món, bấm gửi, và đơn được chuyển tới thu ngân để xác nhận.

## Theo dõi đơn

10. `[Chỉ UC33 extend UC32]` Đặt xong, khách có thể theo dõi đơn đang chờ xác nhận, đang pha hay đã xong.
11. Khách muốn xem thì xem, không bắt buộc, nên đây là extend.

## Chốt

12. Tóm lại, khách tự gọi món mà không cần chờ nhân viên, còn quán vẫn kiểm soát được đơn nhờ bước xác nhận của thu ngân.

---

## Câu hỏi hay gặp

- **Khách đặt đơn giả thì sao?** Đơn của khách luôn phải qua thu ngân xác nhận thì mới tới pha chế.
- **Bàn đang có đơn mà khách gọi thêm thì sao?** Thu ngân xác nhận thì món mới được gộp vào đơn đang mở của bàn.
- **Khách có tự thanh toán trên app được không?** Không. Khách vẫn thanh toán tại quầy với thu ngân.
