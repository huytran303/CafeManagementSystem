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
> thanh toán, báo cáo bàn giao tiền theo ca (tiền đầu ca, tiền mặt, chuyển khoản, dự kiến, đếm được, chênh lệch), lịch sử xuất nhập kho, danh sách khách hàng và điểm, cùng cảnh báo
> sắp hết hàng. Nhóm tách riêng từng báo cáo để mỗi luồng khớp với một yêu cầu FR-RPT trong SRS.
>
> **Thu ngân** là vai trò có nhiều luồng nhất. Thu ngân nhập tiền đầu ca khi check-in, và khi
> check-out thì nhập tiền mặt đếm được trong két cùng ghi chú bàn giao; ngoài ra thu ngân nhập đơn mới tại bàn hoặc mang đi, thêm/sửa món, mã voucher, số điện
> thoại khách, đổi điểm, thanh toán tiền mặt — toàn bộ hoặc một phần khi thanh toán kết hợp — hoặc
> xác nhận chuyển khoản VietQR, chuyển/gộp bàn, huỷ đơn kèm lý do, và xác nhận đơn do khách tự đặt.
> Ngược lại, hệ thống trả về sơ đồ bàn, tổng tiền và tiền thối, mã VietQR, hoá đơn PDF, thông báo
> món đã xong, số điểm của khách, và khi kết ca là bảng tổng kết ca: tiền mặt và chuyển khoản đã thu, tiền mặt dự kiến và số tiền chênh lệch.
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

## 2. Use Case Diagrams (`use-case-diagrams.drawio`, D0–D5)

**Mục đích:** cho thấy ai làm được gì. 46 use case, chia thành 6 sơ đồ vì một sơ đồ không đủ chỗ.

### D0 — System Context (tổng quan module)

> Sơ đồ D0 cho cái nhìn tổng thể: hệ thống BrewBoss gồm 9 module — Xác thực, Quản lý nhân viên,
> Menu, Kho, Bán hàng (POS), Pha chế, Khách đặt món, Khách hàng thân thiết, và Báo cáo.
> Nhân viên nói chung dùng Xác thực, Nhân viên và Menu. Thu ngân dùng POS và Loyalty. Pha chế dùng
> màn hình Pha chế. Khách hàng dùng Menu và Đặt món qua QR. Quản lý có quyền trên hầu hết các module.
> Bên phải là ba hệ thống ngoài mà use case gọi tới: Firebase Auth, Firebase Cloud Messaging và VietQR.

### D1 — Xác thực & Nhân viên (UC01–UC06, UC44–UC45)

> Staff là actor trừu tượng; Thu ngân, Pha chế và Quản lý kế thừa từ Staff. Mọi nhân viên đều
> đăng nhập, đăng xuất, đặt lại mật khẩu và check-in/check-out ca. Check-out *include* "Bàn giao
> tiền" (UC44): thu ngân hoặc quản lý đếm két, hệ thống so với tiền mặt dự kiến và ghi phần chênh
> lệch; ca của pha chế không có phần tiền. Riêng Quản lý thêm ba chức năng: quản lý tài khoản nhân
> viên, xem lịch sử ca và xem báo cáo tiền theo ca (UC45). Đăng nhập và đặt lại mật khẩu gọi tới
> Firebase Auth.

### D2 — Menu & Kho (UC07–UC17, UC42–UC43)

