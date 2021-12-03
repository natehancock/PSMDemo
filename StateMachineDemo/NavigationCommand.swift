//
//  NavigationCommand.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/1/21.
//

import Foundation
import UIKit

enum NavigationCommand<Event, Command> {
    case replaceWindow(UINavigationController)
    case push(UIViewController)
    case present(UIViewController)
}
