//
//  PeripheralViewController.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/3/21.
//

import Foundation
import UIKit
import Combine

enum Section {
    case main
}

typealias DataSource = UITableViewDiffableDataSource<Section, DiscoveredPeripheral>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiscoveredPeripheral>

class PeripheralViewController: UITableViewController {
    
    let _core: App.AppCore
    
    var subscriptions = Set<AnyCancellable>()
    
    var peripherals: [DiscoveredPeripheral] = []
    
    private lazy var dataSource: DataSource = createDataSource()
    
    init(_ core: App.AppCore) {
        self._core = core
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DiscoveredPeripheralCell")
        
        // Subscribe to changes on the State
        self._core.stateChanged
            .receive(on: DispatchQueue.main, options: .none)
            .sink { [unowned self] updatedState in
                print("PeripheralViewController - Received Updated State")
                self.handleUpdate(updatedState)
            }
            .store(in: &subscriptions)
        
        _core.perform(command: .bluetoothCommand(.searchForPeripherals))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createDataSource() -> DataSource {
        return DataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveredPeripheralCell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.name
            return cell
        })
    }
    
    private func handleUpdate(_ updatedState: App.State) {
        if peripherals != updatedState.peripherals {
            print("Handle Update")
            print(updatedState.peripherals.map { $0.name })
            peripherals = updatedState.peripherals

            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(peripherals)
            dataSource.apply(snapshot)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let discoveredPeripheral = dataSource.itemIdentifier(for: indexPath) else { return }
        
        print(discoveredPeripheral)
        
    }
}
