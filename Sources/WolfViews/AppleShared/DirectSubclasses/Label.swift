//
//  Label.swift
//  WolfViews
//
//  Created by Wolf McNally on 7/22/15.
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
public typealias OSLabel = UILabel
#elseif canImport(AppKit)
import AppKit
public typealias OSLabel = NSTextField
#endif

import WolfStrings
import WolfPipe
import WolfGeometry

public typealias TagAction = (String) -> Void

open class Label: OSLabel {
    #if os(macOS)
    public var text: String {
    get { return stringValue }
    set { stringValue = newValue }
    }
    #else
    var tagTapActions = [NSAttributedString.Key: TagAction]()
    var tapAction: GestureRecognizerAction!

    @IBInspectable public var scalesFontSize: Bool = false
    @IBInspectable public var isTransparentToTouches: Bool = false

    private var baseFont: UIFontDescriptor!

    public func resetBaseFont() {
        guard scalesFontSize else { return }

        baseFont = font.fontDescriptor
    }

    public func syncFontSize(toFactor factor: CGFloat) {
        guard scalesFontSize else { return }

        let pointSize = baseFont.pointSize * factor
        font = UIFont(descriptor: baseFont, size: pointSize)
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isTransparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized(onlyIfTagged: true)
    }

    public convenience init(numberOfLines: Int = 1, text: String? = nil) {
        self.init()
        self.numberOfLines = numberOfLines
        self.text = text
    }

    public convenience init(numberOfLines: Int = 1, text: AttributedString? = nil) {
        self.init()
        self.numberOfLines = numberOfLines
        self.attributedText = text
    }

    public var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override open func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    #endif

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

    public var drawAtTop = false {
        didSet {
            #if os(macOS)
                needsDisplay = true
            #else
                setNeedsDisplay()
            #endif
        }
    }

    open func setup() { }
}

#if !os(macOS)

    extension Label {
        public func setTapAction(forTag tag: NSAttributedString.Key, action: @escaping TagAction) {
            tagTapActions[tag] = action
            syncToTagTapActions()
        }

        public func removeTapAction(forTag tag: NSAttributedString.Key) {
            tagTapActions[tag] = nil
            syncToTagTapActions()
        }

        private func syncToTagTapActions() {
            if tagTapActions.count == 0 {
                tapAction = nil
            } else {
                if tapAction == nil {
                    isUserInteractionEnabled = true

                    tapAction = addAction(for: UITapGestureRecognizer()) { [unowned self] recognizer in
                        self.handleTap(fromRecognizer: recognizer)
                    }
                }
            }
        }

        private func handleTap(fromRecognizer recognizer: UIGestureRecognizer) {
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer()
            let textStorage = NSTextStorage(attributedString: attributedText!)
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            textContainer.lineFragmentPadding = 0.0
            textContainer.lineBreakMode = lineBreakMode
            textContainer.maximumNumberOfLines = numberOfLines
            textContainer.size = bounds.size

            let locationOfTouchInLabel = recognizer.location(in: self)
            let labelSize = bounds.size
            let textBoundingBox = layoutManager.usedRect(for: textContainer)
            let textContainerOffset = (labelSize - textBoundingBox.size) * 0.5 - textBoundingBox.minXminY
            let locationOfTouchInTextContainer = CGPoint(vector: locationOfTouchInLabel - textContainerOffset)
            let charIndex = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            if charIndex < textStorage.length {
                let attributedText = (self.attributedText!)§
                for (tag, action) in tagTapActions {
                    let index = attributedText.string.index(fromLocation: charIndex)
                    if let tappedText = attributedText.getString(forTag: tag, atIndex: index) {
                        action(tappedText)
                    }
                }
            }
        }
    }

public func text<L: UILabel>(_ value: String?) -> (_ label: L) -> L {
    return { label in
        label.text = value
        return label
    }
}

public func text<L: UILabel>(_ value: NSAttributedString?) -> (_ label: L) -> L {
    return { label in
        label.attributedText = value
        return label
    }
}

public func textAlignment<L: UILabel>(_ value: NSTextAlignment) -> (_ label: L) -> L {
    return { label in
        label.textAlignment = value
        return label
    }
}

public func center<L: UILabel>(_ label: L) -> L {
    return label |> textAlignment(.center)
}

public func textColor<L: UILabel>(_ value: UIColor) -> (_ label: L) -> L {
    return { label in
        label.textColor = value
        return label
    }
}

public func numberOfLines<L: UILabel>(_ value: Int) -> (_ label: L) -> L {
    return { label in
        label.numberOfLines = value
        return label
    }
}

public func adjustsFontSizeToFitWidth<L: UILabel>(_ value: Bool) -> (_ label: L) -> L {
    return { label in
        label.adjustsFontSizeToFitWidth = value
        return label
    }
}

public func minimumScaleFactor<L: UILabel>(_ value: CGFloat) -> (_ label: L) -> L {
    return { label in
        label.minimumScaleFactor = value
        return label
    }
}

public func baselineAdjustment<L: UILabel>(_ value: UIBaselineAdjustment) -> (_ label: L) -> L {
    return { label in
        label.baselineAdjustment = value
        return label
    }
}

public func fitToWidth<L: UILabel>(_ label: L) -> L {
    return label |> adjustsFontSizeToFitWidth(true) |> minimumScaleFactor(0.5) |> baselineAdjustment(.alignCenters)
}
#endif
