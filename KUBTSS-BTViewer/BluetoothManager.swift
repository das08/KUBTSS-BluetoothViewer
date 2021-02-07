//
//  BluetoothManager.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/06.
//

import Foundation
import CoreBluetooth

let pUUID = UUIDs()

final class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @Published var status:String = "NOT CONNECTED"
    @Published var deviceName:String = "----"
    @Published var altimeter:String = "----"
    @Published var gps:String = "----"
    @Published var CONNECTED:Bool = false
    
    var centralMg: CBCentralManager?
    var kubtssMainPeripheral: CBPeripheral?
    
    override init() {
        super.init()
        centralMg = CBCentralManager(delegate: self, queue: nil)
        kubtssMainPeripheral = nil
    }
    
    func connectPeripheral() {
        centralMg?.scanForPeripherals(withServices: [pUUID.service])
        if CONNECTED || kubtssMainPeripheral == nil { return }
        centralMg?.connect(kubtssMainPeripheral!, options: nil)
        status = "CONNECTED"
    }
    
    func disconnectPeripheral() {
        if kubtssMainPeripheral != nil {
            centralMg?.cancelPeripheralConnection(kubtssMainPeripheral!)
            kubtssMainPeripheral = nil
        }
        CONNECTED = false
        status = "NOT CONNECTED"
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralMg?.scanForPeripherals(withServices: [pUUID.service])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print(peripheral)
        kubtssMainPeripheral = peripheral
        peripheral.delegate = self
        centralMg?.stopScan()
        centralMg?.connect(kubtssMainPeripheral!, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        status = "CONNECTED"
        deviceName = peripheral.name!
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            //        if characteristic.properties.contains(.read) {
            //          print("\(characteristic.uuid): properties contains .read")
            //        }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            //        peripheral.readValue(for: characteristic)
        }
        CONNECTED = true
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        switch characteristic.uuid {
        case pUUID.char_altimeter:
            print(decodeBytes(from: characteristic) )
//            altimeter = decodeBytes(from: characteristic)
            altimeter = isValidBytes(from: characteristic) ? "Available": "----"
        case pUUID.char_gps:
            print(decodeBytes(from: characteristic) )
//            gps = decodeBytes(from: characteristic)
            gps = isValidBytes(from: characteristic) ? "Available": "----"
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    private func isValidBytes(from characteristic: CBCharacteristic) -> Bool {
        guard let characteristicData = characteristic.value,
              let _ = characteristicData.first else { return false }
        
        return true
    }
    
    private func decodeBytes(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value,
              let byte = characteristicData.first else { return "Error" }
        
        return "\(byte)"
    }
}
