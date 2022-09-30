//
//  ReflectableEnum.swift
//  Cryptic API
//
//  Created by Slik on 30.09.2022.
//

import Foundation

protocol ReflectableEnum { }

extension ReflectableEnum {
    
    func typeName() -> String {
        return String(describing: type(of: self)).lowercased()
    }
    
    func caseName() -> String {
        
        let mirror = Mirror(reflecting: self)
        
        guard mirror.displayStyle == .enum,
              let caseWithAssociatedValue = mirror.children.first else
        {
            return String(describing: self)
        }
          
        return caseWithAssociatedValue.label ?? ""
    }
    
    func associatedValue<T>() -> T? {
        
        let mirror = Mirror(reflecting: self)
        
        guard mirror.displayStyle == .enum,
              let enumReflection = mirror.children.first else { return nil }
        
        if let value = enumReflection.value as? T {
            return value
        }
        
        return Mirror(reflecting: enumReflection.value).children.first?.value as? T
    }
}
