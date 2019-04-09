//
//  BlurBackgroundView.swift
//  WolfViews
//
//  Created by Wolf McNally on 5/7/18.
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

import WolfCore
import WolfAutolayout
import WolfGraphics

public class BlurBackgroundView: BackgroundView {
    public var cornerRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    public override var insets: UIEdgeInsets {
        return RoundedCornersBorder.makeInsets(for: cornerRadius, lineWidth: 0)
    }

    public var blurEffectStyle: UIBlurEffect.Style! {
        didSet { syncAppearance() }
    }

    public init() {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var blurView: UIVisualEffectView = {
        let style: UIBlurEffect.Style

        if #available(iOS 10.0, *) {
            style = .regular
        } else {
            style = .light
        }

        return ‡UIVisualEffectView(effect: UIBlurEffect(style: style))
    }()

    public override func setup() {
        super.setup()

        layer.masksToBounds = true

        self => [
            blurView
        ]

        blurView.constrainFrameToFrame()
    }

    private func syncAppearance() {
        blurView.effect = UIBlurEffect(style: blurEffectStyle)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(cornerRadius, bounds.size.min / 2)
    }
}
