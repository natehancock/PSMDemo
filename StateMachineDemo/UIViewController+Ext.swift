//
//  UIViewController+Ext.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/3/21.
//

import Foundation
import UIKit

extension UIViewController {
    static func peripheralViewController(_ core: App.AppCore) -> UIViewController {
        let vc = PeripheralViewController(core)
        return vc
    }
}
