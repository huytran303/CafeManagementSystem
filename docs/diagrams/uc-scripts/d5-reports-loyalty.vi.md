# Kịch bản thuyết trình: Use Case D5 — Báo cáo & Khách thân thiết

Sơ đồ: `../export/use-case-diagrams__06_D5-Reports-Loyalty.png`. Thời lượng: khoảng 3 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. D5 là sơ đồ cuối, gồm 8 use case về khách thân thiết và báo cáo.
2. Phần trên là của thu ngân, phần dưới là của quản lý.

## Khách thân thiết

3. `[Chỉ Cashier → UC25]` Thu ngân chỉ nối vào thanh toán, thanh toán thuộc D3 nên vẽ lại ở đây với chữ "see D3".
4. `[Chỉ UC38 → UC25]` Lúc thanh toán, thu ngân có thể nhập số điện thoại để gắn khách thân thiết.
5. Số điện thoại chưa có thì hệ thống tự tạo khách mới.
6. Thanh toán xong, hệ thống tự cộng điểm theo số tiền khách thực trả.
7. `[Chỉ UC39 → UC25]` Khách đủ điểm thì có thể đổi điểm để trừ tiền.
8. Điểm đổi không được quá số điểm khách có, và không làm tổng tiền bị âm.
9. `[Chỉ hai mũi tên extend]` Cả hai là extend của thanh toán.
10. Mũi tên đi từ việc phụ và chỉ vào thanh toán, vì thanh toán vẫn chạy đủ khi không có khách thân thiết.
11. Thu ngân không bấm riêng hai việc này, mà làm ngay trong màn hình thanh toán, nên không có đường nối thẳng từ thu ngân.

## Báo cáo

12. `[Chỉ UC34]` Quản lý mở dashboard để xem doanh thu hôm nay, số đơn và giá trị trung bình mỗi đơn.
13. `[Chỉ UC35]` Xem lịch sử đơn, lọc theo ngày, trạng thái hoặc thu ngân.
14. `[Chỉ UC28 → UC35]` Mở một đơn đã thanh toán thì xem lại được hoá đơn, nên đây là extend.
15. `[Chỉ UC36]` Xem báo cáo bán hàng: doanh thu theo ngày, tuần, tháng.
16. Có thêm top món bán chạy, và doanh thu chia theo tiền mặt với chuyển khoản.
17. `[Chỉ UC37 → UC36]` Cần thì quản lý xuất báo cáo ra PDF hoặc Excel, nên đây là extend.

## Voucher và danh sách khách

18. `[Chỉ UC40]` Quản lý tạo voucher: mã, giảm theo phần trăm hay số tiền, đơn tối thiểu, hạn dùng và số lượt dùng.
19. `[Chỉ UC41]` Quản lý xem danh sách khách thân thiết, số điểm và số lần ghé quán.

## Chốt

20. Tóm lại, thu ngân chỉ cần nhập số điện thoại, còn việc tính điểm và tổng hợp số liệu là hệ thống tự làm.
21. Em xin kết thúc phần use case diagram.

---

## Câu hỏi hay gặp

- **Sao UC38, UC39 extend vào UC25 mà không phải UC25 extend ra?** Theo UML, mũi tên extend đi từ use case mở rộng tới use case gốc. UC25 không phụ thuộc UC38, UC39: không có khách thân thiết vẫn thanh toán bình thường. Thu ngân nối vào UC25, còn UC38, UC39 chỉ chen vào bên trong nó.
- **Voucher và đổi điểm dùng chung một đơn được không?** Được. Tổng tiền = tạm tính − giảm voucher − tiền quy đổi từ điểm, thấp nhất là 0.
- **Báo cáo có tính đơn gộp bàn là đơn huỷ không?** Không. Đơn nguồn của lần gộp bàn không được tính vào số đơn huỷ.
