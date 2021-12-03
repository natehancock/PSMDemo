//
//  BluetoothCommandProcessor.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/1/21.
//

import Foundation
import Combine

final class BluetoothCommandProcessor {
    
    let scanner: BluetoothScanner
    private var subscriptions = Set<AnyCancellable>()
    
    private var peripherals: [DiscoveredPeripheral] = []
    
    init(_ scanner: BluetoothScanner) {
        self.scanner = scanner
    }
    
    // Takes in core and a command.
    func commandProcessor(core: Core<App.State, App.Event, App.Command>, cmd: App.Command) {

        // ensure command is of type `BluetoothCommand`
        guard case let App.Command.bluetoothCommand(command) = cmd else { return }
        
        switch command {
        case .searchForPeripherals:
            scanner.stateMachine.perform(command: .start)
        }
    }
}
