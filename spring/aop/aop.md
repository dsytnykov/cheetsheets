# Spring AOP Pointcuts and Advices Reference Guide

## Supported Pointcuts by Spring AOP

Spring AOP supports the following pointcut designators:

- `execution` - matches method execution join points
- `within` - matches join points within certain types
- `this` - matches join points where the bean reference is an instance of the given type
- `target` - matches join points where the target object is an instance of the given type
- `args` - matches join points where the arguments are instances of the given types
- `@target` - matches join points where the class of the executing object has an annotation
- `@args` - matches join points where the runtime type of the actual arguments has annotations
- `@within` - matches join points where the declared type has an annotation
- `@annotation` - matches join points where the executing method has an annotation
- `bean` - matches named spring beans (Spring AOP only - not in AspectJ)

## Execution Pattern

The execution pattern has the following structure:

```
execution(modifiers-pattern?
          return-type-pattern
          declaring-type-pattern?name-pattern(param-pattern)
          throws-pattern?)
```

## Pointcut Examples

### Basic Pointcuts

```java
// Matches all methods in controller package
@Pointcut("execution(* com.aop.controller.*.*(..))")
public void allControllerMethods() {}

// Matches classes annotated with @RestController
@Pointcut("within(@org.springframework.web.bind.annotation.RestController *)")
public void anyRestController() {}

// Matches all public methods
@Pointcut("execution(public * *(..))")
public void allPublicMethods() {}

// Matches all setter methods
@Pointcut("execution(* set*(..))")
public void allSetterMethods() {}

// Matches methods in EmployeeService
@Pointcut("execution(* com.aop.service.EmployeeService.*(..))")
public void allEmployeeServiceMethods() {}
```

### Package-based Pointcuts

```java
// Matches methods in service package
@Pointcut("execution(* com.aop.service.*.*(..))")
public void anyServicePackageMethod() {}

// Matches methods in service package and its subpackages
@Pointcut("execution(* com.aop.service..*.*(..))")
public void anyServicePackageAndSubpackageMethod() {}

// Matches join points within service package
@Pointcut("within(com.aop.service.*)")
public void anyJointPointWithinServicePackage() {}

// Matches join points within service package or subpackages
@Pointcut("within(com.aop.service..*)")
public void anyJointPointWithinPackageOrOneOfSubpackages() {}
```

### Interface-based Pointcuts

```java
// Matches where proxy implements EmployeeService interface
@Pointcut("this(com.aop.service.EmployeeService)")
public void anyJointPointWhereProxyImplementsEmployeeServiceInterface() {}

// Matches where target implements EmployeeService interface
@Pointcut("target(com.aop.service.EmployeeService)")
public void anyJointPointWhereTargetImplementsEmployeeServiceInterface() {}
```

### Argument-based Pointcuts

```java
// Matches methods with one Serializable argument
@Pointcut("args(java.io.Serializable)")
public void anyJointPointWithOneArgumentAndArgumentIsSerializable() {}
```

### Annotation-based Pointcuts

```java
// Matches where the class has @Transactional annotation
@Pointcut("@target(org.springframework.transaction.annotation.Transactional)")
public void anyJointPointWithTransactionalAnnotation() {}

// Matches where the declared type has @Transactional annotation
@Pointcut("@within(org.springframework.transaction.annotation.Transactional)")
public void anyJointPointWhereDeclaredTypeOfTargetObjectHasTransactionalAnnotation() {}

// Matches methods with @Transactional annotation
@Pointcut("@annotation(org.springframework.transaction.annotation.Transactional)")
public void anyJointPointWhereMethodHasTransactionalAnnotation() {}

// Matches methods with arguments that have @Transactional annotation
@Pointcut("@args(org.springframework.transaction.annotation.Transactional)")
public void anyJointPointWhereMethodHasTransactionalAnnotationAsArgument() {}
```

### Bean-based Pointcuts

```java
// Matches bean named "employeeService"
@Pointcut("bean(employeeService)")
public void anyJointPointWhereBeanIsNamedEmployeeService() {}

// Matches beans with names ending in "Service"
@Pointcut("bean(*Service)")
public void anyJointPointWhereBeanNameEndsWithService() {}
```

