//
//  Resolution.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public typealias Resolution<P, T> = (P) -> T

// MARK: - Resolve By Keys

extension Guise {
    
    /// All roads lead here
    private static func resolve<T>(keys: Set<Key<T>>, parameter: Any = (), cached: Bool? = nil, metathunk: Metathunk? = nil) -> [Key<T>: T] {
        let keys = keys.map{ AnyKey($0)! }
        var deps = lock.read{ registrations.filter{ keys.contains($0.key) } }
        if let metathunk = metathunk { deps = deps.filter{ metathunk($0.value.metadata) } }
        return deps.map{ (key: Key($0.key)!, value: $0.value.resolve(parameter: parameter, cached: cached)) }.dictionary()
    }
    
    // MARK: Resolve By Single Key
    
    public static func resolve<T>(key: Key<T>, parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: nil).values.first
    }
    
    public static func resolve<T, M>(key: Key<T>, parameter: Any = (), cached: Bool? = nil, metafilter: @escaping Metafilter<M>) -> T? {
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: metathunk(metafilter)).values.first
    }
    
    public static func resolve<T, M: Equatable>(key: Key<T>, metadata: M, parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(key: key, parameter: parameter, cached: cached) { $0 == metadata }
    }
    
    // MARK: Resolve By Multiple Keys
    
    public static func resolve<T>(keys: Set<Key<T>>, parameter: Any = (), cached: Bool? = nil) -> [Key<T>: T] {
        return resolve(keys: keys, parameter: parameter, cached: cached, metathunk: nil)
    }

    public static func resolve<T, M>(keys: Set<Key<T>>, parameter: Any = (), cached: Bool? = nil, metafilter: @escaping Metafilter<M>) -> [Key<T>: T] {
        return resolve(keys: keys, parameter: parameter, cached: cached, metathunk: metathunk(metafilter))
    }
    
    public static func resolve<T, M: Equatable>(keys: Set<Key<T>>, metadata: M, parameter: Any = (), cached: Bool? = nil) -> [Key<T>: T] {
        return resolve(keys: keys, parameter: parameter, cached: cached) { $0 == metadata }
    }
    
    public static func resolve<T>(keys: Set<Key<T>>, parameter: Any = (), cached: Bool? = nil) -> [T] {
        return Array(resolve(keys: keys, parameter: parameter, cached: cached, metathunk: nil).values)
    }

    public static func resolve<T, M>(keys: Set<Key<T>>, parameter: Any = (), cached: Bool? = nil, metafilter: @escaping Metafilter<M>) -> [T] {
        return Array(resolve(keys: keys, parameter: parameter, cached: cached, metathunk: metathunk(metafilter)).values)
    }
    
    public static func resolve<T, M: Equatable>(keys: Set<Key<T>>, metadata: M, parameter: Any = (), cached: Bool? = nil) -> [T] {
        return Array(resolve(keys: keys, parameter: parameter, cached: cached) { $0 == metadata })
    }
}

// MARK: - Resolve By Type, Name, Container

extension Guise {
    
    // MARK: Resolve By Type, Name, & Container
    
    public static func resolve<T, N: Hashable, C: Hashable>(type: T.Type = T.self, name: N, container: C, parameter: Any = (), cached: Bool? = nil) -> T? {
        let key = Key<T>(name: name, container: container)
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: nil).values.first
    }
    
    public static func resolve<T, N: Hashable, C: Hashable, M>(type: T.Type = T.self, name: N, container: C, parameter: Any = (), cached: Bool? = nil, metafilter: @escaping Metafilter<M>) -> T? {
        let key = Key<T>(name: name, container: container)
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: metathunk(metafilter)).values.first
    }
    
    public static func resolve<T, N: Hashable, C: Hashable, M: Equatable>(type: T.Type = T.self, name: N, container: C, metadata: M, parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(name: name, container: container, parameter: parameter, cached: cached) { $0 == metadata }
    }
    
    // MARK: Resolve By Type & Name
    
    public static func resolve<T, N: Hashable>(type: T.Type = T.self, name: N, parameter: Any = (), cached: Bool? = nil) -> T? {
        let key = Key<T>(name: name)
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: nil).values.first
    }
    
    public static func resolve<T, N: Hashable, M>(type: T.Type = T.self, name: N, parameter: Any = (), cached: Bool? = nil, metafilter: @escaping Metafilter<M>) -> T? {
        let key = Key<T>(name: name)
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: metathunk(metafilter)).values.first
    }
    
    public static func resolve<T, N: Hashable, M: Equatable>(type: T.Type = T.self, name: N, metadata: M, parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(name: name, parameter: parameter, cached: cached) { $0 == metadata }
    }
    
    // MARK: Resolve By Type & Container
    
    public static func resolve<T, C: Hashable>(type: T.Type = T.self, container: C, parameter: Any = (), cached: Bool? = nil) -> T? {
        let key = Key<T>(container: container)
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: nil).values.first
    }
    
    public static func resolve<T, C: Hashable, M>(type: T.Type = T.self, container: C, parameter: Any = (), cached: Bool? = nil, metafilter: @escaping Metafilter<M>) -> T? {
        let key = Key<T>(container: container)
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: metathunk(metafilter)).values.first
    }
    
    public static func resolve<T, C: Hashable, M: Equatable>(type: T.Type = T.self, container: C, metadata: M, parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(container: container, parameter: parameter, cached: cached) { $0 == metadata }
    }
    
    // MARK: Resolve By Type
    
    public static func resolve<T>(type: T.Type = T.self, parameter: Any = (), cached: Bool? = nil) -> T? {
        let key = Key<T>()
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: nil).values.first
    }
    
    public static func resolve<T, M>(type: T.Type = T.self, parameter: Any = (), cached: Bool? = nil, metafilter: @escaping Metafilter<M>) -> T? {
        let key = Key<T>()
        return resolve(keys: [key], parameter: parameter, cached: cached, metathunk: metathunk(metafilter)).values.first
    }
    
    public static func resolve<T, M: Equatable>(type: T.Type = T.self, metadata: M, parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(parameter: parameter, cached: cached) { $0 == metadata }
    }

}

