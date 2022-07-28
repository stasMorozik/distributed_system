Simple Example implementing Hexagonal Architecture in Microservices keeping principles DDD up when modeling domain.

Any entry point(controller) to the microservice must compiling. For example, if the read load is higher, you can create another controller that includes read-only entry points and run it on the cluster.

A core of any microservice contains domain layer that includes entities, value-objects and aggregates and the application layer that includes services.

A service of application is orchestration between entities and adapters. Any service of application can be wraped by another service that includes logging and metrics.



