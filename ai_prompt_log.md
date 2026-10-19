# NHẬT KÝ TƯƠNG TÁC AI (AI PROMPT LOG)

## Prompt 1: Phân tích bản chất 1D và 2D giữa Flexbox và CSS Grid
- **User:** "Khi tôi cần một bố cục mà một phần tử con (Child) phải chiếm chính xác 2 hàng và 2 cột (span 2 rows, 2 columns) đan xen với các phần tử nhỏ khác, tôi nên chọn CSS Grid hay Flexbox? Tại sao Flexbox lại chật vật với yêu cầu này?"
- **AI Summary:** AI phân tích Flexbox là hệ thống dàn trang 1 chiều (1D). Mỗi hàng/cột trong Flexbox hoạt động độc lập và không biết sự tồn tại của các hàng khác, do đó Flexbox không thể bắt một item chiếm không gian trên 2 hàng đồng thời mà không tạo ra các thẻ bọc phức tạp. CSS Grid là hệ thống 2D, quản lý đồng thời cả hàng và cột, cho phép dùng `grid-column: span 2` và `grid-row: span 2` cực kỳ dễ dàng.

---

## Prompt 2: Khai thác tính năng của Bootstrap 5 Grid
- **User:** "Trong Bootstrap 5, sự khác biệt giữa lớp col-sm-4 và col-md-4 là gì? Tại sao tôi nên dùng Bootstrap cho một phần tử đơn giản như 3 cột Bảng giá thay vì tự viết CSS Grid?"
- **AI Summary:** `col-sm-4` kích hoạt điểm ngắt ở màn hình Small (>= 576px), trong khi `col-md-4` kích hoạt ở Medium (>= 768px). Dùng Bootstrap cho Bảng giá giúp tái sử dụng mã nguồn chuẩn, hỗ trợ giao diện Responsive sẵn có (stack hàng dọc ở mobile và thành 3 cột ở desktop) cùng hệ thống UI Card đồng bộ mà không cần bảo trì các Media Queries thủ công.

---

## Prompt 3: Cú pháp Bento Box dùng CSS Grid
- **User:** "Hãy cho tôi xem một cú pháp CSS Grid đơn giản (sử dụng span) để tạo một layout dạng Bento Box: có 1 hình vuông lớn bên trái chiếm 2x2, và các hình vuông nhỏ khác bên phải."
- **AI Summary:** Cung cấp mã mẫu dùng `display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;`. Đặt cho item lớn class `grid-column: span 2; grid-row: span 2;`, giúp các item còn lại tự động lấp đầy các khoảng trống theo thuật toán xếp lưới của CSS Grid.

---

## Prompt 4: Mở rộng kiến thức về thuộc tính `gap`
- **User:** "Thuộc tính gap hỗ trợ như thế nào trong cả CSS Grid và Flexbox? Tại sao nên dùng gap thay vì margin trong dàn trang hiện đại?"
- **AI Summary:** Thuộc tính `gap` (hoặc `row-gap`, `column-gap`) tạo khoảng cách trực tiếp giữa các item trong container mà không tạo ra khoảng thừa ở phần tử đầu/cuối (tránh lỗi margin collapse). Hiện tại `gap` đã được hỗ trợ native trên toàn bộ trình duyệt hiện đại cho cả CSS Grid lẫn Flexbox.