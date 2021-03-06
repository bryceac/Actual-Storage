//
//  ContentView.swift
//  Shared
//
//  Created by Bryce Campbell on 4/16/21.
//

import SwiftUI

struct ContentView: View {
    
    // variable to store text field value
    @State private var size: String = ""
    
    // variable to hold current picker selection
    @State private var unitSelection: Int = 0
    
    // variable to hold calculations results
    @State private var actualSize: String = ""
    
    // variable used to help display errors regarding User input.
    @State private var activeInputError: InputError? = nil
    
    
    // computed property to load units from JSON file
    var units: [String] {
        return loadUnits()
    }
    
    var body: some View {
        
        // set up UI and connections properly, based upon OS
        #if os(iOS)
        NavigationView {
            Form {
                TextField("Size", text: $size)
                
                Picker("Units", selection: $unitSelection) {
                    
                    ForEach(units, id: \.self) { unit in
                        
                        if let UNIT_INDEX = units.firstIndex(of: unit) {
                            
                            Text(unit).tag(UNIT_INDEX)
                        }
                    }
                }
                
                TextField("Actual", text: $actualSize).disabled(true)
                
                // attempt to run calculation
                Button("Calculate") {
                    
                    do {
                        let ACTUAL_SIZE = try actual(size, inUnit: units[unitSelection])
                            
                            actualSize = String(format: "%.2f %@", ACTUAL_SIZE, units[unitSelection])
                    } catch (let e) {
                        activeInputError = e as! InputError
                    }
                    
                }.alert(item: $activeInputError) { activeError in
                    activeError.alert!
                }
            }
        }
        #else
        Form {
            TextField("Size", text: $size)
            
            Picker("Units", selection: $unitSelection) {
                
                ForEach(units, id: \.self) { unit in
                    
                    if let UNIT_INDEX = units.firstIndex(of: unit) {
                        
                        Text(unit).tag(UNIT_INDEX)
                    }
                }
            }
            
            TextField("Actual", text: $actualSize).disabled(true)
            
            // attempt to run calculation
            Button("Calculate") {
                
                do {
                    let ACTUAL_SIZE = try actual(size, inUnit: units[unitSelection])
                        
                        actualSize = String(format: "%.2f %@", ACTUAL_SIZE, units[unitSelection])
                } catch (let e) {
                    activeInputError = e as! InputError
                }
                
            }.alert(item: $activeInputError) { activeError in
                activeError.alert!
            }
        }
        #endif
    }
    
    /* function that will attempt to load units from JSON file.
     
     Resulting array will be empty if things go wrong.
     */
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
    
    // method to perform actual calculation
    func actual(_ size: String, inUnit unit: String) throws -> Double {
        
        // make sure given size is numeric, otherwise throw an error
        guard let size = Int(size) else {
            throw InputError.sizeNotNumerical
        }
        
        // variable to hold results of calculation
        var calculation: Double = 0
        
        // attempt to retrieve the index of the specified unit, to help do proper calculations.
        if let UNIT_INDEX = units.firstIndex(of: unit) {
            
            // perform calculation, adding 1 to the unit index, so it can be used for exponents.
            calculation = (Double(size)*pow(Double(1000), Double(UNIT_INDEX+1)))/pow(Double(1024), Double(UNIT_INDEX+1))
        }
        
        // return results.
        return calculation
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
