Cookbook on feature-drive TDD Flutter app building with SOLID principles

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
