# Kịch bản thuyết trình: Use Case A5 — Quản lý

Sơ đồ: `../export/use-case-by-actor__05_A5-Manager.png`. Thời lượng: khoảng 3–4 phút.

Mỗi dòng là một câu để nói. Chữ trong ngoặc vuông `[ ]` là lúc chỉ tay vào sơ đồ, không đọc thành tiếng.

---

## Mở đầu

1. Sơ đồ cuối cùng, A5, là của quản lý hay chủ quán.
2. Quản lý có nhiều use case, nên em chia thành 5 nhóm, đi từ trên xuống dưới.

## Nhóm 1: Nhân viên

3. `[Chỉ UC04]` Quản lý tạo tài khoản cho nhân viên mới, đổi vai trò, và khoá tài khoản khi có người nghỉ việc.
4. `[Chỉ UC06]` Quản lý xem lịch sử ca: ai làm ca nào, vào lúc nào, ra lúc nào.
5. `[Chỉ UC45]` Quản lý xem báo cáo tiền từng ca, để biết ca nào thiếu tiền hay dư tiền.

## Nhóm 2: Menu

6. `[Chỉ UC07, UC08]` Quản lý tạo danh mục, thêm món và sửa món.
7. `[Chỉ UC14 extend UC08]` Khi thêm món, quản lý có thể nhập thêm công thức.
8. Công thức ghi rõ mỗi size cần bao nhiêu gam cà phê, bao nhiêu ml sữa.
9. Không phải món nào cũng cần công thức, nên đây là extend.

## Nhóm 3: Kho

10. `[Chỉ UC11]` Quản lý thêm và sửa danh sách nguyên liệu.
11. `[Chỉ UC12]` Hàng về thì nhập kho.
12. `[Chỉ UC13]` Đổ vỡ hay hư hỏng thì ghi điều chỉnh kho.
13. `[Chỉ UC16 extend UC13]` Điều chỉnh xong mà nguyên liệu xuống dưới mức tối thiểu thì hệ thống cảnh báo sắp hết.
14. `[Chỉ Firebase Cloud Messaging]` Cảnh báo được gửi qua Firebase Cloud Messaging.
15. `[Chỉ UC42]` Định kỳ quản lý kiểm kho: nhập số đếm thực tế, hệ thống tự ghi phần chênh lệch.
16. `[Chỉ UC17]` Mọi lần nhập, xuất hay điều chỉnh đều xem lại được trong lịch sử kho.

## Nhóm 4: Cài đặt quán

17. `[Chỉ UC18]` Quản lý tạo bàn và in mã QR để dán lên từng bàn.
18. `[Chỉ UC29]` Quản lý cài đặt thông tin quán: tên, địa chỉ, tài khoản ngân hàng để nhận chuyển khoản, và tỉ lệ quy đổi điểm.

## Nhóm 5: Báo cáo và khách thân thiết

19. `[Chỉ UC34]` Mở app ra, quản lý thấy ngay bảng doanh thu hôm nay.
20. `[Chỉ UC35]` Quản lý xem lại lịch sử tất cả các đơn.
21. `[Chỉ UC28 extend UC35]` Đang xem đơn nào thì có thể mở hoá đơn của đơn đó.
22. `[Chỉ UC36]` Quản lý xem báo cáo bán hàng: doanh thu theo ngày, món bán chạy, tiền mặt so với chuyển khoản.
23. `[Chỉ UC37 extend UC36]` Cần gửi cho kế toán thì xuất báo cáo ra file PDF hoặc Excel.
24. `[Chỉ UC40]` Quản lý tạo voucher: mã, giảm bao nhiêu, đơn tối thiểu, hạn dùng và số lần dùng.
25. `[Chỉ UC41]` Quản lý xem danh sách khách thân thiết, mỗi khách có bao nhiêu điểm và đã đến bao nhiêu lần.

## Chốt

26. Tóm lại, quản lý là người cài đặt quán lúc đầu và theo dõi kết quả kinh doanh hằng ngày.
27. Quản lý cũng là nhân viên, nên vẫn làm được các việc chung ở sơ đồ A1.
28. Phần trình bày use case của em đến đây là hết, em xin cảm ơn.

---

## Câu hỏi hay gặp

- **Quản lý có làm được việc của thu ngân không?** Có. Nhưng sơ đồ chỉ vẽ vai trò thấp nhất làm được việc đó, để đỡ rối.
- **Ai huỷ được đơn đang pha?** Chỉ quản lý, và phải ghi lý do. Nếu món đã pha thì nguyên liệu bị trừ thành hao hụt.
- **Điểm tính thế nào?** Quản lý tự cài tỉ lệ, ví dụ 10.000 ₫ được 1 điểm, và 1 điểm trừ được 1.000 ₫.
