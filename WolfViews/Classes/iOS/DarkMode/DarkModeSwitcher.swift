import WolfCore
import WolfColor
import WolfAnimation
import WolfNIO
import WolfAutolayout

public class DarkModeSwitcher: View, DarkModeObserving {
    public var darkModeObserver: DarkModeObserver? = nil

    private lazy var button = Button()

    private lazy var animatingImageView = ImageView() • { (🍒: ImageView) in
        🍒.translatesAutoresizingMaskIntoConstraints = true
    }

    private lazy var clipView = View() • { (🍒: View) in
        🍒.clipsToBounds = true
        //🍒.backgroundColor = debugColor()
    }

    private var clipViewConstraints: Constraints?

    public var barHeight: CGFloat = 50 {
        didSet { updateClipViewConstraints() }
    }

    private let onImage: UIImage
    private let offImage: UIImage
    private let onTint: UIColor
    private let offTint: UIColor

    public init(onImage: UIImage, offImage: UIImage, onTint: UIColor, offTint: UIColor) {
        self.onImage = onImage
        self.offImage = offImage
        self.onTint = onTint
        self.offTint = offTint
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateClipViewConstraints() {
        clipViewConstraints ◊= clipView.constrainSize(to: CGSize(width: 44, height: barHeight))
    }

    override public func setup() {
        super.setup()

        syncToDarkMode()

        self => [
            clipView => [
                animatingImageView
            ],
            button
        ]

        constrainSize(to: CGSize(width: 44, height: 44), priority: .defaultHigh)

        updateClipViewConstraints()
        clipView.constrainCenterToCenter()

        button.constrainFrameToFrame()

        animatingImageView.hide()

        button.action = { [unowned self] in
            self.toggle()
        }

        startObservingDarkMode()
    }

    public func darkModeDidChange(_: Frac) {
        syncToDarkMode()
    }

    private func imageForDarkMode(_ isDark: Bool) -> UIImage {
        return isDark ? onImage : offImage
    }

    private var imageForDarkMode: UIImage {
        return imageForDarkMode(DarkMode.shared.isDark)
    }

    private func syncToDarkMode() {
        button.setImage(imageForDarkMode, for: [])
        tintColor = DarkMode.shared.isDark ? onTint : offTint
    }

    private func toggle() {
        let endDarkMode = !DarkMode.shared.isDark
        DarkMode.shared.setDarkMode(endDarkMode, animated: true)
        performAnimation(endDarkMode: endDarkMode)
    }

    private func performAnimation(endDarkMode: Bool) {
        let buttonImageView = button.imageView!
        let startFrame = clipView.convert(buttonImageView.frame, from: button)
        var endFrame = startFrame
        endFrame.origin.y = bounds.maxY + 10
        let phaseDuration = DarkMode.shared.transitionDuration / 2
        animatingImageView.frame = startFrame
        animatingImageView.image = buttonImageView.image
        animatingImageView.show()
        button.hide()
        _ = animation(duration: phaseDuration, options: .curveEaseOut) {
            self.animatingImageView.frame = endFrame
            }.flatMap { (_) -> Future<Bool> in
                self.animatingImageView.image = self.imageForDarkMode(endDarkMode)
                return animation(duration: phaseDuration, options: .curveEaseOut) {
                    self.animatingImageView.frame = startFrame
                }
            }.map { _ in
                self.button.show()
                self.animatingImageView.hide()
        }
    }
}

public class DarkModeSwitcherItem: UIBarButtonItem {
    let switcher: DarkModeSwitcher
    public init(onImage: UIImage, offImage: UIImage, onTint: UIColor, offTint: UIColor) {
        switcher = DarkModeSwitcher(onImage: onImage, offImage: offImage, onTint: onTint, offTint: offTint)
        super.init()
        customView = switcher
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var barHeight: CGFloat {
        get { return switcher.barHeight }
        set { switcher.barHeight = newValue }
    }
}
