<h1 style='text-align: center'>Guise</h1>

<!-- [![Build Status](https://travis-ci.org/Prosumma/Guise.svg)](https://travis-ci.org/Prosumma/Guise) -->
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Guise.svg)](https://cocoapods.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Language](https://img.shields.io/badge/Swift-3.0-orange.svg)](http://swift.org)
![Platforms](https://img.shields.io/cocoapods/p/Guise.svg)

Guise is an elegant, flexible, type-safe dependency resolution framework for Swift.

- [x] Flexible dependency resolution, with optional caching
- [x] Elegant, straightforward registration
- [x] Thread-safe
- [x] Simplifies unit testing
- [x] Support for containers, named dependencies, and arbitrary types
- [x] Pass arbitrary state when resolving
- [x] Support for arbitrary metadata
- [x] Swift 3
- [x] Support for iOS 9+, macOS 10.11+, watchOS 2+, tvOS 9+

### Changes From Version 2.0

Guise 3.0 is not backwards-compatible with any previous version. The principle changes are these:

1. Containers have been eliminated as a separate type and are now just another `Hashable` parameter to the registration and resolution methods.
2. Caching has been simplified back to the state of affairs that existed in version 1.0. Instead of the complex lifecycles supported by version 2.0, there is only cached and not cached.
3. Names and containers can now be any `Hashable` type.
4. A set of `filter` overloads have been added which return arrays of keys. These can be used for resolving or unregistering _en masse_.
5. Arbitrary metadata can be passed during registration. This metadata can then be queried using the `filter` methods.
6. The signatures of the `register` and `resolve` overloads have been updated as needed.

### Usage

Before a dependency can be resolved, it must first be registered. Guise does not register dependencies directly. Instead, it registers blocks of type `(P) -> T`, where `P` is a parameter that can be supplied at resolution and `T` is the type of the actual dependency we wish to register. (Thanks to Swift's excellent type system, `P` can be `()`, i.e., `Void`, i.e., no parameter at all. This is the most common case.)

```swift
Guise.register{ AccountService() }
```

This registers the supplied block under the `AccountService` type, so if we ask Guise for the `AccountService`, this block will be called and its result returned:

```swift
let accountService = Guise.resolve()! as AccountService
```

#### Abstraction

Dependency resolution is most useful when it allows abstraction. This way different implementations can be swapped out as needed, whether at runtime or compile time.

```swift
#if TEST
let accountService = Guise.register{ MockAccountService() as AccountServicing }
#else
let accountService = Guise.register{ AccountService() as AccountServicing }
#endif
```

The return type of our resolution block `(P) -> T` is now the `AccountServicing` protocol, which both `AccountService` and `MockAccountService` implement. When resolving, we must specify this exact type:

```swift
let accountService = Guise.resolve()! as AccountServicing
```

#### Named Registrations

Registrations are recorded based on the type returned by the resolution block.

```swift
Guise.register{ AccountService() as AccountServicing }
Guise.register{ MockAccountService() as AccountServicing }
```

In this case, the second registration silently overwrites the first one. So how can two `AccountServicing` registrations be made?

```swift
Guise.register(name: "real") { AccountService() as AccountServicing }
Guise.registration(name: "mock") { MockAccountService() as AccountServicing }
```

We can then resolve the one we want quite easily.

```swift
let accountService = Guise.resolve(name: "real")! as AccountServicing
```

Any `Hashable` type can be used as a `name`.

```swift
enum Person { // Simple enumerations are hashable by default in Swift
case isabella
case miaoting
}
Guise.register(name: Person.isabella) { Person(name: "Isabella") }
```

#### Parameters

It is sometimes useful to pass a parameter when resolving, because the initializer of the registered type requires it.

```swift
Guise.register{ (size: Int) in Shoe(size) }
```

Resolution is straightforward:

```swift
let shoe = Guise.resolve(parameter: 9)! as Shoe
```

If `parameter` is not compatible with the type specified at registration, an unrecoverable runtime exception will occur.

But what if we need more than one parameter? This can be solved using any of the various structured types offered by Guise: tuples, arrays, dictionaries, structs, classes, and so on.

```swift
typealias AccountServiceParams = (url: String, foo: Int, bar: Float)
Guise.register{ (params: AccountServiceParams) in AccountService(url: params.url, foo: params.foo, bar: params.bar) as AccountServicing }
// Later
let accountService = Guise.resolve(parameter: (url: url, foo: 17, bar: 3.9))! as AccountServicing
```

#### Caching

By default, Guise does not cache. This means that the resolution block is called every time `resolve` is called. Guise can cache the result of the resolution block so that it is not needed again.

```swift
Guise.register(cached: true) { AccountService() }
```

The first time the block is resolved, Guise caches the result and all subsequent calls use this cached result. This can be overridden during resolution by passing an explicit value for `cached`.

```swift
let accountService = Guise.resolve(cached: false)! as AccountService
```

What happens if `cached: true` is passed during resolution when the block was not originally registered to be cached? Guise will cache the result anyway, but subsequent resolutions will still call the resolution block. However, the next time `cached: true` is passed when resolving, the cached value will be returned.

#### Registering Instances

A common case is to register an already-initialized instance rather than a resolution block. Guise has an overload to handle this case easily.

```swift
Guise.register(instance: AccountService() as AccountServicing)
```

This is exactly equivalent to the following:

```swift
let accountService = AccountService()
Guise.register(cached: true) { accountService as AccountServicing }
```

#### Containers

Registrations can be differentiated by placing them in containers. A container is simply another parameter that must be passed when registering and resolving. As with names, any `Hashable` type can be used.

```swift
enum Environment {
  case development
  case test
  case production
}
let accountService = Guise.register(instance: AccountService() as AccountServicing, container: Enviroment.test)
// Later, when resolving
let accountService = Guise.resolve(container: Environment.test)! as AccountServicing
```

Names and containers can be used together.

```swift
Guise.register(instance: Dog(name: "Fido"), name: Name.fido, container: Container.dogs)
let fido = Guise.resolve(name: Name.fido, container: Container.dogs)! as Dog
```

#### Keys

Every registration produces a `Key`. This `Key` uniquely identifies the registration, and any subsequent registration that would produce the same `Key` overwrites the previous one.

```swift
let key = Guise.register{ AccountService() as AccountServicing }
```

Each `Key` records the registration's type (which is always the return type of the resolution block `(P) -> T`), `name`, and `container`. While type must always be specified, `name` and `container` default to `Name.default` if they are not given. The following two registrations are functionally identical:

```swift
let key = Guise.register{ AccountService() as AccountServicing }
let key = Guise.register(name: Name.default, container: Name.default) { AccountService() as AccountServicing }
```

Keys can be constructed directly, if desired.

```swift
let key = Key(type: AccountServicing.self, name: Name.default, container: Name.default)
```

In most cases, keys can be ignored. However, they are used in some scenarios:

- When unregistering.
- When searching for registrations using the `filter` methods, a collection of type `Set<Key>` is returned.
- When performing multiple resolutions.

Each of these scenarios will be discussed below.

#### Metadata

Arbitrary metadata can be specified during registration. (Note that the default metadata is not `nil`, but `()`, i.e., an "instance" of `Void`).

```swift
let name = "Fido"
Guise.register(instance: Dog(name: name), name: name, metadata: 7)
```

To retrieve metadata, a `Key` must be used.

```swift
let key = Key(type: Dog.self, name: "Fido", container: Name.default)
let metadata = Guise.metadata(for: key)! as Int
```

If there is no metadata for the `Key`, or if it is not of the specified type, `nil` is returned.

#### Filtering

Sometimes it is convenient to find all of the registrations matching some criteria. For instance, we might want to know all of the registrations in a certain container, or all of those registered under a certain type, or matching certain metadata, or any combination of these.

The overloads of the `filter` method can accomplish any of these tasks. The result is always a set of keys (i.e., `Set<Key>`).

```swift
// Find all registrations in the default container
let keys = Guise.filter(container: Name.default)
// Find all registrations of this type in all containers with any name
let keys = Guise.filter(type: AccountServicing.self)
// Find all registrations of this type in the given container
let keys = Guise.filter(type: AccountServicing.self, container: Environment.test)
```

The `filter` method also accepts metadata queries. A metadata query is a block of type `(M) -> Bool`, where `M` is the type of the metadata as originally registered.

```swift
let keys = Guise.filter(type: Dog.self, container: Dogs.purebred) { (metadata: DogMetadata) in metadata.age < 1 }
```

To match this filter, the following must _all_ be true.

1. The registered type must be `Dog`.
2. The container must be `Dogs.purebred`.
3. The type of metadata must be `DogMetadata`.
4. The metadata query `metadata.age < 1` must return `true`.

Since `name` is not specified, it is ignored. Note that if a registration exists matching everything above, except that a different metadata type was used, i.e., `Int` instead of `DogMetadata`, it is simply ignored and not returned in the output.

The resulting `Set<Key>` can be used when unregistering, when performing multiple resolution, etc.

#### Single Resolution

Resolution has been discussed implicitly in many of the sections above.

#### Multiple Resolution

Given a sequence of keys, it is possible to resolve many dependencies at the same time.

```swift
let keys = Guise.filter(type: Dog.self, container: Container.dogs)
let dogs = Guise.resolve(keys: dogs) as [Dog]
// Or…
let dogs = Guise.resolve(keys: dogs) as [Key: Dog]
```
