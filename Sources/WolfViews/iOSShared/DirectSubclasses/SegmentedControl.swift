//
//  SegmentedControl.swift
//  WolfViews
//
//  Created by Wolf McNally on 4/15/18.
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

open class SegmentedControl: UISegmentedControl {
    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        __setup()
        syncFont()
        setup()
    }

    open func setup() { }

    public var titleFont: UIFont? {
        didSet { syncFont() }
    }

    @IBInspectable
    public var segmentPadding: CGSize = .zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    @IBInspectable
    public var titleFontName: String? {
        didSet { syncFont() }
    }

    #if os(iOS)
    @IBInspectable
    public var titleFontSize: CGFloat = UIFont.systemFontSize {
        didSet { syncFont() }
    }
    #elseif os(tvOS)
    public var titleFontSize: CGFloat = 14 {
        didSet { syncFont() }
    }
    #endif

    #if TARGET_INTERFACE_BUILDER

    public override func prepareForInterfaceBuilder() {
        setup()
    }

    #endif

    private var effectiveFont: UIFont {
        if let titleFont = titleFont {
            return titleFont
        } else if let fontName = titleFontName, let titleFont = UIFont(name: fontName, size: titleFontSize) {
            return titleFont
        } else {
            return .systemFont(ofSize: titleFontSize)
        }
    }

    private func syncFont() {
        let attributes: StringAttributes = [.font: effectiveFont]
        setTitleTextAttributes(attributes, for: [])
        setNeedsLayout()
    }

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

        size.height += floor(2 * segmentPadding.height)
        size.width += segmentPadding.width * CGFloat(numberOfSegments + 1)

        return size
    }
}
