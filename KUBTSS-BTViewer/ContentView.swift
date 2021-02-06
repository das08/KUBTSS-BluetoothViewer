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
        Text(bm.status)
            .padding()
        Text("Device name: \(bm.deviceName)")
            .bold()
            .padding()
        HStack{
            Button(action: {
                bm.connectPeripheral()
            }, label: {
                Text("接続する")
            })
            Button(action: {
                bm.disconnectPeripheral()
            }, label: {
                Text("切断する")
            })
        }
        
        HStack {
            Image(systemName: "speedometer")
            Text("高度計").padding(10)
            Spacer()
            Text(bm.gps)
        }
        .padding(30)
        
        HStack {
            Image(systemName: "rotate.left")
            Text("回転数計").padding(10)
            Spacer()
            Text(bm.altimeter)
        }
        .padding(30)
        
    }
}
