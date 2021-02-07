//
//  SettingView.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/07.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("カスタマイズ")) {
                    Text("None")
                }
                
                Section(header: Text("デバッグ")) {
                    Text("None")
                }
            }
            .navigationBarTitle("設定")
        }
    }
}
