# Java Core

## Basics

- JVM, JRE, JDK, Garbage collector

  > https://ssudan16.medium.com/internals-of-jvm-architecture-a7162e989553

  > https://medium.com/java-for-beginners/understanding-java-virtual-machine-jvm-architecture-e68d1c611026

  > https://medium.com/@AlexanderObregon/java-virtual-machine-jvm-deep-dive-into-its-architecture-and-performance-9f8f209b30e7

  > https://medium.com/@saquibdev/understanding-the-jvm-a-detailed-explanation-of-its-components-and-processes-64594db429e2

  > https://www.geeksforgeeks.org/java/mark-and-sweep-garbage-collection-algorithm/

  > https://anmolsehgal.medium.com/java-garbage-collectors-610689a5b125

- Autoboxing / Unboxing

  > https://medium.com/@AlexanderObregon/how-javas-autoboxing-and-unboxing-work-78d9ebcdf4d1

- Generics

  > https://medium.com/@pratik.941/understanding-generics-in-java-a-comprehensive-guide-afd437f413cf

- Optional

  > https://medium.com/@iamvivekojha/optional-class-in-java-everything-you-need-to-know-to-565454184248

- DateTime API

- Exceptions

  > https://medium.com/edureka/java-exception-handling-7bd07435508c

  > https://medium.com/thefreshwrites/what-is-exception-chaining-in-java-exception-handling-d5f5a694579b

- Collections

  > https://www.geeksforgeeks.org/java/arraylist-vs-linkedlist-java/

  > https://www.geeksforgeeks.org/java/internal-working-of-hashmap-java/

  > https://anmolsehgal.medium.com/java-hashmap-internal-implementation-21597e1efec3

- Lambda

  > https://medium.com/@alxkm/from-lambdas-to-method-references-writing-cleaner-java-code-87f470a933a6

  > https://medium.com/@nagarjun_nagesh/lambda-functions-vs-anonymous-inner-classes-in-java-80893c2214d5

  > https://medium.com/@nagarjun_nagesh/exception-handling-with-lambda-functions-in-java-3311b1853e26

  > https://amanagrawal9999.medium.com/internal-working-of-functional-interface-and-lambda-expression-d6a19e5d2f46

  > https://www.infoq.com/articles/Java-8-Lambdas-A-Peek-Under-the-Hood/

  > https://medium.com/@nagarjun_nagesh/lambda-functions-and-thread-safety-in-java-6a391a0a80ec

  > https://stackoverflow.com/questions/29143803/java-lambdas-how-it-works-in-jvm-is-it-oop

- Functional Interfaces

  > https://medium.com/codex/understanding-java-functional-interfaces-d028b04c15d0

- Stream API

  > https://medium.com/@alxkm/how-to-build-a-custom-collector-in-java-961bc506c57e

- Records, sealed classes
  > https://medium.com/coding-odyssey/sealed-classes-in-java-deep-dive-with-interview-questions-13d14721e921

## Multithreading / Concurrency

- Threads (methods, phases)

  > https://www.baeldung.com/java-synchronized

  > https://www.baeldung.com/java-wait-necessary-synchronization

  > https://www.geeksforgeeks.org/java/java-concurrency-yield-sleep-and-join-methods/

  > https://medium.com/@AlexanderObregon/javas-wait-notify-and-notifyall-explained-87ec05b6ad65

- Virtual Threads

  > https://medium.com/@Games24x7Tech/virtual-threads-fast-furious-and-sometimes-stuck-654cde6c0c8c

  > https://abhishekvrshny.medium.com/pinning-a-pitfall-to-avoid-when-using-virtual-threads-in-java-482c5eab78a3

