//
//  AppStorage.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/12.
//

import Foundation
import SwiftUI

class SaveToStorage {
    static let shared=SaveToStorage()
    @AppStorage("altimeter", store:UserDefaults())
    private var altimeterData: Data=Data()
    
    func saveData(data: [AltimeterData]) -> Void {
        let loadedData: [AltimeterData]
        loadedData = LoadFromStorage.shared.loadData()
        
        guard let save = try? JSONEncoder().encode(loadedData+data) else { return }
        
        self.altimeterData = save
        print("saved altimeterData")
    }
    func deleteAll() -> Void {
        let data=[AltimeterData]()
        
        guard let save = try? JSONEncoder().encode(data) else { return }
        
        self.altimeterData = save
        print("deleted all altimeterData")
    }

}

class LoadFromStorage {
    static let shared=LoadFromStorage()
    @AppStorage("altimeter", store:UserDefaults())
    private var altimeterData: Data=Data()
    
    func loadData() -> [AltimeterData] {
        var loadedData: [AltimeterData]
        guard let load = try? JSONDecoder().decode([AltimeterData].self, from: altimeterData) else {
            return [AltimeterData]()
        }
        loadedData = load
        return loadedData
    }
}
