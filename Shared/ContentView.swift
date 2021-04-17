//
//  ContentView.swift
//  Shared
//
//  Created by Bryce Campbell on 4/16/21.
//

import SwiftUI

struct ContentView: View {
    @State private var size = WholeNumbersOnly()
    @State private var unitSelection: Int = 0
    @State private var actualSize: String = ""
    
    var units: [String] {
        return loadUnits()
    }
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            Form {
                TextField("Size", text: $size.value).padding().keyboardType(.decimalPad)
                
                Picker("Units", selection: $unitSelection) {
                    
                    ForEach(units, id: \.self) { unit in
                        
                        if let UNIT_INDEX = units.firstIndex(of: unit) {
                            
                            Text(unit).tag(UNIT_INDEX)
                        }
                    }
                }
                
                TextField("Actual", text: $actualSize).disabled(true)
                
                Button("Calculate") {
                    if let ACTUAL_SIZE = actual(size.value, inUnit: units[unitSelection]) {
                        
                        actualSize = String(format: "%.2f %@", ACTUAL_SIZE, units[unitSelection])
                    }
                }
            }
        }
        #else
        Form {
            TextField("Size", text: $size.value).padding().keyboardType(.decimalPad)
            
            Picker("Units", selection: $unitSelection) {
                
                ForEach(units, id: \.self) { unit in
                    
                    if let UNIT_INDEX = units.firstIndex(of: unit) {
                        
                        Text(unit).tag(UNIT_INDEX)
                    }
                }
            }
            
            TextField("Actual", text: $actualSize).disabled(true)
            
            Button("Calculate") {
                if let ACTUAL_SIZE = actual(size.value, inUnit: units[unitSelection]) {
                    
                    actualSize = String(format: "%.2f %@", ACTUAL_SIZE, units[unitSelection])
                }
            }
        }
        #endif
    }
    
    func loadUnits() -> [String] {
        let JSON_DECODER = JSONDecoder()
        
        var units: [String] = []
        
        #if os(iOS)
        let DOCUMENTS_DIRECTORY = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        guard let UNIT_DATA = try? Data(contentsOf: DOCUMENTS_DIRECTORY.appendingPathComponent("units").appendingPathExtension("json")), let UNITS = try? JSON_DECODER.decode([String].self, from: UNIT_DATA) else { return [String]() }
        
        units = UNITS
        #else
        guard let BUNDLE_URL = Bundle.main.url(forResource: "units", withExtension: "json"), let UNIT_DATA = try? Data(contentsOf: BUNDLE_URL), let UNITS = try? JSON_DECODER.decode([String].self, from: UNIT_DATA) else { return [String]() }
        
        units = UNITS
        #endif
        
        return units
    }
    
    func actual(_ size: String, inUnit unit: String) -> Double? {
        guard let size = Int(size), let UNIT_INDEX = units.firstIndex(of: unit) else { return nil }
        
        return (Double(size)*pow(Double(1000), Double(UNIT_INDEX+1)))/pow(Double(1024), Double(UNIT_INDEX+1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
