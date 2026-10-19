# NHẬT KÝ TƯƠNG TÁC AI (AI PROMPT LOG)

## Prompt 1: Tìm hiểu cách giải quyết bài toán Vertical Alignment với Flexbox
- **User:** "Khi dàn hàng ngang cho Avatar, Tên tác giả và Nút Share, tại sao dùng float lại rất khó để căn giữa các phần tử theo chiều dọc? Thuộc tính align-items: center trong Flexbox giải quyết bài toán này như thế nào?"
- **AI Summary:** AI giải thích `float` không có cơ chế tính toán trục vuông góc (cross-axis). Mỗi phần tử `float` được đẩy độc lập về cạnh và phụ thuộc vào `line-height` hoặc `margin-top` thủ công. Trong Flexbox, `align-items: center` tự động xác định chiều cao lớn nhất của phần tử trong container và căn chỉnh tâm của tất cả các phần tử con trùng với trục giữa một cách chính xác tuyệt đối.

---

## Prompt 2: Khai phá cấu trúc Mosaic Gallery bằng CSS Grid
- **User:** "Làm thế nào để tạo một Mosaic Gallery bất đối xứng gồm 1 ảnh lớn bên trái chiếm 2 hàng và 2 ảnh nhỏ bên phải xếp chồng lên nhau bằng CSS Grid mà không gán cứng height bằng pixel?"
- **AI Summary:** Cung cấp hướng dẫn sử dụng `display: grid; grid-template-columns: 2fr 1fr; grid-template-rows: repeat(2, 200px); gap: 15px;`. Đặt cho phần tử ảnh chính thuộc tính `grid-row: span 2` để nó tự động trải dài qua 2 hàng bên trái, trong khi 2 ảnh phụ tự động xếp vào 2 ô bên phải.

---

## Prompt 3: Khám phá Utilities Classes của Bootstrap cho Flexbox
- **User:** "Hãy liệt kê các lớp tiện ích (utility classes) của Bootstrap 5 như d-flex, align-items-center, gap-3 để tôi có thể định dạng Flexbox trực tiếp trong file HTML mà không cần viết file CSS riêng."
- **AI Summary:** Liệt kê danh sách các Bootstrap Utility classes:
  - `d-flex`: Bật Flexbox container.
  - `align-items-center`: Căn giữa theo chiều dọc.
  - `justify-content-between`: Đẩy 2 khối về 2 mép.
  - `flex-wrap`: Cho phép rớt dòng khi thiếu không gian.
  - `gap-1`, `gap-2`, `gap-3`: Tạo khoảng cách tự động giữa các flex-items.

---

## Prompt 4: Khai thác thuộc tính `object-fit: cover` cho Image
- **User:** "Khi đưa ảnh vào các ô của CSS Grid có kích thước cố định, làm thế nào để ảnh không bị méo tỷ lệ (stretch)?"
- **AI Summary:** Hướng dẫn áp dụng `width: 100%; height: 100%; object-fit: cover;`. Thuộc tính `object-fit: cover` giúp hình ảnh tự động cắt tỉa (crop) giữ nguyên tỷ lệ khung hình chuẩn mà vẫn lấp đầy toàn bộ ô chứa mà không bị co giãn méo hình.