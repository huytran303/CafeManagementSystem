# Kịch bản thuyết trình: Context Diagram và ERD

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

Sơ đồ: `export/context-diagram__01_Context-Diagram.png`, `export/erd__01_Entity-Relationship-Diagram.png`.

---

## Phần 1: Context Diagram (khoảng 3 phút)

### Mở đầu

1. Đầu tiên, em xin trình bày sơ đồ ngữ cảnh, hay còn gọi là Context Diagram.
2. Sơ đồ này trả lời một câu hỏi đơn giản: hệ thống của nhóm nói chuyện với ai, và trao đổi những gì.
3. `[Chỉ vòng tròn giữa]` Vòng tròn ở giữa là toàn bộ hệ thống BrewBoss, gom lại thành một khối duy nhất.
4. Ở mức này mình chưa quan tâm bên trong hệ thống làm gì.
5. `[Chỉ 5 hộp xung quanh]` Xung quanh là 5 đối tượng bên ngoài: Quản lý, Thu ngân, Pha chế, Khách hàng và dịch vụ VietQR.
6. Mũi tên đi vào vòng tròn là dữ liệu người dùng nhập vào hệ thống.
7. Mũi tên đi ra là thông tin hệ thống trả lại cho họ.

### Quản lý `[góc trên trái]`

8. Bắt đầu với Chủ quán, hay Quản lý.
9. Quản lý là người thiết lập quán trên hệ thống.
10. Họ nhập vào tài khoản nhân viên, danh mục và món, công thức pha chế, nguyên liệu, bàn và voucher.
11. Họ cũng nhập kho khi có hàng về và điều chỉnh kho khi kiểm kho.
12. Ngược lại, hệ thống trả cho quản lý các báo cáo.
13. Cụ thể là doanh thu, món bán chạy, doanh thu theo tiền mặt và chuyển khoản, và báo cáo bàn giao tiền từng ca.
14. Ngoài ra còn có lịch sử xuất nhập kho, danh sách khách hàng kèm điểm, và cảnh báo khi nguyên liệu sắp hết.
15. Mỗi báo cáo là một mũi tên riêng, để khớp với từng yêu cầu trong tài liệu SRS.

### Thu ngân `[góc dưới trái]`

16. Tiếp theo là Thu ngân, người có nhiều mũi tên nhất vì họ làm việc với hệ thống cả ngày.
17. Đầu ca, thu ngân check-in và nhập số tiền đang có trong két.
18. Trong ca, họ tạo đơn cho khách ngồi bàn hoặc mang đi, rồi thêm hoặc sửa món.
19. Khi khách thanh toán, họ nhập mã voucher, số điện thoại khách để tích điểm, và dùng điểm nếu khách muốn.
20. Khách có thể trả tiền mặt, chuyển khoản VietQR, hoặc kết hợp cả hai.
21. Thu ngân còn chuyển bàn, gộp bàn, huỷ đơn kèm lý do, và xác nhận đơn khách tự đặt qua QR.
22. Cuối ca, họ đếm tiền trong két và ghi chú bàn giao.
23. Chiều ngược lại, hệ thống cho thu ngân xem sơ đồ bàn, tổng tiền, tiền thối lại và mã QR để khách quét.
24. Hệ thống cũng trả về hoá đơn PDF, báo khi món đã pha xong, và cho biết số điểm của khách.
25. Khi kết ca, hệ thống tự tính: tiền mặt đáng lẽ phải có là bao nhiêu, và chênh lệch so với số đếm được là bao nhiêu.

### Pha chế `[góc trên phải]`

26. Tiếp theo là Pha chế.
27. Pha chế nhận danh sách đơn cần làm, cập nhật theo thời gian thực mà không cần tải lại.
28. Họ xem được chi tiết từng đơn: món gì, ghi chú gì, khách đã chờ bao lâu.
29. Có đơn mới thì hệ thống báo, đơn làm quá lâu thì hệ thống cảnh báo.
30. Pha chế chỉ gửi lại một thứ: trạng thái đơn, là "đang pha" hoặc "đã xong".

