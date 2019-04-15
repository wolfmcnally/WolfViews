import WolfCore

public protocol DarkModeObserving: class {
    var darkModeObserver: DarkModeObserver? { get set }
    func darkModeDidChange(_ frac: Frac)
    func startObservingDarkMode()
    func stopObservingDarkMode()
    func observeDarkModeIf(_ condition: Bool)
}

extension DarkModeObserving {
    public func startObservingDarkMode() {
        darkModeObserver = DarkMode.shared.fracDidChange.add(observerFunc: darkModeDidChange)
        darkModeDidChange(DarkMode.shared.frac)
    }

    public func stopObservingDarkMode() {
        darkModeObserver = nil
    }

    public func observeDarkModeIf(_ condition: Bool) {
        if condition {
            startObservingDarkMode()
        } else {
            stopObservingDarkMode()
        }
    }
}