### Combining Pointcuts

```java
// Combines pointcuts with && operator
@Pointcut("allPublicMethods() && anyJointPointWithinServicePackage()")
public void anyPublicMethodInServiceModule() {}
```

## Advice Types

Spring AOP supports the following advice types:

### Before Advice

```java
// Using inline pointcut expression
@Before("execution(* com.aop.model.*.*(..))")
public void doBeforeAdviceInline() {}

// Using named pointcut
@Before("anyPublicMethodInServiceModule()")
public void doBeforeAdviceNamed() {}
```

### After Returning Advice

```java
// Basic after returning
@AfterReturning("execution(* com.aop.model.*.*(..))")
public void doAfterReturning() {}

// With access to return value
@AfterReturning(
        pointcut="execution(* com.aop.model.*.*(..))",
        returning="retVal")
public void doAfterReturningWithReturnValue(Object retVal) {}
```

### After Throwing Advice

```java
// Basic after throwing
@AfterThrowing("execution(* com.aop.model.*.*(..))")
public void doAfterThrowing() {}

// With access to thrown exception
@AfterThrowing(
        pointcut="execution(* com.aop.model.*.*(..))",
        throwing="ex")
public void doAfterThrowingWithException(DataAccessException ex) {}
```

**Note:** `@AfterThrowing` does not indicate a general exception handling callback. It only receives exceptions from the join point (user-declared target method) itself but not from an accompanying `@After`/`@AfterReturning` method.

### After Advice (Finally)

```java
@After("execution(* com.aop.model.*.*(..))")
public void doAfter() {}
```

### Around Advice

```java
@Around("execution(* com.aop.service.*.*(..))")
public Object doBasicProfiling(ProceedingJoinPoint pjp) throws Throwable {
    // start stopwatch
    Object retVal = pjp.proceed();
    // stop stopwatch
    return retVal;
}
```

## Advice Parameters

Any advice method may declare, as its first parameter, a parameter of type `org.aspectj.lang.JoinPoint`. Around advice is required to declare a first parameter of type `ProceedingJoinPoint`, which is a subclass of `JoinPoint`.

### JoinPoint Interface Methods

- `getArgs()`: Returns the method arguments
- `getThis()`: Returns the proxy object
- `getTarget()`: Returns the target object
- `getSignature()`: Returns a description of the method being advised
- `toString()`: Prints a useful description of the method being advised

### Parameter Patterns

- `()` matches a method that takes no parameters
- `(..)` matches any number (zero or more) of parameters
- `(*)` matches a method that takes one parameter of any type
- `(*,String)` matches a method that takes two parameters, first can be any type, second must be a String

### Working with Method Parameters

```java
// Direct access to parameters in advice
@Before("execution(* com.aop.model.*.*(..)) && args(employee,..)")
public void methodsWithParameter(Employee employee) {}

// Alternative approach using a pointcut
@Pointcut("execution(*  com.aop.service.*.*(..)) && args(employee,..)")
private void accountDataAccessOperation(Employee employee) {}

@Before("accountDataAccessOperation(employee)")
public void validateAccount(Employee employee) {}
```

### Working with Annotations and Parameters

```java
@Before(
        value = "allPublicMethods() && target(bean) && @annotation(transactional)",
        argNames = "bean,transactional")
public void trasaction(Object bean, Transactional transactional) {
    String code = transactional.value();
    // ... use code and bean
}

@Before(
        value = "allPublicMethods() && target(bean) && @annotation(transactional)",
        argNames = "joinPoint,bean,transactional")
public void someMethod(JoinPoint joinPoint, Object bean, Transactional transactional) {
    String code = transactional.value();
    // ... use code and bean
}

@Before("allPublicMethods()")
public void someMethod2(JoinPoint joinPoint) {}
```

## Notes on Generics

For generic method parameters, you can use the following approach:

```java
// Example interface
public interface Sample<T> {
    void sampleGenericMethod(T param);
    void sampleGenericCollectionMethod(Collection<T> param);
}

// Advice for generic method
@Before("execution(* ..Sample+.sampleGenericMethod(*)) && args(param)")
public void beforeSampleMethod(MyType param) {}
```

This approach does not work for generic collections.
