//
//  GraphView.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/03/24.
//

import SwiftUI
import SwiftUICharts

struct GraphView: View {
    @EnvironmentObject private var bm: BluetoothManager
    @State  var isRecording: Bool = false
    @State var record = RecordData(fileName: "", height: 0)
    @State var height = "0"
    
    @State var fileName = a()
    
    
    var body: some View {
        VStack{

            
        }
        
    }

}

