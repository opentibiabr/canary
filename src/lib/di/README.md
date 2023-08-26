## Dependency Injection

Dependency injection is a technique for achieving loose coupling between objects and their collaborators, or dependencies. It is a form of inversion of control, where the control being inverted is the setting of object's dependencies.

### Container

A container is a place where dependencies are stored. It is responsible for creating objects and injecting their dependencies.
It is also responsible for managing the lifetime of objects it creates.

In [boost::di](https://boost-ext.github.io/di/), the container is represented by the `di::injector` class.
It is a variadic template class that takes a list of modules as template parameters.
A module is a class that defines how to create objects and how to inject their dependencies.
A module can be a class or a lambda function. 

#### Getting an Instance of a Type

To get an instance of a type, we call the `create` method of the container.

The default injector created from the `di::make_injector` function can create instances of types that weren't registered, if they are concrete types.

For interfaces, we have to register a provider for the interface.
For instance:
```cpp
class A {
public:
    virtual ~A() = default;
};

class B : public A {};

auto container = di::make_injector(
    di::bind<A>().to<B>()
);
auto a = container.create<A>();
auto a = container.create<B>();
```

Both injections above create an instance of `B`, one through the interface `A` and one directly.

#### Scopes

A scope is a way to manage the lifetime of an object.
There are two main types of scopes in our use cases:  

**Unique**

Unique scope creates a new instance of an object every time it is requested.
It is the default scope when calling the `create` method of the container.

For instance:
```cpp
auto container = di::make_injector(
    di::bind<Logger>().to<LogWithSpdLog>()
);
auto logger1 = container.create<Logger &>();
auto logger2 = container.create<Logger &>();
```

In the example above, `logger1` and `logger2` are different instances of `LogWithSpdLog`.

**Shared (Singleton)**  

Singleton scope creates a single instance of an object and returns it every time it is requested.
It is the default scope when registering a provider via reference or shared pointer.

For instance:
```cpp
auto container = di::make_injector(
    di::bind<Logger>().to<LogWithSpdLog>()
);
auto logger1 = container.create<Logger &>();
auto logger2 = container.create<Logger &>();
```

In the example above, `logger1` and `logger2` are the same instance of `LogWithSpdLog`.

### Injection

Injection is the process of providing dependencies to an object.
It is done by the container when it creates an object.

#### Constructor Injection

Constructor injection is the process of providing dependencies to an object through its constructor.
For instance:
```cpp
class A {
public:
    A(int i, double d) {}
};

class B {
public:
    B(A a) {}
};

class C {
public:
    C(A a) {}
};

auto container = di::make_injector();
auto a = container.create<A &>();
auto b = container.create<B &>();
auto c = container.create<C>();
```

In the example above, the container creates an instance of `A` and injects it into the constructors of `B` and `C`.
When the container creates an instance of `B`, it creates an instance of `A` and passes it to the constructor of `B`.
When the container creates an instance of `C`, it creates an instance of `A` and passes it to the constructor of `C`.

#### Field Injection

Field injection is the process of providing dependencies to an object through its fields.
For instance:
```cpp
class A {
public:
    int i;
    double d;
};

class B {
public:
    A &a = inject<A>();
};

auto container = di::make_injector();
auto a = container.create<A &>();
auto b = container.create<B &>();
B b2{};
```

In the example above, the container creates an instance of `A` and injects it into the field `a` of `B`.
When the container creates an instance of `B`, it creates an instance of `A` and assigns it to the field `a` of `B`.
When we create an instance of `B` manually, we have to call the `inject` function to inject an instance of `A` into the field `a` of `B`.

#### Global Variables

Our code base relies on global variables g_() that behaves like singletons.
When we moved to DependencyInjection we've migrated those singletons to the container.
For instance:
```cpp
Logger LogWithSpdLog::getInstance() {
    return inject<Logger>();
}

constexpr auto g_logger = LogWithSpdLog::getInstance;
```

In the example above, we've created a provider for the `Logger` interface.
We've also created a global variable `g_logger` that is initialized with an instance of `Logger` from the container.
Every time we call `g_logger`, we get the same instance of `Logger`.

They are somewhat softer than the traditional singletons, because we can still create instances of them manually.
That improves our testability, because we can create stubs of the `Logger` interface and inject it into the container.


### Using the Container

To simplify the registration of providers in singleton scope, we've created three auxiliary functions.

#### `DI::create<T>`

This translates directly to container.create<T>() and can return unique or shared instances, depending on the value of T.

#### `DI::get<T>`

This translates directly to container.create<T &>() and will always return the same instance.

#### `inject<T>()`

This is a shortcut for `DI::get<T>()` and is used to inject dependencies into fields of objects that are not created by the container.


### Testing

For tests, we allow the setup of a test container via the `DI::setTestContainer` function.
This function receives an instace of `di::injector` and sets it as the test container.
When the test container is set, the `DI::create<T>` and `DI::get<T>` functions will return instances from the test container.
When the test container is not set, the `DI::create<T>` and `DI::get<T>` functions will return instances from the default container.

This gives us the ability to create stubs of interfaces and inject them into the container for testing.
That way we are able to test the behavior of our code without having to rely on the implementation of the dependencies.

For instance:
```cpp
{
    di::extension::injector<> injector{};
    DI::setTestContainer(&InMemoryLogger::install(injector));

    auto &logger = dynamic_cast<InMemoryLogger &>(injector.create<Logger &>());
    auto &logger2 = dynamic_cast<InMemoryLogger &>(inject<Logger>());
    auto &logger3 = g_logger();
}
```

In the example above, we've created a test container and registered a provider for the `Logger` interface.
Because the test container is set, the `DI::create<T>` and `DI::get<T>` functions will return instances from the test container.
When we call `DI::create<Logger &>()`, we get an instance of `InMemoryLogger`.
When we call `DI::get<Logger &>()`, we get the same instance of `InMemoryLogger`.
When we call `g_logger()`, we get the same instance of `InMemoryLogger`.
