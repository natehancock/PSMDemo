//
//  BluetoothScanner.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/1/21.
//

import Foundation
import CoreBluetooth

class BluetoothScanner: NSObject {
    typealias Scanner = Core<State, Event, Command>
    typealias CommandProcessor = Scanner.CommandProcessor
    
    public var scanner: Scanner {
        return _scanner
    }
    private let centralManager: CBCentralManager = CBCentralManager()
    private var _scanner: Scanner
    
    var handler: ((DiscoveredPeripheral) -> ())?
    
    public override init() {
        let processor = BluetoothScannerCommandProcessor(centralManager)
        _scanner = Scanner(initialState: .init(), commandProcessors: [processor.commandProcessor], eventHandler: BluetoothScanner.handleEvent)
        
        super.init()
    }
    
    
//    func startScan() {
//        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
//            self.handler?(self.randomPeripheral())
//        }
//    }
    
    // Takes in event and updates the state. Returns update This is where the business logic occurs
    private static func handleEvent(state: BluetoothScanner.State, event: BluetoothScanner.Event) -> StateUpdate<BluetoothScanner.State, BluetoothScanner.Command> {
        
        
        switch event {

        case .bluetoothConnected:
            var newState = state
            newState.isBluetoothEnabled = true
            return .StateAndCommands(newState, [.searchForDevices])
            
        case .bluetoothDisconnected:
            var newState = state
            newState.isBluetoothEnabled = false
            return .State(newState)
            
        case .didConnectDevice(let device):
            var newState = state
            newState.discoveredPeripherals = [device]
            return .State(newState)
            
        default:
            return .NoUpdate
            
        }
    }
    
    struct State {
        var isBluetoothEnabled: Bool = false
        var discoveredPeripherals: [DiscoveredPeripheral] = []
    }
    
    enum Event {
        case bluetoothConnected
        case bluetoothDisconnected
        case didConnectDevice(DiscoveredPeripheral)
    }
    
    enum Command {
        case connect(DiscoveredPeripheral)
        case searchForDevices
    }
}

extension BluetoothScanner: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            _scanner.fire(event: .bluetoothConnected)
        } else {
            _scanner.fire(event: .bluetoothDisconnected)
        }
    }
}


extension BluetoothScanner {
    private func randomPeripheral() -> DiscoveredPeripheral {
        let peripheral = DiscoveredPeripheral(name: randomString(length: 5))
        return peripheral
    }

    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
