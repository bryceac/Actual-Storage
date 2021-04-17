//
//  wholeNumbersOnly.swift
//  Actual Storage
//
//  Created by Bryce Campbell on 4/17/21.
//

import Foundation
import Combine

class WholeNumbersOnly: ObservableObject {
    @Published var value: String = "" {
        didSet {
            let filtered = value.filter { $0.isWholeNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
