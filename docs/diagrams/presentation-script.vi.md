# Kịch bản thuyết trình các sơ đồ — BrewBoss

Thứ tự trình bày: từ tổng quan đến chi tiết. Context Diagram → Use Case (D0–D5) → Order Flow →
Order State Machine → Screen Flow → ERD → Screen Mockups. Mỗi phần có: **mục đích**, **lời nói**,
và **câu hỏi có thể gặp**.

---

## 1. Context Diagram (`context-diagram.drawio`)

**Mục đích:** cho thấy BrewBoss trao đổi dữ liệu gì với môi trường bên ngoài, ở góc nhìn nghiệp vụ.

**Lời nói:**

> Đây là sơ đồ ngữ cảnh của hệ thống BrewBoss. Toàn bộ hệ thống được thể hiện bằng một tiến trình
> duy nhất ở giữa. Xung quanh là năm thực thể ngoài: bốn vai trò người dùng — Chủ quán/Quản lý,
> Thu ngân, Pha chế, Khách hàng — và một dịch vụ bên thứ ba là VietQR.
>
> **Chủ quán/Quản lý** gửi vào hệ thống các dữ liệu cấu hình: thông tin đăng nhập, tài khoản nhân viên,
> danh mục và sản phẩm, công thức và nguyên liệu, nhập kho/điều chỉnh kho, bàn và voucher.
> Hệ thống trả về cho quản lý các báo cáo: doanh thu, món bán chạy, doanh thu theo phương thức
> thanh toán, lịch sử ca làm, lịch sử xuất nhập kho, danh sách khách hàng và điểm, cùng cảnh báo
> sắp hết hàng. Nhóm tách riêng từng báo cáo để mỗi luồng khớp với một yêu cầu FR-RPT trong SRS.
>
> **Thu ngân** là vai trò có nhiều luồng nhất. Thu ngân nhập đơn mới tại bàn hoặc mang đi, thêm/sửa
> món, mã giảm giá, số điện thoại khách, đổi điểm, thanh toán tiền mặt hoặc xác nhận chuyển khoản
> VietQR, chuyển/gộp bàn, huỷ đơn kèm lý do, và xác nhận đơn do khách tự đặt. Ngược lại, hệ thống
> trả về sơ đồ bàn, tổng tiền và tiền thối, mã VietQR, hoá đơn PDF, thông báo món đã xong và
> số điểm của khách.
>
> **Pha chế** nhận hàng đợi đơn theo thời gian thực, chi tiết từng đơn, thông báo có đơn mới và
> cảnh báo đơn quá giờ; pha chế gửi lại cập nhật trạng thái "đang pha" và "đã xong".
>
> **Khách hàng** quét QR trên bàn — dữ liệu đi vào hệ thống là mã bàn — xem menu, gửi yêu cầu
> đặt món và theo dõi trạng thái đơn.
>
> **VietQR**: hệ thống gửi số tiền và mã đơn, VietQR trả về ảnh QR để khách quét chuyển khoản.

**Câu hỏi có thể gặp:**

- *Sao không có Firebase?* — Context Diagram mô tả hệ thống ở mức logic. Firebase (Auth, Firestore,
  FCM) là hạ tầng cài đặt bên trong ranh giới hệ thống; Firestore sẽ xuất hiện dưới dạng data store
  ở DFD mức 1.
- *Sao không có luồng webhook ngân hàng tự xác nhận thanh toán?* — Nằm ngoài phạm vi (US-03,
  giả định A4). VietQR chỉ là chuẩn mã QR, hệ thống dùng dịch vụ tạo ảnh `img.vietqr.io`, không có
  callback. Thu ngân xác nhận thủ công — đúng như luồng "VietQR payment confirmation" trên sơ đồ.

---

## 2. Use Case Diagrams (`D0`–`D5_*.puml`)

**Mục đích:** cho thấy ai làm được gì. 41 use case, chia thành 6 sơ đồ vì một sơ đồ không đủ chỗ.

### D0 — System Context (tổng quan module)

