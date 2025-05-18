# Java.util.time Cheatsheet

## Core Classes

### LocalDate
```java
// Creation
LocalDate today = LocalDate.now();
LocalDate specificDate = LocalDate.of(2023, 5, 15);
LocalDate fromString = LocalDate.parse("2023-05-15");

// Manipulation
LocalDate tomorrow = today.plusDays(1);
LocalDate nextMonth = today.plusMonths(1);
LocalDate previousYear = today.minusYears(1);
LocalDate withDay = today.withDayOfMonth(1);

// Information
int year = today.getYear();
Month month = today.getMonth();
int monthValue = today.getMonthValue();
int day = today.getDayOfMonth();
DayOfWeek dayOfWeek = today.getDayOfWeek();
int dayOfYear = today.getDayOfYear();
boolean isLeapYear = today.isLeapYear();

// Comparison
boolean isBefore = today.isBefore(tomorrow);
boolean isAfter = today.isAfter(tomorrow);
boolean isEqual = today.isEqual(today);
```

### LocalTime
```java
// Creation
LocalTime now = LocalTime.now();
LocalTime specificTime = LocalTime.of(13, 30, 15); // 13:30:15
LocalTime fromString = LocalTime.parse("13:30:15");

// Manipulation
LocalTime plusHours = now.plusHours(2);
LocalTime minusMinutes = now.minusMinutes(15);
LocalTime withHour = now.withHour(10);

// Information
int hour = now.getHour();
int minute = now.getMinute();
int second = now.getSecond();
int nano = now.getNano();

// Truncation
LocalTime truncated = now.truncatedTo(ChronoUnit.SECONDS);

// Comparison
boolean isBefore = now.isBefore(plusHours);
boolean isAfter = now.isAfter(minusMinutes);
```

### LocalDateTime
```java
// Creation
LocalDateTime now = LocalDateTime.now();
LocalDateTime specificDateTime = LocalDateTime.of(2023, 5, 15, 13, 30, 15);
LocalDateTime fromLocalDateAndTime = LocalDateTime.of(LocalDate.now(), LocalTime.now());
LocalDateTime fromString = LocalDateTime.parse("2023-05-15T13:30:15");

// Manipulation (has all methods from both LocalDate and LocalTime)
LocalDateTime tomorrow = now.plusDays(1);
LocalDateTime nextHour = now.plusHours(1);
LocalDateTime withMonth = now.withMonth(1);

// Getting components
LocalDate date = now.toLocalDate();
LocalTime time = now.toLocalTime();

// Comparison
boolean isBefore = now.isBefore(tomorrow);
boolean isAfter = now.isAfter(tomorrow);
```

### ZonedDateTime
```java
// Creation
ZonedDateTime now = ZonedDateTime.now();
ZonedDateTime specificZone = ZonedDateTime.now(ZoneId.of("America/New_York"));
ZonedDateTime fromLocalDateTime = LocalDateTime.now().atZone(ZoneId.of("Europe/Paris"));
ZonedDateTime fromInstant = Instant.now().atZone(ZoneId.systemDefault());

// Manipulation (has all methods from LocalDateTime plus zone operations)
ZonedDateTime tomorrow = now.plusDays(1);
ZonedDateTime inDifferentZone = now.withZoneSameInstant(ZoneId.of("Australia/Sydney"));
ZonedDateTime sameLocalWithDifferentZone = now.withZoneSameLocal(ZoneId.of("Australia/Sydney"));

// Getting components
ZoneId zone = now.getZone();
ZoneOffset offset = now.getOffset();
Instant instant = now.toInstant();
LocalDateTime localDateTime = now.toLocalDateTime();

// DST awareness
ZonedDateTime dst = ZonedDateTime.of(
    LocalDate.of(2023, 3, 12), 
    LocalTime.of(2, 30), 
    ZoneId.of("America/New_York")
); // Handles Daylight Saving Time transitions
```

### Period
```java
// Creation
Period oneYear = Period.ofYears(1);
Period twoMonths = Period.ofMonths(2);
Period threeDays = Period.ofDays(3);
Period complex = Period.of(1, 2, 3); // 1 year, 2 months, 3 days
Period fromUnits = Period.parse("P1Y2M3D");

// Properties
int years = oneYear.getYears();
int months = twoMonths.getMonths();
int days = threeDays.getDays();

// Calculations
Period total = oneYear.plus(twoMonths).plus(threeDays);
Period doubled = oneYear.multipliedBy(2);
Period negated = oneYear.negated();
Period normalized = Period.of(0, 13, 0).normalized(); // Normalizes to 1Y1M0D

// With dates
LocalDate date = LocalDate.now();
LocalDate futureDate = date.plus(oneYear);
Period between = Period.between(date, futureDate);
```

