# Kịch bản thuyết trình: Use Case D3 — Bán hàng

Sơ đồ: `../export/use-case-diagrams__04_D3-Point-of-Sale.png`. Thời lượng: khoảng 4 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. D3 là module bán hàng, gồm 13 use case, phần lớn là của thu ngân.
2. Em đi từ trên xuống, theo thứ tự phục vụ một bàn khách.

## Phục vụ bàn

3. `[Chỉ UC19]` Thu ngân xem sơ đồ bàn: bàn nào trống, bàn nào đang có đơn.
4. Mỗi bàn chỉ có một đơn đang mở.
5. `[Chỉ UC20 → UC10]` Khách gọi món thì thu ngân tạo đơn.
6. Tạo đơn luôn phải chọn món từ menu, nên đây là include.
7. `[Chỉ UC21]` Khách gọi thêm thì thu ngân thêm món vào đơn, lúc nào cũng thêm được.
8. Nhưng chỉ sửa hoặc xoá món cũ được khi pha chế chưa bắt đầu pha.
9. `[Chỉ UC23]` Món mang ra cho khách rồi thì thu ngân đánh dấu đã phục vụ.
10. `[Chỉ UC26]` Khách đổi chỗ thì chuyển sang bàn trống.
11. Hai bàn đi chung thì gộp bàn, khi cả hai đơn đều đã phục vụ.

## Đơn khách tự đặt

12. `[Chỉ UC22]` Khách tự đặt qua QR thì đơn phải chờ thu ngân xác nhận rồi mới tới pha chế.
13. Việc này chặn đơn ảo, ví dụ có người chụp mã QR mang về nhà đặt thử.
14. Nếu bàn đó đang có đơn, món khách đặt được thêm vào đơn đang có.
15. `[Chỉ UC27 → UC22]` Đơn có vấn đề thì thu ngân từ chối, tức là huỷ đơn.
16. Chỉ khi từ chối mới huỷ, nên đây là extend.
17. Mũi tên extend đi từ việc phụ và chỉ vào việc chính.
18. Huỷ đơn luôn phải ghi lý do, và thu ngân chỉ huỷ được đơn chưa pha.

## Thanh toán

19. `[Chỉ UC25]` Thanh toán là use case quan trọng nhất, và chỉ thanh toán được sau khi đã phục vụ.
20. Người thu tiền phải đang trong ca, để mỗi hoá đơn đều thuộc về một ca.
21. `[Chỉ UC25 → VietQR]` Khách chuyển khoản thì hệ thống gọi VietQR tạo mã QR có sẵn số tiền.
22. `[Chỉ 3 elip extend vào UC25]` Thanh toán có ba việc mở rộng, cần thì mới làm.
23. Thu ngân không nối thẳng vào ba việc này, vì chúng chỉ làm được bên trong màn hình thanh toán.
24. `[Chỉ UC24]` Một là áp voucher: mỗi đơn một voucher, và không có giảm giá tay.
25. `[Chỉ UC46]` Hai là thanh toán kết hợp: một phần tiền mặt, một phần chuyển khoản, cộng lại phải đúng tổng tiền.
26. `[Chỉ UC28]` Ba là xem và gửi hoá đơn cho khách.

## Việc của quản lý

27. `[Chỉ Manager, UC18, UC29]` Quản lý tạo bàn và in mã QR dán lên bàn.
28. Quản lý cũng cấu hình thông tin quán, ví dụ tên quán, tài khoản nhận chuyển khoản và tỉ lệ tích điểm.

## Chốt

29. Tóm lại, D3 đi trọn một vòng từ lúc khách ngồi vào bàn tới lúc trả tiền xong.

---

## Câu hỏi hay gặp

- **Sao huỷ đơn vừa nối với thu ngân, vừa extend xác nhận đơn?** Vì thu ngân huỷ được theo hai cách: tự huỷ khi khách đổi ý, hoặc từ chối một đơn khách đặt qua QR. Còn voucher và hoá đơn thì chỉ làm được lúc thanh toán, nên không có đường nối riêng.
- **Sao không thấy tích điểm ở D3?** Gắn khách thân thiết và đổi điểm cũng extend thanh toán, nhưng thuộc module khách thân thiết nên nằm ở D5.
- **Hệ thống có tự biết khách đã chuyển khoản không?** Không. VietQR chỉ tạo mã QR, thu ngân kiểm tra tài khoản rồi tự xác nhận.
- **Đơn mang đi thì sao?** Vẫn đi đúng luồng đó: giao ly cho khách là đánh dấu đã phục vụ, rồi mới thanh toán.
