# Route  

Define route in folder `routes`. There are 2 main file to define route : `web.php` and `api.php`.  
 + `web.php` is used to define route for web application which we can access directly from application's url. These routes are assigned `web` middleware group with session and CSRF token.  
 + `api.php` is used to define api route. It will add `/api` automatically before route's name by `RouteServiceProvider`

## Basic routing  

```php
use Illuminate\Support\Facades\Route;

Route::get('/greeting', function () {
    return 'Hello World';
});
```

## Avaiable method

```php
Route::get($uri, $callback);
Route::post($uri, $callback);
Route::put($uri, $callback);
Route::patch($uri, $callback);
Route::delete($uri, $callback);
Route::options($uri, $callback);
```

## Get parametes  

```php
Route::get('/user/{name?}', function ($name = null) {
    return $name;
});

Route::get('/user/{name?}', function ($name = 'John') {
    return $name;
});
```

