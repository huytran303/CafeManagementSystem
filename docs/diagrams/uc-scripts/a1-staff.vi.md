# Kịch bản thuyết trình: Use Case A1 — Staff (nhân viên nói chung)

Sơ đồ: `../export/use-case-by-actor__01_A1-Staff.png`. Thời lượng: khoảng 2–3 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. Tiếp theo, em xin trình bày phần use case, tức là ai được làm gì trong hệ thống.
2. Nhóm vẽ 5 sơ đồ, mỗi sơ đồ dành cho một vai trò: nhân viên chung, thu ngân, pha chế, khách hàng và quản lý.
3. Như vậy, muốn biết một người dùng được làm gì thì chỉ cần nhìn sơ đồ của vai trò đó.
4. Đây là sơ đồ đầu tiên, A1, gồm những việc mà nhân viên nào cũng làm.

## Cách đọc

5. `[Chỉ khung lớn]` Khung chữ nhật là hệ thống BrewBoss.
6. `[Chỉ các hình elip]` Mỗi hình elip là một use case, tức là một việc người dùng làm được trên hệ thống.
7. `[Chỉ hình người]` Hình người là actor, có thể là người hoặc một hệ thống bên ngoài.
8. `[Chỉ mũi tên tam giác rỗng]` Mũi tên tam giác rỗng là kế thừa.
9. Thu ngân, Pha chế và Quản lý đều trỏ về Staff.
10. Nghĩa là Staff làm được gì thì cả ba vai trò đều làm được, nên các sơ đồ sau không phải vẽ lại những việc này.

## Các việc chung

11. `[Chỉ UC01]` Việc đầu tiên là đăng nhập bằng email và mật khẩu.
12. `[Chỉ Firebase Auth]` Hệ thống nhờ Firebase Auth kiểm tra thông tin đăng nhập.
13. `[Chỉ UC03]` Quên mật khẩu thì tự đặt lại, Firebase sẽ gửi email khôi phục.
14. `[Chỉ UC02]` Làm xong thì đăng xuất.
15. `[Chỉ UC10]` Nhân viên nào cũng xem và tìm được món trong menu.

## Vào ca, kết ca và bàn giao tiền

16. `[Chỉ UC05]` Đến quán thì check-in để vào ca, hết giờ thì check-out.
17. `[Chỉ mũi tên «include»]` Mũi tên nét đứt ghi include nghĩa là việc này luôn kéo theo việc kia.
18. Check-out luôn đi kèm bàn giao tiền, là UC44.
19. Khi kết ca, người giữ két đếm tiền mặt và nhập vào.
20. Hệ thống tự tính số tiền đáng lẽ phải có, rồi ghi lại phần chênh lệch.
21. Pha chế không giữ tiền, nên ca của pha chế không có phần bàn giao này.

## Chốt

22. Tóm lại, A1 là phần nền: ai cũng phải đăng nhập, và mỗi ca làm đều được ghi lại.
23. Tiếp theo là vai trò bận rộn nhất quán, thu ngân.

---

## Câu hỏi hay gặp

- **Sao check-out là include mà không phải extend?** Vì lần check-out nào của thu ngân cũng phải bàn giao tiền, không có lần nào được bỏ qua.
- **Nhân viên tự đăng ký tài khoản được không?** Không. Chỉ quản lý mới tạo tài khoản cho nhân viên (xem A5).
