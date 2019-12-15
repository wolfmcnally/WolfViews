//
//  ActivityOverlayView.swift
//  WolfViews
//
//  Created by Wolf McNally on 4/12/17.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#if canImport(UIKit)
import UIKit
import WolfAutolayout
import WolfWith
import WolfNesting
import WolfConcurrency
import WolfFoundation

public class ActivityOverlayView: View {
    public private(set) var hysteresis: Hysteresis!

    @objc dynamic public var color = UIColor.black.withAlphaComponent(0.5)

    public init(startLag: TimeInterval = 0.5, endLag: TimeInterval = 0.4) {
        super.init(frame: .zero)
        hysteresis = Hysteresis(
            onStart: {
                self.show(animated: true)
        },
            onEnd: {
                self.hide(animated: true)
        },
            startLag: startLag,
            endLag: endLag
        )
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func newActivity() -> LockerCause {
        return hysteresis.newCause()
    }

    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge) • { 🍒 in
        ‡🍒
        🍒.hidesWhenStopped = false
    }

    public override var isHidden: Bool {
        didSet {
            if isHidden {
                activityIndicatorView.stopAnimating()
            } else {
                activityIndicatorView.startAnimating()
            }
        }
    }

    private lazy var frameView = View() • { 🍒 in
        🍒.constrainSize(to: CGSize(width: 80, height: 80))
        🍒.layer.masksToBounds = true
        🍒.layer.cornerRadius = 10
    }

    override public func setup() {
        super.setup()

        self => [
            frameView => [
                activityIndicatorView
            ]
        ]

        activityIndicatorView.constrainCenterToCenter()
        frameView.constrainCenterToCenter()
        hide()
    }

    public func show(animated: Bool) {
        superview?.bringSubviewToFront(self)
        backgroundColor = color
        super.show(animated: animated)
    }
}
#endif
