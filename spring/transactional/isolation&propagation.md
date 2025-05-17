# Spring @Transactional Examples: Isolation Levels and Propagation Types

## Isolation Levels Examples

### READ_UNCOMMITTED

```java
@Transactional(isolation = Isolation.READ_UNCOMMITTED)
public List<Product> getAllProducts() {
    return productRepository.findAll();
}
```

**Real-life scenario**: High-performance analytics dashboard showing near real-time inventory counts where absolute accuracy isn't critical. The dashboard can tolerate seeing some in-progress updates that might be rolled back later.

### READ_COMMITTED

```java
@Transactional(isolation = Isolation.READ_COMMITTED)
public Order processOrder(OrderRequest orderRequest) {
    // Process and save order
    Order order = createOrderFromRequest(orderRequest);
    orderRepository.save(order);
    
    // Update inventory
    updateInventory(order.getItems());
    
    return order;
}
```

**Real-life scenario**: E-commerce order processing system where you want to prevent dirty reads (seeing uncommitted inventory changes) but can tolerate non-repeatable reads. This gives good performance while maintaining basic data integrity.

### REPEATABLE_READ

```java
@Transactional(isolation = Isolation.REPEATABLE_READ)
public AccountSummary generateAccountStatement(Long accountId, LocalDate startDate, LocalDate endDate) {
    Account account = accountRepository.findById(accountId).orElseThrow();
    List<Transaction> transactions = transactionRepository.findByAccountAndDateBetween(account, startDate, endDate);
    
    BigDecimal openingBalance = calculateOpeningBalance(account, startDate);
    BigDecimal closingBalance = calculateClosingBalance(openingBalance, transactions);
    
    return new AccountSummary(account, openingBalance, closingBalance, transactions);
}
```

**Real-life scenario**: Banking application generating account statements. You need consistent readings of the same account data throughout the transaction, even if other transactions are modifying records.

### SERIALIZABLE

```java
@Transactional(isolation = Isolation.SERIALIZABLE)
public void transferFunds(Long fromAccountId, Long toAccountId, BigDecimal amount) {
    Account fromAccount = accountRepository.findById(fromAccountId).orElseThrow();
    Account toAccount = accountRepository.findById(toAccountId).orElseThrow();
    
    if (fromAccount.getBalance().compareTo(amount) < 0) {
        throw new InsufficientFundsException();
    }
    
    fromAccount.debit(amount);
    toAccount.credit(amount);
    
    accountRepository.save(fromAccount);
    accountRepository.save(toAccount);
    
    transactionHistoryService.recordTransfer(fromAccount, toAccount, amount);
}
```

**Real-life scenario**: Banking fund transfer where highest data integrity is required. We need to prevent phantom reads - for example, if another transaction is simultaneously creating new withdrawal records against the same account.

## Propagation Types Examples

### REQUIRED (Default)

```java
@Transactional(propagation = Propagation.REQUIRED)
public Order createOrder(Cart cart) {
    Order order = new Order();
    // Convert cart to order
    
    for (CartItem item : cart.getItems()) {
        OrderItem orderItem = createOrderItem(item);
        order.addItem(orderItem);
    }
    
    return orderRepository.save(order);
}
```

**Real-life scenario**: Standard service method that should either complete fully or roll back completely. If called from another transactional method, it will join that transaction.

### REQUIRES_NEW

```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void logAuditEvent(String user, String action, String details) {
    AuditLog log = new AuditLog(user, action, details, LocalDateTime.now());
    auditLogRepository.save(log);
}
```

**Real-life scenario**: Audit logging that must persist even if the main business transaction fails. For example, recording that a user attempted to perform an action, regardless of whether the action succeeded.

### SUPPORTS

```java
@Transactional(propagation = Propagation.SUPPORTS)
public List<Product> searchProducts(ProductSearchCriteria criteria) {
    return productRepository.findByCriteria(criteria);
}
```

**Real-life scenario**: A product search method that can work either within a transaction (if called from a transactional method) or without one (if called directly). Since it's read-only, it doesn't strictly need a transaction but can participate in one.

### NOT_SUPPORTED

