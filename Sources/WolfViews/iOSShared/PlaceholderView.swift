//
//  PlaceholderView.swift
//  WolfViews
//
//  Created by Wolf McNally on 1/30/17.
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
import WolfCore
import WolfAutolayout
import WolfGraphics

open class PlaceholderView: View {
    public var color: UIColor? { didSet { setNeedsDisplay() } }
    public var lineWidth: CGFloat { didSet { setNeedsDisplay() } }

    public private(set) var titleLabel = Label() • { 🍒 in
        🍒.font = .systemFont(ofSize: 12)
        🍒.textColor = .darkGray
        🍒.adjustsFontSizeToFitWidth = true
        🍒.minimumScaleFactor = 0.2
        🍒.baselineAdjustment = .alignCenters
        🍒.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    @IBInspectable public var title: String! {
        didSet {
            syncTitle()
        }
    }

    private func syncTitle() {
        titleLabel.text = title
    }

    public init(title: String? = nil, backgroundColor: UIColor? = nil, lineWidth: CGFloat = 1, color: UIColor? = nil) {
        self.lineWidth = lineWidth
        self.color = color
        super.init(frame: .zero)
        self.title = title
        self.backgroundColor = backgroundColor
        syncTitle()
    }

    public required init?(coder aDecoder: NSCoder) {
        lineWidth = 1
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        syncTitle()
    }

    open override func setup() {
        super.setup()
        contentMode = .redraw
        self => [
            titleLabel
        ]
        titleLabel.constrainCenterToCenter()
        Constraints(
            titleLabel.widthAnchor <= widthAnchor
        )
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawPlaceholderRect(rect, lineWidth: lineWidth, color: color)
    }
}
#endif
