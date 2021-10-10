# Computed properties  

```js
new Vue({
    data: {
        message: "Hello world"
    }
    computed: {
        reversedMessage: function () {
            return this.message.split('').reverse().join('')
        }
    }
});
```

Then we can use that in `<template>` :  

```html
<template>
    <p>Original message: "{{ message }}"</p>
    <p>Computed reversed message: "{{ reversedMessage }}" </p>
</template>
```

If we use `reversedMessage` insteadof `reversedMessage()`, it will be cached based on dependencies. If there is something change, it will be regenerated.  
