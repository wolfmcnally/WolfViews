//
//  InputAccessoryView.swift
//  WolfViews
//
//  Created by Wolf McNally on 4/7/16.
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

import WolfCore
import WolfAutolayout
import UIKit

/// This class provides a view suitable for assigning to `inputAccessoryView` in
/// UITextView or UITextField. To use it, provide the view that you want to use as its content
/// view, and it will ensure that the content view will remain visible above the layout
/// margins guide.
///
/// A raw view used as an input accessory view can conflict with the
/// home indicator on the iPhone X when the keyboard is present but hidden, as when a Bluetooth
/// keyboard is connected or when "Toggle Software Keyboard" is turned on in the iOS simulator.
/// This view solves that problem.
public class InputAccessoryView: View {
    private let contentView: UIView

    public init(contentView: UIView) {
        self.contentView = ‡contentView
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setup() {
        super.setup()

        translatesAutoresizingMaskIntoConstraints = true
        autoresizingMask = .flexibleHeight
        //backgroundColor = debugColor()

        self => [
            contentView
        ]

        Constraints(
            contentView.leadingAnchor == leadingAnchor,
            contentView.trailingAnchor == trailingAnchor,
            contentView.topAnchor == topAnchor,
            contentView.bottomAnchor <= layoutMarginsGuide.bottomAnchor
        )
    }

    public override var intrinsicContentSize: CGSize {
        return .zero
    }
}
