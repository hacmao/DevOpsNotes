# DevOps notes 

## Laravel force https 

https://stackoverflow.com/questions/35827062/how-to-force-laravel-project-to-use-https-for-all-routes/67638121#67638121

Add below to nginx :  

```bash
fastcgi_param  HTTPS "on";
```
