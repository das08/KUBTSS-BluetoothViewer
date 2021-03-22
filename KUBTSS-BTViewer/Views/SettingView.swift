//
//  SettingView.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/07.
//

import SwiftUI

struct SettingView: View {
    @State var showData = false
    @State var datas = LoadFromStorage.shared.loadData()
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
                        
                        self.datas = LoadFromStorage.shared.loadData()
                        
                    })
                    {
                        Text("reload")
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1))
                    }
                    
                    Button(action: {
                        let a = LoadFromStorage.shared.loadData()
                        for i in a{
                            print("\(i.id)")
                            print("Filename: \(i.fileName)")
                            print("RawData: \(i.rawData)")
                            print("adjust: \(i.adjustData)")
                            print("timestamp: \(i.aquiredTime)")
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
                        let a = SaveToStorage.shared.deleteAll()
                        datas = LoadFromStorage.shared.loadData()
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
    var data: AltimeterData
    
    var body: some View {
        VStack {
            Text(data.fileName).font(.headline)
            
            HStack {
                Text("設定高度: \(data.adjustData) cm")
                List(data.rawData, id: \.self) { item in
                    Text("\(item) cm")
                }
            }
            
            Spacer()
        }
    }
}
