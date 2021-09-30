# Middleware

[Doc](https://laravel.com/docs/8.x/middleware)

Middleware provide a mechanism for inspecting and filtering HTTP request. For example, we can use middleware to authenticate users, and return user to homepage if user is not authenticated.  

## Defining a middleware

Use command to create a middleware:  

```bash
php artisan make:middleware TestMiddleware
```

After that, there will be a middleware which will be located in folder `app/Http/Middlerware`.  

Sample:  

```php
<?php

namespace App\Http\Middleware;

use Closure;

class EnsureTokenIsValid
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        if ($request->input('token') !== 'my-secret-token') {
            return redirect('home');
        }

        return $next($request);
    }
}
```

Above middleware will check for user's token. It will return to home by `redirect('home')` or forward request deeper into application by `$next` closure.  

## Registering Middleware

### Global Middleware 

If we list middleware in `$middleware` property in file `Kernel.php`, it will be ran in every HTTP request.  

```php
protected $middleware = [
    // \App\Http\Middleware\TrustHosts::class,
    \App\Http\Middleware\TrustProxies::class,
    \Fruitcake\Cors\HandleCors::class,
    \App\Http\Middleware\PreventRequestsDuringMaintenance::class,
    \Illuminate\Foundation\Http\Middleware\ValidatePostSize::class,
    \App\Http\Middleware\TrimStrings::class,
    \Illuminate\Foundation\Http\Middleware\ConvertEmptyStringsToNull::class,

    \App\Http\Middleware\DBTransaction::class,
];
```

### Assign a middleware to a route  

We can assign a key for each middleware in `$routeMiddleware` :  

```php
protected $routeMiddleware = [
    'auth' => \App\Http\Middleware\Authenticate::class,
    'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
    'bindings' => \Illuminate\Routing\Middleware\SubstituteBindings::class,
    'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
    'can' => \Illuminate\Auth\Middleware\Authorize::class,
    'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
    'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
    'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
    'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
];
```

Once we define middleware in HTTP Kernel, we can use `middleware` method to assign middleware to route.  

```php
Route::get('/', function () {
    echo "Hello world";   
})->middleware('auth');
```

+ We can assign multiple middleware by list :  

```php
Route::get('/', function() {
    echo "Hello world";
})->middleware(['auth', 'second']);
```

+ We can group many route which use same group of middlewares :  

```php
use \App\Http\Middleware\TestMiddleware;

Route::middleware([TestMiddleware::class])->group(function () {
    Route::get('/', function() {
        //
    });

    Route::get('/api', function() {
        //
    })->withoutMiddleware([TestMiddleware::class])
});
```

## Middleware group  

Group by add to `$middlewareGroups`.

