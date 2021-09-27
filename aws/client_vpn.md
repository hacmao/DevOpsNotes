# Create client vpn

## Create ACM certificate

[AWS](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/client-authentication.html#mutual).  
Download `easyrsa`.  

```bash
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa build-server-full server nopass
./easyrsa build-client-full client1.domain.tld nopass
```

Import server certificate to ACM : `issused/server.crt` and `private/server.key`.  

## Create Client VPN  

Follow step by step.  

## Configure client vpn

+ Association : with 2 private subnet
+ Authorization: allow 0.0.0.0/0
+ Route table: route to 2 private subnet


