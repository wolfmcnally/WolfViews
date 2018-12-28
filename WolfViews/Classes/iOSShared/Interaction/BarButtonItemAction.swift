//
//  BarButtonAction.swift
//  WolfViews
//
//  Created by Wolf McNally on 2/18/16.
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
import WolfConcurrency

private let barButtonActionSelector = #selector(BarButtonItemAction.itemAction)

public class BarButtonItemAction: NSObject {
    public var action: Block?
    public let item: UIBarButtonItem

    public init(item: UIBarButtonItem, action: Block? = nil) {
        self.item = item
        self.action = action
        super.init()
        item.target = self
        item.action = barButtonActionSelector
    }

    @objc public func itemAction() {
        action?()
    }
}

extension UIBarButtonItem {
    public func addAction(action: @escaping Block) -> BarButtonItemAction {
        return BarButtonItemAction(item: self, action: action)
    }
}

extension UIBarButtonItem {
    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }

    public convenience init(title: String, style: UIBarButtonItem.Style = .plain) {
        self.init(title: title, style: style, target: nil, action: nil)
    }

    public convenience init(image: UIImage, style: UIBarButtonItem.Style = .plain) {
        self.init(image: image, style: style, target: nil, action: nil)
    }
}
