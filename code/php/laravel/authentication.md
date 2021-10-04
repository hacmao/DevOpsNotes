# Authentication  

[Doc](https://laravel.com/docs/8.x/authentication#retrieving-the-authenticated-user)  

## Breeze  

Breeze is a minimal, simple implementation of laravel's authentication, including login, registration, password reset, email verification, password confirmation.  

+ Install :  

```bash
composer require laravel/breeze --dev
php artisan breeze:install
npm install
npm run dev
php artisan migrate
```

+ Test :  

```bash
php artisan serve
```

## Retrieving authenticated user  

+ By using `Auth` facades:  

```php
use Illuminate\Support\Facades\Auth;

// Retrieve the currently authenticated user...
$user = Auth::user();
$username = Auth::user()->name;

// Retrieve the currently authenticated user's ID...
$id = Auth::id();
```

+ Or access user in controller by `Request`:  

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class FlightController extends Controller
{
    /**
     * Update the flight information for an existing flight.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request)
    {
        // $request->user()
    }
}
```

## Determining if current user is authenticated  

```php
if (Auth::check()){
    // TO DO
}
```

+ Or by middleware :  

```php
Route::get('/', function() {
    // TO DO
})->middleware('auth');
```
