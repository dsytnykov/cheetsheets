## Core Ways to Create Streams

### From a Collection
```java
List<String> list = List.of("a", "b", "c");
Stream<String> stream = list.stream();
```

### From an Array
```java
String[] arr = {"a", "b", "c"};
Stream<String> stream = Arrays.stream(arr);
```

### From Stream.of()
```java
Stream<String> stream = Stream.of("a", "b", "c");
```

### From Stream.empty()
```java
Stream<Object> emptyStream = Stream.empty();
```

### From Stream.builder()
```java
Stream<String> stream = Stream.<String>builder()
    .add("a").add("b").add("c")
    .build();
```

## For Infinite or Generated Streams

### Stream.generate() (Supplier – infinite stream)
```java
Stream<Double> stream = Stream.generate(Math::random);
```

### Stream.iterate() (seed + UnaryOperator)
```java
Stream<Integer> stream = Stream.iterate(0, n -> n + 2);
```

### Stream.iterate(seed, predicate, next) (Java 9+)
```java
Stream<Integer> stream = Stream.iterate(0, n -> n < 100, n -> n + 10);
```


## 📁 From Files (java.nio.file)

### Files.lines(Path) – line-by-line stream from a file
```java
Stream<String> lines = Files.lines(Path.of("data.txt"));
```

### Files.walk(Path) – stream of file paths in a directory tree
```java
Stream<Path> paths = Files.walk(Path.of("some/folder"));
```

### Files.list(Path) – stream of entries in a directory
```java
Stream<Path> entries = Files.list(Path.of("some/folder"));
```

## 🎯 From Primitive Types (IntStream, LongStream, DoubleStream)

### IntStream / LongStream / DoubleStream.of()
```java
IntStream intStream = IntStream.of(1, 2, 3);
```

### IntStream.range(start, end)
```java
IntStream range = IntStream.range(1, 5); // 1 to 4
```

### IntStream.rangeClosed(start, end)
```java
IntStream range = IntStream.rangeClosed(1, 5); // 1 to 5
```

## 🧩 Others

### From Stream.concat() – combining two streams
```java
Stream<String> merged = Stream.concat(stream1, stream2);
```

### From BufferedReader.lines()
```java
BufferedReader br = new BufferedReader(new FileReader("file.txt"));
Stream<String> lines = br.lines();
```

### From Pattern.splitAsStream()
```java
Stream<String> words = Pattern.compile("\\s+").splitAsStream("a b c");
```

### From Optional.stream() (Java 9+)
```java
Optional<String> opt = Optional.of("hello");
Stream<String> stream = opt.stream();
```

## 💡 Bonus: Advanced / Rare

### Stream from a Queue or Deque (custom supplier)
```java
Queue<String> queue = new LinkedList<>(List.of("a", "b", "c"));
Stream<String> stream = Stream.generate(queue::poll).takeWhile(Objects::nonNull);
```
Custom Spliterator – for complex sources (advanced usage)

