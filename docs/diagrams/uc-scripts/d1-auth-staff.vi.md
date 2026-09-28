# Kịch bản thuyết trình: Use Case D1 — Xác thực & Nhân viên

Sơ đồ: `../export/use-case-diagrams__02_D1-Auth-Staff.png`. Thời lượng: khoảng 3 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. D1 gồm 8 use case: đăng nhập, tài khoản nhân viên và ca làm việc.
2. `[Chỉ mũi tên tam giác rỗng từ Cashier, Barista, Manager lên Staff]` Trước hết là ký hiệu kế thừa.
3. Staff là actor trừu tượng, không có ai mang đúng vai trò "Staff".
4. Thu ngân, pha chế và quản lý đều kế thừa Staff, nên việc gì Staff làm được thì cả ba đều làm được.
5. Ký hiệu kế thừa chỉ vẽ ở D1, các sơ đồ sau không vẽ lại.

## Việc của mọi nhân viên

6. `[Chỉ UC01 → Firebase Auth]` Đăng nhập bằng email và mật khẩu, qua Firebase Auth.
7. Đăng nhập xong, hệ thống đưa mỗi người tới màn hình chính của vai trò mình.
8. Tài khoản đã bị khoá thì không đăng nhập được.
9. `[Chỉ UC02]` Đăng xuất.
10. `[Chỉ UC03 → Firebase Auth]` Quên mật khẩu thì Firebase Auth gửi email để đặt lại.
11. `[Chỉ UC05]` Vào ca và ra ca: không ai vào ca hai lần liền nếu chưa ra ca.

## Bàn giao tiền

12. `[Chỉ UC05 → UC44]` Đây là mũi tên include.
13. Include là việc luôn phải làm, việc chính không chạy trọn nếu thiếu nó.
14. Mũi tên include đi từ việc chính và chỉ vào việc bắt buộc.
15. Vào ca, thu ngân nhập tiền đầu ca có trong két.
16. Ra ca, thu ngân đếm két, hệ thống so với số tiền mặt lẽ ra phải có.
17. Tiền lẽ ra phải có bằng tiền đầu ca cộng tiền mặt đã thu trong ca, không tính tiền chuyển khoản.
18. Nếu bị lệch thì bắt buộc ghi chú lý do, và ra ca xong thì không sửa được nữa.
19. Ca của pha chế không có phần tiền, vì pha chế không cầm két.

## Việc riêng của quản lý

20. `[Chỉ UC04]` Quản lý tạo, sửa và khoá tài khoản nhân viên, nhưng không tự khoá tài khoản của mình.
21. `[Chỉ UC06]` Xem lịch sử ca và tổng giờ làm của từng người.
22. `[Chỉ UC45]` Xem báo cáo tiền theo ca, và lọc riêng những ca bị lệch tiền.

## Chốt

23. Tóm lại, D1 lo hai việc: ai được vào hệ thống, và tiền trong két khớp với từng ca.

---

## Câu hỏi hay gặp

- **Sao bàn giao tiền là include mà không phải extend?** Thu ngân và quản lý ra ca lần nào cũng phải bàn giao, không có ngoại lệ. Ca của pha chế không có phần tiền là quy tắc nghiệp vụ, không phải một nhánh tuỳ chọn.
- **Sao UC44 không nối trực tiếp với ai?** Không ai bấm riêng "bàn giao tiền". Nó chạy bên trong lúc ra ca.
