# HDFS

## Refresh node

- get nodes 

```bash
hadoop dfsadmin -report
```

- refresh name node

```bash
systemctl restart hadoop-hdfs-namenode.service
```