> Quản lý quản lý danh mục, sản phẩm, nguyên liệu, nhập kho, điều chỉnh kho, kiểm kho và xem lịch sử kho.
> "Định nghĩa công thức" là phần mở rộng của "Quản lý sản phẩm". Thu ngân có thể bật/tắt món hết hàng.
> Cả nhân viên và khách đều duyệt/tìm kiếm menu.
>
> Điểm đáng chú ý: "Trừ kho theo công thức" (UC15) không có actor trực tiếp — nó được *include*
> bởi "Thanh toán" (UC25). Sau khi trừ kho hoặc điều chỉnh kho, nếu tồn kho xuống dưới mức tối thiểu
> thì *extend* sang "Gửi cảnh báo sắp hết hàng" qua Firebase Cloud Messaging.
>
> "Trừ hao hụt khi huỷ" (UC43) *extend* "Huỷ đơn" (UC27): đơn đã pha rồi mới huỷ thì nguyên liệu
> vẫn bị trừ theo công thức. "Kiểm kho" (UC42) là cách quản lý sửa các sai lệch như pha sai định lượng
> hay pha lại — nhập số đếm thực tế, hệ thống ghi phần chênh lệch.

### D3 — Bán hàng (UC18–UC29, UC46)

> Đây là sơ đồ của thu ngân: xem sơ đồ bàn, tạo đơn — bắt buộc include duyệt menu —, sửa món,
> đánh dấu đã phục vụ, chuyển/gộp bàn, xác nhận đơn của khách, huỷ đơn, và thanh toán.
> Thanh toán có ba phần mở rộng tuỳ chọn: áp voucher — chỉ voucher mới được giảm giá, không có giảm
> giá tay —, xem/chia sẻ hoá đơn, và thanh toán kết hợp
> (UC46) — một phần tiền mặt, một phần VietQR. Huỷ đơn mở rộng từ
> xác nhận đơn khách — khi thu ngân từ chối. Thanh toán gọi VietQR khi khách chuyển khoản.
> Quản lý phụ trách cấu hình bàn/QR và thông tin cửa hàng.

### D4 — Pha chế & Khách đặt món (UC30–UC33)

> Pha chế xử lý hàng đợi đơn; lần nào bấm "Xong" hệ thống cũng gửi "Thông báo món đã xong" qua FCM,
> nên đây là include chứ không phải extend. Khách đặt món qua QR bàn — include duyệt menu, đăng nhập ẩn danh qua Firebase Auth —
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
> Đơn thu ngân đặt được tạo ở trạng thái **pending** và cấp mã ngắn. Đơn của khách thì vào trạng
> thái **awaiting**: pha chế chưa thấy, bàn chưa bị chiếm. Thu ngân kiểm tra lại giá rồi xác nhận —
> đơn sang pending. Nếu từ chối thì huỷ kèm lý do — đơn chuyển sang **cancelled** và không trừ kho,
> vì chưa pha gì cả. Nhờ bước này, ai cầm link bàn đặt bậy từ xa cũng không tới được quầy pha chế.
> Nếu bàn đang có đơn mở thì khách vẫn đặt được — đó là món gọi thêm. Thu ngân xác nhận thì món
> được thêm vào đơn đang mở theo đúng quy tắc lượt gọi, còn đơn QR đóng lại với lý do "Gộp vào …".
>
> Đơn được xác nhận sẽ vào hàng đợi của pha chế theo thứ tự cũ nhất trước. Pha chế bấm "Bắt đầu" —
> trạng thái **preparing**. Từ đây trở đi chỉ Quản lý mới được huỷ. Pha xong bấm "Xong" — trạng thái
> **ready** — và thu ngân được báo qua push notification, hoặc listener trong app nếu không có
> Cloud Functions.
>
> Thu ngân mang món ra và đánh dấu **served**. Khách gọi thêm thì đơn quay về pending, món thêm
> thuộc một lượt mới và pha chế chỉ thấy lượt mới đó. Nếu đơn còn đang pha thì món thêm nằm luôn
> cuối thẻ đang pha, kèm âm báo.
> Không gọi thêm thì sang bước thanh toán: áp voucher, nhập số điện thoại khách thân thiết, đổi điểm.
> Chọn tiền mặt — nhập tiền nhận và thấy tiền thối; VietQR — hiển thị QR, thu ngân xác nhận thủ công;
> hoặc kết hợp — nhập phần chuyển khoản, QR chỉ hiện đúng số tiền đó, phần còn lại thu bằng tiền mặt.
>
> Bước quan trọng nhất là **một Firestore transaction** chạy ngay trên thiết bị: kiểm tra người thu
> tiền đang trong ca (BR-PAY-03) và tiền mặt cộng chuyển khoản bằng tổng tiền (BR-PAY-01), rồi đổi
> trạng thái sang **paid**, lưu `cashAmount`, `qrAmount` và `paidBy`, trừ kho theo công thức, cộng
> điểm cho khách — tất cả thành công hoặc tất cả thất bại.
> Sau đó nếu có nguyên liệu dưới mức tối thiểu thì gửi cảnh báo cho quản lý, dashboard doanh thu
> được cập nhật, và thu ngân có thể chia sẻ hoá đơn PDF.
>
> Đơn mang đi đi cùng luồng, chỉ khác là không có bàn: thu ngân đánh dấu served khi giao đồ cho
> khách rồi mới thanh toán. Không có luồng trả tiền trước (BR-PAY-04).
>
> Nhánh cuối ở làn Quản lý là **huỷ sau khi đã pha**: đơn đang preparing, ready hoặc served đều có
> thể bị Quản lý huỷ kèm lý do. Hệ thống hỏi "Đã pha chưa?". Nếu **đã pha** — nguyên liệu thật sự đã
> dùng — hệ thống trừ kho theo công thức, ghi lịch sử loại *điều chỉnh* với lý do huỷ. Nếu chưa pha
> thì chỉ chuyển sang **cancelled**. Cả hai bước chạy trong một transaction.

