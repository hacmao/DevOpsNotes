# Hbase

## hbck

Xem tình trạng của các table

```bash
hbase hbck -details
```

Với hbase > 2.0.0, ta phải dùng tới hbck2 để thực hiện các lệnh sửa chữa :  

```bash
sudo hbase hbck -j /usr/lib/hbase-operator-tools/hbase-hbck2-1.0.0.jar <cmd>
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

## zkcli

Có thể tương tác với zookeeper từ hbase để thực hiện một số tác vụ.

+ xóa bảng :  

```bash
hbase zkcli rmr /hbase/table/test
```

## Cách xóa zombie table

+ xóa trong hadoop

```bash
hadoop fs -rmr /user/hbase/<table>
```

+ xóa trong zookeeper
+ xóa trong S3 (nếu làm với AWS)
+ xóa meta data
+ restart hbase master


