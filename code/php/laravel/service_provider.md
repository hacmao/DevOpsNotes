# Service provider  

Service provider is a service that will be ran with our applications at boostrap. It will provide many function for our application. Many providers won't be load in every request but it will be loaded when application uses its services.  

We can view a list of providers in array `providers` in `config/app.php`.  

## Creating a service provider  

```bash
php artisan make:provider RedisServiceProvider
```

Php will create a provider for us. Service provider's code will be put in `vendor\laravel\framework\src\Illuminate\Redis`.  

### Register method  

