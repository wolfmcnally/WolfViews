//
//  RoundedCornersBorder.swift
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

#if canImport(UIKit)
import UIKit
import WolfGeometry

public struct RoundedCornersBorder: Border {
    private typealias `Self` = RoundedCornersBorder

    public var lineWidth: CGFloat
    public var cornerRadius: CGFloat
    public var fillColor: UIColor?
    public var strokeColor: UIColor?

    public init(lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8, fillColor: UIColor? = nil, strokeColor: UIColor? = .black) {
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }

    public static func clampCornerRadius(_ cornerRadius: CGFloat, in frame: CGRect?) -> CGFloat {
        guard let frame = frame else { return cornerRadius }
        let minDimension = min(frame.width, frame.height)
        return min(cornerRadius, minDimension / 2)
    }

    public static func makeInsets(for cornerRadius: CGFloat, lineWidth: CGFloat) -> UIEdgeInsets {
        let inset = cornerRadius - cos(45°) * cornerRadius + cos(45°) * lineWidth
        return UIEdgeInsets(all: inset)
    }

    private var effectiveLineWidth: CGFloat {
        return strokeColor != nil ? lineWidth : 0
    }

    public func makePath(in frame: CGRect) -> UIBezierPath {
        let halfLineWidth = effectiveLineWidth / 2
        let clampedCornerRadius = Self.clampCornerRadius(cornerRadius, in: frame) - halfLineWidth
        let insetRect = frame.insetBy(dx: halfLineWidth, dy: halfLineWidth)
        let path = UIBezierPath(roundedRect: insetRect, cornerRadius: clampedCornerRadius)
        path.lineWidth = effectiveLineWidth
        return path
    }

    public func makeInsets(in frame: CGRect?) -> UIEdgeInsets {
        return Self.makeInsets(for: cornerRadius, lineWidth: effectiveLineWidth)
    }
}
#endif
