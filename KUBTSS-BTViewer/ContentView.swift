//
//  ContentView.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/06.
//

import SwiftUI
import CoreBluetooth



struct ContentView: View {
    @ObservedObject private var bm = BluetoothManager()
    
    var body: some View {
        Text("Hello, world!")
            .padding()
        Button(action: {
            print("a")
        }, label: {
            Text("Button")
        })
        
    }
}
