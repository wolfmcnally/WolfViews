//
//  KeyboardAvoidantView.swift
//  WolfViews
//
//  Created by Wolf McNally on 7/19/15.
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

#if os(iOS)
import UIKit
import WolfAutolayout

public class KeyboardTrackerView: View {
    let margin: CGFloat = 20
    var keyboardActions: KeyboardNotificationActions!
    var leftConstraint: NSLayoutConstraint!
    var defaultTopConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!

    public override func setup() {
        super.setup()

        isUserInteractionEnabled = false
        keyboardActions = KeyboardNotificationActions()
        keyboardActions.willChangeFrame = { [unowned self] info in
            self.keyboardWillMove(info)
        }
        keyboardActions.didHide = { [unowned self] info in
            self.keyboardDidHide(info)
        }
    }

    public override func didMoveToSuperview() {
        if let superview = superview {
            leftConstraint = leftAnchor == superview.leftAnchor
            defaultTopConstraint = topAnchor == superview.bottomAnchor =&= .defaultHigh
            topConstraint = topAnchor == superview.topAnchor + superview.frame.maxY
            widthConstraint = widthAnchor == superview.frame.width
            heightConstraint = heightAnchor == 100
            Constraints(
                leftConstraint,
                widthConstraint,
                defaultTopConstraint,
                heightConstraint
            )
        } else {
            leftConstraint = nil
            topConstraint = nil
            widthConstraint = nil
            heightConstraint = nil
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if constraintFrame == nil {
            topConstraint.constant = superview!.frame.maxY
        }
    }

    func keyboardWillMove(_ info: KeyboardMovement) {
        topConstraint.isActive = true
        let frameEnd = info.frameEnd(in: superview!)
        self.constraintFrame = frameEnd
    }

    func keyboardDidHide(_ info: KeyboardMovement) {
        topConstraint.isActive = false
    }

    public var constraintFrame: CGRect? {
        didSet {
            if let constraintFrame = constraintFrame {
                leftConstraint.constant = constraintFrame.minX
                topConstraint.constant = constraintFrame.minY
                widthConstraint.constant = constraintFrame.width
                heightConstraint.constant = constraintFrame.height
            }
        }
    }
}

public class KeyboardAvoidantView: View {
    var keyboardTrackerView: KeyboardTrackerView!

    public override func setup() {
        super.setup()
        keyboardTrackerView = KeyboardTrackerView()
    }

    public override func didMoveToSuperview() {
        if let superview = superview {
            superview.insertSubview(keyboardTrackerView, aboveSubview: self)

            Constraints(
                bottomAnchor == keyboardTrackerView.topAnchor =&= .required
            )
        } else {
            keyboardTrackerView.removeFromSuperview()
        }
    }
}
#endif
