//
//  TextView.swift
//  WolfViews
//
//  Created by Wolf McNally on 5/27/16.
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
import WolfStrings

open class TextView: UITextView {
    var tagTapActions = [NSAttributedString.Key: TagAction]()
    var tapAction: GestureRecognizerAction!

    public typealias PredicateBlock = (UITextView) -> Bool
    public var shouldReturn: PredicateBlock?

    public convenience init() {
        self.init(frame: .zero, textContainer: nil)
    }

    public convenience init(textContainer: NSTextContainer) {
        self.init(frame: .zero, textContainer: textContainer)
    }

    public override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    let returnKeyCommand = UIKeyCommand(input: String.cr, modifierFlags: [], action: #selector(returnKeyPressed))

    override open var keyCommands: [UIKeyCommand]? {
        return [returnKeyCommand]
    }

    open func enterCarriageReturn() {
        // Get a mutable version of the current text
        var newText = text!
        // Note the currently selected range, because we'll be replacing it
        let range = newText.stringRange(from: selectedRange)!
        // Note the offset of the start of the current range, as we'll be leaving the insertion point just past where we do the replacement
        let offset = newText.distance(from: newText.startIndex, to: range.lowerBound)
        // Replace the range with a carriage return
        newText.replaceSubrange(range, with: String.cr)
        // Replace the text in the UITextView with our updated version
        text = newText
        // Create a range where to leave the insertion point
        let s = newText.index(newText.startIndex, offsetBy: offset + 1)
        let newRange = s ..< s
        // Leave the insertion point after the inserted carriage return
        selectedRange = newText.nsRange(from: newRange)!
    }

    @objc func returnKeyPressed() {
        if shouldReturn?(self) ?? true {
            enterCarriageReturn()
            delegate?.textViewDidChange?(self)
        }
    }

    private func _setup() {
        __setup()
        setup()
    }

    open func setup() {
        font = UIFont.systemFont(ofSize: 18)
    }

    public var plainText: String {
        get {
            return text ?? ""
        }

        set {
            text = newValue
        }
    }
}

extension TextView {
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
                tapAction = addAction(for: UITapGestureRecognizer()) { [unowned self] recognizer in
                    self.handleTap(fromRecognizer: recognizer)
                }
            }
        }
    }

    private func handleTap(fromRecognizer recognizer: UIGestureRecognizer) {
        var location = recognizer.location(in: self)
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top
        let charIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if charIndex < textStorage.length {
            let attributedText = (self.attributedText§?)!
            for (tag, action) in tagTapActions {
                let index = attributedText.string.index(fromLocation: charIndex)
                if let tappedText = attributedText.getString(forTag: tag, atIndex: index) {
                    action(tappedText)
                }
            }
        }
    }
}

extension TextView {
    public func characterPosition(for point: CGPoint) -> UITextPosition {
        guard !isEmpty else { return beginningOfDocument }

        let attrText = (attributedText!)§
        let font = attrText.font

        let r1: CGRect
        let lastChar = String(text[text.index(text.endIndex, offsetBy: -1)...])
        if lastChar == "\n" {
            let r = caretRect(for: position(from: endOfDocument, offset: -1)!)
            let sr = caretRect(for: position(from: beginningOfDocument, offset: 0)!)
            r1 = CGRect(origin: CGPoint(x: sr.minX, y: r.minY + font.lineHeight), size: r.size)
        } else {
            r1 = caretRect(for: position(from: endOfDocument, offset: 0)!)
        }

        print("point: \(point), endRect: \(r1)")

        if point.x > r1.minX && point.y > r1.minY {
            return endOfDocument
        }

        if point.y >= r1.maxY {
            return endOfDocument
        }

        let index = textStorage.layoutManagers[0].characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return position(from: beginningOfDocument, offset: index)!
    }
}

extension UITextView {
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
}
#endif
