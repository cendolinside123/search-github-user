//
//  ConstraintsHelper.swift
//  GitUser
//
//  Created by Jan Sebastian on 22/09/22.
//

import Foundation
import UIKit

struct ConstraintHelper {
    
}

extension ConstraintHelper {
    static func findConstraints(_ constraints: [NSLayoutConstraint], name identifier: String) -> Int? {
        
        guard let getIndex = constraints.firstIndex(where: {
            $0.identifier == identifier
        }) else {
            return nil
        }
        
        guard getIndex < constraints.count else {
            return nil
        }
        
        return getIndex
    }
}
