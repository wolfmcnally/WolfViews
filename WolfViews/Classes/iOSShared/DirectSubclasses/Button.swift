//
//  Button.swift
//  WolfViews
//
//  Created by Wolf McNally on 7/8/15.
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
import WolfLocale
import WolfStrings

open class Button: UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(title(for: .normal)?.localized(onlyIfTagged: true), for: .normal)
    }

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
        setup()
    }

    open func setup() { }

    public func setTitle(_ title: String, font: UIFont? = nil, normal: UIColor? = nil, highlighted: UIColor? = nil, disabled: UIColor? = .gray) {
        let title = title§
        if let font = font {
            title.font = font
        }
        if let normal = normal {
            title.foregroundColor = normal
            setAttributedTitle(title, for: [])
        }
        if let highlighted = highlighted {
            let title = title.mutableCopy() as! AttributedString
            title.foregroundColor = highlighted
            setAttributedTitle(title, for: [.highlighted])
        }
        if let disabled = disabled {
            let title = title.mutableCopy() as! AttributedString
            title.foregroundColor = disabled
            setAttributedTitle(title, for: [.disabled])
        }
    }
}
