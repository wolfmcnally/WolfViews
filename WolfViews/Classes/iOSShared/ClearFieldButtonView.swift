//
//  ClearFieldButtonView.swift
//  WolfViews
//
//  Created by Wolf McNally on 3/19/17.
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
import WolfNesting
import WolfAutolayout
import WolfConcurrency
import WolfAnimation
import WolfPipe

public class ClearFieldButtonView: View {
    public private(set) lazy var button = ClearFieldButton()

    public override func setup() {
        super.setup()
        self => [
            button
        ]
        let image = button.image(for: .normal)!
        let size = image.size
        Constraints(
            button.centerXAnchor == centerXAnchor,
            button.centerYAnchor == centerYAnchor,

            widthAnchor == size.width,
            heightAnchor == size.height
        )
    }

    public func conceal(animated: Bool) {
        if isShown {
            run <| animation(animated) { self.button.alpha = 0 }
                ||* { self.hide() }
        }
    }

    public func reveal(animated: Bool) {
        if isHidden {
            self.show()
            run <| animation(animated) {
                self.button.alpha = 1
            }
        }
    }
}

public class ClearFieldButton: Button {
    public override func setup() {
        super.setup()

        let image = UIImage.init(named: "clearFieldButton", in: Framework.bundle)
        setImage(image, for: .normal)
        setPriority(hugH: .required, hugV: .required)
    }
}
