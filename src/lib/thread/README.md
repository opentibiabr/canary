## Thread Pool

The thread pool is a collection of threads that can be used to execute tasks.
The thread pool is created with a fixed number of threads. By default, the number of threads is the number of cpu cores.
The use can also specify the number of cores via `DEFAULT_NUMBER_OF_THREADS` environment variable.
The bigger value between the two is used.

Keep in mind that if the number of threads is too high, the performance will be degraded due to the context switching.

### Usage

The thread pool uses asio for the implementation. 
Its basic concept is to have a shared asio::io_context and have it run on multiple threads.
The user can post tasks to the thread pool and the thread pool will execute them on one of its threads.

```cpp
#include <thread/thread_pool.hpp>

int main() {
    ThreadPool &pool = inject<ThreadPool>(); // preferrably uses constructor injection or setter injection.

    // Post a task to the thread pool
    pool.detach_task([]() {
        std::cout << "Hello from thread " << std::this_thread::get_id() << std::endl;
    });
}
```

### Parallelism
The load can be executed on any thread in the thread pool, meaning that they are trully asynchronous and parallel (if you have multiple cores).
This means that you should take care of the thread safety of your code, either with atomic variables or mutexes.

### Lifetime
We have a centralized thread pool via dependency injection. This means that the thread pool will be destroyed when the dependency injection container is destroyed.
This also mean that you cannot join threads, you need to rely on signals if you want to acknowledge that the a load executed.

