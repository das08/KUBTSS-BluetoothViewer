//
//  RecordData.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/12.
//

import Foundation
import SwiftUI

class RecordData {
    var rawData: [Int]
    var timestamp: [Date]
    let fileName:String
    let height:Int
    
    init(fileName: String, height: Int) {
        rawData = [Int]()
        timestamp = [Date]()
        self.fileName = fileName
        self.height = height
    }

    func record(raw:Double?) {
        let currentDate = Date()
        print("\(raw)")
        rawData.append(Int(raw ?? 0))
        timestamp.append(currentDate)
        
    }
    func stop(){
        let tmpData = AltimeterData(id:UUID().uuidString, fileName: self.fileName, rawData: rawData, adjustData: height, aquiredTime: timestamp)
        print("recorded: \(rawData)")
        SaveToStorage.shared.saveData(data: [tmpData])
    }
}