### Khách hàng `[giữa bên phải]`

31. Khách hàng không cần tài khoản.
32. Khách quét mã QR dán trên bàn, nên hệ thống biết khách đang ngồi bàn nào.
33. Hệ thống gửi menu cho khách, khách chọn món và gửi yêu cầu đặt.
34. Sau đó khách theo dõi được đơn của mình đang ở trạng thái nào.

### VietQR `[dưới bên phải]`

35. Cuối cùng là VietQR, một dịch vụ bên ngoài.
36. Hệ thống gửi số tiền và mã đơn, VietQR trả về ảnh mã QR để khách chuyển khoản.
37. Vì không kết nối trực tiếp với ngân hàng, thu ngân tự xác nhận khi đã nhận được tiền.

### Chốt

38. Tóm lại, sơ đồ này cho thấy phạm vi của hệ thống: có 4 vai trò người dùng và 1 dịch vụ ngoài.
39. Tiếp theo, em sẽ đi vào bên trong xem hệ thống lưu dữ liệu như thế nào, qua sơ đồ ERD.

---

## Phần 2: ERD (khoảng 4–5 phút)

### Cách đọc sơ đồ (nói trước khi vào nội dung)

1. ERD là sơ đồ dữ liệu: hệ thống lưu những gì và các dữ liệu liên quan với nhau ra sao.
2. `[Chỉ một hộp bất kỳ]` Mỗi hộp là một loại dữ liệu, ví dụ Đơn hàng, Món, Nguyên liệu.
3. Dòng in đậm trên cùng là tên, dòng nhỏ bên dưới là chỗ lưu trên Firestore.
4. PK là mã định danh của mỗi bản ghi.
5. FK là chỗ lưu mã của một bản ghi khác, dùng để liên kết hai bảng với nhau.
6. `[Chỉ hộp viền đứt]` Hộp viền liền là một bảng riêng, hộp viền đứt là dữ liệu nằm luôn bên trong bảng cha.
7. `[Chỉ đầu đường nối]` Ký hiệu ở đầu đường nối cho biết số lượng: hai gạch là đúng một, có vòng tròn là có thể không có, còn chân chim là nhiều.

### Kể theo một đơn hàng

8. Để dễ theo dõi, em sẽ không đọc từng hộp mà kể câu chuyện của một đơn hàng.

#### Bước 1: Vào ca

9. `[Chỉ USER]` Thu ngân đăng nhập bằng tài khoản trong bảng USER.
10. Trường `role` cho biết người đó là quản lý, thu ngân hay pha chế.
11. `[Chỉ SHIFT]` Khi check-in, hệ thống tạo một ca làm việc trong bảng SHIFT.
12. Một nhân viên có nhiều ca, nên đầu phía SHIFT có chân chim.
13. Ca lưu tiền đầu ca, và khi kết ca thì lưu thêm tiền đếm được, tiền dự kiến và chênh lệch.

#### Bước 2: Khách gọi món

14. `[Chỉ ORDER]` Khách ngồi bàn số 3 gọi hai ly cà phê sữa size M, thêm trân châu.
15. Thu ngân tạo một đơn trong bảng ORDER, đây là bảng trung tâm của sơ đồ.
16. `[Chỉ TABLE]` Đơn gắn với một bàn, còn khách mang đi thì không có bàn, nên có ký hiệu vòng tròn.
17. Bàn cũng lưu ngược mã đơn đang mở, nhờ vậy nhìn sơ đồ bàn là biết ngay bàn nào có khách.
18. `[Chỉ ORDER_ITEM]` Mỗi món trong đơn là một ORDER_ITEM, nằm luôn bên trong đơn.
19. Một đơn phải có ít nhất một món.
20. Món lưu lại tên và giá tại thời điểm gọi.
21. Nhờ vậy, sau này quản lý có tăng giá thì hoá đơn cũ vẫn giữ đúng giá cũ.
22. Trường `batch` đánh số lần gọi: khách gọi thêm thì là lần 2, để pha chế biết phần nào mới.

