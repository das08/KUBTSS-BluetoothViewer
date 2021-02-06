//
//  UUIDConfig.swift
//  KUBTSS-BTViewer
//
//  Created by das08 on 2021/02/06.
//

import CoreBluetooth

struct UUIDs {
    let service = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    let char_altimeter = CBUUID(string: "4FAA0EBD-36E1-4688-B7F5-EA07361B26A8")
    let char_gps = CBUUID(string: "BEB5483F-36E1-4688-B7F5-EA07361B26A8")
}
