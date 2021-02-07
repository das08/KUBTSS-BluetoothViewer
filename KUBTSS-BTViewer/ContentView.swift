//
//  ContentView.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/06.
//

import SwiftUI
import CoreBluetooth


struct ContentView: View {
//    @ObservedObject private var bm = BluetoothManager()
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    VStack {
                        Image(systemName: "tray.2.fill")
                        Text("計器類")
                    }
                }.tag(1)
            SettingView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("設定")
                    }
                }.tag(2)
        }
        
    }
}
