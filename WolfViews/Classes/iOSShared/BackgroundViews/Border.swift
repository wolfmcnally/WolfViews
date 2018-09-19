//
//  PathUtils.swift
//  WolfViews
//
//  Created by Wolf McNally on 3/31/18.
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

public protocol Border {
    var lineWidth: CGFloat { get set }
    var fillColor: UIColor? { get set }
    var strokeColor: UIColor? { get set }

    func makePath(in frame: CGRect) -> UIBezierPath
    func makeInsets(in frame: CGRect?) -> UIEdgeInsets

    var insets: UIEdgeInsets { get }

    func draw(in frame: CGRect)
}

extension Border {
    public var insets: UIEdgeInsets {
        return makeInsets(in: nil)
    }
    
    public func draw(in frame: CGRect) {
        let path = makePath(in: frame)
        if let fillColor = fillColor {
            fillColor.setFill()
            path.fill()
        }
        if let strokeColor = strokeColor {
            strokeColor.setStroke()
            path.lineWidth = lineWidth
            path.stroke()
        }
    }
}
