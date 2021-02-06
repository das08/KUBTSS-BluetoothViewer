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
    
    var centralMg: CBCentralManager!
    var kubtssMainPeriferal: CBPeripheral!
    
    override init() {
        super.init()
        centralMg = CBCentralManager(delegate: self, queue: nil)
        kubtssMainPeriferal = nil
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
            centralMg.scanForPeripherals(withServices: [pUUID.service])
      }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
      print(peripheral)
      kubtssMainPeriferal = peripheral
      kubtssMainPeriferal.delegate = self
        centralMg.stopScan()
        centralMg.connect(kubtssMainPeriferal)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
      print("Connected!")
      kubtssMainPeriferal.discoverServices(nil)
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
        if characteristic.properties.contains(.read) {
          print("\(characteristic.uuid): properties contains .read")
        }
        if characteristic.properties.contains(.notify) {
          print("\(characteristic.uuid): properties contains .notify")
          peripheral.setNotifyValue(true, for: characteristic)
        }
        peripheral.readValue(for: characteristic)
      }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
      switch characteristic.uuid {
      case pUUID.char_altimeter:
  //        print(characteristic.value ?? "no value")
        print(decodeBytes(from: characteristic) )
        default:
          print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
    }
    
    private func decodeBytes(from characteristic: CBCharacteristic) -> String {
      guard let characteristicData = characteristic.value,
        let byte = characteristicData.first else { return "Error" }

      return "\(byte)"
    }
}
