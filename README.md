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
  > pure, devoid of any muddying details like how to talk to a database or API.
  >
  > Repository is the brain of the data layer of an app. It handles data from
  > remote and local Data Sources, decides which Data Source to prefer and also,
  > this is where data caching policy is decided upon.

- **Service Locator**:
  > One of the advantages of using GetIt is that it allows us to easily manage
  > dependencies between services. We can use named registrations to specify
  > dependencies between services, and GetIt will automatically resolve them when
  > the services are requested. We can also use the lazy parameter to defer the
  > creation of a service until it is needed.

# Cookbook on feature-drive TDD Flutter app building with SOLID principles

- [Concepts](#concepts)
- [Cookbook on feature-drive TDD Flutter app building with SOLID principles](#cookbook-on-feature-drive-tdd-flutter-app-building-with-solid-principles)
  - [Define the feature](#define-the-feature)
  - [Design the UX/UI of the feature](#design-the-uxui-of-the-feature)
  - [Clean Architecture](#clean-architecture)
  - [Test-Driven Development](#test-driven-development)
    - [Files that are **NOT** going to be written in a TDD manner:](#files-that-are-not-going-to-be-written-in-a-tdd-manner)
  - [Implement the `domain` layer](#implement-the-domain-layer)
    - [- Implement `entity` classes](#--implement-entity-classes)
    - [- Implement `failure` classes In order to not have to deal with exceptions, we](#--implement-failure-classes-in-order-to-not-have-to-deal-with-exceptions-we)
    - [- Implement the `repository` contract on the `domain` layer](#--implement-the-repository-contract-on-the-domain-layer)
    - [- Implement the `usecase` for each `repository` method](#--implement-the-usecase-for-each-repository-method)
  - [Implement the `data` layer](#implement-the-data-layer)
    - [- Implement `model`](#--implement-model)
    - [- Implement `repository` concrete implementation](#--implement-repository-concrete-implementation)

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

### - Implement `entity` classes

> **Q&A on `entity`:**
>
> - **Q:** What kind of **data** will this entity need to work with?
> - **A:** To find out which fields `entity` classes must have, we have to
>   take a look at the response from the API.

### - Implement `failure` classes In order to not have to deal with exceptions, we

implement `failure` classes. They use the package `dartz`, that brings the
`Either` type to Dart. `failure` classes return an `Either` with a `Failure`
and the object with the wanted data.

### - Implement the `repository` contract on the `domain` layer

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

### - Implement the `usecase` for each `repository` method

1. First write the test for it
   > The first and only test will ensure that the Repository is
   > actually called and that the data simply passes unchanged throught the Use
   > Case
2. Then do the concrete implementation
   > Note: For consistency, implement a `UseCase` abstract class with a `call()`
   > method from which all other `UseCase` classes will inherit from.

## Implement the `data` layer

While the `domain` layer is the safe center of an app which is independent of
other layers, the `data` layer is a place where the app meets with the harsh
outside world of APIs and 3rd party libraries. It consists of low-level Data
Sources, Repositories which are the single source of truth for the data, and
finally Models.

### - Implement `model`

- Create a _fixture_ to test the `model`'s `fromJson` and `toJson` methods
  > Let's first conversion logic we'll implement will be the fromJson method
  > which should return a NumberTriviaModel instance with the same data as is
  > present inside the JSON string. We aren't going to get the JSON string
  > from the "live" Numbers API. Instead, we will create a fixture which is
  > just a regular JSON file used for testing. That's because we want to have
  > a predictable JSON string to test with - for example, what if the Numbers
  > API is under maintenance? We don't want any outside forces to mess with
  > the results of our tests.

### - Implement `repository` concrete implementation

1.  Implement the `repository`'s dependency contracts
    Are Data Sources enough though? After all, we will cache the latest Posts
    locally to make sure the user sees something even when he's offline. This
    means, we'll also need to have a way to find out about the current state
    of the network connection. Since we want to keep our code as independent
    from the outside world as possible, we won't just plop any 3rd party
    library for connectivity directly into the Repository. Instead, we'll
    create a `NetworkInfo` class.
2.  Implement the `data_sources` classes and methods
    We're on the boundary between the outside world and our app, so we want to keep this simple. There will be no `Either<Failure, Post>`, but instead, we're going to return just a simple PostModel (converted from JSON). Errors will be handled by throwing Exceptions. Taking care of this "dumb" data and converting it to the Either type will be the responsibility of the Repository.

    > Naming rationale on `data_sources` and `repository` methods:

    > - When fetching data from the API endpoint, we'll call the method
    >   `fetch<use_case>`
    > - When getting data from the repository: `get<use_case>`

3.  Implement `Exceptions` and `Failures`
