//
//  SpacerView.swift
//  WolfViews
//
//  Created by Wolf McNally on 3/9/17.
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
import WolfGraphics
import WolfCore

public class SpacerView: View {
    public var width: CGFloat {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public var height: CGFloat {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public override func setup() {
        isUserInteractionEnabled = false
    }

    public init(width: CGFloat = 10, height: CGFloat = 10) {
        self.width = width
        self.height = height
        super.init(frame: .zero)
        setPriority(hugH: .required, hugV: .required, crH: .required, crV: .required)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.width = 10
        self.height = 10
        super.init(coder: aDecoder)
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

public func vertical<V: SpacerView>(height: CGFloat) -> (_ view: V) -> V {
    return { view in
        view.width = noSize
        view.height = height
        return view
    }
}

public func vertical<V: SpacerView>(_ view: V) -> V {
    return view |> vertical(height: 10)
}

public func horizontal<V: SpacerView>(width: CGFloat) -> (_ view: V) -> V {
    return { view in
        view.width = width
        view.height = noSize
        return view
    }
}

public func horizontal<V: SpacerView>(_ view: V) -> V {
    return view |> horizontal(width: 10)
}
