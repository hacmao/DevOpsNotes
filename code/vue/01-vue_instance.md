# Vue instance  

When starting an Vue application, we create a vue instance. It will handle many task to render html, rerender, passing data, changing props, ...  

Every vue components are also vue instance.  

```ts
var vm = new Vue({
  // options
})
```

We will pass options object to vue instance so it can do many task. Full list of options to pass to vue instance : [API](https://vuejs.org/v2/api/#Options-Data).  

## Data methods  

For example, we can pass data to vue instance.  

```ts
data = { a : 1 }

var vm = new Vue({
    data: data
})

vm.a == data.a // true 

vm.a = 3 // data.a == 3 

data.a = 3 // vm.a = 3 

data.b = 3 // vm.b != 3 
```

So we need to define a list of properties before pass it to vue instance.  

```ts
data: {
  newTodoText: '',
  visitCount: 0,
  hideCompletedTodos: false,
  todos: [],
  error: null
}
```

## Instance lifecycle hook  

```ts
new Vue({
    data: {
        a: 1
    },
    created: function() {
        console.log("a = " + this.a)
    }
})
```

![lifecycle_hook](../../img/2021-10-05-21-04-49.png)  
