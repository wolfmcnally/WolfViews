//
//  StackViewExtensions.swift
//  WolfViews
//
//  Created by Wolf McNally on 12/4/16.
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

extension UIStackView.Distribution: CustomStringConvertible {
    public var description: String {
        switch self {
        case .equalCentering:
            return ".equalCentering"
        case .equalSpacing:
            return ".equalSpacing"
        case .fill:
            return ".fill"
        case .fillEqually:
            return ".fillEqually"
        case .fillProportionally:
            return ".fillProportionally"
        @unknown default:
            fatalError()
        }
    }
}

extension UIStackView.Alignment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .center:
            return ".center"
        case .fill:
            return ".fill"
        case .firstBaseline:
            return ".firstBaseline"
        case .lastBaseline:
            return ".lastBaseline"
        case .leading:
            return ".leading"
        case .trailing:
            return ".trailing"
        @unknown default:
            fatalError()
        }
    }
}
//
//extension UIStackView {
//    public func addArrangedSubviews(_ views: [UIView]) {
//        for view in views {
//            addArrangedSubview(view)
//        }
//    }
//
//    public func addArrangedSubviews(_ views: UIView...) {
//        addArrangedSubviews(views)
//    }
//}
