//
//  BordersTestView.swift
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

import UIKit
import WolfColor
import WolfAutolayout

public class BordersTestView: View {
    public override func setup() {
        contentMode = .redraw
        backgroundColor = debugColor(.gray, when: true)
        constrainSize(to: CGSize(width: 300, height: 300))
    }

    public override func draw(_ rect: CGRect) {
        let lineWidth: CGFloat = 10
        let strokeColor = UIColor.red.withAlphaComponent(0.5)
        let fillColor = UIColor.blue.withAlphaComponent(0.5)
        var bounds = self.bounds

        func paint(border: Border, in rect: CGRect) {
            border.draw(in: rect)

            let rectPath = UIBezierPath(rect: rect)
            rectPath.lineWidth = 0.5
            UIColor.green.setStroke()
            rectPath.stroke()

            let insetRect = rect.inset(by: border.makeInsets(in: rect))
            let path = UIBezierPath(rect: insetRect)
            path.lineWidth = 0.5
            UIColor.white.setStroke()
            path.stroke()
        }

        do {
            let border = RectBorder(lineWidth: lineWidth, fillColor: fillColor, strokeColor: strokeColor)
            paint(border: border, in: bounds)
        }

        bounds = bounds.insetBy(dx: 30, dy: 30)
        do {
            let border = RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: 30, fillColor: fillColor, strokeColor: strokeColor)
            paint(border: border, in: bounds)
        }

        bounds = bounds.insetBy(dx: 30, dy: 30)
        do {
            let ornaments = CornerOrnaments(topLeft: .square, bottomLeft: .bubbleTail(20), bottomRight: .bubbleTail(20), topRight: .rounded(30))
            let border = OrnamentedCornersBorder(lineWidth: lineWidth, ornaments: ornaments, fillColor: fillColor, strokeColor: strokeColor)
            paint(border: border, in: bounds)
        }
    }
}
