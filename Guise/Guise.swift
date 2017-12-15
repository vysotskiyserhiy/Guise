//
//  Guise.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct Guise: _Guise {
    public enum Name {
        case `default`
    }
    
    public enum Container {
        case `default`
        case injections
    }
    
    public static var defaultResolver: Guising = Resolver()
    
    @discardableResult public static func register<RegisteredType, ParameterType, HoldingType: Holder>(key: Key<RegisteredType>, metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<RegisteredType> where HoldingType.Held == RegisteredType {
        return defaultResolver.register(key: key, metadata: metadata, cached:cached, resolution: resolution)
    }

    @discardableResult public static func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed {
        return defaultResolver.unregister(keys: keys)
    }

    public static func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration] {
        return defaultResolver.filter(filter)
    }
}
