# Kịch bản thuyết trình: Use Case D0 — Tổng quan hệ thống

Sơ đồ: `../export/use-case-diagrams__01_D0-System-Context.png`. Thời lượng: khoảng 2 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. Hệ thống có 46 use case, một sơ đồ không đủ chỗ nên nhóm em chia thành 6 sơ đồ, từ D0 đến D5.
2. D0 là sơ đồ tổng quan, mỗi elip ở đây là một module chứ chưa phải một use case.
3. Năm sơ đồ D1 đến D5 phía sau sẽ mở từng module ra chi tiết.

## Các module

4. `[Chỉ khung BrewBoss]` Trong khung BrewBoss có 9 module.
5. `[Chỉ từ trên xuống]` Đó là xác thực, quản lý nhân viên, menu, khách đặt món, bán hàng, khách thân thiết, màn hình pha chế, kho và báo cáo.

## Người dùng bên trái

6. `[Chỉ Staff]` Staff là nhân viên nói chung, ai cũng phải đăng nhập, vào ca và xem menu.
7. `[Chỉ Customer]` Khách hàng xem menu và tự đặt món bằng cách quét QR trên bàn.
8. `[Chỉ Cashier]` Thu ngân dùng module bán hàng và khách thân thiết.
9. `[Chỉ Barista]` Pha chế chỉ dùng một module là màn hình pha chế.

## Quản lý bên phải

10. `[Chỉ Manager]` Quản lý nối vào gần hết các module.
11. Có ba module chỉ quản lý dùng: kho, báo cáo và quản lý nhân viên.

## Hệ thống ngoài

12. `[Chỉ Firebase Auth]` Firebase Auth lo đăng nhập cho nhân viên, và đăng nhập ẩn danh cho khách quét QR.
13. `[Chỉ VietQR]` VietQR tạo mã QR chuyển khoản khi thanh toán.
14. `[Chỉ Firebase Cloud Messaging]` Firebase Cloud Messaging gửi thông báo: báo món đã xong cho thu ngân, và báo nguyên liệu sắp hết cho quản lý.

## Chốt

15. Tóm lại, D0 cho thấy ai dùng module nào và hệ thống gọi ra ngoài những đâu.
16. Tiếp theo em đi vào từng module, bắt đầu với D1.

---

## Câu hỏi hay gặp

- **Sao Firebase là actor ở đây mà Context Diagram thì không?** Use case diagram cho phép hệ thống ngoài làm actor phụ khi use case gọi tới nó. Context Diagram vẽ luồng dữ liệu nghiệp vụ, nên hạ tầng nằm bên trong ranh giới.
- **Quản lý có làm được việc của thu ngân và pha chế không?** Có. Nhưng mỗi sơ đồ chỉ vẽ vai trò thấp nhất làm được việc đó, để sơ đồ không bị rối.
