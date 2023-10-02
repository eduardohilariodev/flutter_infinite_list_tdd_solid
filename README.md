
# Concepts
- **Repository**:
  > In the context of clean architecture, a repository takes on a more
  > specialized role.
  > 
  > It serves as a middleman between the application's business logic and the
  > data source (which could be a database, an API, or even just in-memory
  > data). The repository pattern is all about abstracting away the complexities
  > of data retrieval and manipulation.
  > 
  > It enables the core business logic, or domain layer, to remain clean and
pure, devoid of any muddying details like how to talk to a database or API.
- **Service Locator**:
  > One of the advantages of using GetIt is that it allows us to easily manage
  >dependencies between services. We can use named registrations to specify
  >dependencies between services, and GetIt will automatically resolve them when
  >the services are requested. We can also use the lazy parameter to defer the
  >creation of a service until it is needed.
# Cookbook on feature-drive TDD Flutter app building with SOLID principles

- [Concepts](#concepts)
- [Cookbook on feature-drive TDD Flutter app building with SOLID principles](#cookbook-on-feature-drive-tdd-flutter-app-building-with-solid-principles)
  - [Define the feature](#define-the-feature)
  - [Design the UX/UI of the feature](#design-the-uxui-of-the-feature)
  - [Clean Architecture](#clean-architecture)
  - [Test-Driven Development](#test-driven-development)
    - [Files that are **NOT** going to be written in a TDD manner:](#files-that-are-not-going-to-be-written-in-a-tdd-manner)
  - [Implement the `domain` layer](#implement-the-domain-layer)

Step-by-step overview guide on implementing a new feature

## Define the feature

## Design the UX/UI of the feature

## Clean Architecture

> The actual coding process will happen from the inner, most stable layers of
> the architecture outwards.

## Test-Driven Development

### Files that are **NOT** going to be written in a TDD manner:

- `entity` classes
  - We aren't going to write it in a test-driven way and it's for one simple
    reason - there's nothing to test.

## Implement the `domain` layer

- Implement `entity` classes
  > **Q&A on `entity`:**
  >
  > - **Q:** What kind of **data** will this entity need to work with?
  > - **A:** To find out which fields `entity` classes must have, we have to
  >   take a look at the response from the API.
- Implement `failure` classes In order to not have to deal with exceptions, we
  implement `failure` classes. They use the package `dartz`, that brings the
  `Either` type to Dart. `failure` classes return an `Either` with a `Failure`
  and the object with the wanted data.
- Implement the `repository` contract on the `domain` layer
  > **Q&A on `repository` contract:**
  >
  > - **Q:** Why are there two `repository` files?
  > - **A:** The `repository` contract (placed on the `domain` layer) is the
  >   interface that the `data` layer with implement. This separation of
  >   concerns (the **D** in **SOLID**) protects the `domain` layer from the
  >   outside world (the `data` layer). This also allows us to test it without
  >   implementing a concrete `repository` class, through the use of **mocks**
  >   (the `mockito` package on this project).
  >
  > - **Q:** What's implemented on the contract?
  > - **A:** The `repository` contract is a class that **has all the methods**
  >   that the `repository` class (on the `data` layer) will have to implement.
  >   It's a contract that defines what the `repository` class will have to do.
- Implement the `usecase` for each `repository` method
  1. First write the test for it
  > The first and only test will ensure that the Repository is
  actually called and that the data simply passes unchanged throught the Use
  Case
  2. Then do the concrete implementation
