//
//  ViewController.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/1/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Add"
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    // Store any .sink in here
    var subscriptions = Set<AnyCancellable>()
    
    init(_ core: App.AppCore) {
        super.init(nibName: nil, bundle: nil)

        // Subscribe to changes on the State
        core.stateChanged
            .receive(on: DispatchQueue.main, options: .none)
            .sink { [unowned self] updatedState in
                self.handleUpdate(updatedState)
            }
            .store(in: &subscriptions)
        
        configureLayout()
        
        core.fire(event: .login([:]))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func handleUpdate(_ updatedState: App.State) {
        print("Handle Update")
        print(updatedState.peripherals.map { $0.name })
    }

    func configureLayout() {
        view.addSubview(mainView)
        mainView.pinToSuperView()
        
        mainView.addSubview(addButton)
        addButton.centerInSuperView()
    }
}

extension ViewController {
    @objc func didTapButton(_ sender: UIButton) {
        
    }
}