**Câu hỏi có thể gặp:**

- *Sao trừ kho lúc thanh toán mà không phải lúc tạo đơn?* — BR-INV-01: đơn bị huỷ không được
  tiêu hao kho; trừ ở lúc thanh toán nên không cần hoàn kho. Ngoại lệ duy nhất là đơn đã pha rồi mới
  huỷ (BR-INV-02) — khi đó trừ như hao hụt.
- *Nhân viên pha sai định lượng thì sao?* — Không theo dõi từng ly. Quản lý kiểm kho định kỳ, phần
  chênh lệch giữa số đếm và số trên hệ thống được ghi thành một lần điều chỉnh (BR-INV-03).
- *Khách bỏ về sau khi đã nhận món?* — Quản lý huỷ đơn ở trạng thái served, tick "Đã pha" để trừ kho.
- *Không có server thì đảm bảo nhất quán thế nào?* — Firestore transaction là atomic (NFR-REL-01).
- *Sao không lưu phương thức thanh toán?* — Hai field `cashAmount` và `qrAmount` cho phép thanh toán
  kết hợp; đơn chỉ trả một cách thì field còn lại bằng 0. Báo cáo theo phương thức chỉ cần cộng từng field.
- *Tiền thối có lưu không?* — Không (BR-PAY-02). `cashAmount` là tiền quán giữ lại, tiền thối chỉ
  hiển thị lúc thanh toán.

---

## 4. Order State Machine (`order-state-machine.drawio`)

**Mục đích:** các trạng thái hợp lệ của đơn hàng và điều kiện chuyển trạng thái.

**Lời nói:**

> Đơn hàng có bảy trạng thái. Khách tự đặt qua QR thì đơn bắt đầu ở **awaiting**, chờ thu ngân
> xác nhận. Thu ngân đặt thì đơn ở **pending** ngay. Pha chế bắt đầu thì sang **preparing**,
> pha xong sang **ready**, thu ngân phục vụ — hoặc giao đơn mang đi — sang **served**, xác nhận
> thanh toán sang **paid** — kèm trừ kho và cộng điểm. Chỉ thanh toán được từ served, kể cả đơn mang
> đi (BR-PAY-04).
>
> Có hai nhánh đặc biệt. Thứ nhất, **huỷ**: thu ngân hoặc quản lý huỷ được khi đơn còn awaiting hoặc pending;
> từ preparing, ready hay served thì chỉ quản lý được huỷ; luôn phải có lý do. Nếu đồ đã pha thì
> nguyên liệu bị trừ như hao hụt. Thứ hai, **gọi thêm món**: từ ready hoặc served quay về pending để
> pha chế làm tiếp; đang pending hay preparing thì món thêm vào cùng lượt, trạng thái giữ nguyên.
>
> **paid** và **cancelled** là trạng thái kết thúc, không được sửa nữa. Đơn đang mở thì luôn thêm
> món được, nhưng chỉ sửa hay xoá món cũ khi đơn còn pending.

