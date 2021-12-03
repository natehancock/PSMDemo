//
//  Environment.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/1/21.
//

import Foundation
import UIKit
import CoreBluetooth

final class Environment {
    let app: App
    
    init(window: UIWindow) {
        
        // Set up all Command Processors
        let navigationProcessor = NavigationCommandProcessor<App.State, App.Event, App.Command>(window)
        let bluetoothProcessor = BluetoothCommandProcessor(BluetoothScanner())
        
        // pass into App
        app = App([navigationProcessor.commandProcessor, bluetoothProcessor.commandProcessor])
        bluetoothProcessor.scanner.scanner.stateChanged.sink { [unowned self] bluetoothState in
//            app.core.fire(event: .didDiscoverPeripheral(<#T##DiscoveredPeripheral#>))
        }
    }
    
    public func start() {
        app.start()
    }
}
