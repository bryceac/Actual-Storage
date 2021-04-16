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
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
