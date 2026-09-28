# Kịch bản thuyết trình: Use Case D2 — Menu & Kho

Sơ đồ: `../export/use-case-diagrams__03_D2-Menu-Inventory.png`. Thời lượng: khoảng 4 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. D2 gồm 13 use case về menu và kho nguyên liệu.
2. Cột bên trái là việc có người bấm, cột bên phải là việc hệ thống tự làm.
3. `[Chỉ 2 elip có chữ "see D3"]` Hai elip có chữ "see D3" thuộc sơ đồ D3, vẽ lại ở đây chỉ để thấy mũi tên nối sang.

## Menu

4. `[Chỉ UC10 và Staff, Customer]` Xem và tìm menu: cả nhân viên và khách đều dùng.
5. `[Chỉ UC09 và Cashier]` Thu ngân tắt món khi hết nguyên liệu, để không ai gọi được món đó nữa.
6. `[Chỉ UC07, UC08]` Quản lý quản lý danh mục và sản phẩm.
7. Mỗi sản phẩm có size, ví dụ size M đắt hơn size S 5 nghìn, và có topping tính tiền riêng.
8. `[Chỉ UC14 → UC08]` Công thức là extend của quản lý sản phẩm.
9. Extend là việc mở rộng, chỉ làm trong một số trường hợp.
10. Mũi tên extend đi từ việc phụ và chỉ vào việc chính.
11. Khi sửa sản phẩm, quản lý có thể mở thêm phần công thức, hoặc bỏ qua.
12. Công thức ghi mỗi size dùng bao nhiêu nguyên liệu.

## Kho

13. `[Chỉ UC11 đến UC17]` Quản lý thêm nguyên liệu và đặt mức tồn tối thiểu.
14. Nhập kho có ghi số lượng và giá mua.
15. Điều chỉnh kho khi đổ bỏ, hư hỏng hay đếm sai, bắt buộc có lý do.
16. Mọi lần kho thay đổi đều được ghi lại, quản lý xem lại được trong lịch sử kho.

## Trừ kho tự động

17. `[Chỉ UC25 → UC15]` Mỗi lần thu tiền, hệ thống luôn tự trừ nguyên liệu theo công thức.
18. Lần nào cũng trừ, nên đây là include.
19. Kho trừ lúc thanh toán chứ không trừ lúc tạo đơn, vì đơn còn có thể bị huỷ.
20. `[Chỉ UC16 → UC15, UC13]` Trừ xong hoặc điều chỉnh xong mà nguyên liệu xuống dưới mức tối thiểu thì hệ thống cảnh báo.
21. Chỉ khi sắp hết mới cảnh báo, nên đây là extend.
22. `[Chỉ UC16 → Firebase Cloud Messaging]` Cảnh báo được gửi tới điện thoại quản lý qua Firebase Cloud Messaging.

## Huỷ đơn và kiểm kho

23. `[Chỉ UC43 → UC27]` Đơn đã pha rồi mới huỷ thì nguyên liệu vẫn bị trừ, và ghi là hao hụt.
24. Đơn chưa pha thì không trừ, nên đây là extend.
25. `[Chỉ UC42]` Pha sai định lượng hay pha lại thì hệ thống không theo dõi từng ly.
26. Cuối ngày quản lý kiểm kho: nhập số đếm thực tế, hệ thống tự ghi phần chênh lệch.

## Chốt

27. Tóm lại, quản lý chỉ cần nhập kho và kiểm kho, việc trừ kho hằng ngày hệ thống tự làm.

---

## Câu hỏi hay gặp

- **Topping có trừ kho không?** Chưa. Bản đầu topping chưa có công thức, phần hao đó được sửa bằng kiểm kho.
- **Sao UC15 không nối với ai?** Không ai bấm "trừ kho". Nó chạy bên trong lúc thanh toán.
