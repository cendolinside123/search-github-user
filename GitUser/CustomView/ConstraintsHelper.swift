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


extension UIDevice {
    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_6Plus_6sPlus_7Plus_8Plus_Simulators = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus Simulators"
        case iPhones_X_XS_12MiniSimulator = "iPhone X or iPhone XS or iPhone 12 Mini Simulator"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case iPhone_12Mini = "iPhone 12 Mini"
        case iPhone_12_12Pro = "iPhone 12 or iPhone 12 Pro"
        case iPhone_12ProMax = "iPhone 12 Pro Max"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136: return .iPhones_5_5s_5c_SE
        case 1334: return .iPhones_6_6s_7_8
        case 1792: return .iPhone_XR_11
        case 1920: return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2208: return .iPhones_6Plus_6sPlus_7Plus_8Plus_Simulators
        case 2340: return .iPhone_12Mini
        case 2426: return .iPhone_11Pro
        case 2436: return .iPhones_X_XS_12MiniSimulator
        case 2532: return .iPhone_12_12Pro
        case 2688: return .iPhone_XSMax_ProMax
        case 2778: return .iPhone_12ProMax
        default: return .unknown
        }
    }
    
    var specialType: Bool {
        if self.iPhoneX {
            return true
        }
        
        switch self.screenType {
        case .iPhones_4_4S, .iPhones_5_5s_5c_SE, .iPhones_6_6s_7_8, .iPhones_6Plus_6sPlus_7Plus_8Plus, .iPhones_6Plus_6sPlus_7Plus_8Plus_Simulators, .unknown:
            return false
        default:
            return true
        }
    }
}