### Duration
```java
// Creation
Duration twoHours = Duration.ofHours(2);
Duration fifteenMinutes = Duration.ofMinutes(15);
Duration tenSeconds = Duration.ofSeconds(10);
Duration millis = Duration.ofMillis(1000);
Duration nanos = Duration.ofNanos(1_000_000);
Duration fromUnits = Duration.parse("PT2H15M10S");

// Properties
long seconds = twoHours.getSeconds();
int nano = twoHours.getNano();
long toMillis = twoHours.toMillis();
long toMinutes = twoHours.toMinutes();

// Calculations
Duration total = twoHours.plus(fifteenMinutes).plus(tenSeconds);
Duration doubled = twoHours.multipliedBy(2);
Duration negated = twoHours.negated();

// With times
LocalTime time = LocalTime.now();
LocalTime futureTime = time.plus(twoHours);
Duration between = Duration.between(time, futureTime);
```

## Adjusters and Formatters

### TemporalAdjusters
```java
// Using built-in adjusters
LocalDate firstDayOfMonth = today.with(TemporalAdjusters.firstDayOfMonth());
LocalDate lastDayOfMonth = today.with(TemporalAdjusters.lastDayOfMonth());
LocalDate nextMonday = today.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
LocalDate previousMonday = today.with(TemporalAdjusters.previous(DayOfWeek.MONDAY));
LocalDate dayOfWeekInMonth = today.with(TemporalAdjusters.dayOfWeekInMonth(3, DayOfWeek.WEDNESDAY)); // 3rd Wednesday

// Custom adjuster
TemporalAdjuster businessDayAdjuster = temporal -> {
    LocalDate date = LocalDate.from(temporal);
    DayOfWeek dow = date.getDayOfWeek();
    if (dow == DayOfWeek.SATURDAY || dow == DayOfWeek.SUNDAY) {
        return date.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
    }
    return temporal;
};
LocalDate nextBusinessDay = today.with(businessDayAdjuster);
```

### DateTimeFormatter
```java
// Predefined formatters
DateTimeFormatter isoLocal = DateTimeFormatter.ISO_LOCAL_DATE;
String formattedIsoDate = today.format(isoLocal); // 2023-05-15

// Custom patterns
DateTimeFormatter customFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
String formattedCustom = today.format(customFormatter); // 15/05/2023

// Localized formatters
DateTimeFormatter localizedFormatter = DateTimeFormatter
    .ofPattern("EEEE, MMMM dd, yyyy")
    .withLocale(Locale.US);
String formattedLocalized = today.format(localizedFormatter); // Monday, May 15, 2023

// Parsing
LocalDate parsedDate = LocalDate.parse("15/05/2023", customFormatter);

// Formatting datetime with time
DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
String formattedDateTime = LocalDateTime.now().format(dateTimeFormatter);

// Builder pattern for complex formatters
DateTimeFormatter complexFormatter = new DateTimeFormatterBuilder()
    .appendLiteral("On ")
    .appendText(ChronoField.DAY_OF_WEEK)
    .appendLiteral(" the ")
    .appendText(ChronoField.DAY_OF_MONTH)
    .appendLiteral(" of ")
    .appendText(ChronoField.MONTH_OF_YEAR)
    .appendLiteral(", ")
    .appendValue(ChronoField.YEAR)
    .toFormatter(Locale.US);
String complexFormatted = today.format(complexFormatter); // "On Monday the 15 of May, 2023"
```

## Conversions Between Types

```java
// LocalDate <-> LocalDateTime
LocalDate date = LocalDate.now();
LocalDateTime dateTime1 = date.atTime(LocalTime.now());
LocalDateTime dateTime2 = date.atTime(13, 30);
LocalDate extractedDate = dateTime1.toLocalDate();

// LocalTime <-> LocalDateTime
LocalTime time = LocalTime.now();
LocalDateTime dateTime3 = time.atDate(LocalDate.now());
LocalTime extractedTime = dateTime3.toLocalTime();

// LocalDateTime <-> ZonedDateTime
LocalDateTime dateTime = LocalDateTime.now();
ZonedDateTime zonedDateTime1 = dateTime.atZone(ZoneId.of("Europe/Paris"));
LocalDateTime extractedDateTime = zonedDateTime1.toLocalDateTime();

// ZonedDateTime <-> Instant
ZonedDateTime zonedDateTime = ZonedDateTime.now();
Instant instant1 = zonedDateTime.toInstant();
ZonedDateTime fromInstant = instant1.atZone(ZoneId.systemDefault());

// Instant <-> Epoch millis
Instant instant = Instant.now();
long epochMilli = instant.toEpochMilli();
Instant fromEpochMilli = Instant.ofEpochMilli(epochMilli);
```

