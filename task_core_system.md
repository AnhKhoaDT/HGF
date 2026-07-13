1. CRUD Lịch trình và Xử lý Điểm đến

task: [BE] Quản lý cấu trúc lịch trình cơ bản
Chi tiết: Xây dựng các RESTful API (Create, Read, Update, Delete) cho các bảng itineraries, itinerary_days, và itinerary_items. Thiết lập logic phân trang và bộ lọc dữ liệu. Đảm bảo khi tạo một lịch trình mới, hệ thống tự động sinh ra các bản ghi ngày (days) tương ứng với khoảng thời gian start_date và end_date.


task: [BE] Xử lý truy vấn không gian (Spatial Queries) lấy danh sách địa điểm lân cận
Chi tiết: Viết model hoặc đoạn logic để truy vấn các địa điểm lân cận. Viết truy vấn nhóm các địa điểm có cùng category_id (ví dụ: cùng nhóm nhà hàng, khách sạn) trong một bán kính cho trước để trả về qua API gợi ý.

task: [WEB] Giao diện Quản lý lịch trình và hiển thị danh sách
Chi tiết: Xây dựng bộ component React/Next.js hiển thị cấu trúc cây: Tên chuyến đi -> Các ngày -> Danh sách địa điểm trong ngày. Tích hợp  thêm/sửa/xóa điểm đến với hiệu ứng chuyển cảnh mượt mà. Xử lý logic gọi API để load danh sách điểm đến đã lưu trong lịch trình và render dữ liệu lên màn hình.

task: [WEB] Tích hợp kéo thả (Drag-and-Drop) với thứ tự động
Chi tiết: Tích hợp thư viện kéo thả (ví dụ: @dnd-kit). Xử lý sự kiện khi người dùng nhấc và thả một địa điểm sang vị trí mới (hoặc sang một ngày khác): giao diện lập tức cập nhật vị trí optimistic, sau đó gọi API truyền vị trí mới (dựa trên state hiện tại) để Backend tính toán chuỗi Fractional Index mới và lưu lại.  

task: [WEB] Hiển thị chi tiết địa điểm và gợi ý lân cận
Chi tiết: Xây dựng Modal Component hoặc Side-panel hiển thị chi tiết metadata của một địa điểm (hình ảnh, giờ mở cửa, mô tả). Gọi API PostGIS từ Backend để load danh sách "Các địa điểm lân cận" và "Địa điểm cùng danh mục", hiển thị dưới dạng một thanh trượt (slider) ngay bên dưới phần chi tiết để người dùng dễ dàng bấm thêm vào lịch trình.

task: [MOBILE] Giao diện quản lý danh sách lịch trình (Online)
Chi tiết: Xây dựng màn hình danh sách chuyến đi và chi tiết từng ngày bằng Flutter/React Native. Sử dụng REST API để fetch và render dữ liệu trực tiếp từ server. Thêm các nút bấm Swipe-to-delete (vuốt để xóa) và các form nhập liệu popup để chỉnh sửa thông tin điểm đến. Mọi thao tác đều có loading indicator chờ phản hồi từ server (không dùng cơ chế lưu tạm offline).


2. Ước tính chi phí chuyến đi
(chưa có ý tưởng về việc thiết kế để hệ thống tự  biết được chi phí toàn chuyến đi là khoảng bao nhiêu, làm sao biết 1 điểm có thể tốn bao nhiêu tiền.)
-> Cho người dùng tự ước tính và chi phí chuyến đi, sau đó hệ thống sẽ tính toán chi phí dựa trên ước tính của người dùng.
task: [WEB] Giao diện Dashboard Ước tính Ngân sách
Chi tiết: Xây dựng tab "Ngân sách". Hiển thị một biểu đồ tròn (Pie Chart) phân bổ chi phí dự kiến theo danh mục (Khách sạn, Di chuyển, Ăn uống) dựa trên API trả về. Cung cấp một form để người dùng tự nhập Ngân sách cá nhân (Budget Limit).

task: [MOBILE] Thẻ tổng quan ngân sách và cảnh báo vượt định mức
Chi tiết: Ở màn hình tổng quan chuyến đi, thiết kế một Component dạng thẻ tín dụng hiển thị tổng tiền dự kiến. Vẽ một thanh ProgressBar (Thanh tiến trình), nếu tổng tiền hệ thống ước lượng vượt quá 90% ngân sách do người dùng thiết lập, thanh sẽ chuyển sang màu cam hoặc đỏ để cảnh báo trực quan.

