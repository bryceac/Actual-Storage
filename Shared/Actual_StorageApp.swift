//
//  Actual_StorageApp.swift
//  Shared
//
//  Created by Bryce Campbell on 4/16/21.
//

import SwiftUI

@main
struct Actual_StorageApp: App {
    init() {
        #if os(iOS)
        let DOCUMENTS_DIRECTORY = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if !FileManager.default.fileExists(atPath: DOCUMENTS_DIRECTORY.appendingPathComponent("units").appendingPathExtension("json").absoluteString) {
            
            if let BUNDLE_PATH = Bundle.main.url(forResource: "units", withExtension: "json") {
                try? FileManager.default.copyItem(at: BUNDLE_PATH, to: DOCUMENTS_DIRECTORY.appendingPathComponent("units").appendingPathExtension("json"))
            }
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
