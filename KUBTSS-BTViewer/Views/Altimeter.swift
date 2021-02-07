//
//  Altimeter.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/07.
//

import SwiftUI
import SwiftUICharts

struct AltimeterGraphView: View {
    @State var altimeter: [Double] = (0..<26).map { _ in .random(in: 9.0...100.0) }
    var body: some View {
            LineView(data: altimeter,
                     xAxisLables: ["12:00", "12:01", "12:03","12:09", "12:11", "12:12","12:15", "12:20", "12:40"],
                     title: "高度計",
                     legend: "センサ：MB1260",
                     showOrigin: true,
                     valueSpecifier: "%.2f m")
    }
}


