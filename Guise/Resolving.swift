//
//  Resolving.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    
    func resolve<RegisteredType>(key: Key<RegisteredType>, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        guard let registration = filter(key: key) else { return nil }
        return registration.resolve(parameter: parameter, cached: cached)
    }
    
    func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolve(key: Key<RegisteredType>(name: name, container: container), parameter: parameter, cached: cached)
    }
    
    func resolve<RegisteredType>(weak type: RegisteredType.Type, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, parameter: Any = ()) -> RegisteredType? {
        guard let weakling = resolve(type: Weak<RegisteredType>.self, name: name, container: container, parameter: parameter, cached: nil) else { return nil }
        return weakling.value
    }
    
    @discardableResult func resolve<Target>(into instance: Target) -> Target {
        let key = Key<Target>(container: Guise.Container.injections)
        guard let registration = filter(key: key) else { return instance }
        let parameter = InjectionParameters(target: instance, resolver: self)
        return registration.resolve(parameter: parameter, cached: false)
    }
}

public extension _Guise {

    static func resolve<RegisteredType>(key: Key<RegisteredType>, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return defaultResolver.resolve(key: key, parameter: parameter, cached: cached)
    }
    
    static func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return defaultResolver.resolve(type: type, name: name, container: container, parameter: parameter, cached: cached)
    }
    
    static func resolve<RegisteredType>(weak type: RegisteredType.Type, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, parameter: Any = ()) -> RegisteredType? {
        return defaultResolver.resolve(weak: type, name: name, container: container, parameter: parameter)
    }
    
    @discardableResult static func resolve<Target>(into instance: Target) -> Target {
        return defaultResolver.resolve(into: instance)
    }
}
