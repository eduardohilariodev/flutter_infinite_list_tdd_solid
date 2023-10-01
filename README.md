Cookbook on feature-drive TDD Flutter app building with SOLID principles

- [1. Define the feature](#1-define-the-feature)
- [2. Design the UX/UI of the feature](#2-design-the-uxui-of-the-feature)
- [3. Clean Architecture](#3-clean-architecture)
- [4. Test-Driven Development](#4-test-driven-development)
  - [4.1. Files that are **NOT** going to be written in a TDD manner:](#41-files-that-are-not-going-to-be-written-in-a-tdd-manner)
- [5. Implement the `domain` layer](#5-implement-the-domain-layer)

Step-by-step overview guide on implementing a new feature

# 1. Define the feature

# 2. Design the UX/UI of the feature

# 3. Clean Architecture

> The actual coding process will happen from the inner, most stable layers of the architecture outwards.

# 4. Test-Driven Development

## 4.1. Files that are **NOT** going to be written in a TDD manner:

1. `entity` classes
   1. We aren't going to write it in a test-driven way and it's for one simple reason - there's nothing to test. 

# 5. Implement the `domain` layer

1. Implement `entity` classes
   > **Q&A on `entity`:**
   >
   > - **Q:** What kind of **data** will this entity need to work with?
   > - **A:** To find out which fields this `entity` class must have, we have to take a look at the response from the API.
