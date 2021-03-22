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
                    Text(self.bm.stateText)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Device name: \(bm.deviceName)")
                        .bold()
                        .padding()
                    HStack{
//                        Button(action: {
//                            bm.connectPeripheral()
//                        }, label: {
//                            Text("接続する")
//                        })
                        Button(action: {
                            self.bm.buttonPushed()
                        })
                        {
                            Text(self.bm.buttonText)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 1))
                        }
                    }
                    
                    HStack {
                        VStack{
                            HStack{
                                Image(systemName: "speedometer")
                                Text("高度計").padding(10)
                            }
                            Text(bm.altimeter)
                                .font(.system(size: 55))
                                .fontWeight(.bold)
                        }
                    }
                    .padding(20)
                    
                    HStack {
                        VStack{
                            HStack{
                                Image(systemName: "arrow.clockwise.circle")
                                Text("回転数計").padding(10)
                            }
                            Text(bm.rotation)
                                .font(.system(size: 55))
                                .fontWeight(.bold)
                        }
                    }
                    .padding(20)
                    
                    HStack {
                        VStack{
                            HStack{
                                Image(systemName: "airplane")
                                Text("気速計").padding(10)
                            }
                            Text(bm.airspeed)
                                .font(.system(size: 55))
                                .fontWeight(.bold)
                        }
                    }
                    .padding(20)
                    
//                    Spacer()
                    
                }
                .tabItem { Image(systemName:"waveform.path.ecg.rectangle"); Text("接続情報")}.tag(1)
                
                VStack {
                    AltimeterGraphView().environmentObject(bm)
                }
                .tabItem { Image(systemName:"chart.bar.xaxis"); Text("高度計") }.tag(2)
                
                VStack {
                    RotationGraphView().environmentObject(bm)
                }
                .tabItem { Image(systemName:"chart.bar.xaxis"); Text("回転数計") }.tag(3)
                
                VStack {
                    AirspeedGraphView().environmentObject(bm)
                }
                .tabItem { Image(systemName:"chart.bar.xaxis"); Text("気速計") }.tag(4)
                
                
                
                
            }
            
        }
    }
}
