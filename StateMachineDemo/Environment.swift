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
        
        // pass into App
        app = App([navigationProcessor.commandProcessor])
    }
    
    public func start() {
        app.start()
    }
}