> Sơ đồ D0 cho cái nhìn tổng thể: hệ thống BrewBoss gồm 9 module — Xác thực, Quản lý nhân viên,
> Menu, Kho, Bán hàng (POS), Pha chế, Khách đặt món, Khách hàng thân thiết, và Báo cáo.
> Nhân viên nói chung dùng Xác thực, Nhân viên và Menu. Thu ngân dùng POS và Loyalty. Pha chế dùng
> màn hình Pha chế. Khách hàng dùng Menu và Đặt món qua QR. Quản lý có quyền trên hầu hết các module.
> Bên phải là ba hệ thống ngoài mà use case gọi tới: Firebase Auth, Firebase Cloud Messaging và VietQR.

### D1 — Xác thực & Nhân viên (UC01–UC06)

> Staff là actor trừu tượng; Thu ngân, Pha chế và Quản lý kế thừa từ Staff. Mọi nhân viên đều
> đăng nhập, đăng xuất, đặt lại mật khẩu và check-in/check-out ca. Riêng Quản lý thêm hai chức năng:
> quản lý tài khoản nhân viên và xem lịch sử ca. Đăng nhập và đặt lại mật khẩu gọi tới Firebase Auth.

### D2 — Menu & Kho (UC07–UC17)

> Quản lý quản lý danh mục, sản phẩm, nguyên liệu, nhập kho, điều chỉnh kho và xem lịch sử kho.
> "Định nghĩa công thức" là phần mở rộng của "Quản lý sản phẩm". Thu ngân có thể bật/tắt món hết hàng.
> Cả nhân viên và khách đều duyệt/tìm kiếm menu.
>
> Điểm đáng chú ý: "Trừ kho theo công thức" (UC15) không có actor trực tiếp — nó được *include*
> bởi "Thanh toán" (UC25). Sau khi trừ kho hoặc điều chỉnh kho, nếu tồn kho xuống dưới mức tối thiểu
> thì *extend* sang "Gửi cảnh báo sắp hết hàng" qua Firebase Cloud Messaging.

### D3 — Bán hàng (UC18–UC29)

> Đây là sơ đồ của thu ngân: xem sơ đồ bàn, tạo đơn — bắt buộc include duyệt menu —, sửa món,
> đánh dấu đã phục vụ, chuyển/gộp bàn, xác nhận đơn của khách, huỷ đơn, và thanh toán.
> Thanh toán có hai phần mở rộng tuỳ chọn: áp giảm giá và xem/chia sẻ hoá đơn. Huỷ đơn mở rộng từ
> xác nhận đơn khách — khi thu ngân từ chối. Thanh toán gọi VietQR khi khách chuyển khoản.
> Quản lý phụ trách cấu hình bàn/QR và thông tin cửa hàng.

### D4 — Pha chế & Khách đặt món (UC30–UC33)

> Pha chế xử lý hàng đợi đơn; khi đơn chuyển sang "xong" thì extend sang "Thông báo món đã xong"
> qua FCM. Khách đặt món qua QR bàn — include duyệt menu, đăng nhập ẩn danh qua Firebase Auth —
> và có thể mở rộng sang theo dõi trạng thái đơn.

### D5 — Báo cáo & Khách thân thiết (UC34–UC41)

> Quản lý xem dashboard doanh thu, lịch sử đơn, báo cáo bán hàng — có thể xuất báo cáo —, quản lý
> voucher và danh sách khách thân thiết. Thu ngân gắn khách thân thiết và đổi điểm; cả hai là phần
> mở rộng của "Thanh toán".

**Câu hỏi có thể gặp:**

- *Sao use case có Firebase là actor mà context diagram thì không?* — Use case diagram theo UML cho
  phép hệ thống ngoài làm secondary actor khi use case gọi tới nó. Context Diagram (DFD) thì mô tả
  luồng dữ liệu nghiệp vụ, nên hạ tầng nằm trong ranh giới.
- *Quản lý có làm được việc của thu ngân không?* — Có (brief §2), nhưng sơ đồ chỉ vẽ vai trò thấp
  nhất thực hiện được use case để tránh rối.

