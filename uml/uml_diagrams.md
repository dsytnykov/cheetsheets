# UML Diagrams in Java with Mermaid - Cheatsheet

This README serves as a comprehensive reference for creating UML diagrams that represent Java code using Mermaid. It covers basic to advanced UML concepts tailored specifically for Java developers.

## Table of Contents
- [Mermaid Basics](#mermaid-basics)
- [Class Representations](#class-representations)
  - [Regular Classes](#regular-classes)
  - [Abstract Classes](#abstract-classes)
  - [Interfaces](#interfaces)
- [Relationships](#relationships)
  - [Inheritance (extends)](#inheritance-extends)
  - [Implementation (implements)](#implementation-implements)
  - [Association](#association)
  - [Aggregation](#aggregation)
  - [Composition](#composition)
  - [Dependency](#dependency)
- [Advanced Concepts](#advanced-concepts)
  - [Visibility Modifiers](#visibility-modifiers)
  - [Static Members](#static-members)
  - [Generic Types](#generic-types)
  - [Enumerations](#enumerations)
  - [Nested Classes](#nested-classes)
- [Complete Examples](#complete-examples)
- [Best Practices](#best-practices)

## Mermaid Basics

Mermaid diagrams are defined within code blocks in markdown. For class diagrams, use the `classDiagram` directive:

```mermaid
classDiagram
    class ClassName {
        +field: Type
        +method(): ReturnType
    }
```

## Class Representations

### Regular Classes

```mermaid
classDiagram
    class Student {
        -String name
        -int age
        +Student(String name, int age)
        +String getName()
        +void setName(String name)
        +int getAge()
        +void setAge(int age)
    }
```

### Abstract Classes

In Mermaid, abstract classes are denoted using the `<<abstract>>` classifier:

```mermaid
classDiagram
    class Shape {
        <<abstract>>
        -String color
        +Shape(String color)
        +String getColor()
        +void setColor(String color)
        +double calculateArea()* 
    }
```

Note: The `*` after a method indicates it's abstract.

### Interfaces

Interfaces are represented using the `<<interface>>` classifier:

```mermaid
classDiagram
    class Drawable {
        <<interface>>
        +void draw()
        +void resize(double factor)
    }
```

## Relationships

### Inheritance (extends)

In Java, a class can extend another class. This is represented with a solid line and an empty triangle pointing to the parent:

```mermaid
classDiagram
    Animal <|-- Dog
    Animal <|-- Cat
    
    class Animal {
        #String name
        +void makeSound()
    }
    class Dog {
        +void makeSound()
        +void fetch()
    }
    class Cat {
        +void makeSound()
        +void purr()
    }
```

### Implementation (implements)

When a class implements an interface, it's shown with a dashed line and an empty triangle:

```mermaid
classDiagram
    Drawable <|.. Circle
    Drawable <|.. Rectangle
    
    class Drawable {
        <<interface>>
        +void draw()
        +void resize(double factor)
    }
    class Circle {
        -double radius
        +void draw()
        +void resize(double factor)
    }
    class Rectangle {
        -double width
        -double height
        +void draw()
        +void resize(double factor)
    }
```

### Association

Represents a general relationship between classes:

```mermaid
classDiagram
    Student -- Course : takes
    
    class Student {
        -String name
    }
    class Course {
        -String code
        -String title
    }
```

### Aggregation

A special form of association where one class "has" another class but doesn't own it (the contained object can exist independently):

```mermaid
classDiagram
    University o-- Department : contains
    
    class University {
        -String name
        +void addDepartment(Department dept)
    }
    class Department {
        -String name
        -Professor[] faculty
    }
```

### Composition

A stronger form of aggregation where the contained class can't exist without the container:

```mermaid
classDiagram
    Car *-- Engine : has
    
    class Car {
        -String model
        +void start()
    }
    class Engine {
        -int horsePower
        +void ignite()
    }
```

### Dependency

When one class uses another class temporarily but doesn't store it:

```mermaid
classDiagram
    OrderProcessor ..> PaymentGateway : uses
    
    class OrderProcessor {
        +void processOrder(Order order, PaymentGateway gateway)
    }
    class PaymentGateway {
        +boolean processPayment(double amount)
    }
```

## Advanced Concepts

### Visibility Modifiers

Mermaid uses symbols to denote visibility:
- `+` : public
- `-` : private
- `#` : protected
- `~` : package/default

```mermaid
classDiagram
    class AccessModifiers {
        +publicField
        -privateField
        #protectedField
        ~packageField
        +publicMethod()
        -privateMethod()
        #protectedMethod()
        ~packageMethod()
    }
```

### Static Members

Static members can be underlined in Mermaid:

```mermaid
classDiagram
    class MathHelper {
        +PI$ : double
        +add$(int a, int b) int
    }
```

Note: The `$` symbol indicates static members.

### Generic Types

```mermaid
classDiagram
    class ArrayList~T~ {
        -Object[] elementData
        +boolean add(T element)
        +T get(int index)
        +int size()
    }
    
    class Pair~K,V~ {
        -K key
        -V value
        +K getKey()
        +V getValue()
    }
```

### Enumerations

```mermaid
classDiagram
    class DayOfWeek {
        <<enumeration>>
        MONDAY
        TUESDAY
        WEDNESDAY
        THURSDAY
        FRIDAY
        SATURDAY
        SUNDAY
    }
```

### Nested Classes

```mermaid
classDiagram
    class OuterClass {
        -int outerField
        +void outerMethod()
    }
    class OuterClass$StaticNestedClass {
        -int nestedField
        +void nestedMethod()
    }
    class OuterClass$InnerClass {
        -int innerField
        +void innerMethod()
    }
    
    OuterClass +-- OuterClass$StaticNestedClass
    OuterClass +-- OuterClass$InnerClass
```

## Complete Examples

### Example 1: Online Store System

```mermaid
classDiagram
    Product <|-- PhysicalProduct
    Product <|-- DigitalProduct
    Orderable <|.. Product
    ShoppingCart o-- Product
    Order *-- LineItem
    LineItem o-- Product
    Customer -- Order
    
    class Product {
        <<abstract>>
        -String id
        -String name
        -double price
        +double getPrice()
        +String getName()
    }
    
    class PhysicalProduct {
        -double weight
        -double dimensions
        +double getShippingCost()
    }
    
    class DigitalProduct {
        -String downloadUrl
        -double fileSizeMB
        +String getDownloadLink()
    }
    
    class Orderable {
        <<interface>>
        +boolean isInStock()
        +void addToOrder(Order order)
    }
    
    class ShoppingCart {
        -List~Product~ items
        +void addProduct(Product p)
        +void removeProduct(Product p)
        +double getTotal()
        +Order checkout()
    }
    
    class Order {
        -String orderId
        -Customer customer
        -List~LineItem~ items
        -Date orderDate
        -OrderStatus status
        +double getTotal()
        +void process()
    }
    
    class LineItem {
        -Product product
        -int quantity
        +double getSubtotal()
    }
    
    class Customer {
        -String id
        -String name
        -String email
        -List~Order~ orderHistory
        +void placeOrder(Order o)
    }
```

### Example 2: Design Patterns (Observer)

```mermaid
classDiagram
    Subject <|-- ConcreteSubject
    Observer <|.. ConcreteObserverA
    Observer <|.. ConcreteObserverB
    ConcreteSubject -- Observer
    
    class Subject {
        <<abstract>>
        -List~Observer~ observers
        +void attach(Observer observer)
        +void detach(Observer observer)
        +void notifyObservers()
    }
    
    class Observer {
        <<interface>>
        +void update(Subject subject)
    }
    
    class ConcreteSubject {
        -State state
        +State getState()
        +void setState(State state)
    }
    
    class ConcreteObserverA {
        -State observerState
        +void update(Subject subject)
    }
    
    class ConcreteObserverB {
        -State observerState
        +void update(Subject subject)
    }
```

## Best Practices

1. **Keep It Simple**: Only include essential classes and relationships to avoid overwhelming diagrams.
   
2. **Use Meaningful Names**: Choose descriptive names for classes, methods, and attributes.
   
3. **Group Related Classes**: Organize your diagram by placing related classes near each other.
   
4. **Add Notes When Needed**: Use notes to explain complex relationships or design decisions.

5. **Consistent Notation**: Maintain consistent use of UML notation throughout your diagrams.

6. **Limit Diagram Size**: Break large systems into multiple diagrams focused on specific aspects.

7. **Include Key Methods Only**: For complex classes, only show the most important methods and attributes.

8. **Document Design Decisions**: Add comments explaining why certain design choices were made.

9. **Keep Diagrams Updated**: Update your UML diagrams when code changes significantly.

10. **Review with Team**: Use diagrams as communication tools with your development team.
