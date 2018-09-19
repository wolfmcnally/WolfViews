//
//  ScrollingStackView.swift
//  WolfViews
//
//  Created by Wolf McNally on 6/30/16.
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
import WolfWith
import WolfAutolayout
import WolfFoundation

//  keyboardAvoidantView: KeyboardAvoidantView
//      outerStackView: StackView
//          < your non-scrolling views above the scrolling view >
//          scrollView: ScrollView
//              stackView: StackView
//                  < your views that will scroll if necessary >
//          < your non-scrolling views below the scrolling view >

open class ScrollingStackView: View {
    public private(set) lazy var keyboardAvoidantView = KeyboardAvoidantView()

    public private(set) lazy var outerStackView = StackView() • { 🍒 in
        🍒.axis = .vertical
        🍒.distribution = .fill
        🍒.alignment = .fill
    }

    public private(set) lazy var scrollView = ScrollView() • { 🍒 in
        🍒.indicatorStyle = .white
        🍒.keyboardDismissMode = .interactive
    }

    public private(set) lazy var stackView = StackView() • { 🍒 in
        🍒.axis = .vertical
        🍒.distribution = .fill
        🍒.alignment = .fill
    }

    public var stackViewInsets: UIEdgeInsets = .zero {
        didSet { syncInsets() }
    }

    private var stackViewConstraints = Constraints()

    open override func setup() {
        super.setup()

        self => [
            keyboardAvoidantView => [
                outerStackView => [
                    scrollView => [
                        stackView
                    ]
                ]
            ]
        ]

        Constraints(
            keyboardAvoidantView.leadingAnchor == leadingAnchor,
            keyboardAvoidantView.trailingAnchor == trailingAnchor,
            keyboardAvoidantView.topAnchor == topAnchor,
            keyboardAvoidantView.bottomAnchor == bottomAnchor =&= UILayoutPriority.required - 1
        )

        outerStackView.constrainFrameToFrame()

        syncInsets()
    }

    private func syncInsets() {
        stackViewConstraints ◊= Constraints(
            stackView.leadingAnchor == leadingAnchor + stackViewInsets.left,
            stackView.trailingAnchor == trailingAnchor - stackViewInsets.right,
            stackView.leadingAnchor == scrollView.leadingAnchor + stackViewInsets.left,
            stackView.trailingAnchor == scrollView.trailingAnchor - stackViewInsets.right,
            stackView.topAnchor == scrollView.topAnchor + stackViewInsets.top,
            stackView.bottomAnchor == scrollView.bottomAnchor - stackViewInsets.bottom
        )
    }

    public func flashScrollIndicators() {
        scrollView.flashScrollIndicators()
    }
}
