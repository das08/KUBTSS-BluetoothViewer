//
//  BluetoothManager.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/06.
//

import Foundation
import CoreBluetooth

let config = UUIDConfig()

final class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @Published var status:String = "NOT CONNECTED"
    @Published var state:Bluestate = .POWERED_OFF
    @Published var deviceName:String = "----"
    @Published var altimeter:String = "----"
    @Published var gps:String = "----"
    @Published var buttonText:String = "検索できません"
    @Published var stateText:String = "Bluetoothが使用できません"
    @Published var resultText:String = ""
    @Published var CONNECTED:Bool = false
    @Published var AltimeterData:[Double] = []
    @Published var GPSData:[Int] = []
    
    var centralMg: CBCentralManager?
    var kubtssMainPeripheral: CBPeripheral?
    var SERVICE_UUID:CBUUID!
    var Altimeter_UUID:CBUUID!
    var GPS_UUID:CBUUID!
    var Altimeter_CHAR:CBCharacteristic?
    var GPS_CHAR:CBCharacteristic?
    var SCAN_TIMER:Timer?
    var CONNECT_TIMER:Timer?
    
    override init() {
        super.init()
        centralMg = CBCentralManager(delegate: self, queue: nil)
        kubtssMainPeripheral = nil
        SERVICE_UUID = config.service
        Altimeter_UUID = config.char_altimeter
        GPS_UUID = config.char_gps
        Altimeter_CHAR=nil
        GPS_CHAR=nil
        SCAN_TIMER = nil
        CONNECT_TIMER = nil
    }
    
    func updateStatus() {
        switch self.state {
        case .POWERED_OFF:
            self.buttonText = "検索できません"
            self.stateText = "Bluetoothが使用できません"
        break
        case .POWERED_ON:
            self.buttonText = "検索する"
            self.stateText = "機器を検索してください"
        break
        case .SCANNING:
            self.buttonText = "検索キャンセル"
            self.stateText = "デバイスを検索しています..."
        break
        case .SCAN_TIMEOUT:
            self.buttonText = "検索する"
            self.stateText = "デバイスが見つかりませんでした"
        break
        case .DISCOVER_PERIPHERAL:
            self.buttonText = "接続する"
        break
        case .CONNECTING:
            self.buttonText = "接続キャンセル"
            self.stateText += "\n" + "接続中..."
        break
        case .CONNECT_TIMEOUT:
            self.buttonText = "検索する"
            self.stateText += "タイムアウトしました"
        break
        case .CONNECT_ERROR, .CONNECT_CLOSE:
            self.buttonText = "検索する"
        break
        case .CONNECT_OK:
            self.buttonText = "切断する"
        break
        }
    }
    
    //ボタンアクション
    func buttonPushed(){
        switch self.state {
        case .POWERED_OFF:
        break
        case .POWERED_ON, .SCAN_TIMEOUT, .CONNECT_TIMEOUT, .CONNECT_ERROR, .CONNECT_CLOSE:
            startScan()
        break
        case .SCANNING:
            stopScan()
            self.state = .POWERED_ON
            updateStatus()
        break
        case .DISCOVER_PERIPHERAL:
            connectPeripheral()
        break
        case .CONNECTING:
            disconnectPeripheral()
            self.state = .CONNECT_CLOSE
            self.stateText += "キャンセルしました"
            updateStatus()
        case .CONNECT_OK:
            disconnectPeripheral()
            self.state = .CONNECT_CLOSE
            self.stateText += "\n接続を切断しました"
            updateStatus()
        break
        }
    }
    
    func startScan(){
        stopScan()
        self.state = .SCANNING
        updateStatus()
        SCAN_TIMER = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(scanTimeout), userInfo: nil, repeats: false)
        centralMg?.scanForPeripherals( withServices:[SERVICE_UUID],options:nil )
        //CENTRAL?.scanForPeripherals( withServices:nil,options:nil )
    }
    
    func stopScan(){
        disconnectPeripheral()
        SCAN_TIMER?.invalidate()
        SCAN_TIMER = nil
        centralMg?.stopScan()
    }
    @objc func scanTimeout() {
        stopScan()
        self.state = .SCAN_TIMEOUT
        updateStatus()
    }
    
    
    func centralManagerDidUpdateState( _ central:CBCentralManager ) {
        print("centralManagerDidUpdateState.state=\(central.state.rawValue)")
        //central.state is .poweredOff,.poweredOn,.resetting,.unauthorized,.unknown,.unsupported
        if central.state == .poweredOn {
            self.state = .POWERED_ON
        }
        else{
            self.state = .POWERED_OFF
            stopScan()
        }
        updateStatus()
    }
    
    func centralManager( _ central:CBCentralManager,didDiscover peripheral:CBPeripheral,
                         advertisementData:[String:Any],rssi RSSI:NSNumber ) {
        print("didDiscover")
        stopScan()
        kubtssMainPeripheral = peripheral
        self.stateText = "以下のBluetoothが見つかりました\n" + peripheral.name!
        
        self.state = .DISCOVER_PERIPHERAL
        updateStatus()
    }
    
    func connectPeripheral() {
        if CONNECT_TIMER != nil || CONNECTED || kubtssMainPeripheral == nil {
            return
        }
        self.state = .CONNECTING
        updateStatus()
        CONNECT_TIMER = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(connectTimeout), userInfo: nil, repeats: false)
        centralMg?.connect( kubtssMainPeripheral!,options:nil )
    }

    func disconnectPeripheral() {
        CONNECT_TIMER?.invalidate()
        CONNECT_TIMER = nil
        if kubtssMainPeripheral != nil {
            centralMg?.cancelPeripheralConnection( kubtssMainPeripheral! )
            kubtssMainPeripheral = nil
        }
        GPS_CHAR = nil
        Altimeter_CHAR=nil
        CONNECTED = false
    }
    
    @objc func connectTimeout() {
        disconnectPeripheral()
        self.state = .CONNECT_TIMEOUT
        updateStatus()
    }
    
    
    // connect peripheral OK
    func centralManager( _ central:CBCentralManager,didConnect peripheral:CBPeripheral ) {
        print("didConnect")
        CONNECT_TIMER?.invalidate()
        CONNECT_TIMER = nil
        peripheral.delegate = self
        peripheral.discoverServices( [SERVICE_UUID] )
    }
    
    // connect peripheral NG
    func centralManager( _ central:CBCentralManager,didFailToConnect peripheral:CBPeripheral,error:Error? ) {
        print("didFailToConnect")
        self.stateText += "エラー発生"
        if let e = error{
            self.stateText += "\n" + e.localizedDescription
        }
        self.state = .CONNECT_ERROR
        disconnectPeripheral()
        updateStatus()
    }
    
    
    // discover services
    func peripheral( _ peripheral:CBPeripheral,didDiscoverServices error:Error? ) {
        print("didDiscoverServices")
        if error != nil {
            self.stateText += "エラー発生"
            self.stateText += "\n" + error.debugDescription
            self.state = .CONNECT_ERROR
            disconnectPeripheral()
            updateStatus()
            return
        }
        if peripheral.services == nil || peripheral.services?.first == nil {
            self.stateText += "エラー発生"
            self.stateText += "\n" + "ble error empty peripheral.services"
            self.state = .CONNECT_ERROR
            disconnectPeripheral()
            updateStatus()
            return
        }
        guard let services = peripheral.services else {return}
        
        for sevice in services {
            peripheral.discoverCharacteristics(nil, for:sevice)
        }
    }
    
    // discover characteristics
    func peripheral( _ peripheral:CBPeripheral,didDiscoverCharacteristicsFor service:CBService,error:Error? ) {
        print("didDiscoverCharacteristicsFor")
        if error != nil {
            self.stateText += "エラー発生"
            self.stateText += "\n" + error.debugDescription
            self.state = .CONNECT_ERROR
            disconnectPeripheral()
            updateStatus()
            return
        }
        if service.characteristics == nil || service.characteristics?.first == nil {
            self.stateText += "エラー発生"
            self.stateText += "\n" + "ble error empty service.characteristics"
            self.state = .CONNECT_ERROR
            disconnectPeripheral()
            updateStatus()
            return
        }
        guard let characteristics = service.characteristics else { return }
        for char in characteristics {
            print("char: \(char)")
            if char.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: char)
            }
        }
        self.stateText += "接続しました"
        self.deviceName = peripheral.name!
        self.state = .CONNECT_OK
        self.resultText = ""
        CONNECTED = true
        updateStatus()
    }
    
    // disconnect peripheral RESULT
    func centralManager( _ central:CBCentralManager,didDisconnectPeripheral peripheral:CBPeripheral,error:Error? ) {
        print("didDisconnectPeripheral")
        if error != nil {
            self.stateText += "\n" + error.debugDescription
        }
        var gonotify:Bool = false
        if( kubtssMainPeripheral != nil ){
            gonotify = true
        }
        disconnectPeripheral()
        if gonotify {
            self.state = .CONNECT_CLOSE
            self.stateText += "\n" + "接続が切断されました"
            updateStatus()
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        switch characteristic.uuid {
        case Altimeter_UUID:
            print("Altimeter: \(decodeBytes(from: characteristic))" )
            if AltimeterData.count == 10{
                AltimeterData.removeFirst()
            }
            let tmp = Double(decodeBytes(from: characteristic))!
            AltimeterData.append(tmp)
            altimeter = decodeBytes(from: characteristic)
            altimeter = isValidBytes(from: characteristic) ? "Available": "----"
        case GPS_UUID:
            print("GPS: \(decodeBytes(from: characteristic))" )
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
        
        var array : [UInt8] = []
        for i in characteristicData {
            array.append(UInt8(i))
        }
//        print(array)
        
        var value : UInt16 = 0
        let data = NSData(bytes: array, length: 2)
        data.getBytes(&value, length: 2)
        value = UInt16(bigEndian: value)
//        print(value)
        return "\(value)"
    }
}


enum Bluestate : Int {
    case
    POWERED_ON,
    POWERED_OFF,
    SCANNING,
    SCAN_TIMEOUT,
    DISCOVER_PERIPHERAL,
    CONNECTING,
    CONNECT_TIMEOUT,
    CONNECT_ERROR,
    CONNECT_CLOSE,
    CONNECT_OK
}
