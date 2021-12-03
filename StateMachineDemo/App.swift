//
//  App.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/1/21.
//

import Foundation
import UIKit
import Combine

final class App {
    typealias AppCore = Core<State, Event, Command>
    typealias CommandProcessor = AppCore.CommandProcessor
    
    let core: AppCore
    
    let bluetoothScanner = BluetoothScanner()
    var subscriptions = Set<AnyCancellable>()
    
    init(_ processors: [CommandProcessor]) {

        let bluetoothProcessor = BluetoothCommandProcessor(self.bluetoothScanner)
        
        core = AppCore(initialState: .init([:]), commandProcessors: [bluetoothProcessor.commandProcessor] + processors, eventHandler: App.handleEvent)
        
        self.bluetoothScanner.stateMachine.stateChanged
            .receive(on: DispatchQueue.main, options: .none)
            .sink { updatedState in
                self.handleBluetoothScannerUpdate(updatedState)
            }
            .store(in: &subscriptions)
    }
    
    func start() {
        let startNavVC = UINavigationController(rootViewController: ViewController(core))
        core.perform(command: .navigation(.replaceWindow(startNavVC)))
        core.fire(event: .login(["UserName": "Mo"]))
    }
    
    // Takes in event and updates the state. This is where we mutate the state. 
    private static func handleEvent(state: App.State, event: App.Event) -> StateUpdate<App.State, App.Command> {
        
        switch (state, event) {
        case (_, .login(let userDict)):
            print(userDict)
            var currentState = state
            currentState.user = userDict
            return .State(currentState)
            
        case (_, .didDiscoverPeripherals(let peripherals)):
            var currentState = state
            currentState.peripherals = peripherals
            return .State(currentState)
        }
    }
    
    struct State {
        var user: [String: Any]
        var peripherals: [DiscoveredPeripheral] = []

        init(_ user: [String: Any]) {
            self.user = user
        }
    }
    
    enum Event {
        case login([String: Any])
        case didDiscoverPeripherals([DiscoveredPeripheral])
    }
    
    enum Command {
        case navigation(NavigationCommand<Event, Command>)
        case bluetoothCommand(BluetoothCommand)
    }
}

extension App {
    func handleBluetoothScannerUpdate(_ update: BluetoothScanner.State) {
        core.fire(event: .didDiscoverPeripherals(update.discoveredPeripherals))
    }
}
