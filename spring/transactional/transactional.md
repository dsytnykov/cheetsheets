# Spring @Transactional Cheatsheet

## Basic Usage

```java
@Transactional
public void transferMoney(Account from, Account to, BigDecimal amount) {
    from.debit(amount);
    to.credit(amount);
}
```

## Key Concepts

### Transaction Proxies
- Spring uses **proxies** to implement transaction management
- For class-based proxies (default): extends your class with a proxy that handles transactions
- For interface-based proxies: implements the same interfaces with transaction handling
- **Important**: The proxy intercepts method calls - direct calls within the same class bypass the proxy!

### Configuration

Enable transactions in your Spring application:

```java
@Configuration
@EnableTransactionManagement
public class AppConfig {
    // Configuration
}
```

## Common Interview Questions

### 1. How does @Transactional work internally?
Spring creates a proxy around your bean that intercepts method calls. When a transactional method is called, the proxy:
1. Starts a transaction before method execution
2. Commits the transaction after successful execution
3. Rolls back the transaction if exceptions occur

### 2. Why doesn't @Transactional work when calling a method within the same class?
When you call another method within the same class, you're making a direct method call that **bypasses the proxy**. The proxy is only involved when the method is called from outside the class.

```java
public class UserService {
    @Transactional
    public void methodA() {
        // Transaction works here
        
        // This call BYPASSES the proxy - methodB's transaction settings are ignored!
        methodB();
    }
    
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void methodB() {
        // When called from methodA, this doesn't start a new transaction!
    }
}
```

### 3. What's the difference between checked and unchecked exceptions with @Transactional?
- By default, transactions roll back on **unchecked exceptions** (RuntimeException and Error)
- Checked exceptions do NOT trigger rollback by default
- You can customize with:
  ```java
  @Transactional(rollbackFor = Exception.class, noRollbackFor = IgnoredException.class)
  ```

### 4. What happens if you place @Transactional on private methods?
It won't work! Spring proxy can only intercept public methods.

### 5. How do you control transaction behavior?
By setting attributes on the @Transactional annotation:
```java
@Transactional(
    propagation = Propagation.REQUIRED,
    isolation = Isolation.READ_COMMITTED,
    timeout = 30,
    readOnly = false,
    rollbackFor = Exception.class,
    noRollbackFor = IgnoredException.class
)
```

## Transaction Isolation Levels

| Isolation Level    | Dirty Reads | Non-repeatable Reads | Phantom Reads | Use Case |
|--------------------|-------------|----------------------|--------------|----------|
| READ_UNCOMMITTED   | Possible    | Possible             | Possible     | Highest performance, lowest consistency |
| READ_COMMITTED     | Prevented   | Possible             | Possible     | Good balance for most applications |
| REPEATABLE_READ    | Prevented   | Prevented            | Possible     | When consistency of reads is important |
| SERIALIZABLE       | Prevented   | Prevented            | Prevented    | Highest consistency, lowest concurrency |

### What they prevent:
- **Dirty Read**: Reading uncommitted changes from another transaction
- **Non-repeatable Read**: Getting different values when reading the same row twice
- **Phantom Read**: Getting different result sets when executing the same query twice

### Real-life Use Cases:
- **READ_UNCOMMITTED**: Real-time analytics where absolute accuracy isn't critical
- **READ_COMMITTED**: Most business applications, e-commerce order processing
- **REPEATABLE_READ**: Financial calculations, reporting systems
- **SERIALIZABLE**: Critical financial transactions, regulatory compliance scenarios

## Transaction Propagation Types

| Propagation Type     | Description                                                      | Real-life Use Case |
|----------------------|------------------------------------------------------------------|-------------------|
| REQUIRED (default)   | Use current transaction, create new one if none exists           | Most service methods |
| REQUIRES_NEW         | Always create a new transaction, suspend current if exists       | Operations that must commit/rollback independently |
| SUPPORTS             | Use current transaction if exists, otherwise non-transactional   | Read-only operations that can work either way |
| NOT_SUPPORTED        | Execute non-transactionally, suspend current if exists           | Long-running read operations |
| MANDATORY            | Use current transaction, throw exception if none exists          | Methods that should never be called outside a transaction |
| NEVER                | Execute non-transactionally, throw exception if transaction exists | Operations that should never run within a transaction |
| NESTED               | Execute in nested transaction if transaction exists              | Operations that should conditionally roll back |

### Real-life Use Cases:
- **REQUIRES_NEW**: Logging operations, audit trails that must persist even if main transaction fails
- **MANDATORY**: Critical updates that should never run on their own
- **NESTED**: Multi-step operations where some steps can fail without failing the whole transaction

## Best Practices

1. Place @Transactional on service-layer methods, not on DAO/Repository methods
2. Be mindful of proxy limitations when calling transactional methods within the same class
3. Use read-only transactions for read operations to improve performance
4. Choose the right isolation level based on your consistency vs. performance needs
5. Set appropriate timeout values for long-running transactions
6. Be specific about exception handling with rollbackFor and noRollbackFor
7. Consider using TransactionTemplate for programmatic transaction management

## Common Pitfalls

1. Self-invocation (calling @Transactional methods from the same class)
2. Using @Transactional on non-public methods
3. Ignoring checked exceptions that should trigger rollback
4. Using wrong isolation levels can cause data inconsistency or performance issues
5. Setting overly restrictive isolation can cause deadlocks
6. Not using read-only flag for read operations
7. Overly long-running transactions without proper timeout settings
