//
//  MessageOverlayView.swift
//  
//
//  Created by Wolf McNally on 1/24/20.
//

import UIKit
import WolfPipe
import WolfNesting
import WolfAutolayout
import WolfNIO
import WolfAnimation
import WolfFoundation
import WolfConcurrency

@available(iOS 13.0, *)
open class MessageOverlayView: View {
    public var message: String? {
        get { messageLabel.text }
        set {
            messageLabel.text = newValue
            if highlightMessageChange {
                animateMessageHighlight()
            }
        }
    }

    public var highlightMessageChange = false

    lazy var glowView = ImageView()

    private func animateMessageHighlight() {
        if glowView.superview == nil {
            self => [
                glowView
            ]
            glowView.constrainCenterToCenter(of: messageLabel)
        }
        let scale: CGFloat = 2
        glowView.transform = CGAffineTransform(scaleX: scale, y: scale)
        glowView.alpha = 1
        animation(duration: 0.6) {
            let scale: CGFloat = 0.2
            self.glowView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.glowView.alpha = 0
        }
    }

    public var glowImage: UIImage? {
        get { glowView.image }
        set { glowView.image = newValue }
    }

    public var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    public var size = CGSize(width: 180, height: 180) {
        didSet { sync() }
    }

    public var font = UIFont.boldSystemFont(ofSize: 16) {
        didSet { sync() }
    }

    open override func setup() {
        super.setup()
        build()
    }

    open func makeBackgroundView() -> BackgroundView {
        BlurBackgroundView() |> { (🍒: BlurBackgroundView) in
            🍒.cornerRadius = 10
            🍒.blurEffectStyle = .systemThinMaterial
        }
    }

    open func makeImageView() -> ImageView {
        ImageView() |> { (🍒: ImageView) in
            🍒.tintColor = .label
            🍒.constrainSize(to: CGSize(width: 50, height: 50))
            🍒.contentMode = .scaleAspectFit
            🍒.image = nil
        }
    }

    open func makeMessageLabel() -> Label {
        Label() |> { (🍒: Label) in
            🍒.font = font
            🍒.textColor = .label
            🍒.numberOfLines = 0
            🍒.textAlignment = .center
            🍒.text = "Your Message Here"
        }
    }

    open func makeColumnView() -> UIStackView {
        VerticalStackView() |> { (🍒: VerticalStackView) in
            🍒.alignment = .center
            🍒.spacing = 8
        }
    }

    open func populateColumnView() {
        columnView => [
            imageView,
            messageLabel
        ]
    }

    lazy var backgroundView = makeBackgroundView()
    lazy var imageView = makeImageView()
    lazy var messageLabel = makeMessageLabel()
    lazy var columnView = makeColumnView()

    open func build() {
        populateColumnView()

        self => [
            backgroundView,
            columnView
        ]

        backgroundView.constrainFrameToFrame()
        columnView.constrainCenterToCenter()
        columnView.constrainWidthToWidth(offset: -20)
        sync()
    }

    private var sizeConstraint: Constraints!

    private func sync() {
        sizeConstraint ◊= constrainSize(to: size)
        messageLabel.font = font
    }

    @discardableResult public func show(in parentView: UIView, duration: TimeInterval) -> Future<Void> {
        let promise = MainEventLoop.shared.makePromise(of: Void.self)

        let savedParentViewInteractionEnabled = parentView.isUserInteractionEnabled
        parentView.isUserInteractionEnabled = false
        parentView => [
            self
        ]
        self.constrainCenterToCenter()
        self.hide()
        self.show(animated: true, duration: 0.2)
        dispatchOnMain(afterDelay: duration) {
            self.hide(animated: true, duration: 0.2)
            parentView.isUserInteractionEnabled = savedParentViewInteractionEnabled
            promise.succeed(())
        }

        return promise.futureResult
    }
}

@available(iOS 13.0, *)
public func setMessage<V: MessageOverlayView>(_ message: String) -> (_ alertView: V) -> V {
    { alertView in
        alertView.message = message
        return alertView
    }
}

@available(iOS 13.0, *)
public func setImage<V: MessageOverlayView>(_ image: UIImage?) -> (_ alertView: V) -> V {
    { alertView in
        alertView.image = image
        return alertView
    }
}

@available(iOS 13.0, *)
public func setGlowImage<V: MessageOverlayView>(_ image: UIImage?) -> (_ alertView: V) -> V {
    { alertView in
        alertView.glowImage = image
        return alertView
    }
}