- Concurrency package

  - Package review

    > https://www.baeldung.com/java-util-concurrent

    > https://saannjaay.medium.com/mastering-java-multithreading-concurrency-future-objects-no-question-beyond-239dfd410460

  - Concurrent collections

    > https://medium.com/@greekykhs/all-about-blockingqueue-cb57350c9793

    > https://www.geeksforgeeks.org/java/concurrenthashmap-in-java/

  - ExecutorService

    > https://medium.com/codex/executorservice-internal-working-in-java-7b286882f54e

    > https://saannjaay.medium.com/understanding-the-executor-framework-in-java-with-interview-question-5401a7ea1156

    > https://aditya-sunjava.medium.com/how-to-configure-a-custom-thread-pool-in-java-it-interview-guide-38a9f4b24df1

    > https://stackoverflow.com/questions/11520189/difference-between-shutdown-and-shutdownnow-of-executor-service

  - ForkJoinPool

    > https://www.baeldung.com/java-fork-join

  - CompletableFuture

    > https://blog.stackademic.com/java-completable-future-motivation-and-understanding-6bf293542d03

  - Locks

    > https://www.geeksforgeeks.org/java/reentrant-lock-in-java/

    > https://medium.com/@zjawad333/reentrantlock-synchronization-in-java-ca19d240d7dd

    > https://www.baeldung.com/java-concurrent-locks

  - Atomic

    > https://www.baeldung.com/java-volatile-vs-atomic

    > https://www.geeksforgeeks.org/java/difference-between-atomic-volatile-and-synchronized-in-java/

- Exceptions

  > https://www.baeldung.com/java-interrupted-exception#:~:text=The%20interrupt%20mechanism%20is%20implemented,interrupt()%20sets%20this%20flag.

- Performance Optimisation

  > https://medium.com/@alxkm/concurrency-in-java-best-practices-and-performance-optimization-0dfd990f413b

- Others

  > https://sumitmm.medium.com/asynchronous-programming-in-java-a-deep-dive-4b7b702fd004

  > https://medium.com/javarevisited/all-multithreading-and-concurrency-api-interview-questions-and-answers-for-java-developer-0-8yr-65499a1da7b2

  > https://medium.com/@kolheankita15/multithreading-questions-with-practical-project-examples-9d22bd53063b

  > https://dip-mazumder.medium.com/mastering-thread-safety-best-practices-for-java-developers-8f829c1a82a4

  > https://blog.stackademic.com/java-advanced-concurrency-interview-questions-02-d712a9fe76bf

  > https://saannjaay.medium.com/mastering-java-multithreading-concurrency-future-objects-no-question-beyond-239dfd410460

- Problems (multithreading, concurrency)

  > https://www.baeldung.com/cs/deadlock-livelock-starvation

  > https://stackoverflow.com/questions/214741/what-is-a-stackoverflowerror

  > https://abhishekvrshny.medium.com/pinning-a-pitfall-to-avoid-when-using-virtual-threads-in-java-482c5eab78a3

## NIO / IO

> https://medium.com/@ujjawalr/java-nio-complete-tutorial-69c2c6a8d2a0

> https://anmolsehgal.medium.com/non-blocking-io-java-nio-b18e53a92bad

> https://medium.com/@AlexanderObregon/java-i-o-vs-nio-understanding-the-differences-b29654aa3ee6

> https://developer.ibm.com/tutorials/j-nio/ > https://medium.com/@trunghuynh/java-nio-microservice-networking-101-1222c5ff2760

## Serialization / Deserialization

## Networking

> https://medium.com/@AlexanderObregon/java-networking-basics-832150cc21c9

> https://www.geeksforgeeks.org/java/java-networking/

> https://docs.oracle.com/javase/tutorial/networking/index.html

> https://www.geeksforgeeks.org/computer-networks/differences-between-tcp-and-udp/

> https://docs.oracle.com/javaee/7/tutorial/websocket.htm#:~:text=WebSocket%20is%20an%20application%20protocol,and%20the%20server%20provides%20responses.

> https://vishalrana9915.medium.com/understanding-websockets-in-depth-6eb07ab298b3

> https://medium.com/swlh/how-to-build-a-websocket-applications-using-java-486b3e394139

## SQL package

> https://www.javaguides.net/p/java-sql-package-tutorial.html

## Profiling java applications

> https://medium.com/@AlexanderObregon/profiling-java-applications-tools-and-techniques-3569b32862f4

> https://www.baeldung.com/java-heap-dump-capture

# Low Level Design

