# Kubernetes - các khái niệm cơ bản

## Khởi tạo một cluster

+ Tạo cluster:

```bash
eksctl create cluster --name fargate-cluster --region ap-southeast-1
```

+ Tạo nodegroup:

```bash
eksctl create nodegroup --config-file=../nodegroup.yaml
```

+ Tạo fargate profile:

```bash
eksctl create fargateprofile --cluster fargate-cluster --name dev --namespace dev
```

+ Kết nối kubelet với eks cluster:

```bash
aws eks update-kubeconfig --name fargate-cluster --region ap-southeast-1
```

## Pods

Pods là đơn vị nhỏ nhất mà Kubenets cho phép ta triển khai. Bao gồm 1 hoặc nhiều containers. Tất cả containers trong 1 pod đều sử dụng chung namespace, volumes, network. Điều này cho phép chúng giao tiếp với nhau thông qua `localhost`.

```yaml
$ cat pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

Tạo pods:

```bash
kubectl apply -f pod.yaml -n dev
```

Xem logs:  

```bash
kubectl logs <pod-name> --namespace <namespace-name>
```

Get shell :  

```bash
kubectl exec <pod-name> -it /bin/bash
```

## Deployment

Định nghĩa 1 `trạng thái mong muốn` ví dụ như là 4 replicas of a pod. Từ đó, deployment controller sẽ đảm bảo trạng thái hiện có và mong muốn phải tương đồng. Deployment đảm bảo pods sẽ được khởi tạo lại nếu pod bị fails hoặc reboots. Cho phép scaling replicas. Deployment quản lí `ReplicaSets` và update các pods.

### Create sample deployment

```yaml
 $ cat deployment.yaml
apiVersion: apps/v1
kind: Deployment # kubernetes object type
metadata:
  name: nginx-deployment # deployment name
spec:
  replicas: 3 # number of replicas
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx # pod labels
    spec:
      containers:
      - name: nginx # container name
        image: nginx:1.12.1 # nginx image
        imagePullPolicy: IfNotPresent # if exists, will not pull new image
        ports: # container and host port assignments
        - containerPort: 80
        - containerPort: 443
```

### Scaling a deployment

```bash
kubectl scale --replicas=5 deployment nginx-deployment
```

### Update a deployment

```bash
kubectl edit --replicas=5 deployment nginx-deployment 
```

### Rollback

```bash
kubectl rollout history deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment --to-revision=<version>
```

## Service

Pod là tạm thời. Nó có thể bị tắt và khởi động lại. Khi đó, địa chỉ IP gán với port đó có thể bị thay đổi. Thêm nữa, pod mới có thể được tạo ra nhờ `Deployment` hoặc `ReplicaSets`. Điều này gây khó khăn khi giao tiếp với pod thông qua địa chỉ IP.

Service là một lớp trừu tượng, định nghĩa một bộ các pods theo một mối quan hệ logic nào đó. Ip của service không thay đổi nên đáng tin hơn pod. Service quản lí các logic pod thông qua nhãn selector.

## Sample service

```yaml
$ cat service.yaml
apiVersion: v1
kind: Service
metadata:
  name: echo-service
spec:
  selector:
    app: echo-pod
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer
```

Service `echo-service` sẽ tiến hành quản lí các pods có nhãn `app:echo-pod`. Nó cũng định nghĩa một inbound traffic từ cổng 80 của host tới cổng 8080 của containers.

### Publish services

Có 4 loại service:

+ `ClusterIP`: service sẽ exposed 1 ip trong mạng của cluster. Đây là thiết lập mặc định
+ `NodePort`: service sẽ mở 1 port trên từng `nodes`
+ `LoadBalancer`: nếu deploy trên cloud, nó sẽ tạo 1 loadbalancer
+ `ExternalName`: ...

[More](https://github.com/hacmao/eksworkshop/blob/main/beginner/06-ingress.md)  

```yaml
apiVersion: v1
kind: Service
metadata:
  name: echo-service
spec:
  selector:
    app: echo-pod
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer
```

-> Tạo một sample service có sử dụng classic load balancer.  

Muốn dùng ALB, làm theo [hướng dẫn](https://www.eksworkshop.com/beginner/130_exposing-service/ingress_controller_alb/).  

## DaemonSet

Daemon Set đảm bảo 1 bản copy của pod chạy trên 1 node chỉ định. Mặc định là tất cả các nodes trong cluster đều được chọn.  

### Create a DaemonSet

```yaml
$ cat daemonset.yaml
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: prometheus-daemonset
spec:
  selector:
    matchLabels:
      tier: monitoring
      name: prometheus-exporter
  template:
    metadata:
      labels:
        tier: monitoring
        name: prometheus-exporter
    spec:
      containers:
      - name: prometheus
        image: prom/node-exporter
        ports:
        - containerPort: 80
```
  
Ta có thể chỉ định chính xác nodes nào sẽ chạy pods bằng cách thêm `nodeSelector` vào phần `spec.template.spec`.  

## Job  

Job bao gồm 1 hoặc nhiều pods và đảm bảo số lượng nhất định các pods được thực thi thành công. Khi đạt tới số lượng chỉ định, jobs được coi là hoàn thành.

### Non-parrallel Job  

Chạy chỉ 1 pod / 1 job.

```yaml
$ cat job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: wait
spec:
  template:
    metadata:
      name: wait
    spec:
      containers:
      - name: wait
        image: ubuntu
        command: ["sleep",  "20"]
      restartPolicy: Never
```

### Parrallel Job  

```yaml
$ cat job-parallel.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: wait
spec:
  completions: 6
  parallelism: 2
  template:
    metadata:
      name: wait
    spec:
      containers:
      - name: wait
        image: ubuntu
        command: ["sleep",  "20"]
      restartPolicy: Never
```

Chạy song song 2 pods 1 lúc cho tới khi đạt `.spec.completions` pods thành công.  
