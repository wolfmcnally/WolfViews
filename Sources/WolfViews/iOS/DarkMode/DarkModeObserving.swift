#if canImport(UIKit)
import UIKit
import WolfCore

public protocol DarkModeObserving: class {
    var darkModeObserver: DarkModeObserver? { get set }
    func darkModeDidChange(frac: Frac, didSwitch: Bool)
    func startObservingDarkMode()
    func stopObservingDarkMode()
    func observeDarkModeIf(_ condition: Bool)
}

extension DarkModeObserving {
    public func startObservingDarkMode() {
        darkModeObserver = DarkMode.shared.didChange.add { [weak self] in
            self?.darkModeDidChange(frac: $0.frac, didSwitch: $0.didSwitch)
        }
        //(observerFunc: darkModeDidChange)
        darkModeDidChange(frac: DarkMode.shared.frac, didSwitch: true)
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
#endif
