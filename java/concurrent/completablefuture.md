# Java CompletableFuture Cheatsheet

## Overview

CompletableFuture is Java's implementation of the Promise pattern, providing a powerful API for asynchronous programming and composition of non-blocking operations. It implements both `Future` and `CompletionStage` interfaces.

## Core Creation Methods

### Static Factory Methods

```java
// Completed future with value
CompletableFuture<String> completed = CompletableFuture.completedFuture("result");

// Failed future
CompletableFuture<String> failed = CompletableFuture.failedFuture(new RuntimeException("error"));

// Async computation with default ForkJoinPool
CompletableFuture<String> async = CompletableFuture.supplyAsync(() -> "computed value");

// Async computation with custom executor
CompletableFuture<String> asyncCustom = CompletableFuture.supplyAsync(
    () -> "computed value", 
    customExecutor
);

// Async runnable (no return value)
CompletableFuture<Void> runAsync = CompletableFuture.runAsync(() -> {
    System.out.println("Task executed");
});
```

### Manual Completion

```java
CompletableFuture<String> future = new CompletableFuture<>();

// Complete normally
future.complete("result");

// Complete exceptionally
future.completeExceptionally(new RuntimeException("error"));

// Complete with timeout
future.completeOnTimeout("default", 5, TimeUnit.SECONDS);

// Complete if not already done
boolean completed = future.complete("backup result");
```

## Transformation Operations

### Map-like Operations

```java
CompletableFuture<String> base = CompletableFuture.supplyAsync(() -> "hello");

// Synchronous transformation
CompletableFuture<String> upper = base.thenApply(String::toUpperCase);

// Asynchronous transformation
CompletableFuture<String> upperAsync = base.thenApplyAsync(String::toUpperCase);

// With custom executor
CompletableFuture<String> upperCustom = base.thenApplyAsync(
    String::toUpperCase, 
    customExecutor
);
```

### FlatMap-like Operations (Composition)

```java
// Chain dependent async operations
CompletableFuture<String> composed = base
    .thenCompose(s -> CompletableFuture.supplyAsync(() -> s + " world"));

// Async version
CompletableFuture<String> composedAsync = base
    .thenComposeAsync(s -> fetchFromDatabase(s));
```

### Side Effects (Consume)

```java
// Consume result without returning value
CompletableFuture<Void> consumed = base.thenAccept(System.out::println);

// Consume result asynchronously
CompletableFuture<Void> consumedAsync = base.thenAcceptAsync(result -> {
    // Process result
});

// Chain without consuming result
CompletableFuture<String> chained = base.thenRun(() -> {
    System.out.println("Task completed");
}).thenReturn(base); // Custom method - use thenApply(_ -> originalResult)
```

## Combining Multiple Futures

### Combining Two Futures

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> "Hello");
CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> "World");

// Combine both results
CompletableFuture<String> combined = future1.thenCombine(future2, (a, b) -> a + " " + b);

// Combine with async execution
CompletableFuture<String> combinedAsync = future1.thenCombineAsync(future2, (a, b) -> a + " " + b);

// Accept both results without returning value
CompletableFuture<Void> accepted = future1.thenAcceptBoth(future2, (a, b) -> {
    System.out.println(a + " " + b);
});

// Run after both complete
CompletableFuture<Void> afterBoth = future1.runAfterBoth(future2, () -> {
    System.out.println("Both completed");
});
```

### Either Operations (First to Complete)

```java
CompletableFuture<String> fast = CompletableFuture.supplyAsync(() -> "fast");
CompletableFuture<String> slow = CompletableFuture.supplyAsync(() -> {
    Thread.sleep(1000);
    return "slow";
});

// Apply function to first result
CompletableFuture<String> firstResult = fast.applyToEither(slow, String::toUpperCase);

// Accept first result
CompletableFuture<Void> firstAccepted = fast.acceptEither(slow, System.out::println);

// Run after first completes
CompletableFuture<Void> afterEither = fast.runAfterEither(slow, () -> {
    System.out.println("One completed");
});
```

### Multiple Futures Composition

```java
List<CompletableFuture<String>> futures = Arrays.asList(
    CompletableFuture.supplyAsync(() -> "task1"),
    CompletableFuture.supplyAsync(() -> "task2"),
    CompletableFuture.supplyAsync(() -> "task3")
);

// Wait for all to complete
CompletableFuture<Void> allOf = CompletableFuture.allOf(
    futures.toArray(new CompletableFuture[0])
);

