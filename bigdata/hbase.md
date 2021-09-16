# Hbase

## hbck

Xem tình trạng của các table

```bash
hbase hbck -details
```

## metadata

Mỗi khi tạo 1 bảng, hbase sẽ update thông tin về bảng đó lên 1 bảng tên là `hbase:meta`.  
Bảng này gồm 1 số cột như:
+ table:state
+ info:regioninfo
+ info:server
+ info:sn 
+ info:state

Khi query tới 1 bảng mà bị lỗi có thể kiểm tra các thông tin trong bảng này.