---

## 3. Order Flow (`order-flow.drawio`)

**Mục đích:** luồng xử lý một đơn hàng từ lúc tạo đến lúc thanh toán, theo từng vai trò (swimlane).

**Lời nói:**

> Sơ đồ chia làn theo năm vai trò: Khách hàng, Thu ngân, Hệ thống, Pha chế và Quản lý.
>
> Đơn có hai nguồn. Nếu **khách tự đặt**: khách quét QR trên bàn, mở menu mà không cần đăng nhập,
> chọn món và đặt. Nếu **thu ngân đặt**: chọn bàn hoặc mang đi, rồi thêm món với size, topping,
> số lượng và ghi chú.
>
> Hệ thống tạo đơn với trạng thái **pending** và cấp mã ngắn. Đơn của khách được đánh dấu để thu
> ngân kiểm tra lại giá rồi mới xác nhận. Nếu không xác nhận thì huỷ kèm lý do — đơn chuyển sang
> **cancelled** và không trừ kho.
>
> Đơn được xác nhận sẽ vào hàng đợi của pha chế theo thứ tự cũ nhất trước. Pha chế bấm "Bắt đầu" —
> trạng thái **preparing**. Lúc này chỉ Quản lý mới được huỷ. Pha xong bấm "Xong" — trạng thái
> **ready** — và thu ngân được báo qua push notification, hoặc listener trong app nếu không có
> Cloud Functions.
>
> Thu ngân mang món ra và đánh dấu **served**. Khách gọi thêm thì đơn quay về pending.
> Không gọi thêm thì sang bước thanh toán: áp voucher, nhập số điện thoại khách thân thiết, đổi điểm.
> Chọn tiền mặt — nhập tiền nhận và thấy tiền thối; hoặc VietQR — hiển thị QR, thu ngân xác nhận thủ công.
>
> Bước quan trọng nhất là **một Firestore transaction** chạy ngay trên thiết bị: đổi trạng thái sang
> **paid**, trừ kho theo công thức, cộng điểm cho khách — tất cả thành công hoặc tất cả thất bại.
> Sau đó nếu có nguyên liệu dưới mức tối thiểu thì gửi cảnh báo cho quản lý, dashboard doanh thu
> được cập nhật, và thu ngân có thể chia sẻ hoá đơn PDF.
>
> Đơn mang đi đi cùng luồng, chỉ khác là không có bàn và có thể thanh toán trước khi pha.

**Câu hỏi có thể gặp:**

- *Sao trừ kho lúc thanh toán mà không phải lúc tạo đơn?* — BR-INV-01: đơn bị huỷ không được
  tiêu hao kho; trừ ở lúc thanh toán nên không cần hoàn kho.
- *Không có server thì đảm bảo nhất quán thế nào?* — Firestore transaction là atomic (NFR-REL-01).

---

## 4. Order State Machine (`order-state-machine.drawio`)

**Mục đích:** các trạng thái hợp lệ của đơn hàng và điều kiện chuyển trạng thái.

**Lời nói:**

> Đơn hàng có sáu trạng thái. Khi tạo, đơn ở **pending**. Pha chế bắt đầu thì sang **preparing**,
> pha xong sang **ready**, thu ngân phục vụ sang **served**, xác nhận thanh toán sang **paid** —
> kèm trừ kho và cộng điểm.
>
> Có hai nhánh đặc biệt. Thứ nhất, **huỷ**: thu ngân hoặc quản lý huỷ được khi đơn còn pending;
> khi đã preparing thì chỉ quản lý được huỷ; luôn phải có lý do. Thứ hai, **gọi thêm món**: từ served
> quay về pending để pha chế làm tiếp.
>
> **paid** và **cancelled** là trạng thái kết thúc, không được sửa nữa. Chỉ được thêm món khi đơn
> đang pending hoặc served.

---

## 5. Screen Flow (`screen-flow.drawio`)