// Collect all results
CompletableFuture<List<String>> allResults = allOf.thenApply(v ->
    futures.stream()
        .map(CompletableFuture::join)
        .collect(Collectors.toList())
);

// Wait for any to complete
CompletableFuture<Object> anyOf = CompletableFuture.anyOf(
    futures.toArray(new CompletableFuture[0])
);
```

## Error Handling

### Exception Handling

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    if (Math.random() > 0.5) {
        throw new RuntimeException("Random failure");
    }
    return "success";
});

// Handle exceptions
CompletableFuture<String> handled = future.handle((result, throwable) -> {
    if (throwable != null) {
        return "default value";
    }
    return result;
});

// Handle exceptions with different type
CompletableFuture<Integer> transformed = future.handle((result, throwable) -> {
    if (throwable != null) {
        return -1;
    }
    return result.length();
});
```

### Exception Recovery

```java
// Recover from exception
CompletableFuture<String> recovered = future.exceptionally(throwable -> {
    System.err.println("Error occurred: " + throwable.getMessage());
    return "recovery value";
});

// Async recovery
CompletableFuture<String> recoveredAsync = future.exceptionallyAsync(throwable -> {
    // Perform async recovery operation
    return "async recovery value";
});

// Compose recovery
CompletableFuture<String> composedRecovery = future.exceptionallyCompose(throwable -> {
    return CompletableFuture.supplyAsync(() -> "composed recovery");
});
```

### When Complete

```java
// Execute on both success and failure
CompletableFuture<String> withCallback = future.whenComplete((result, throwable) -> {
    if (throwable != null) {
        System.err.println("Failed: " + throwable.getMessage());
    } else {
        System.out.println("Succeeded: " + result);
    }
});

// Async version
CompletableFuture<String> withCallbackAsync = future.whenCompleteAsync((result, throwable) -> {
    // Handle completion asynchronously
});
```

## Advanced Patterns

### Timeout Handling

```java
// Complete with timeout
CompletableFuture<String> withTimeout = future
    .completeOnTimeout("timeout value", 5, TimeUnit.SECONDS);

// Timeout with exception
CompletableFuture<String> timeoutException = future
    .orTimeout(5, TimeUnit.SECONDS);
```

### Retry Pattern

```java
public static <T> CompletableFuture<T> retry(Supplier<CompletableFuture<T>> supplier, int maxRetries) {
    return supplier.get().exceptionallyCompose(throwable -> {
        if (maxRetries > 0) {
            return retry(supplier, maxRetries - 1);
        }
        return CompletableFuture.failedFuture(throwable);
    });
}

// Usage
CompletableFuture<String> retried = retry(() -> 
    CompletableFuture.supplyAsync(() -> callUnreliableService()), 3);
```

### Circuit Breaker Pattern

```java
public class CircuitBreaker {
    private final int threshold;
    private final long timeout;
    private int failureCount = 0;
    private long lastFailureTime = 0;
    private State state = State.CLOSED;
    
    public <T> CompletableFuture<T> execute(Supplier<CompletableFuture<T>> supplier) {
        if (state == State.OPEN && System.currentTimeMillis() - lastFailureTime < timeout) {
            return CompletableFuture.failedFuture(new RuntimeException("Circuit breaker is OPEN"));
        }
        
        return supplier.get()
            .whenComplete((result, throwable) -> {
                if (throwable != null) {
                    onFailure();
                } else {
                    onSuccess();
                }
            });
    }
    
    private void onFailure() {
        failureCount++;
        lastFailureTime = System.currentTimeMillis();
        if (failureCount >= threshold) {
            state = State.OPEN;
        }
    }
    
    private void onSuccess() {
        failureCount = 0;
        state = State.CLOSED;
    }
    
    enum State { CLOSED, OPEN }
}
```

### Parallel Processing with Limits

```java
// Process items with concurrency limit
public static <T, R> CompletableFuture<List<R>> processWithLimit(
        List<T> items, 
        Function<T, CompletableFuture<R>> processor, 
        int concurrencyLimit) {
    
    Semaphore semaphore = new Semaphore(concurrencyLimit);
    
    List<CompletableFuture<R>> futures = items.stream()
        .map(item -> {
            return CompletableFuture
                .supplyAsync(() -> {
                    try {
                        semaphore.acquire();
                        return processor.apply(item).join();
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        throw new RuntimeException(e);
                    } finally {
                        semaphore.release();
                    }
                });
        })
        .collect(Collectors.toList());
    
    return CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]))
        .thenApply(v -> futures.stream()
            .map(CompletableFuture::join)
            .collect(Collectors.toList()));
}
```

