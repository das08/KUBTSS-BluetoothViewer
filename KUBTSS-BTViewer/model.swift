//
//  model.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/12.
//

import Foundation

struct AltimeterData: Identifiable, Codable,Hashable {
    var id: String
    let fileName: String
    let rawData: [Int]
    let adjustData: Int
    let aquiredTime: [Date]
}


struct TFData: Identifiable, Codable,Hashable {
    var id: String
    let fileName: String
    let altitude: [String]
    let rotation: [String]
    let airspeed: [String]
    let aquiredTime: Date
}
