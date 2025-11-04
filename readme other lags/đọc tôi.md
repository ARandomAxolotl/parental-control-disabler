# **Tập lệnh Vô hiệu hóa Kiểm soát của Phụ huynh**

## **⚠️ CẢNH BÁO NGHIÊM TRỌNG ⚠️**

Tập lệnh này được thiết kế để sửa đổi các tệp hệ thống cốt lõi của Windows và vô hiệu hóa phần mềm bảo mật. Sử dụng sai có thể gây mất ổn định hệ thống hoặc tạo ra các lỗ hổng bảo mật nghiêm trọng.

* **KHÔNG** chạy tập lệnh này nếu bạn không hiểu đầy đủ về những gì nó thực hiện.  
* Tác giả không chịu trách nhiệm cho bất kỳ thiệt hại nào đối với hệ thống của bạn.  
* **Chỉ sử dụng cho mục đích giáo dục hoặc để khôi phục quyền truy cập vào hệ thống của chính bạn.**

## **Tổng quan**

Tập lệnh batch này được thiết kế để vô hiệu hóa (hoặc kích hoạt lại) hai chương trình kiểm soát của phụ huynh:

1. **Kaspersky Safe Kids**  
2. **Microsoft Family Safety**

Nó thực hiện điều này bằng cách đổi tên các tệp thực thi quan trọng và thư mục cài đặt để ngăn chúng khởi chạy.

## **‼️ YÊU CẦU BẮT BUỘC ‼️**

1. **Môi trường Khôi phục Windows (WinRE):** Tập lệnh này **PHẢI** được chạy từ Môi trường Khôi phục Windows (WinRE). Nó sẽ không hoạt động trong một phiên Windows bình thường do các tệp đang được sử dụng và hạn chế về quyền.  
   * Bạn có thể vào WinRE bằng cách giữ phím Shift trong khi nhấp vào Restart từ menu Start, sau đó điều hướng đến Troubleshoot \> Advanced options \> Command Prompt.  
2. **Quyền Quản trị (Administrator):** Bạn cần có quyền quản trị. Dấu nhắc lệnh trong WinRE thường chạy với quyền HỆ THỐNG (SYSTEM), điều này là đủ.  
3. **Vị trí Tập lệnh:** Khuyến nghị đặt tập lệnh này trên ổ USB và chạy nó từ đó trong WinRE.

## **Hướng dẫn sử dụng**

1. Lưu tệp parental\_control\_disabler.cmd vào ổ USB.  
2. Khởi động máy tính mục tiêu vào **WinRE** và mở **Command Prompt**.  
3. Trong Command Prompt, xác định chữ cái ổ đĩa của bạn. Chúng có thể khác trong WinRE (ví dụ: ổ Windows của bạn có thể là D: và USB của bạn là E:).  
   * Bạn có thể sử dụng lệnh diskpart sau đó list volume để xem các ổ đĩa.  
4. Điều hướng đến ổ USB của bạn (ví dụ: E:).  
5. Chạy tập lệnh bằng cách gõ tên của nó:  
   parental\_control\_disabler.cmd

## **Các tùy chọn sử dụng**

### **1\. Menu Tương tác (Khuyến nghị)**

Nếu bạn chạy tập lệnh mà không có đối số (parental\_control\_disabler.cmd), một menu tương tác sẽ xuất hiện:

1. **Chọn hành động:**  
   * 1 \- (disable \- vô hiệu hóa)  
   * 2 \- (enable \- kích hoạt)  
2. **Chọn mục tiêu:**  
   * 1 \- (Kaspersky Safe Kids)  
   * 2 \- (Microsoft Family Safety)  
   * 3 \- (Both \- Cả hai)

Tập lệnh sẽ thực hiện hành động tương ứng dựa trên lựa chọn của bạn.

### **2\. Đối số Dòng lệnh**

Bạn cũng có thể chạy tập lệnh với các đối số để thực hiện một hành động cụ thể ngay lập tức:

* \--disablekaspersky: Vô hiệu hóa Kaspersky Safe Kids.  
* \--disablemicrosoftfamilysafely: Vô hiệu hóa Microsoft Family Safety (và cài đặt cửa hậu sethc.exe).  
* \--disableboth: Vô hiệu hóa cả hai.  
* \--enablekaspersky: Kích hoạt lại Kaspersky Safe Kids.  
* \--enablemicrosoftfamilysafely: Kích hoạt lại Microsoft Family Safety (và gỡ bỏ cửa hậu sethc.exe).  
* \--enableboth: Kích hoạt lại cả hai.  
* \--debugon: (Sử dụng làm đối số thứ hai) Chạy tập lệnh với chế độ gỡ lỗi (echo on).

**Ví dụ:**

parental\_control\_disabler.cmd \--disableboth

## **Chi tiết Kỹ thuật (Tập lệnh này làm gì?)**

### **Vô hiệu hóa Microsoft Family Safety (:domic)**

1. Điều hướng đến Windows\\System32.  
2. Đổi tên wpcmon.exe (Windows Parental Controls Monitor) thành wpcmon1.exe để vô hiệu hóa nó.  
3. Đổi tên sethc.exe (chương trình Sticky Keys) thành sethc1.exe.  
4. Sao chép cmd.exe (Command Prompt) và đặt tên là sethc.exe.  
   * **Hậu quả:** Điều này tạo ra một "cửa hậu" (backdoor). Từ màn hình đăng nhập Windows, nhấn phím Shift 5 lần sẽ mở Command Prompt với quyền HỆ THỐNG (SYSTEM) thay vì Sticky Keys.

### **Kích hoạt lại Microsoft Family Safety (:undomic)**

1. Điều hướng đến Windows\\System32.  
2. Xóa bản sao sethc.exe (là cmd.exe).  
3. Đổi tên sethc1.exe trở lại thành sethc.exe (khôi phục Sticky Keys).  
4. Đổi tên wpcmon1.exe trở lại thành wpcmon.exe (kích hoạt lại giám sát).

### **Vô hiệu hóa Kaspersky Safe Kids (:dokas)**

1. Điều hướng đến Program Files (x86)\\Kaspersky Lab\\.  
2. Đổi tên thư mục Kaspersky Safe Kids 23.0 thành Kaspersky Fuck Kids.  
   * **Hậu quả:** Hệ điều hành và các dịch vụ của Kaspersky sẽ không thể tìm thấy các tệp thực thi của chương trình, ngăn không cho nó khởi chạy.

### **Kích hoạt lại Kaspersky Safe Kids (:undokas)**

1. Điều hướng đến Program Files (x86)\\Kaspersky Lab\\.  
2. Đổi tên thư mục Kaspersky Fuck Kids trở lại thành Kaspersky Safe Kids 23.0.