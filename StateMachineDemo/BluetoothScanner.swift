//
//  BluetoothScanner.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/1/21.
//

import Foundation
import CoreBluetooth
import Combine

class BluetoothScanner: NSObject {
    typealias Scanner = Core<State, Event, Command>
    typealias CommandProcessor = Scanner.CommandProcessor
    
    public var stateMachine: Scanner {
        return _stateMachine
    }
    
    private var _stateMachine: Scanner
    
    private let centralManager: CBCentralManager = CBCentralManager()
    
    public override init() {
        let processor = BluetoothScannerCommandProcessor(centralManager)
        
        _stateMachine = Scanner(initialState: .init(), commandProcessors: [processor.commandProcessor], eventHandler: BluetoothScanner.handleEvent)
        
        super.init()
        
    }
    
    deinit {
        print("deinit - BluetoothScanner")
    }
    
    // Takes in event and updates the state. Returns update This is where the business logic occurs
    private static func handleEvent(state: BluetoothScanner.State, event: BluetoothScanner.Event) -> StateUpdate<BluetoothScanner.State, BluetoothScanner.Command> {
        
        
        switch event {

        case .bluetoothConnected:
            var newState = state
            newState.isBluetoothEnabled = true
            return .StateAndCommands(newState, [.start])
            
        case .bluetoothDisconnected:
            var newState = state
            newState.isBluetoothEnabled = false
            return .State(newState)
            
        case .didConnectDevice(let device):
            var newState = state
            newState.discoveredPeripherals = [device]
            return .State(newState)
            
        case .discoveredPeripheral(let discoveredPeripheral):
            var peripherals = state.discoveredPeripherals
            var newState = state
            
            // Check for new peripheral
            if !peripherals.contains(where: { $0.name == discoveredPeripheral.name }) {
                // new peripheral discovered - update state
                peripherals.append(discoveredPeripheral)
                newState.discoveredPeripherals = peripherals
                // return new state
                return .StateAndCommands(newState, [.stop])
            }
            // not a new peripheral - dont update state
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
        case discoveredPeripheral(DiscoveredPeripheral)
    }
    
    enum Command {
        case connect(DiscoveredPeripheral)
        case start
        case stop
    }
}

extension BluetoothScanner: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            _stateMachine.fire(event: .bluetoothConnected)
        } else {
            _stateMachine.fire(event: .bluetoothDisconnected)
        }
    }
}


extension BluetoothScanner {
}