## Working with Zones

```java
// Getting available zones
Set<String> availableZoneIds = ZoneId.getAvailableZoneIds();

// Creating ZoneId
ZoneId zoneId1 = ZoneId.systemDefault();
ZoneId zoneId2 = ZoneId.of("America/New_York");

// Getting ZoneOffset
ZoneOffset offset1 = ZoneOffset.UTC;
ZoneOffset offset2 = ZoneOffset.ofHours(-5);
ZoneOffset offset3 = ZoneOffset.ofHoursMinutes(-5, -30);
ZoneOffset currentOffset = zoneId2.getRules().getOffset(Instant.now());

// OffsetDateTime
OffsetDateTime offsetDateTime1 = OffsetDateTime.now();
OffsetDateTime offsetDateTime2 = OffsetDateTime.of(LocalDateTime.now(), ZoneOffset.ofHours(-5));
OffsetDateTime offsetDateTime3 = instant.atOffset(ZoneOffset.ofHours(-5));
```

## Clocks (for Testing)

```java
// System clock (default)
Clock systemClock = Clock.systemDefaultZone();
LocalDate today = LocalDate.now(systemClock);

// Fixed clock (great for testing)
Clock fixedClock = Clock.fixed(Instant.parse("2023-05-15T10:15:30Z"), ZoneId.of("UTC"));
LocalDate fixedDate = LocalDate.now(fixedClock); // Always 2023-05-15

// Offset clock
Clock offsetClock = Clock.offset(systemClock, Duration.ofHours(1));
LocalTime hourAhead = LocalTime.now(offsetClock);
```

## Java 9+ Additions

```java
// Java 9: ofInstant() method for LocalDate and LocalTime
LocalDate dateFromInstant = LocalDate.ofInstant(Instant.now(), ZoneId.systemDefault()); // Java 9+
LocalTime timeFromInstant = LocalTime.ofInstant(Instant.now(), ZoneId.systemDefault()); // Java 9+

// Java 9: datesUntil() method to stream dates
Stream<LocalDate> dates = date.datesUntil(date.plusMonths(1)); // Stream of all dates in the next month
Stream<LocalDate> datesByWeek = date.datesUntil(date.plusMonths(1), Period.ofWeeks(1)); // Weekly dates

// Java 10: toEpochSecond() method for LocalDateTime
long epochSecond = LocalDateTime.now().toEpochSecond(ZoneOffset.UTC); // Java 10+
```

## Interoperability with Legacy Date/Time APIs

```java
// To Legacy java.util.Date
Date legacyDate1 = Date.from(Instant.now());
Date legacyDate2 = Date.from(ZonedDateTime.now().toInstant());
Date legacyDate3 = Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant());

// From Legacy java.util.Date
Instant instantFromLegacy = legacyDate1.toInstant();
ZonedDateTime zonedFromLegacy = instantFromLegacy.atZone(ZoneId.systemDefault());
LocalDateTime dateTimeFromLegacy = LocalDateTime.ofInstant(legacyDate1.toInstant(), ZoneId.systemDefault());

// To java.sql.Date
java.sql.Date sqlDate = java.sql.Date.valueOf(LocalDate.now());

// From java.sql.Date
LocalDate localDateFromSql = sqlDate.toLocalDate();
```

## Best Practices

1. **Use the right class for the job**:
   - `LocalDate` for date without time
   - `LocalTime` for time without date
   - `LocalDateTime` for date and time without timezone
   - `ZonedDateTime` for date and time with timezone
   - `Instant` for machine timestamps

2. **Be timezone aware**: Always specify timezone when it matters, especially in distributed systems.

3. **Immutability**: All java.time classes are immutable, so remember to capture the return value of modification methods.

4. **Duration vs Period**: Use Duration for time-based amounts and Period for date-based amounts.

5. **Formatting**: Use built-in formatters when possible or create reusable custom formatters.

6. **Interoperability**: Avoid mixing old and new APIs unless necessary for legacy integration.

7. **Testing**: Use Clock for deterministic testing of date/time related code.