## Blocking Operations

### Synchronous Access

```java
// Block until completion
String result = future.get(); // Can throw InterruptedException, ExecutionException

// Block with timeout
String resultWithTimeout = future.get(5, TimeUnit.SECONDS); // Can throw TimeoutException

// Block without checked exceptions (may throw unchecked exceptions)
String joinResult = future.join(); // CompletionException for failures

// Non-blocking check
if (future.isDone()) {
    String result = future.getNow("default"); // Returns default if not completed
}
```

### State Checking

```java
boolean isDone = future.isDone();
boolean isCancelled = future.isCancelled();
boolean isCompletedExceptionally = future.isCompletedExceptionally();

// Get number of dependents
int dependents = future.getNumberOfDependents();
```

## Cancellation

```java
// Cancel the future
boolean cancelled = future.cancel(true); // mayInterruptIfRunning

// Create pre-cancelled future
CompletableFuture<String> cancelledFuture = new CompletableFuture<>();
cancelledFuture.cancel(false);
```

## Custom Executors

```java
// Custom thread pool
ExecutorService customExecutor = Executors.newFixedThreadPool(10);

// Use with CompletableFuture
CompletableFuture<String> customExecution = CompletableFuture
    .supplyAsync(() -> "custom execution", customExecutor)
    .thenApplyAsync(String::toUpperCase, customExecutor);

// Don't forget to shutdown
customExecutor.shutdown();
```

## Best Practices

### Resource Management

```java
// Proper executor shutdown
try {
    ExecutorService executor = Executors.newCachedThreadPool();
    CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> "result", executor);
    String result = future.get();
} finally {
    executor.shutdown();
    if (!executor.awaitTermination(60, TimeUnit.SECONDS)) {
        executor.shutdownNow();
    }
}
```

### Exception Propagation

```java
// Proper exception handling in chains
CompletableFuture<String> chain = CompletableFuture
    .supplyAsync(() -> {
        if (condition) throw new BusinessException("Business error");
        return "success";
    })
    .thenApply(result -> {
        // This won't execute if previous stage failed
        return result.toUpperCase();
    })
    .exceptionally(throwable -> {
        if (throwable.getCause() instanceof BusinessException) {
            return "business error handled";
        }
        return "generic error handled";
    });
```

### Performance Considerations

```java
// Avoid blocking in async callbacks
CompletableFuture<String> bad = future.thenApply(result -> {
    // DON'T DO THIS - blocks the thread
    return anotherFuture.join();
});

// Use composition instead
CompletableFuture<String> good = future.thenCompose(result -> {
    // Properly chains without blocking
    return anotherFuture;
});
```

## Common Pitfalls to Avoid

1. **Don't block in async callbacks** - Use `thenCompose` instead of `thenApply` + `join()`
2. **Handle exceptions properly** - Use `handle`, `exceptionally`, or `whenComplete`
3. **Don't create too many threads** - Use appropriate executors and limit concurrency
4. **Avoid nested CompletableFutures** - Use `thenCompose` to flatten
5. **Remember to handle timeouts** - Use `orTimeout` or `completeOnTimeout`
6. **Shutdown custom executors** - Prevent resource leaks
7. **Use `join()` over `get()`** - When you don't need to handle InterruptedException separately

## Testing CompletableFutures

```java
@Test
public void testAsyncOperation() throws Exception {
    // Test with immediate completion
    CompletableFuture<String> future = CompletableFuture.completedFuture("test");
    assertEquals("test", future.join());
    
    // Test with async execution
    CompletableFuture<String> asyncFuture = CompletableFuture.supplyAsync(() -> "async");
    assertEquals("async", asyncFuture.get(1, TimeUnit.SECONDS));
    
    // Test exception handling
    CompletableFuture<String> failedFuture = CompletableFuture.supplyAsync(() -> {
        throw new RuntimeException("test error");
    });
    
    assertThrows(ExecutionException.class, () -> failedFuture.get());
    
    // Test with mock executor for deterministic behavior
    Executor immediateExecutor = Runnable::run;
    CompletableFuture<String> immediate = CompletableFuture.supplyAsync(() -> "immediate", immediateExecutor);
    assertTrue(immediate.isDone());
}
```