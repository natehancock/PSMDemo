//
//  App.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/1/21.
//

import Foundation
import UIKit

final class App {
    typealias AppCore = Core<State, Event, Command>
    typealias CommandProcessor = AppCore.CommandProcessor
    
    let core: AppCore
    
    
    init(_ processors: [CommandProcessor]) {
        core = AppCore(initialState: .init([:]), commandProcessors: processors, eventHandler: App.handleEvent)
    }
    
    func start() {
        let startVC = ViewController(core)
        core.perform(command: .navigation(.replaceWindow(startVC)))
        core.fire(event: .login(["UserName": "Mo"]))
    }
    
    // Takes in event and updates the state. Returns update This is where the business logic occurs
    private static func handleEvent(state: App.State, event: App.Event) -> StateUpdate<App.State, App.Command> {
        
        
        switch (state, event) {
        case (_, .login(let userDict)):
            print(userDict)
            var currentState = state
            currentState.user = userDict
            return .StateAndCommands(currentState, [.bluetoothCommand(.searchForPeripherals)])
            
        case (_, .didDiscoverPeripheral(let peripheral)):
            
            var currentState = state
            var peripherals = currentState.peripherals
            
            if !peripherals.contains(where: { $0.name == peripheral.name }) {
                peripherals.append(peripheral)
                currentState.peripherals = peripherals
                return .State(currentState)
            }
            return .NoUpdate

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
        case didDiscoverPeripheral(DiscoveredPeripheral)
    }
    
    enum Command {
        case navigation(NavigationCommand<Event, Command>)
        case bluetoothCommand(BluetoothCommand)
    }
}