#### Bước 3: Menu và công thức

23. `[Chỉ CATEGORY → PRODUCT]` Món ăn lấy từ bảng PRODUCT, được xếp theo danh mục CATEGORY.
24. `[Chỉ 3 hộp viền đứt bên phải]` Mỗi món chứa bên trong ba thứ: các size, các topping, và công thức.
25. Công thức ghi cụ thể theo từng size, ví dụ size M cần 18 gam cà phê và 30 ml sữa.
26. `[Chỉ INGREDIENT]` Mỗi dòng công thức trỏ tới một nguyên liệu trong kho.
27. Đây chính là cầu nối giữa bán hàng và kho.

#### Bước 4: Thanh toán

28. `[Chỉ CUSTOMER, VOUCHER]` Khi thanh toán, đơn có thể gắn một khách thân thiết và một voucher.
29. Cả hai đều không bắt buộc, nên có ký hiệu vòng tròn.
30. Mã khách hàng chính là số điện thoại, nên tìm khách rất nhanh và không bao giờ bị trùng.
31. Tiền được lưu thành hai trường: tiền mặt và tiền chuyển khoản.
32. Khách trả kết hợp thì cả hai trường đều có số, còn khi làm báo cáo chỉ cần cộng lại.

#### Bước 5: Trừ kho

33. `[Chỉ STOCK_MOVEMENT]` Khi đơn thanh toán xong, hệ thống xem công thức từng món và tự trừ nguyên liệu trong kho.
34. Mỗi lần trừ được ghi lại vào STOCK_MOVEMENT, có mã đơn đi kèm để biết trừ vì đơn nào.
35. Bảng này còn ghi cả lúc nhập hàng và lúc kiểm kho, nên mỗi nguyên liệu có lịch sử đầy đủ.

#### Bước 6: Ai làm gì

36. `[Chỉ 4 đường nối USER–ORDER]` Giữa nhân viên và đơn có bốn đường nối.
37. Bốn đường này là: ai tạo đơn, ai xác nhận, ai thu tiền, và ai huỷ.
38. Lưu riêng từng người để khi có sự cố thì biết ai chịu trách nhiệm.
39. Người thu tiền cũng là căn cứ để tính tiền két của từng thu ngân khi kết ca.

#### Cuối cùng

40. `[Chỉ SHOP_SETTINGS]` SHOP_SETTINGS đứng riêng, chỉ có một bản ghi duy nhất.
41. Bản ghi này lưu tên quán, tài khoản ngân hàng để tạo mã VietQR, và tỉ lệ quy đổi điểm.

### Chốt: 3 điểm thiết kế

42. Để kết thúc, nhóm muốn nhấn mạnh ba quyết định thiết kế.
43. Thứ nhất, dữ liệu luôn được đọc cùng nhau thì nhóm để chung một chỗ, ví dụ món nằm trong đơn, nên chỉ cần đọc một lần.
44. Thứ hai, tên, giá và tiền két được chụp lại tại thời điểm phát sinh, nên số liệu cũ không bị thay đổi.
45. Thứ ba, tiền được lưu bằng số nguyên VND, nên không có lỗi làm tròn.
46. Phần trình bày về dữ liệu của em đến đây là hết, em xin cảm ơn.

---

## Câu hỏi hay gặp

- **Sao sơ đồ ngữ cảnh không có Firebase?** Firebase là công cụ bên trong hệ thống, không phải đối tượng bên ngoài.
- **Firestore là NoSQL, vẽ ERD để làm gì?** Quan hệ nghiệp vụ vẫn có. ERD cho thấy chỗ nào liên kết bằng mã, chỗ nào để chung một bản ghi.
- **Xoá món thì đơn cũ có bị lỗi không?** Không, vì đơn đã lưu lại tên và giá của món.
- **Sao không tự xác nhận chuyển khoản?** Hệ thống không kết nối với ngân hàng, VietQR chỉ tạo ảnh mã QR, nên thu ngân tự xác nhận.
