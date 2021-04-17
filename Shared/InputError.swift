//
//  InputError.swift
//  Actual Storage
//
//  Created by Bryce Campbell on 4/17/21.
//

import Foundation
import SwiftUI

enum InputError: String, Error, Identifiable {
    case sizeNotNumerical
    
    var alert: Alert? {
        var errorAlert: Alert? = nil
        switch self {
        case .sizeNotNumerical: errorAlert = Alert(title: Text("Input Not Numerical"), message: Text("Input must be numerical"), dismissButton: .default(Text("Ok")))
        }
        
        return errorAlert
    }
    
    var id: String {
        return rawValue
    }
}
