//
//  CornerOrnaments.swift
//  WolfViews
//
//  Created by Wolf McNally on 4/1/18.
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

import CoreGraphics

public struct CornerOrnaments {
    public enum Ornament {
        case square
        case rounded(CGFloat) // cornerRadius
        case bubbleTail(CGFloat) // cornerRadius
    }

    public var topLeft: Ornament
    public var bottomLeft: Ornament
    public var bottomRight: Ornament
    public var topRight: Ornament

    public init(topLeft: Ornament, bottomLeft: Ornament, bottomRight: Ornament, topRight: Ornament) {
        self.topLeft = topLeft
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
        self.topRight = topRight
    }

    public init() {
        self.init(topLeft: .square, bottomLeft: .square, bottomRight: .square, topRight: .square)
    }

    public init(cornerRadius: CGFloat) {
        self.init(topLeft: .rounded(cornerRadius), bottomLeft: .rounded(cornerRadius), bottomRight: .rounded(cornerRadius), topRight: .rounded(cornerRadius))
    }

    public var isAllSquare: Bool {
        guard case .square = topLeft else { return false }
        guard case .square = bottomLeft else { return false }
        guard case .square = bottomRight else { return false }
        guard case .square = topRight else { return false }
        return true
    }

    public func allRoundedRadius() -> CGFloat? {
        guard case let .rounded(topLeftRadius) = topLeft else { return nil }
        guard case let .rounded(bottomLeftRadius) = bottomLeft else { return nil }
        guard case let .rounded(bottomRightRadius) = bottomRight else { return nil }
        guard case let .rounded(topRightRadius) = topRight else { return nil }
        guard topLeftRadius == bottomLeftRadius else { return nil }
        guard topLeftRadius == bottomRightRadius else { return nil }
        guard topLeftRadius == topRightRadius else { return nil }
        return topLeftRadius
    }
}
