//
//  Rotation.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/07.
//

import SwiftUI
import SwiftUICharts

struct RotationGraphView: View {
    @EnvironmentObject private var bm: BluetoothManager
    @State  var isRecording: Bool = false
    @State var record = RecordData(fileName: "", height: 0)
    @State var height = "0"
    
    @State var fileName = a()
    
    
    var body: some View {
        VStack{
            LineView(data: bm.RotationData,
                         xAxisLables: ["12:00", "12:01", "12:03","12:09", "12:11", "12:12","12:15", "12:20", "12:40"],
                         title: "回転数計",
                         legend: "フォトインタラプタ",
                         showOrigin: false,
                         valueSpecifier: "%.0f rpm")
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
                        record.record(raw:bm.RotationData.last)
                        self.isRecording = true
                    })
                    {
                        Text("記録開始")
                    }
                }
                Text("\(Int(bm.RotationData.last ?? 0)) rpm")
                    .font(.system(size: 25, weight: .black, design: .default))
                    .padding()
                    .onChange(of: bm.RotationData) { newValue in
                        go()
                    }
            }
            
        }
        
    }
    func go(){
        print("S")
        if isRecording {
            record.record(raw:bm.RotationData.last)
        }
    }
    
}