---

## 5. Screen Flow (`screen-flow.drawio`)

**Mục đích:** điều hướng giữa 22 màn hình, kèm route `go_router` của từng màn.

**Lời nói:**

> Khi mở app, màn Splash kiểm tra phiên đăng nhập. Chưa có phiên thì vào Login — từ đây có thể sang
> Quên mật khẩu. Đăng nhập thành công, hệ thống rẽ nhánh theo vai trò:
>
> - **Quản lý** vào Dashboard. Từ đây đi tới quản lý nhân viên, lịch sử ca kèm bàn giao tiền, menu — và form sản phẩm
>   với size, topping, công thức —, kho — và lịch sử xuất nhập —, quản lý bàn và in QR, báo cáo,
>   lịch sử đơn, khách hàng và voucher. Quản lý cũng vào được màn POS và màn Pha chế.
> - **Thu ngân** vào Sơ đồ bàn. Chạm bàn hoặc "Mang đi" để mở màn soạn đơn, bấm "Thanh toán" (khi
>   đơn đã served) sang màn thanh toán, thanh toán xong quay về sơ đồ bàn.
> - **Pha chế** vào Hàng đợi pha chế.
>
> Thu ngân, pha chế và quản lý có màn "Ca làm" để check-in/out; thu ngân và quản lý nhập tiền đầu
> ca khi vào ca và bàn giao tiền khi kết ca. Mọi vai trò đều vào được màn Hồ sơ từ
> thanh app bar; đăng xuất sẽ xoá stack và quay về Login.
>
> **Khách hàng** không đi qua Login: quét QR trên bàn mở thẳng menu của bàn đó bằng deep link,
> đặt món xong chuyển sang màn theo dõi trạng thái đơn.
>
> Nét liền là push màn mới, nét đứt là pop quay lại. Màn home của mỗi vai trò không có nút back về Login.

---

## 6. ERD (`erd.drawio`)

