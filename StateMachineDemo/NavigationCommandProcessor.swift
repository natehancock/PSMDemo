//
//  NavigationCommandProcessor.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/1/21.
//

import Foundation
import UIKit
final class NavigationCommandProcessor<State, Event, Command> {
    private let window: UIWindow
    
    private var navigationController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    func commandProcessor(core: Core<App.State, App.Event, App.Command>, cmd: App.Command) {
        // ensure that command is of type NavigationCommand
        guard case let App.Command.navigation(command) = cmd else { return }
        
        DispatchQueue.main.async {
            switch command {
            case .replaceWindow(let rootViewController):
                self.window.rootViewController = rootViewController
                
            case .push(let viewController):
                self.navigationController?.pushViewController(viewController, animated: true)
                
            case .present(let viewController):
                self.navigationController?.present(viewController, animated: true, completion: nil)
            }
        }
    }
}
