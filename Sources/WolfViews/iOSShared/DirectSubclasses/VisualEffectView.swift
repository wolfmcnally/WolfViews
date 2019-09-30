#if canImport(UIKit)
import UIKit

open class VisualEffectView: UIVisualEffectView {
    public override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        __setup()
        setup()
    }

    open func setup() { }
}
#endif
