//
//  View.swift
//  WolfViews
//
//  Created by Wolf McNally on 7/6/15.
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
#elseif canImport(AppKit)
    import AppKit
#endif

import WolfAutolayout
import WolfApp
import WolfOSBridge
import WolfNesting
import WolfFoundation

open class View: OSView {
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

    @IBInspectable public var isTransparentToTouches: Bool = false

    #if os(iOS) || os(tvOS)

    var baseSize: CGSize!
    @IBInspectable public var managesSublabelScaling: Bool = false

    @IBInspectable public var contentNibName: String?
    //
    //    private var endEditingAction: GestureRecognizerAction!
    //
    //    @IBInspectable public var endsEditingWhenTapped: Bool = false {
    //        didSet {
    //            if endsEditingWhenTapped {
    //                let tapGestureRecognizer = UITapGestureRecognizer()
    //                tapGestureRecognizer.cancelsTouchesInView = false
    //                endEditingAction = addAction(for: tapGestureRecognizer) { [unowned self] _ in
    //                    self.window?.endEditing(false)
    //                }
    //                endEditingAction.shouldReceiveTouch = { touch in
    //                    return !(touch.view is UIControl)
    //                }
    //            } else {
    //                endEditingAction = nil
    //            }
    //        }
    //    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        loadContentFromNib()
        setupSublabelScaling()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        syncSublabelScaling()
    }
    #endif



    //extension View {
    #if os(iOS) || os(tvOS)
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isTransparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }

    func loadContentFromNib() {
        if let contentNibName = contentNibName {
            let view: OSView = ‡loadView(fromNibNamed: contentNibName, owner: self)
            transferContent(from: view)
        }
    }

    private func transferContent(from view: UIView) {
        // These are attributes that can be set from Interface Builder
        contentMode = view.contentMode
        tag = view.tag
        isUserInteractionEnabled = view.isUserInteractionEnabled
        #if !os(tvOS)
            isMultipleTouchEnabled = view.isMultipleTouchEnabled
        #endif
        alpha = view.alpha
        backgroundColor = view.backgroundColor
        tintColor = view.tintColor
        isOpaque = view.isOpaque
        isHidden = view.isHidden
        clearsContextBeforeDrawing = view.clearsContextBeforeDrawing
        clipsToBounds = view.clipsToBounds
        autoresizesSubviews = view.autoresizesSubviews

        // Copy these arrays because the act of moving the subviews will remove constraints
        let constraints = view.constraints
        let subviews = view.subviews

        self => subviews

        for constraint in constraints {
            var firstItem = constraint.firstItem
            let firstAttribute = constraint.firstAttribute
            let relation = constraint.relation
            var secondItem = constraint.secondItem
            let secondAttribute = constraint.secondAttribute
            let multiplier = constraint.multiplier
            let constant = constraint.constant
            let priority = constraint.priority
            let identifier = constraint.identifier

            if firstItem === view {
                firstItem = self
            }
            if secondItem === view {
                secondItem = self
            }

            let newConstraint = NSLayoutConstraint(item: firstItem!, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
            newConstraint.priority = priority
            newConstraint.identifier = identifier
            addConstraint(newConstraint)
        }
    }
    #endif
    //}



    //extension View {
    open func osDidSetNeedsDisplay() {
    }

    #if os(iOS) || os(tvOS)
    override open func setNeedsDisplay() {
        super.setNeedsDisplay()
        guard !frame.isEmpty else { return }
        osDidSetNeedsDisplay()
    }

    public func osSetNeedsDisplay() {
        setNeedsDisplay()
    }
    #endif

    #if os(macOS)
    override open var needsDisplay: Bool {
    didSet {
    guard !frame.isEmpty else { return }
    osDidSetNeedsDisplay()
    }
    }

    public func osSetNeedsDisplay() {
    needsDisplay = true
    }

    open override func setNeedsDisplay(_ rect: CGRect) {
    super.setNeedsDisplay(rect)
    guard !frame.isEmpty else { return }
    osDidSetNeedsDisplay()
    }
    #endif
    //}
}

#if os(macOS)
    extension View {
        open override var isFlipped: Bool {
            return true
        }
    }
#endif

#if os(iOS) || os(tvOS)
    extension View {

        func setupSublabelScaling() {
            guard managesSublabelScaling else { return }

            baseSize = bounds.size
            for label in descendantViews() as [Label] {
                label.resetBaseFont()
            }
            setNeedsLayout()
        }

        func syncSublabelScaling() {
            guard managesSublabelScaling else { return }

            let factor = bounds.height / baseSize.height
            for label in descendantViews() as [Label] {
                label.syncFontSize(toFactor: factor)
            }
        }
    }
#endif
