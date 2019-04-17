//
//  NavigationBarBlurEffect.swift
//  WolfViews
//
//  Created by Wolf McNally on 6/15/17.
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
import WolfAutolayout
import WolfCore

public class NavigationBarBlurEffect {
    weak var navigationController: UINavigationController!

    private var effectView: UIVisualEffectView!
    private var topConstraint: NSLayoutConstraint!

    public required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setup()
    }

    func setup() {
        effectView = VisualEffectView(effect: UIBlurEffect(style: .light))
        // Add the effect view as a the first subview of the _UIBarBackground view
        let navigationBar = navigationController.navigationBar
        navigationBar.subviews[0].insertSubview(effectView, at: 0)
        navigationBar.backgroundColor = .clear
        topConstraint = effectView.topAnchor == navigationBar.topAnchor
        Constraints(
            effectView.leftAnchor == navigationBar.leftAnchor,
            effectView.rightAnchor == navigationBar.rightAnchor,
            effectView.bottomAnchor == navigationBar.bottomAnchor,
            topConstraint
        )
    }

    public func update() {
        var statusBarAdjustment: CGFloat = -UIApplication.shared.statusBarFrame.height
        out: do {
            guard navigationController.traitCollection.horizontalSizeClass == .regular else { break out }
            guard navigationController.modalPresentationStyle == .fullScreen else { break out }
            guard navigationController.presentingViewController != nil else { break out }
            guard !navigationController.modalPresentationCapturesStatusBarAppearance else { break out }
            statusBarAdjustment = 0
        }
        topConstraint.constant = statusBarAdjustment
    }

    public func show() {
        effectView.show()
    }

    public func hide() {
        effectView.hide()
    }
}
