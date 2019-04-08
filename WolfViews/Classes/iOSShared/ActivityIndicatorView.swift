//
//  ActivityIndicatorView.swift
//  WolfViews
//
//  Created by Wolf McNally on 5/15/17.
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

import UIKit
import WolfCore
import WolfAutolayout

public class ActivityIndicatorView: View {
    private let style: UIActivityIndicatorView.Style
    private var hysteresis: Hysteresis!

    public init(activityIndicatorStyle style: UIActivityIndicatorView.Style = .white) {
        self.style = style

        super.init(frame: .zero)

        hysteresis = Hysteresis(
            onStart: {
                self.activityIndicatorView.show(animated: true)
        },
            onEnd: {
                self.activityIndicatorView.hide(animated: true)
        },
            startLag: 0.25,
            endLag: 0.2
        )
    }

    private func revealIndicator(animated: Bool) {
        activityIndicatorView.show(animated: animated)
    }

    private func concealIndicator(animated: Bool) {
        activityIndicatorView.hide(animated: animated)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func newActivity() -> LockerCause {
        return hysteresis.newCause()
    }

    private lazy var activityIndicatorView = UIActivityIndicatorView(style: self.style) • { 🍒 in
        ‡🍒
        🍒.hidesWhenStopped = false
        🍒.startAnimating()
    }

    override public func setup() {
        super.setup()

        setPriority(crH: .defaultLow, crV: .defaultLow)

        self => [
            activityIndicatorView
        ]

        activityIndicatorView.constrainCenterToCenter()
        Constraints(
            widthAnchor == activityIndicatorView.widthAnchor =&= .defaultLow,
            heightAnchor == activityIndicatorView.heightAnchor =&= .defaultLow,
            widthAnchor == heightAnchor
        )

        concealIndicator(animated: false)
    }
}