3. Upload ảnh, Ghi note trong lịch trình

task: [BE] Dịch vụ Lưu trữ File qua Presigned URL
Chi tiết: Thiết lập kết nối Backend với AWS S3 (hoặc Cloudflare R2). Xây dựng
 API bảo mật: nhận yêu cầu tải ảnh từ client, kiểm tra quyền truy cập lịch trình, sau đó Backend sẽ gọi AWS SDK để tạo và trả về một Presigned URL (đường dẫn ký sẵn) có thời hạn 15 phút, cho phép Client upload file thẳng lên Cloud mà không cần gửi file xuyên qua Backend gây nghẽn RAM.

task: [WEB] Tích hợp Text Editor và Kéo thả Ảnh
Chi tiết: Cài đặt một Rich Text Editor (như Quill, TipTap) vào phần Ghi chú của từng địa điểm. Lập trình sự kiện OnDrop để bắt file ảnh khi người dùng kéo thả từ máy tính vào editor. Viết hàm upload file sử dụng Presigned URL nhận từ BE, lấy link S3 công khai trả về và chèn thẻ <img> trực tiếp vào mã HTML của khung soạn thảo note.

task: [MOBILE] Xử lý chọn ảnh và nén ảnh (Image Picker & Compress)
Chi tiết: Tích hợp thư viện truy cập hệ thống file nội bộ (Image Picker) xin quyền truy cập Camera/Thư viện ảnh. Viết script xử lý nén ảnh (Compress) ngay trên điện thoại (giảm chất lượng xuống 80%, resize chiều ngang tối đa 1280px) trước khi gọi Presigned URL để upload, nhằm tiết kiệm dung lượng 3G/4G cho người dùng. Thiết kế khung nhập Note cơ bản (plain text hoặc rich text rút gọn) tối ưu cho bàn phím ảo di động.

4. Quản lý lịch trình theo nhóm (Cộng tác thời gian thực)

task: [BE] Quản lý phân quyền và Tạo link mời
Chi tiết: Tạo bảng itinerary_collaborators và viết API sinh ra Invite Link (có token mã hóa chứa ID lịch trình và hạn sử dụng). Viết middleware kiểm tra phân quyền (Owner, Editor, Viewer) trước khi cho phép thực thi bất kỳ thao tác thay đổi dữ liệu nào trên lịch trình.

task: [BE] Máy chủ đồng bộ WebSocket (CRDT)
Chi tiết: Thiết lập máy chủ WebSocket độc lập (sử dụng y-websocket hoặc thư viện tương đương). Máy chủ này có nhiệm vụ tiếp nhận kết nối từ các thành viên trong cùng một nhóm, nhận các chuỗi cập nhật nhị phân (binary updates) của cấu trúc dữ liệu CRDT, và phát sóng (broadcast) các thay đổi này đến tất cả các thành viên khác đang online ngay lập tức.  

task: [WEB] Quản lý thành viên và Cài đặt nhóm
Chi tiết: Xây dựng giao diện cho phép Owner xem danh sách thành viên đang tham gia chuyến đi. Cung cấp các nút bấm để tạo link mời copy vào clipboard, thay đổi quyền (từ Editor xuống Viewer) hoặc đuổi một thành viên ra khỏi nhóm.

task: [WEB] Tích hợp đồng bộ giao diện CRDT và Hiện diện (Presence)
Chi tiết: Gắn thư viện Yjs vào state của ứng dụng Web. Liên kết dữ liệu danh sách địa điểm với cấu trúc Y.Array. Lắng nghe sự kiện từ WebSocket để tự động render lại danh sách khi người khác thay đổi. Xây dựng module Presence để bắt tọa độ con trỏ chuột hoặc vị trí focus input của người dùng khác, hiển thị avatar nhỏ hoặc viền màu tên họ lướt trên màn hình.

task: [MOBILE] Đồng bộ màn hình nhóm và cập nhật dữ liệu realtime
Chi tiết: Xây dựng màn hình quản lý nhóm (hiển thị danh sách avatar thành viên). Kết nối ứng dụng Mobile với máy chủ WebSocket khi mở lịch trình. Khi nhận được tín hiệu cập nhật (ví dụ người khác vừa thêm một điểm đến), tiến hành refresh lại state danh sách hiển thị trên mobile ngay lập tức để dữ liệu hai bên được đồng bộ online.


