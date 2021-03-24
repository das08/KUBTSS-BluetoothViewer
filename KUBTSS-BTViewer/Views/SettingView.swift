//
//  SettingView.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/07.
//

import SwiftUI

struct SettingView: View {
    @State var showData = false
    @State var datas = LoadFromStorage2.shared.loadData()
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("カスタマイズ")) {
                                        ForEach(datas) { data in
                                            NavigationLink(destination: DetailView(data: data)) {
                                            Text(data.fileName)
                                            }
                                        }
//                    List(datas, id: \.self) { data in
//                        NavigationLink(destination: DetailView(data: data)) {
//                            Text(data.fileName)
//                        }
//                    }
                    
                    
                }
                
                Section(header: Text("デバッグ")) {
                    Button(action: {
                        
                        self.datas = LoadFromStorage2.shared.loadData()
                        
                    })
                    {
                        Text("reload")
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1))
                    }
                    
                    Button(action: {
                        let a = LoadFromStorage2.shared.loadData()
                        for i in a{
                            print("\(i.id)")
                            print("Filename: \(i.fileName)")
//                            print("RawData: \(i.rawData)")
//                            print("adjust: \(i.adjustData)")
//                            print("timestamp: \(i.aquiredTime)")
                        }
                    })
                    {
                        Text("debug")
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1))
                    }
                    Button(action: {
                        let a = SaveToStorage2.shared.deleteAll()
                        datas = LoadFromStorage2.shared.loadData()
                    })
                    {
                        Text("reset")
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1))
                    }
                }
            }
            .navigationBarTitle("設定")
        }
    }
}

struct DetailView: View {
    var data: TFData
    
    var body: some View {
        VStack {
            Text(data.fileName).font(.headline)
            
            HStack {
//                List(data.altitude, id: \.self) { item in
//                    Text("\(item) cm")
//                }
                List{
                    Text("高度, 回転数")
                    ForEach(Array(zip(data.altitude, data.rotation)), id: \.0) { item in
                        Text("\(item.0) cm, \(item.1) rpm")
                    }
                }
                
            }
            
            Spacer()
        }
    }
}
