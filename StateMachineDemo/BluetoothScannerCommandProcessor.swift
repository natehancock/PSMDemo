//
//  BluetoothScannerCommandProcessor.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/2/21.
//

import Foundation
import CoreBluetooth

final class BluetoothScannerCommandProcessor {
    
    typealias State = BluetoothScanner.State
    typealias Event = BluetoothScanner.Event
    typealias Command = BluetoothScanner.Command
    
    private let _manager: CBCentralManager
    
    init(_ centralManager: CBCentralManager) {
        self._manager = centralManager
    }
    // Takes in core and a command.
    func commandProcessor(core: Core<State, Event, Command>, cmd: Command) {
        
        switch cmd {
        case .connect(let device):
            break
//            core.fire(event: )
        case .searchForDevices:
            _manager.scanForPeripherals(withServices: nil)
        }
    }
}