5. Lưu, note lại chi phí (Kèm Đơn giản hóa Công nợ)(chức năng này khi đã có nhóm, mọi chi phí tính chung sẽ được note trên chuyến đi, sau đó sẽ có nút nhấn để tính số tiền chia ra cho từng người.)

task: [BE] API CRUD Giao dịch tài chính
Chi tiết: Tạo API để ghi nhận một giao dịch mới vào bảng expense_transactions. Payload cần xử lý chi tiết logic: Tổng tiền, Người trả tiền (Payer), Danh sách người tham gia chia tiền (Split participants) và Tỷ lệ chia (chia đều, chia theo %, chia số tiền cố định).


task: [WEB] Form nhập chi phí đa dạng và linh hoạt
Chi tiết: Tạo popup nhập chi phí. Tích hợp giao diện chọn danh mục chi tiêu (Icon/Màu sắc). Xây dựng phần logic chia tiền phức tạp: có các checkbox để tick chọn những ai tham gia vào khoản chi này, có các ô input để nhập % hoặc số tiền cụ thể cho từng người và validate đảm bảo tổng các khoản chia phải bằng đúng 100% hóa đơn.

task: [WEB] Màn hình Báo cáo Công nợ tối ưu
Chi tiết: Thiết kế một giao diện dạng danh sách hiển thị phần "Ai nợ ai". Dữ liệu lấy trực tiếp từ kết quả của thuật toán Đơn giản hóa công nợ từ BE. Mỗi mục sẽ ghi rõ "Bạn cần chuyển khoản cho [Người A]: 500,000 VND". Có thêm nút "Đánh dấu đã thanh toán" để cập nhật trạng thái xóa nợ.

task: [MOBILE] Nhập chi phí nhanh và Máy quét Hóa đơn (OCR)
Chi tiết: Tạo giao diện bấm nút (+) nổi để nhập nhanh chi phí. Tích hợp SDK máy ảnh của thiết bị kết hợp thư viện OCR (như Google ML Kit) để quét ảnh chụp hóa đơn nhà hàng. Trích xuất text số tiền tổng để tự động điền vào ô input trên mobile, giúp người dùng không phải gõ tay khi đang đi chơi ngoài đường.

6. Quản lý danh sách đồ cần mang (Packing List / Essentials)

Phân tích kỹ thuật: Tính năng Packing List không chỉ là một checklist (danh sách kiểm tra) cá nhân đơn thuần. Trong bối cảnh đi du lịch nhóm, việc chuẩn bị đồ đạc dùng chung cần được đồng bộ theo thời gian thực để tránh mang trùng lặp (ví dụ: nếu người A đã đánh dấu mang loa Bluetooth hoặc máy sấy tóc, người B sẽ thấy và không cần mang nữa). Do đó, trạng thái của Packing List cũng bắt buộc phải được gắn vào cấu trúc đồng bộ CRDT (Conflict-free Replicated Data Types) thông qua Yjs để xử lý mượt mà các thao tác tick/untick đồng thời.  

task: [BE] Quản lý cấu trúc dữ liệu và API Packing List
Chi tiết: Cập nhật cơ sở dữ liệu để lưu trữ danh sách đồ đạc. Thiết kế cấu trúc JSON tích hợp vào thuộc tính mở rộng của bảng itineraries (hoặc tạo bảng packing_lists riêng nếu dữ liệu phức tạp). Định nghĩa các Schema tương thích với thư viện y-websocket để hỗ trợ việc khởi tạo danh sách mặc định (ví dụ: gợi ý sẵn hộ chiếu, bàn chải, sạc điện thoại tùy theo loại hình chuyến đi) và đồng bộ trạng thái checkbox giữa các thành viên.

task: [WEB] Giao diện Checklist phân loại và Đồng bộ trạng thái
Chi tiết: Xây dựng một Tab "Packing List" riêng biệt trên giao diện Web. Tạo các component Checklist cho phép người dùng thêm, xóa, sửa tên món đồ và gom nhóm theo danh mục (Ví dụ: Giấy tờ, Y tế, Điện tử, Quần áo). Tích hợp Yjs vào các ô checkbox: khi một người dùng tick chọn "Đã chuẩn bị" hoặc gán tên mình vào một món đồ dùng chung, giao diện của các thành viên khác đang online phải lập tức cập nhật trạng thái mà không cần tải lại trang.

