# Service container  

Service container is a way to management dependencies injection. We talk to service container to know how to resolve package.  

## Binding  

### Simple binding  

Almost all of service containers will be registered in service providers. Within a provider, we can access to service container by `$this->app`.  

We can make a binding by passing a class or name that we wish to register along with a closure that return an instance of class :  

```php
use App\Services\Transistor;
use App\Services\PodcastParser;

$this->app->bind(Transistor::class, function ($app) {
    return new Transistor($app->make(PodcastParser::class));
});
```

In above closure, we bind class `Transistor` with closure which return its self. But in the closure, containers will resolve sub-dependencies of `Transistor` .

### Sigleton  

Return only once instance.  

### Binding an interface to implementation  

```php
use App\Contracts\EventPusher;
use App\Services\RedisEventPusher;

$this->app->bind(EventPusher::class, RedisEventPusher::class);
```

After we finish implementation of `RedisEventPusher`, we can bind it to interface `EventPusher`. So when we use interface `EventPusher`, it will call `RedisEventPusher`.  

```php
use App\Contracts\EventPusher;

/**
 * Create a new class instance.
 *
 * @param  \App\Contracts\EventPusher  $pusher
 * @return void
 */
public function __construct(EventPusher $pusher)
{
    $this->pusher = $pusher;
}
```

## Resolving

### `make` method  


