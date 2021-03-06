

import Foundation
import Combine

// Holds Reference to PSM
public final class Core<State, Event, Command> {

    public typealias CommandProcessor = (Core<State, Event, Command>, Command) -> Void

    public var stateChanged: AnyPublisher<State, Never> {
        _stateChanged.eraseToAnyPublisher()
    }
    public var currentState: State {
        return stateMachine.currentState
    }
    
    private let _stateChanged: CurrentValueSubject<State, Never>
    private let workQueue: DispatchQueue = DispatchQueue(label: "com.testing.Core", qos: .userInitiated, attributes: [], autoreleaseFrequency: .inherit, target: nil)
    private let stateMachine: PureStateMachine<State, Event, Command>
    private let commandProcessors: [CommandProcessor]

    public init(
        initialState: State,
        commandProcessors: [CommandProcessor] = [],
        eventHandler: @escaping PureStateMachine<State, Event, Command>.EventHandler
    ) {
        self.stateMachine = PureStateMachine<State, Event, Command>(
            initialState: initialState,
            eventHandler: eventHandler
        )
        self.commandProcessors = commandProcessors
        self._stateChanged = CurrentValueSubject(initialState)
    }

    
    public func fire(event: Event) {
        workQueue.async {
            // Calls the passed in EventHandler
            let update = self.stateMachine.handleEvent(event)

            if let state = update.state {
                self._stateChanged.send(state)
            }

            for command in update.commands {
                for processor in self.commandProcessors {
                    processor(self, command)
                }
            }
        }
    }

    public func perform(command: Command) {
        DispatchQueue.global(qos: .default).async {
            self.commandProcessors.forEach { $0(self, command) }
        }
    }
}
