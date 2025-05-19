# Java.time.Instant Cheatsheet

`Instant` represents a point in time on the timeline in UTC, stored with nanosecond precision. It's ideal for machine-based time, timestamps, and system events.

## Creation

```java
// Current timestamp
Instant now = Instant.now();

// From epoch seconds
Instant fromEpochSec = Instant.ofEpochSecond(1621022400); // 2021-05-15T00:00:00Z

// From epoch milliseconds
Instant fromEpochMilli = Instant.ofEpochMilli(1621022400000L);

// From epoch seconds with nanosecond adjustment
Instant withNanos = Instant.ofEpochSecond(1621022400, 500000000); // +0.5 seconds

// From String (ISO-8601 format)
Instant fromString = Instant.parse("2021-05-15T12:30:45.123456789Z");

// Using Clock (useful for testing)
Clock clock = Clock.systemUTC();
Instant fromClock = Instant.now(clock);

// Fixed timestamp (Java 9+)
Instant fixed = Instant.EPOCH; // 1970-01-01T00:00:00Z
```

## Manipulation

```java
// Adding time
Instant plusSeconds = now.plusSeconds(3600); // add 1 hour
Instant plusMillis = now.plusMillis(500);
Instant plusNanos = now.plusNanos(1000);

// Using Duration
Instant plusDuration = now.plus(Duration.ofHours(2));
Instant minusDuration = now.minus(Duration.ofMinutes(30));

// Truncation
Instant truncatedToSeconds = now.truncatedTo(ChronoUnit.SECONDS);
Instant truncatedToMinutes = now.truncatedTo(ChronoUnit.MINUTES);
Instant truncatedToHours = now.truncatedTo(ChronoUnit.HOURS);
Instant truncatedToDays = now.truncatedTo(ChronoUnit.DAYS);
```

## Information Extraction

```java
// Get epoch values
long epochSecond = now.getEpochSecond();
long epochMilli = now.toEpochMilli();
int nano = now.getNano(); // nanosecond-of-second

// Is methods (Java 9+)
boolean isAfterEpoch = now.isAfter(Instant.EPOCH);
boolean isBeforeFuture = now.isBefore(now.plusSeconds(60));
```

## Comparison

```java
// Direct comparison
boolean isBefore = now.isBefore(plusSeconds);
boolean isAfter = now.isAfter(minusDuration);
boolean isEqual = now.equals(now);

// Comparing with compareTo()
int compareResult = now.compareTo(plusSeconds); // -1 if before, 0 if equal, 1 if after

// Getting duration between instants
Duration duration = Duration.between(now, plusSeconds);
long secondsBetween = ChronoUnit.SECONDS.between(now, plusSeconds);
```

## Conversion to Other Types

```java
// To ZonedDateTime
ZonedDateTime zdt = now.atZone(ZoneId.of("America/New_York"));
ZonedDateTime zdtSystem = now.atZone(ZoneId.systemDefault());

// To OffsetDateTime
OffsetDateTime odt = now.atOffset(ZoneOffset.UTC);
OffsetDateTime odtOffset = now.atOffset(ZoneOffset.ofHours(-5));

// To LocalDateTime (requires a zone)
LocalDateTime ldt = LocalDateTime.ofInstant(now, ZoneId.systemDefault());

// To legacy java.util.Date
java.util.Date legacyDate = Date.from(now);

// To legacy java.sql.Timestamp
java.sql.Timestamp sqlTimestamp = java.sql.Timestamp.from(now);
```

## Mathematical Operations

```java
// Duration between instants
Duration between = Duration.between(fromEpochSec, now);
long seconds = between.getSeconds();
int nanos = between.getNano();

// Adding/subtracting specific units
Instant plus5Minutes = now.plus(5, ChronoUnit.MINUTES);
Instant minus2Hours = now.minus(2, ChronoUnit.HOURS);
Instant plus1Day = now.plus(1, ChronoUnit.DAYS);
```

## Working with ChronoUnit

```java
// Calculating time between instants with different units
long secondsDiff = ChronoUnit.SECONDS.between(fromEpochSec, now);
long minutesDiff = ChronoUnit.MINUTES.between(fromEpochSec, now);
long hoursDiff = ChronoUnit.HOURS.between(fromEpochSec, now);
long daysDiff = ChronoUnit.DAYS.between(fromEpochSec, now);

// Supported ChronoUnits for Instant
boolean isSupported = now.isSupported(ChronoUnit.MINUTES); // true
boolean notSupported = now.isSupported(ChronoUnit.MONTHS); // false - Instant doesn't support date-based units
```

## Java 9+ Additions

```java
// Addition of static constants (Java 9+)
Instant epoch = Instant.EPOCH;      // 1970-01-01T00:00:00Z
Instant min = Instant.MIN;          // The minimum supported Instant
Instant max = Instant.MAX;          // The maximum supported Instant

// Addition of now() overloads for ZoneId (Java 9+)
Instant nowInZone = Instant.now(ZoneId.of("Europe/Paris")); // Still UTC, just uses the zone's clock
```

## Formatting and Parsing

```java
// Basic ISO formatting (built-in toString())
String iso = now.toString(); // 2023-05-18T10:15:30.123456789Z

// Custom formatting (requires conversion to ZonedDateTime first)
String formatted = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
    .format(now.atZone(ZoneId.systemDefault()));

// Parsing ISO format
Instant parsed = Instant.parse("2023-05-18T10:15:30.123456789Z");
```

## Interoperability with Other Libraries

```java
// With java.time.Clock
Clock fixed = Clock.fixed(now, ZoneId.systemDefault());
Instant fromFixed = Instant.now(fixed); // Will always return 'now'

// With java.time.temporal.Temporal interface
Temporal temporal = now; // Instant implements Temporal
Instant backToInstant = Instant.from(temporal);

// With java.nio.file.attribute.FileTime (Java 9+)
java.nio.file.attribute.FileTime fileTime = java.nio.file.attribute.FileTime.from(now);
Instant fromFileTime = fileTime.toInstant();
```

## Performance Considerations and Best Practices

1. **Machine timestamps**: Use `Instant` for timestamps that represent machine or system time, especially in logs and performance measurements.

2. **UTC is default**: Remember that `Instant` is always in UTC time zone. For local time or specific time zones, convert to `ZonedDateTime`.

3. **Nanosecond precision**: `Instant` stores time to nanosecond precision, making it suitable for high-precision timing.

4. **Immutability**: Like all java.time classes, `Instant` is immutable - always capture the return values of operations like `plus()` and `minus()`.

5. **Avoid toString() for persistence**: While `toString()` provides ISO-8601 format, for persistence consider `getEpochSecond()` or `toEpochMilli()` for better interoperability.

6. **Consistent comparison**: Use `isBefore()`, `isAfter()`, and `equals()` methods for clear and consistent comparison of timestamps.

7. **Limited arithmetic**: `Instant` only supports time-based units (seconds, minutes, hours, days), not date-based units (months, years).

8. **Dealing with pre-epoch time**: Be cautious when working with dates before 1970-01-01, especially with methods like `toEpochMilli()` which may result in negative values.

9. **Moving through time zones**: When working across time zones, convert `Instant` to `ZonedDateTime` appropriately to avoid time zone confusion.

10. **Use with temporal adjusters**: `Instant` has limited adjustment capabilities compared to other date-time classes. Convert to `ZonedDateTime` for more complex adjustments.
