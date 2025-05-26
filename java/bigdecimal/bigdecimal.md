# BigDecimal & BigInteger Cheatsheet for Senior Java Developers

## Overview
High-precision arithmetic classes in Java for handling numbers beyond primitive type limits and avoiding floating-point precision issues.

## BigDecimal - Arbitrary Precision Decimal Numbers

### Core Concepts
- **Immutable**: All operations return new instances
- **Scale**: Number of digits after decimal point
- **Precision**: Total number of significant digits
- **Unscaled Value**: The actual numeric value without decimal point

### Creation Patterns
```java
// PREFERRED - Avoids floating-point representation issues
BigDecimal bd1 = new BigDecimal("123.45");
BigDecimal bd2 = BigDecimal.valueOf(123.45);

// AVOID - Can introduce precision errors
BigDecimal bd3 = new BigDecimal(123.45); // May not equal 123.45 exactly

// Factory methods
BigDecimal.ZERO, BigDecimal.ONE, BigDecimal.TEN
```

### Essential Operations
```java
// Arithmetic (all return new BigDecimal instances)
BigDecimal result = bd1.add(bd2);
BigDecimal result = bd1.subtract(bd2);
BigDecimal result = bd1.multiply(bd2);
BigDecimal result = bd1.divide(bd2, RoundingMode.HALF_UP);
BigDecimal result = bd1.divide(bd2, 2, RoundingMode.HALF_UP); // 2 decimal places

// Comparison
bd1.compareTo(bd2) // Returns -1, 0, or 1
bd1.equals(bd2)    // Scale-sensitive: 2.0 != 2.00
```

### Rounding Modes (Critical for Financial Applications)
```java
RoundingMode.HALF_UP      // Round away from zero (traditional rounding)
RoundingMode.HALF_DOWN    // Round toward zero  
RoundingMode.HALF_EVEN    // Banker's rounding (reduces bias)
RoundingMode.UP           // Always round away from zero
RoundingMode.DOWN         // Always round toward zero (truncate)
RoundingMode.CEILING      // Round toward positive infinity
RoundingMode.FLOOR        // Round toward negative infinity
RoundingMode.UNNECESSARY  // Throws exception if rounding needed
```

### MathContext - Precision Control
```java
MathContext mc = new MathContext(10, RoundingMode.HALF_UP);
BigDecimal result = bd1.divide(bd2, mc);

// Predefined contexts
MathContext.DECIMAL32    // 7 digits, HALF_EVEN
MathContext.DECIMAL64    // 16 digits, HALF_EVEN  
MathContext.DECIMAL128   // 34 digits, HALF_EVEN
MathContext.UNLIMITED    // Unlimited precision
```

### Scale Management
```java
BigDecimal bd = new BigDecimal("123.450");
bd.scale()                    // Returns 3
bd.precision()                // Returns 6
bd.stripTrailingZeros()       // Returns 123.45 (scale = 2)
bd.setScale(2, RoundingMode.HALF_UP)  // Force scale to 2
```

### Common Patterns for Senior Developers
```java
// Safe division with proper error handling
public BigDecimal safeDivide(BigDecimal dividend, BigDecimal divisor, int scale) {
    if (divisor.compareTo(BigDecimal.ZERO) == 0) {
        throw new ArithmeticException("Division by zero");
    }
    return dividend.divide(divisor, scale, RoundingMode.HALF_UP);
}

// Null-safe operations
public BigDecimal nullSafeAdd(BigDecimal a, BigDecimal b) {
    return Optional.ofNullable(a).orElse(BigDecimal.ZERO)
           .add(Optional.ofNullable(b).orElse(BigDecimal.ZERO));
}

// Percentage calculations
public BigDecimal calculatePercentage(BigDecimal value, BigDecimal percentage) {
    return value.multiply(percentage).divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
}
```

### Performance Considerations
```java
// Reuse BigDecimal constants
private static final BigDecimal HUNDRED = new BigDecimal("100");
private static final BigDecimal TAX_RATE = new BigDecimal("0.0825");

// Use valueOf() for small integers
BigDecimal bd = BigDecimal.valueOf(42); // More efficient than new BigDecimal("42")
```

## BigInteger - Arbitrary Precision Integers

### Creation
```java
BigInteger bi1 = new BigInteger("12345678901234567890");
BigInteger bi2 = BigInteger.valueOf(42); // For values fitting in long
BigInteger bi3 = new BigInteger("1010", 2); // Binary representation

// Constants
BigInteger.ZERO, BigInteger.ONE, BigInteger.TWO, BigInteger.TEN
```

### Core Operations
```java
BigInteger result = bi1.add(bi2);
BigInteger result = bi1.subtract(bi2);
BigInteger result = bi1.multiply(bi2);
BigInteger result = bi1.divide(bi2);
BigInteger[] divmod = bi1.divideAndRemainder(bi2); // [quotient, remainder]

// Modular arithmetic
BigInteger result = bi1.mod(bi2);
BigInteger result = bi1.modPow(exponent, modulus); // Efficient for cryptography
```