```java
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public byte[] generateLargeReport() {
    // Complex, long-running report generation
    // that doesn't need a transaction and would
    // benefit from not holding one open
}
```

**Real-life scenario**: Generating a large PDF report that involves reading a lot of data but doesn't modify anything. Running this without a transaction avoids database locks and improves performance.

### MANDATORY

```java
@Transactional(propagation = Propagation.MANDATORY)
public void applyPayment(Order order, Payment payment) {
    order.addPayment(payment);
    order.updateStatus();
    orderRepository.save(order);
}
```

**Real-life scenario**: A payment application method that should never be called outside of an existing transaction. This ensures payment processing is always part of a larger transactional context.

### NEVER

```java
@Transactional(propagation = Propagation.NEVER)
public CacheStatistics getCacheStatistics() {
    // Collect and return various cache statistics
}
```

**Real-life scenario**: Monitoring/diagnostic methods that should never be part of a transaction, as they're purely for informational purposes and should throw an exception if accidentally called within a transaction.

### NESTED

```java
@Transactional(propagation = Propagation.REQUIRED)
public Order submitOrder(OrderRequest request) {
    Order order = createOrderFromRequest(request);
    orderRepository.save(order);
    
    try {
        processPayment(order, request.getPaymentDetails());
    } catch (PaymentFailedException e) {
        // Payment failed but order is still created
        order.setStatus(OrderStatus.PAYMENT_PENDING);
        orderRepository.save(order);
        notifyCustomerAboutPaymentIssue(order);
        return order;
    }
    
    // Rest of order processing
    return order;
}

@Transactional(propagation = Propagation.NESTED)
public void processPayment(Order order, PaymentDetails details) {
    // Process payment - if this fails, only this nested transaction
    // will roll back, not the parent transaction
}
```

**Real-life scenario**: Order submission where payment processing is a separate step that may fail without invalidating the entire order. The nested transaction allows the payment part to roll back independently, while the main order creation still commits.

## Advanced Combined Examples

### Example 1: Critical Financial Operation

```java
@Transactional(
    propagation = Propagation.REQUIRED,
    isolation = Isolation.SERIALIZABLE,
    timeout = 30,
    rollbackFor = Exception.class
)
public void performMonthEndAccountingClose() {
    // Critical end-of-month financial procedures
}
```

**Real-life scenario**: Month-end accounting closure that requires the highest level of data consistency and integrity. The serializable isolation prevents any concurrency issues, while the timeout ensures the process doesn't lock resources indefinitely.

### Example 2: Reporting with Performance Focus

```java
@Transactional(
    propagation = Propagation.SUPPORTS,
    isolation = Isolation.READ_COMMITTED,
    readOnly = true
)
public SalesReport generateMonthlySalesReport(YearMonth month) {
    // Generate report based on sales data
}
```

**Real-life scenario**: Generating business reports that don't need to modify data but benefit from being in a transaction if called from transactional context. The read-only flag optimizes database performance.

### Example 3: Saga Pattern Implementation

```java
@Transactional(propagation = Propagation.REQUIRED)
public void bookTrip(TripBookingRequest request) {
    // Create main booking record
    Booking booking = createInitialBooking(request);
    
    try {
        // Each of these uses REQUIRES_NEW to be independent
        flightService.bookFlight(booking.getId(), request.getFlightDetails());
    } catch (Exception e) {
        booking.setFlightStatus(BookingStatus.FAILED);
        // Continue with other bookings
    }
    
    try {
        hotelService.bookHotel(booking.getId(), request.getHotelDetails());
    } catch (Exception e) {
        booking.setHotelStatus(BookingStatus.FAILED);
        // Continue with other bookings
    }
    
    try {
        carService.rentCar(booking.getId(), request.getCarDetails());
    } catch (Exception e) {
        booking.setCarStatus(BookingStatus.FAILED);
    }
    
    // Final save of the booking with all statuses
    bookingRepository.save(booking);
}
```

**Real-life scenario**: Travel booking system implementing a saga pattern where each service (flight, hotel, car) has its own transaction that can succeed or fail independently. The main method tracks the overall status but allows partial success.
