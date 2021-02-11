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
    
    var body: some View {
        VStack{
            LineView(data: bm.AltimeterData,
                         xAxisLables: ["12:00", "12:01", "12:03","12:09", "12:11", "12:12","12:15", "12:20", "12:40"],
                         title: "高度計",
                         legend: "センサ：MB1260",
                         showOrigin: false,
                         valueSpecifier: "%.0f cm")
            Text("\(Int(bm.AltimeterData.last ?? 0)) cm")
                .font(.system(size: 25, weight: .black, design: .default))
                .padding()
        }
        
    }
    
}