**Mục đích:** mô hình dữ liệu Firestore: có những thực thể nào, mỗi thực thể lưu gì, và chúng nối
với nhau ra sao. Ký hiệu chân chim (crow's foot).

### 6.1 Cách đọc sơ đồ (nói trước khi đi vào nội dung, khoảng 30 giây)

> Mỗi hộp là một thực thể. Dòng đầu là tên, dòng thứ hai là đường dẫn Firestore, ví dụ
> `orders/{orderId}`. **PK** là document id — nó là tên của document chứ không phải một field bên
> trong. **FK** là field chứa id của document ở collection khác. Firestore không có khoá ngoại
> thật, nên FK ở đây là quy ước của ứng dụng, được kiểm tra trong code và security rules.
>
> Hộp **viền liền** là collection thật. Hộp **viền đứt** là dữ liệu **nhúng**: một mảng hoặc map
> nằm bên trong document cha, không có collection riêng.
>
> Ký hiệu ở đầu đường nối cho biết số lượng:
>
> | Ký hiệu | Nghĩa |
> |---|---|
> | `‖` hai gạch | đúng một, bắt buộc |
> | `o‖` vòng + gạch | không hoặc một, tuỳ chọn (FK có thể null) |
> | `o<` vòng + chân chim | không hoặc nhiều |
> | `‖<` gạch + chân chim | một hoặc nhiều, ít nhất một |

### 6.2 Lời nói: đi theo một đơn hàng

Đừng đọc từng hộp từ trái sang phải. Hãy kể câu chuyện của **một đơn hàng**, đi qua thực thể nào
thì chỉ vào thực thể đó.

> **Bước 1 — Nhân viên vào ca.** Thu ngân đăng nhập bằng tài khoản **USER** (`users/{uid}`,
> `role` = manager / cashier / barista). Họ check-in, tạo một **SHIFT**: một user có nhiều ca
> (`USER ‖—o< SHIFT`). Ca của thu ngân lưu tiền đầu ca; khi kết ca lưu thêm tiền đếm được,
> tiền dự kiến `expectedCash`, chênh lệch `cashDiff` và ghi chú bàn giao.
>
> **Bước 2 — Khách gọi món.** Khách ngồi bàn T3 gọi hai ly cà phê sữa size M thêm trân châu. Thu
> ngân tạo một **ORDER**. Đơn thuộc về tối đa một **TABLE** (`tableId`; mang đi thì null, vì thế
> đầu TABLE là `o‖`). Ngược lại, bàn giữ `currentOrderId` trỏ tới đơn đang mở (đường
> "current order", hai đầu đều `o‖`): sơ đồ bàn chỉ cần đọc bàn là biết bàn nào đang có khách. Mỗi dòng món là một **ORDER_ITEM** nhúng trong mảng `items[]` của đơn; một
> đơn có ít nhất một món (`ORDER ‖—‖< ORDER_ITEM`).
>
> Mỗi ORDER_ITEM trỏ tới một **PRODUCT** bằng `productId`, nhưng vẫn **chép lại** tên và đơn giá
> lúc gọi (snapshot). Nếu sau này quản lý đổi giá hay đổi tên món, hoá đơn cũ không bị thay đổi.
> `batch` đánh số lượt gọi: gọi thêm sau khi đã pha xong thì là batch 2, để pha chế biết phải làm
> phần nào.
>
> **Bước 3 — Menu ở đâu ra.** **CATEGORY** chứa nhiều PRODUCT. Mỗi PRODUCT nhúng ba thứ: danh sách
> **PRODUCT_SIZE** (S/M/L và giá cộng thêm), **TOPPING**, và **RECIPE_ITEM**, tức công thức theo
> từng size: size M cần 18 g cà phê, 30 ml sữa đặc... Mỗi dòng công thức trỏ tới một
> **INGREDIENT**. Đây là cầu nối giữa bán hàng và kho.
>
> **Bước 4 — Thanh toán.** Đơn phục vụ xong thì thu ngân thu tiền. Đơn có thể gắn một khách thân
> thiết **CUSTOMER** (id chính là số điện thoại đã chuẩn hoá) và một **VOUCHER** (id chính là mã
> voucher). Cả hai đều tuỳ chọn, nên đầu phía CUSTOMER / VOUCHER là `o‖`.
>
> Tiền lưu thành hai field `cashAmount` và `qrAmount`, không có field "phương thức thanh toán".
> Trả tiền mặt thì `qrAmount = 0`; chuyển khoản thì `cashAmount = 0`; trả kết hợp thì có cả hai.
> Báo cáo chỉ việc cộng từng field.
>
> **Bước 5 — Trừ kho.** Ngay trong transaction thanh toán, hệ thống đọc công thức của từng món, trừ
> `stock` của INGREDIENT và ghi một **STOCK_MOVEMENT** loại `sale` có `orderId` trỏ về đơn
> (đường "causes (sale / waste)"; huỷ đơn đã pha cũng ghi `orderId` cho dòng hao hụt).
> STOCK_MOVEMENT là **subcollection** nằm dưới nguyên liệu (`ingredients/{id}/movements`): mỗi
> nguyên liệu có lịch sử nhập xuất riêng. Ngoài `sale` còn có `in` (nhập hàng, lưu giá nhập `cost`)
> và `adjust` (kiểm kho, hao hụt khi huỷ đơn đã pha).
>
> **Bước 6 — Ai làm gì.** Đơn có bốn đường nối về USER, mỗi đường ứng với một hành động:
> `createdBy` (tạo; đơn khách tự đặt qua QR thì là `"anonymous"`, nên đầu USER là `o‖`), `confirmedBy` (xác nhận đơn khách tự đặt), `paidBy` (thu tiền), `cancelledBy`
> (huỷ). Tách riêng từng người để truy vết được (NFR-AUD-01), và `paidBy` là cơ sở để tính tiền
> mặt dự kiến khi thu ngân kết ca. STOCK_MOVEMENT cũng lưu `byUserId`.
>
> **Cuối cùng**, **SHOP_SETTINGS** đứng riêng: một document duy nhất `settings/shop` chứa tên quán,
> tài khoản ngân hàng cho VietQR và các tham số như số phút coi là đơn trễ, tỉ lệ quy đổi điểm.

### 6.3 Ba quyết định thiết kế nên nhấn mạnh

1. **Nhúng thay vì tách collection** (ORDER_ITEM, size, topping, công thức): dữ liệu luôn được đọc
   cùng document cha, nên một lần đọc là đủ và vẫn nằm gọn trong một transaction.
2. **Snapshot** (tên và giá trong ORDER_ITEM, `expectedCash` trong SHIFT): số liệu lịch sử không
   đổi khi dữ liệu gốc đổi.
3. **Tiền là `int` VND**: không dùng số thực, nên không có lỗi làm tròn.

### 6.4 Câu hỏi có thể gặp

- *Sao nhúng order items mà không tách thành collection?* — Đơn luôn được đọc và ghi cùng các món.
  Nhúng giúp chỉ cần một lần đọc và nằm gọn trong một transaction. Giới hạn 1 MB mỗi document là
  quá đủ cho một đơn cà phê.
- *Firestore là NoSQL, sao vẫn vẽ ERD?* — Quan hệ vẫn tồn tại ở mức nghiệp vụ. ERD cho thấy field
  nào là id tham chiếu và phần nào được nhúng; đó chính là quyết định thiết kế quan trọng nhất
  khi dùng Firestore.
- *Sao lưu `expectedCash` mà không tính lại khi xem?* — Đó là ảnh chụp tại lúc kết ca. Sau này có
  sửa đơn thì biên bản bàn giao vẫn giữ đúng con số đã đối chiếu.
- *Sao id của CUSTOMER là số điện thoại?* — Để tra khách theo số điện thoại chỉ bằng một lần đọc
  document, và không thể tạo trùng hai khách cùng một số.
- *Xoá sản phẩm thì đơn cũ có sao không?* — Không. Đơn cũ đã chép tên và giá, nên vẫn hiển thị
  đúng; `productId` chỉ còn là tham chiếu lịch sử.

---

## 7. Screen Mockups (`screen-mockups.drawio`)

**Mục đích:** wireframe độ trung thực thấp, mỗi trang một màn S01–S22.

**Lời nói:**

> Bộ wireframe gồm 30 trang cho 22 màn hình. Các trang có hậu tố "b", "c" là trạng thái khác của
> cùng một màn: form nhân viên, vào ca nhập tiền đầu ca và kết ca bàn giao tiền, bottom sheet chọn
> tuỳ chọn món, form nhập kho có giá nhập, thanh toán bằng VietQR và thanh toán kết hợp, và tab voucher. Lịch sử ca (S06) hiển
> thị tiền đầu ca, tiền mặt, chuyển khoản, dự kiến, đếm được và chênh lệch của từng ca.
> Màn hàng đợi pha chế được thiết kế cho tablet; các màn còn lại cho điện thoại.
> Tên màn và route khớp với Screen Flow, nên có thể đối chiếu trực tiếp giữa hai sơ đồ.