- OOP
  > https://medium.com/@AlexanderObregon/a-guide-to-object-oriented-programming-in-java-89dc4544837f
- SOLID

  > https://medium.com/coding-odyssey/s-o-l-i-d-principles-in-java-deep-dive-with-interview-questions-c65ded6c3922

  > https://medium.com/@cibofdevs/understanding-solid-principles-in-java-with-real-life-examples-d6fe93b0acc2

- KISS, DRY
- Design patterns

  > https://medium.com/javarevisited/spring-jpa-when-to-use-join-fetch-a6cec898c4c6

  > https://github.com/aershov24/design-patterns-interview-questions

  > https://www.geeksforgeeks.org/system-design/top-design-patterns-interview-questions/

  > https://www.interviewbit.com/design-patterns-interview-questions/

# Spring / Spring Boot

## Spring Basics

- SpEL

  > https://www.baeldung.com/spring-expression-language

- Autoconfiguration

  > https://www.youtube.com/watch?v=Ybfo8Dwactg&list=PLSH12D6v2LcLjdsz5pEWLSZoPKy6NTMf-

- Bean lifecycle

## Security

> https://medium.com/javarevisited/springboot-integration-with-jwt-easily-achieves-unified-cross-site-login-321627ad8e8c

## JPA, Data JPA, Hibernate

> https://medium.com/@chikim79/exploring-every-way-of-querying-databases-in-spring-spring-jpa-9c4a6b5f3525

> https://medium.com/@chikim79/ultimate-guide-to-n-1-loading-problem-in-hibernate-jpa-42e8e6cfb9f3

> https://medium.com/javarevisited/spring-jpa-when-to-use-join-fetch-a6cec898c4c6

## Transactional

- Propagation

  > https://medium.com/@gaddamnaveen192/what-is-transaction-propagation-in-spring-boot-when-to-use-b034db33fc63

- Isolation
- CascadeType

  > https://medium.com/jpa-java-persistence-api-guide/cascadetype-managing-related-entities-in-jpa-and-spring-data-b7fe446aedbd

> https://www.marcobehler.com/guides/spring-transaction-management-transactional-in-depth#commento

> https://medium.com/@gaddamnaveen192/interview-how-you-handling-transactionexception-in-a-spring-boot-application-1cfcd70cc1e7

> https://www.baeldung.com/spring-programmatic-transaction-management

## AOP

> https://medium.com/@sharmapraveen91/mastering-spring-aop-the-ultimate-guide-for-2025-55a146c8204c

## Asynchronous

> https://medium.com/javarevisited/how-does-spring-boot-implement-asynchronous-programming-this-is-how-masters-do-it-e89fc9245928

> https://levelup.gitconnected.com/springboot-combine-spring-event-with-async-annotation-for-effortless-code-decoupling-and-7bb17942f20a

## Caching

## Cloud

> https://spring.io/guides/gs/spring-cloud-loadbalancer

## Swagger

> https://medium.com/@AlexanderObregon/understanding-the-hidden-annotation-in-spring-for-hiding-openapi-endpoints-e3a81a99161c

## Actuator

## Testing

> https://medium.com/@gaddamnaveen192/spring-boot-interview-prep-300-questions-and-real-world-challenges-explained-c1f5ab7bb4b1#3f94

## Performance and proper using

> https://medium.com/javarevisited/interviewer-how-to-achieve-graceful-shutdown-in-spring-boot-888f7cfdf6da

> https://medium.com/javarevisited/how-to-gracefully-load-configuration-files-in-spring-boot-these-methods-are-a-must-know-b40358817103

## Others

> https://medium.com/@junfeng0828/list/spring-spring-boot-0af4e97aa3f5

> https://blog.stackademic.com/the-ultimate-spring-springboot-annotations-cheatsheet-e331cc3f4b13

> https://vrnsky.medium.com/understanding-cglib-in-spring-boot-enhancing-runtime-code-generation-d33907499834

# Websockets

> https://medium.com/@greekykhs/websockets-part-1-socket-programming-interview-questions-in-java-b4d96545401d

