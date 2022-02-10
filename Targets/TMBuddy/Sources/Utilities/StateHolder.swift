import Combine

class StateHolder<State>: ObservableObject {
    @Published var state: State?
}