**Mục đích:** điều hướng giữa 22 màn hình, kèm route `go_router` của từng màn.

**Lời nói:**

> Khi mở app, màn Splash kiểm tra phiên đăng nhập. Chưa có phiên thì vào Login — từ đây có thể sang
> Quên mật khẩu. Đăng nhập thành công, hệ thống rẽ nhánh theo vai trò:
>
> - **Quản lý** vào Dashboard. Từ đây đi tới quản lý nhân viên, lịch sử ca, menu — và form sản phẩm
>   với size, topping, công thức —, kho — và lịch sử xuất nhập —, quản lý bàn và in QR, báo cáo,
>   lịch sử đơn, khách hàng và voucher. Quản lý cũng vào được màn POS và màn Pha chế.
> - **Thu ngân** vào Sơ đồ bàn. Chạm bàn hoặc "Mang đi" để mở màn soạn đơn, bấm "Thanh toán" sang
>   màn thanh toán, thanh toán xong quay về sơ đồ bàn.
> - **Pha chế** vào Hàng đợi pha chế.
>
> Thu ngân và pha chế có thêm màn "Ca làm" để check-in/out. Mọi vai trò đều vào được màn Hồ sơ từ
> thanh app bar; đăng xuất sẽ xoá stack và quay về Login.
>
> **Khách hàng** không đi qua Login: quét QR trên bàn mở thẳng menu của bàn đó bằng deep link,
> đặt món xong chuyển sang màn theo dõi trạng thái đơn.
>
> Nét liền là push màn mới, nét đứt là pop quay lại. Màn home của mỗi vai trò không có nút back về Login.

---

## 6. ERD (`erd.drawio`)

**Mục đích:** mô hình dữ liệu Firestore, ký hiệu chân chim (crow's foot).

**Lời nói:**

> Hệ thống dùng Firestore nên có hai loại thực thể: **collection** — viền liền — và **dữ liệu nhúng**
> trong document — viền đứt. Khoá chính là document id, không lưu thành field.
>
> Trung tâm là **ORDER**. Một đơn chứa một hoặc nhiều **ORDER_ITEM** nhúng bên trong. Đơn do một
> **USER** tạo; thuộc về tối đa một **TABLE** — mang đi thì không có bàn; có thể gắn tối đa một
> **CUSTOMER** thân thiết và tối đa một **VOUCHER**.
>
> Phía menu: một **CATEGORY** chứa nhiều **PRODUCT**. Mỗi sản phẩm nhúng danh sách **size**,
> **topping** và **công thức theo size** — mỗi dòng công thức trỏ tới một **INGREDIENT**. Mỗi món
> trong đơn tham chiếu tới một sản phẩm.
>
> Phía kho: mỗi **INGREDIENT** có nhiều **STOCK_MOVEMENT** — là subcollection — do một user ghi,
> và nếu là xuất kho do bán hàng thì liên kết với đơn gây ra nó.
>
> Ngoài ra **USER** có nhiều **SHIFT**, và **SHOP_SETTINGS** là một document duy nhất chứa thông tin
> cửa hàng, gồm cả tài khoản ngân hàng dùng cho VietQR.

**Câu hỏi có thể gặp:**

- *Sao nhúng order items thay vì tách collection?* — Đơn luôn được đọc/ghi cùng các món, nhúng giúp
  một lần đọc và nằm gọn trong một transaction.

---

## 7. Screen Mockups (`screen-mockups.drawio`)

**Mục đích:** wireframe độ trung thực thấp, mỗi trang một màn S01–S22.

**Lời nói:**

> Bộ wireframe gồm 26 trang cho 22 màn hình. Các trang có hậu tố "b" là trạng thái thứ hai của cùng
> một màn: form nhân viên, bottom sheet chọn tuỳ chọn món, thanh toán bằng VietQR, và tab voucher.
> Màn hàng đợi pha chế được thiết kế cho tablet; các màn còn lại cho điện thoại.
> Tên màn và route khớp với Screen Flow, nên có thể đối chiếu trực tiếp giữa hai sơ đồ.