task: [MOBILE] Giao diện kiểm đồ (Check-off) và lưu trữ cục bộ
Chi tiết: Thiết kế màn hình Packing List trên Mobile tập trung vào trải nghiệm thực thi (Execution). Giao diện cần các nút checkbox lớn, hỗ trợ thao tác chạm bằng một tay (tap-to-check) hoặc vuốt để xóa (swipe-to-delete) khi người dùng đang thực sự sắp xếp vali. Mọi thao tác thay đổi trạng thái của các món đồ phải được ghi ngay vào cơ sở dữ liệu cục bộ trên điện thoại (như WatermelonDB hoặc SQLite) để người dùng có thể check đồ ngay cả khi không có mạng, sau đó luồng ngầm sẽ tự động hợp nhất (merge) dữ liệu lên server khi thiết bị online trở lại.

7. Tích hợp Maps tính khoảng cách và thời gian di chuyển

task: [BE] Proxy gọi API Distance Matrix và cơ chế Cache
Chi tiết: Xây dựng một Microservice đóng vai trò Proxy. API này nhận vào một mảng chứa tọa độ của các địa điểm trong 1 ngày. Dùng Secret Key gọi tới Goong Maps (hoặc Google Maps) Matrix API để lấy khoảng cách và thời gian di chuyển (lái xe, đi bộ). Xử lý bóc tách JSON kết quả và lưu vào Redis Cache với thời gian sống (TTL) dài để tái sử dụng nếu người dùng request lại cùng một lộ trình, giúp tiết kiệm chi phí API.  

task: [WEB] Render đường dẫn và nhãn thời gian giữa các điểm
Chi tiết: Trong giao diện danh sách các địa điểm của 1 ngày, chèn các đoạn UI nhỏ ở giữa các item. Gọi API Proxy từ BE, lấy dữ liệu và hiển thị trực tiếp lên UI (Ví dụ: Icon Ô tô - 15 km - 30 phút). Bổ sung logic đổi màu cảnh báo (màu đỏ) nếu thời gian di chuyển lớn hơn khoảng thời gian rảnh giữa giờ kết thúc của điểm A và giờ bắt đầu của điểm B.

task: [MOBILE] Nút dẫn đường trực tiếp (Deep linking)
Chi tiết: Render nhãn khoảng cách giống trên Web. Tuy nhiên, thêm một nút "Điều hướng" (Navigate). Lập trình logic sử dụng URL Scheme/Deep link (ví dụ comgooglemaps:// hoặc liên kết intent) để đẩy thẳng tọa độ địa điểm hiện tại sang ứng dụng Google Maps hoặc Apple Maps gốc trên điện thoại để tài xế có thể bắt đầu lái xe bằng GPS thật.

8. Tích hợp Maps trực quan vào ứng dụng

task: [BE] Truy vấn Box lấy điểm trên khung hình bản đồ
Chi tiết: Viết API lấy danh sách tọa độ giới hạn bằng khung hình (Bounding Box). API nhận vào 4 góc tọa độ (NorthEast, SouthWest). Sử dụng hàm ST_MakeEnvelope và ST_Intersects của PostGIS để chỉ query và trả về các địa điểm, marker đang nằm lọt trong khung nhìn hiện tại của màn hình hiển thị để tối ưu hóa băng thông.

task: [WEB] Giao diện Bản đồ và hiệu ứng Split-Screen
Chi tiết: Nhúng Mapbox GL JS (render với data Goong/OpenStreetMap). Viết logic đồng bộ state: duyệt qua danh sách các địa điểm trong lịch trình để vẽ các Marker đánh số (1, 2, 3...) theo từng ngày (mỗi ngày 1 màu).

task: [WEB] Đồng bộ hóa tương tác List - Map
Chi tiết: Xử lý sự kiện Event Listener hai chiều: Khi user di chuột qua item trên list bên trái, gọi hàm map.flyTo() để bản đồ tự động lướt và zoom vào tọa độ đó. Khi user click vào một Marker trên bản đồ, cuộn danh sách (scrollIntoView) bên trái đến đúng thẻ item tương ứng.

task: [MOBILE] Hiển thị bản đồ tổng quan chuyến đi
Chi tiết: Tích hợp thư viện react-native-maps hoặc gói Maps của Flutter. Gắn danh sách tọa độ trong ngày lên bản đồ (vẽ đường line nối các điểm). Vì hiện tại chỉ yêu cầu làm online, mỗi lần mở tab Map, ứng dụng sẽ tải lại tile bản đồ từ mạng. Thiết kế các Marker có thể click vào để mở popup nhỏ hiển thị tên địa điểm và hình thu nhỏ.