> https://medium.com/@greekykhs/websockets-part-2-websockets-interview-questions-in-java-1ba0f086372c

> https://medium.com/@greekykhs/websockets-part-3-key-components-of-the-java-websocket-api-e18d4ea40f63

> https://medium.com/@AlexanderObregon/a-basic-overview-of-java-web-sockets-for-real-time-communication-183209883ee5

> https://medium.com/swlh/how-to-build-a-websocket-applications-using-java-486b3e394139

> https://medium.com/@AlexanderObregon/real-time-data-streaming-with-java-web-sockets-7a1eab0a8845

# SQL

> https://charliefay.medium.com/sql-find-the-second-or-nth-highest-value-f4a99dcab254

> https://medium.com/@johnnyJK/understanding-sql-joins-a-comprehensive-guide-88bab3457270

> https://medium.com/swlh/learn-sql-joins-once-and-for-all-d5d9078eee7c

> https://medium.com/data-science/sql-explained-normal-forms-e2a8b8ce1122

> https://www.datacamp.com/tutorial/normalization-in-sql

# Hibernate

> https://www.geeksforgeeks.org/advance-java/hibernate-lifecycle/

> https://medium.com/@shumbareuben/understanding-hibernate-an-in-depth-overview-6e9a14fe03ae

> https://medium.com/@pratik.941/understanding-hibernate-a-comprehensive-guide-with-examples-d988df74e940

> https://medium.com/@himani.prasad016/caching-in-hibernate-3ad4f479fcc0

> https://medium.com/free-code-camp/hibernate-deep-dive-relations-lazy-loading-n-1-problem-common-mistakes-aff1fa390446

> https://www.youtube.com/watch?v=GRV69QNSdVg

# UML

> https://www.visual-paradigm.com/guide/uml-unified-modeling-language/uml-class-diagram-tutorial/

> https://www.linkedin.com/pulse/object-oriented-programming-part-4-association-alireza-goodarzi-frqpf/

> https://www.visual-paradigm.com/guide/uml-unified-modeling-language/uml-aggregation-vs-composition/

# Maven

> https://maven.apache.org/guides/plugin/guide-java-plugin-development.html

> https://vrnsky.medium.com/maven-plugin-development-from-basic-to-advanced-9b666dc55211

> https://medium.com/@madharjagan/maven-mvn-archetype-generate-no-pom-in-this-directory-missingprojectexception-8e12c1f5df99

> https://jstobigdata.com/maven/maven-plugins-in-depth/#google_vignette

# Git

# DSA

# Microservices

- Protocols

  - RESTful API
    > https://itsrorymurphy.medium.com/restful-apis-essential-concepts-for-developers-a48600e808c3

- Message Brokers
  - Kafka
    > https://www.youtube.com/watch?v=DU8o-OTeoCc&list=PLSH12D6v2LcJG7iduRLIMuRojbc9Kbvah
  - RabbitMQ

# Docker

> https://docs.docker.com/build/building/best-practices/#from

> https://medium.com/@kmdkhadeer/docker-get-started-9aa7ee662cea

> https://stackoverflow.com/questions/37461868/difference-between-run-and-cmd-in-a-dockerfile

> https://www.baeldung.com/ops/docker-copy-add

> https://kapeli.com/cheat_sheets/Dockerfile.docset/Contents/Resources/Documents/index

> https://medium.com/@devops_83824/introduction-to-docker-compose-934238b14c13

> https://devhints.io/docker-compose

# Algorithms

- Permutation of a string
  > https://www.geeksforgeeks.org/dsa/write-a-c-program-to-print-all-permutations-of-a-given-string/

# Interview descriptions that make sense to revisit

> https://rathod-ajay.medium.com/top-10-senior-level-java-dev-interview-questions-difficulty-hard-b7a6be93105a

# OWASP

> https://medium.com/@aasthathakker/owasp-top-10-web-application-vulnerabilities-part-1-5631d69ab89f

> https://medium.com/@dev.nest/owasp-top-10-explained-with-examples-5c15071a3c13s

## Interview questions/answers

> https://www.geeksforgeeks.org/java/java-interview-questions/
