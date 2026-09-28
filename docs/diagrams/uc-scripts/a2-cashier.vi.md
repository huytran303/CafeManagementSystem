# Kịch bản thuyết trình: Use Case A2 — Thu ngân

Sơ đồ: `../export/use-case-by-actor__02_A2-Cashier.png`. Thời lượng: khoảng 4 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. Sơ đồ A2 là của thu ngân, vai trò có nhiều việc nhất trong quán.
2. Em sẽ đi theo đúng thứ tự một ca làm của thu ngân, từ trên xuống dưới.
3. `[Chỉ mũi tên «extend»]` Ở sơ đồ này có thêm ký hiệu extend.
4. Extend là việc mở rộng, chỉ làm trong một số trường hợp, không phải lúc nào cũng làm.
5. Mũi tên extend đi từ việc phụ và chỉ vào việc chính.

## Đầu ca

6. `[Chỉ UC05 → UC44]` Đầu ca, thu ngân check-in và nhập tiền đang có trong két.
7. Cuối ca thì check-out và bàn giao tiền, phần này đã nói ở sơ đồ A1.

## Nhận khách

8. `[Chỉ UC19]` Khi có khách, thu ngân xem sơ đồ bàn để biết bàn nào trống, bàn nào có người.
9. `[Chỉ UC20 → UC10]` Khách gọi món thì thu ngân tạo đơn.
10. Tạo đơn luôn phải chọn món từ menu, nên tạo đơn include xem menu.
11. `[Chỉ UC21]` Khách đổi món hoặc gọi thêm thì thu ngân sửa đơn.
12. `[Chỉ UC26]` Khách muốn đổi chỗ thì chuyển bàn, hai bàn đi chung thì gộp bàn.
13. `[Chỉ UC23]` Món pha xong và đã mang ra cho khách thì thu ngân đánh dấu đã phục vụ.
14. `[Chỉ UC09]` Món nào hết nguyên liệu thì thu ngân tắt món đó đi, để không ai gọi được nữa.

## Đơn khách tự đặt và huỷ đơn

15. `[Chỉ UC22]` Khách tự đặt qua QR thì đơn chưa được pha ngay.
16. Thu ngân phải xem lại và xác nhận trước, để tránh đơn ảo.
17. `[Chỉ UC27 extend UC22]` Nếu đơn có vấn đề thì thu ngân từ chối, tức là huỷ đơn.
18. Thu ngân cũng huỷ được đơn bình thường khi khách đổi ý, nhưng phải ghi lý do.
19. `[Chỉ UC43 extend UC27]` Nếu đơn đã pha rồi mới huỷ, nguyên liệu vẫn bị trừ khỏi kho và ghi là hao hụt.
20. Chỉ trừ khi đơn đã pha, nên đây là extend.

## Thanh toán

21. `[Chỉ UC25]` Khách về thì thu ngân thu tiền, đây là use case quan trọng nhất.
22. `[Chỉ VietQR]` Khách chuyển khoản thì hệ thống gọi VietQR để tạo mã QR có sẵn số tiền.
23. `[Chỉ UC25 → UC15]` Mỗi lần thu tiền, hệ thống luôn tự trừ nguyên liệu trong kho theo công thức.
24. Ví dụ bán một ly cà phê sữa size M thì kho tự trừ 18 gam cà phê và 30 ml sữa.
25. Lần nào cũng trừ, nên đây là include.
26. `[Chỉ UC16 → Firebase Cloud Messaging]` Trừ xong mà nguyên liệu xuống dưới mức tối thiểu thì hệ thống gửi cảnh báo sắp hết tới quản lý.
27. Chỉ khi sắp hết mới gửi, nên đây là extend.

## Các việc mở rộng khi thanh toán

28. `[Chỉ 5 elip bên dưới UC25]` Lúc thanh toán còn có 5 việc mở rộng, cần thì mới làm.
29. `[Chỉ UC24]` Một là áp voucher.
30. Voucher là cách giảm giá duy nhất, thu ngân không được tự giảm tay.
31. `[Chỉ UC38]` Hai là gắn khách thân thiết: nhập số điện thoại của khách để tích điểm.
32. `[Chỉ UC39]` Ba là đổi điểm: khách có đủ điểm thì dùng điểm để trừ tiền.
33. `[Chỉ UC28]` Bốn là xem và gửi hoá đơn cho khách.
34. `[Chỉ UC46]` Năm là thanh toán kết hợp: khách trả một phần tiền mặt, phần còn lại chuyển khoản.

## Chốt

35. Tóm lại, sơ đồ A2 bao trọn một vòng phục vụ khách, từ lúc ngồi vào bàn cho đến lúc thanh toán xong.
36. Việc trừ kho và tích điểm diễn ra tự động, thu ngân không phải làm thêm gì.

---

## Câu hỏi hay gặp

- **Hệ thống có tự biết khách đã chuyển khoản không?** Không. VietQR chỉ tạo ảnh mã QR, thu ngân kiểm tra tài khoản rồi tự xác nhận.
- **Sao UC15 và UC16 không nối với ai?** Vì không ai bấm nút cả, hệ thống tự làm khi thu tiền.
- **Thu ngân huỷ được đơn đang pha không?** Không. Thu ngân chỉ huỷ được đơn chưa pha. Đơn đang pha hoặc đã xong phải nhờ quản lý huỷ.
