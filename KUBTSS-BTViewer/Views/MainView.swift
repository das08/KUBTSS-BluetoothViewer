//
//  MainView.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/07.
//

import SwiftUI
import CoreBluetooth

struct MainView: View {
    @State private var selectedTab = 1
    @ObservedObject private var bm = BluetoothManager()
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                VStack {
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
                .tabItem { Image(systemName:"waveform.path.ecg.rectangle"); Text("接続情報")}.tag(1)
                
                VStack {
                    AltimeterGraphView()
                }
                .tabItem { Image(systemName:"chart.bar.xaxis"); Text("高度計") }.tag(2)
                
                VStack {
                    RotatorGraphView()
                }
                .tabItem { Image(systemName:"chart.bar.xaxis"); Text("回転数計") }.tag(3)
                
                
            }
            
        }
    }
}
