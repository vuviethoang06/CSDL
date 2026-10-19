# BÁO CÁO PHÂN TÍCH VÀ TỐI ƯU TRUY VẤN (EXPLAIN ANALYSIS REPORT)
**Dự án:** Ví điện tử PayFlow  
**Vai trò:** Database Performance Engineer  

---

### 1. Phân tích điểm nghẽn hiệu suất (Bottleneck)
Cú pháp cũ do team Kế toán viết bị nghẽn nghiêm trọng do viết theo dạng **Non-SARGable**:
```sql
WHERE transaction_type = 'DEPOSIT' AND YEAR(created_at) = 2026 AND MONTH(created_at) = 6;