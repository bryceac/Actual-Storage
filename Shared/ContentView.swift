//
//  ContentView.swift
//  Shared
//
//  Created by Bryce Campbell on 4/16/21.
//

import SwiftUI

struct ContentView: View {
    @State private var size: String = ""
    @State private var unitSelection: Int = 0
    @State private var actualSize: String = ""
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            Form {
                TextField("Size", text: $size)
                
                
            }
        }
        #else
        #endif
    }
    
    func loadUnits() -> [String] {
        let JSON_DECODER = JSONDecoder()
        
        var units: [String] = []
        
        #if os(iOS)
        let DOCUMENTS_DIRECTORY = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        guard let UNIT_DATA = try? Data(contentsOf: DOCUMENTS_DIRECTORY.appendingPathComponent("units").appendPathExtension("json")), let UNITS = try? JSON_DECODER.decode([String].self, from: UNIT_DATA) else { return [String]() }
        
        units = UNITS
        #else
        guard let BUNDLE_URL = Bundle.main.url(forResource: "units", withExtension: "json"), let UNIT_DATA = try? Data(contentsOf: BUNDLE_URL), let UNITS = try? JSON_DECODER.decode([String].self, from: UNIT_DATA) else { return [String]() }
        
        units = UNITS
        #endif
        
        return units
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
