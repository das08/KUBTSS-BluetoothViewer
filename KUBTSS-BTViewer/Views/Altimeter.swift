//
//  Altimeter.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/07.
//

import SwiftUI
import SwiftUICharts


struct AltimeterGraphView: View {
    @EnvironmentObject private var bm: BluetoothManager
    @State  var isRecording: Bool = false
    @State var record = RecordData(fileName: "", height: 0)
    @State var height = "0"
    
    @State var fileName = a()
    
    
    var body: some View {
        VStack{
            LineView(data: bm.AltimeterData,
                         xAxisLables: ["12:00", "12:01", "12:03","12:09", "12:11", "12:12","12:15", "12:20", "12:40"],
                         title: "高度計",
                         legend: "センサ：MB1260",
                         showOrigin: false,
                         valueSpecifier: "%.0f cm")
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
                        record.record(raw:bm.AltimeterData.last)
                        self.isRecording = true
                    })
                    {
                        Text("記録開始")
                    }
                }
                Text("\(Int(bm.AltimeterData.last ?? 0)) cm")
                    .font(.system(size: 25, weight: .black, design: .default))
                    .padding()
                    .onChange(of: bm.AltimeterData) { newValue in
                        go()
                    }
            }
            
        }
        
    }
    func go(){
        print("S")
        if isRecording {
            record.record(raw:bm.AltimeterData.last)
        }
    }
    
}

func a () -> String{
    /// DateFomatterクラスのインスタンス生成
    let dateFormatter = DateFormatter()
     
    /// カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
     
    /// 変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
    dateFormatter.dateFormat = "yyyy-M-d H:m:s"
     
    /// データ変換（Date→テキスト）
    let dateString = dateFormatter.string(from: Date())
    return dateString
}
