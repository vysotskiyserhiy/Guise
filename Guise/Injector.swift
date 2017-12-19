//
//  Injector.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct Injector<Target> {
    let resolver: Guising
    var injections = [Injection<Target>]()
    
    public init(resolver: Guising) {
        self.resolver = resolver
    }

    public func inject(injection: @escaping Injection<Target>) -> Injector<Target> {
        var injector = self
        injector.injections.append(injection)
        return injector
    }
    
    func inject<RegisteredType>(exact keyPath: WritableKeyPath<Target, RegisteredType>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            var target = target
            guard let resolved = resolver.resolve(key: key, cached: cached) else { return target }
            target[keyPath: keyPath] = resolved
            return target
        }
    }
    
    func inject<RegisteredType>(exact keyPath: WritableKeyPath<Target, RegisteredType>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(exact: keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(exact keyPath: ReferenceWritableKeyPath<Target, RegisteredType>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            guard let resolved = resolver.resolve(key: key, cached: cached) else { return target }
            target[keyPath: keyPath] = resolved
            return target
        }
    }
    
    func inject<RegisteredType>(exact keyPath: ReferenceWritableKeyPath<Target, RegisteredType>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(exact: keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, RegisteredType?>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            var target = target
            target[keyPath: keyPath] = resolver.resolve(key: key, cached: cached)
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, RegisteredType?>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, RegisteredType?>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            target[keyPath: keyPath] = resolver.resolve(key: key, cached: cached)
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, RegisteredType?>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, ImplicitlyUnwrappedOptional<RegisteredType>>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            var target = target
            target[keyPath: keyPath] = resolver.resolve(key: key, cached: cached)
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, ImplicitlyUnwrappedOptional<RegisteredType>>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, ImplicitlyUnwrappedOptional<RegisteredType>>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            target[keyPath: keyPath] = resolver.resolve(key: key, cached: cached)
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, ImplicitlyUnwrappedOptional<RegisteredType>>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, Lazy<RegisteredType>>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            var target = target
            guard let resolved = resolver.lazy(key: key, cached: cached) else { return target }
            target[keyPath: keyPath] = resolved
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, Lazy<RegisteredType>>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, Lazy<RegisteredType>>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            guard let resolved = resolver.lazy(key: key, cached: cached) else { return target }
            target[keyPath: keyPath] = resolved
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, Lazy<RegisteredType>>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, Lazy<RegisteredType>?>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            var target = target
            target[keyPath: keyPath] = resolver.lazy(key: key, cached: cached)
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, Lazy<RegisteredType>?>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, Lazy<RegisteredType>?>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            target[keyPath: keyPath] = resolver.lazy(key: key, cached: cached)
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, Lazy<RegisteredType>?>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, ImplicitlyUnwrappedOptional<Lazy<RegisteredType>>>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            var target = target
            target[keyPath: keyPath] = resolver.lazy(key: key, cached: cached)
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, ImplicitlyUnwrappedOptional<Lazy<RegisteredType>>>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, ImplicitlyUnwrappedOptional<Lazy<RegisteredType>>>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            target[keyPath: keyPath] = resolver.lazy(key: key, cached: cached)
            return target
        }
    }
    
    func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, ImplicitlyUnwrappedOptional<Lazy<RegisteredType>>>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    @discardableResult public func register() -> Key<Target> {
        let injections = self.injections
        return resolver.register(injectable: Target.self) { (target, resolver) in
            var target = target
            for injection in injections {
                target = injection(target, resolver)
            }
            return target
        }
    }
}
