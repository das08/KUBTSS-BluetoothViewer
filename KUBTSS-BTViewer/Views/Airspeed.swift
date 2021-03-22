//
//  Airspeed.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/03/22.
//

import SwiftUI
import SwiftUICharts

struct AirspeedGraphView: View {
    @EnvironmentObject private var bm: BluetoothManager
    @State  var isRecording: Bool = false
    @State var record = RecordData(fileName: "", height: 0)
    @State var height = "0"
    
    @State var fileName = a()
    
    
    var body: some View {
        VStack{
            LineView(data: bm.AirspeedData,
                         xAxisLables: ["12:00", "12:01", "12:03","12:09", "12:11", "12:12","12:15", "12:20", "12:40"],
                         title: "気速計",
                         legend: "センサ:RE12D",
                         showOrigin: false,
                         valueSpecifier: "%.0f m/s")
                .padding()
            
            VStack{
                TextField("FN", text: $fileName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("現在の高さ", text: $height)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if isRecording {
                    HStack{
                        Button(action: {
                            self.record.stop()
                            self.isRecording = false
                        })
                        {
                            Text("保存する")
                        }
                    }
                    
                }else{
                    Button(action: {
                        record = RecordData(fileName: fileName, height: Int(height) ?? 0)
                        record.record(raw:bm.AirspeedData.last)
                        self.isRecording = true
                    })
                    {
                        Text("記録開始")
                    }
                }
                Text("\(Int(bm.AirspeedData.last ?? 0)) m/s")
                    .font(.system(size: 25, weight: .black, design: .default))
                    .padding()
                    .onChange(of: bm.AirspeedData) { newValue in
                        go()
                    }
            }
            
        }
        
    }
    func go(){
        print("S")
        if isRecording {
            record.record(raw:bm.AirspeedData.last)
        }
    }
    
}


