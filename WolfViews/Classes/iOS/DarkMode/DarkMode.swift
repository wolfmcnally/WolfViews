import WolfCore
import WolfAnimation
import WolfColor

public class DarkMode {
    private typealias `Self` = DarkMode

    public static let shared = DarkMode()

    let fracDidChange = Event<Frac>()
    private var transition: DarkModeTransition?

    // 0.0 is dark mode, 1.0 is light mode
    public var frac: Frac = 0 {
        didSet { fracDidChange.notify(frac) }
    }

    fileprivate init() { }

    public var transitionDuration: TimeInterval = 1.0

    public func setDarkMode(_ isDark: Bool, animated: Bool) {
        let end: Frac = isDark ? 0 : 1
        if animated {
            transition ◊= DarkModeTransition(start: frac, end: end, duration: transitionDuration)
        } else {
            transition ◊= nil
            frac = end
        }
    }

    public var isDark: Bool {
        return Self.isDark(frac)
    }

    public static func isDark(_ frac: Frac) -> Bool {
        return frac.ledge()
    }

    public static func color(for gradient: Gradient) -> UIColor {
        return gradient.at(DarkMode.shared.frac).osColor
    }
}

class DarkModeTransition: Invalidatable {
    let start: Frac
    let end: Frac
    let duration: TimeInterval
    var current: Frac
    private var effectiveDuration: TimeInterval
    private var displayLink: DisplayLink!

    init(start: Frac, end: Frac, duration: TimeInterval) {
        self.start = start.clamped()
        self.end = end.clamped()
        self.duration = duration

        current = start
        let distance = abs(end - start)
        effectiveDuration = duration * distance

        displayLink = DisplayLink(onFired: onFired)
    }

    private func onFired(displayLink: DisplayLink) {
        let elapsedTime = displayLink.elapsedTime
        let t = elapsedTime.lerpedToFrac(from: 0..effectiveDuration).clamped()
        if t == 1 {
            invalidate()
        }
        let frac = t.lerpedFromFrac(to: start..end)
        DarkMode.shared.frac = frac
    }

    func invalidate() {
        displayLink.invalidate()
    }

    deinit {
        invalidate()
    }
}