### Bit Operations
```java
bi1.and(bi2)           // Bitwise AND
bi1.or(bi2)            // Bitwise OR  
bi1.xor(bi2)           // Bitwise XOR
bi1.not()              // Bitwise NOT
bi1.shiftLeft(n)       // Left shift by n bits
bi1.shiftRight(n)      // Right shift by n bits
bi1.testBit(n)         // Test if bit n is set
bi1.setBit(n)          // Set bit n
bi1.clearBit(n)        // Clear bit n
bi1.flipBit(n)         // Flip bit n
```

### Mathematical Functions
```java
bi1.abs()              // Absolute value
bi1.negate()           // Negation
bi1.pow(n)             // Raise to power n
bi1.gcd(bi2)           // Greatest common divisor
bi1.min(bi2), bi1.max(bi2)  // Min/max values
bi1.signum()           // Sign (-1, 0, 1)
```

### Primality Testing
```java
bi1.isProbablePrime(certainty); // Probabilistic primality test
// certainty: higher values = more accurate but slower
```

### Conversion Methods
```java
bi1.toString()         // Decimal string
bi1.toString(16)       // Hexadecimal string  
bi1.toString(2)        // Binary string
bi1.intValue()         // Convert to int (may lose precision)
bi1.longValue()        // Convert to long (may lose precision)
bi1.intValueExact()    // Convert to int, throws if overflow
bi1.longValueExact()   // Convert to long, throws if overflow
```

## Advanced Patterns & Best Practices

### Null Safety Utilities
```java
public class BigDecimalUtils {
    public static BigDecimal nullSafe(BigDecimal value) {
        return Optional.ofNullable(value).orElse(BigDecimal.ZERO);
    }
    
    public static boolean isNullOrZero(BigDecimal value) {
        return value == null || value.compareTo(BigDecimal.ZERO) == 0;
    }
}
```

### Money Handling Pattern
```java
public class Money {
    private final BigDecimal amount;
    private final Currency currency;
    private static final int SCALE = 2;
    private static final RoundingMode ROUNDING = RoundingMode.HALF_UP;
    
    public Money add(Money other) {
        validateCurrency(other);
        return new Money(this.amount.add(other.amount), this.currency);
    }
    
    public Money multiply(BigDecimal factor) {
        return new Money(amount.multiply(factor).setScale(SCALE, ROUNDING), currency);
    }
}
```

### Comparison Utilities
```java
public static boolean isEqual(BigDecimal a, BigDecimal b) {
    return a.compareTo(b) == 0; // Scale-insensitive comparison
}

public static boolean isGreaterThan(BigDecimal a, BigDecimal b) {
    return a.compareTo(b) > 0;
}
```

### Stream Operations
```java
List<BigDecimal> amounts = Arrays.asList(/*...*/);

BigDecimal total = amounts.stream()
    .filter(Objects::nonNull)
    .reduce(BigDecimal.ZERO, BigDecimal::add);

BigDecimal average = amounts.stream()
    .filter(Objects::nonNull)
    .reduce(BigDecimal.ZERO, BigDecimal::add)
    .divide(BigDecimal.valueOf(amounts.size()), 2, RoundingMode.HALF_UP);
```

## Common Pitfalls & Solutions

### Pitfall 1: Using double constructor
```java
// WRONG - Precision loss
BigDecimal bd = new BigDecimal(0.1); // Might be 0.1000000000000000055511151231257827021181583404541015625

// CORRECT
BigDecimal bd = new BigDecimal("0.1"); // Exactly 0.1
```

### Pitfall 2: Incorrect equality comparison
```java
// WRONG - Scale matters
new BigDecimal("2.0").equals(new BigDecimal("2.00")); // false

// CORRECT
new BigDecimal("2.0").compareTo(new BigDecimal("2.00")) == 0; // true
```

### Pitfall 3: Forgetting immutability
```java
// WRONG - Original value unchanged
BigDecimal bd = new BigDecimal("10");
bd.add(new BigDecimal("5")); // bd is still 10

// CORRECT
BigDecimal bd = new BigDecimal("10");
bd = bd.add(new BigDecimal("5")); // bd is now 15
```

### Pitfall 4: Division without rounding mode
```java
// WRONG - May throw ArithmeticException
BigDecimal result = bd1.divide(bd2);

// CORRECT
BigDecimal result = bd1.divide(bd2, RoundingMode.HALF_UP);
```

## Performance Tips

1. **Reuse constants**: Create static final instances for commonly used values
2. **Use valueOf()**: More efficient for small integers
3. **Avoid string conversion**: Don't convert to string for comparisons
4. **Pool MathContext**: Reuse MathContext instances
5. **Consider alternatives**: For simple cases, consider using long with implicit scaling

## When to Use What

- **BigDecimal**: Financial calculations, precise decimal arithmetic, when scale matters
- **BigInteger**: Cryptography, large integer calculations, when range exceeds long
- **double/float**: Scientific calculations where small precision loss is acceptable
- **long with scaling**: Simple money calculations with fixed decimal places

## Integration with Popular Frameworks

### Jackson JSON Serialization
```java
@JsonSerialize(using = ToStringSerializer.class)
@JsonDeserialize(using = BigDecimalDeserializer.class)
private BigDecimal amount;
```

### JPA/Hibernate
```java
@Column(precision = 19, scale = 2)
private BigDecimal amount;
```

### Spring Boot Configuration
```properties
spring.jackson.serialization.write-bigdecimal-as-plain=true
```

This cheatsheet covers the essential knowledge for working with Java's arbitrary precision classes in enterprise applications.