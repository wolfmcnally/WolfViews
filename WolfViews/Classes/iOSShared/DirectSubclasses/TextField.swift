//
//  TextField.swift
//  WolfViews
//
//  Created by Wolf McNally on 6/1/16.
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
import WolfImage

open class TextField: UITextField {
    var tintedClearImage: UIImage?
    var lastTintColor: UIColor?
    public static var placeholderColor: UIColor?
    var placeholderColor: UIColor?
    public var clearButtonTintColor: UIColor?

    open func makeTextFieldClearButtonImage(width: CGFloat, color: UIColor) -> UIImage {
        let size = CGSize(width: width, height: width)
        return newImage(withSize: size) { context in
            context.setFillColor(color.cgColor)
            let bounds = size.bounds
            context.fillEllipse(in: bounds)
            let inset = bounds.width * 0.3
            let xBounds = bounds.insetBy(dx: inset, dy: inset)
            let path = UIBezierPath()
            path.move(to: xBounds.minXminY)
            path.addLine(to: xBounds.maxXmaxY)
            path.move(to: xBounds.maxXminY)
            path.addLine(to: xBounds.minXmaxY)
            path.lineWidth = width * 0.1
            path.lineCapStyle = .round
            path.stroke(with: .sourceOut, alpha: 1)
        }
    }

    open func applyClearButtonImage() {
        guard let color = clearButtonTintColor else { return }
        for view in subviews {
            guard let button = view as? UIButton else { continue }
            let width = button.image(for: .normal)?.size.width ?? 14
            button.setImage(makeTextFieldClearButtonImage(width: width, color: color), for: .normal)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    private func _setup() {
        __setup()
        setup()
    }

    open func setup() {
    }

    public var plainText: String {
        get {
            return text ?? ""
        }

        set {
            text = newValue
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        applyClearButtonImage()
    }
}

extension UITextField {
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
}

public func autocapitalizationType<T: UITextField>(_ value: UITextAutocapitalizationType) -> (_ t: T) -> T {
    return { t in
        t.autocapitalizationType = value
        return t
    }
}

public func autocorrectionType<T: UITextField>(_ value: UITextAutocorrectionType) -> (_ t: T) -> T {
    return { t in
        t.autocorrectionType = value
        return t
    }
}

public func spellCheckingType<T: UITextField>(_ value: UITextSpellCheckingType) -> (_ t: T) -> T {
    return { t in
        t.spellCheckingType = value
        return t
    }
}

@available(iOS 11.0, *)
public func smartQuotesType<T: UITextField>(_ value: UITextSmartQuotesType) -> (_ t: T) -> T {
    return { t in
        t.smartQuotesType = value
        return t
    }
}

@available(iOS 11.0, *)
public func smartDashesType<T: UITextField>(_ value: UITextSmartDashesType) -> (_ t: T) -> T {
    return { t in
        t.smartDashesType = value
        return t
    }
}

@available(iOS 11.0, *)
public func smartInsertDeleteType<T: UITextField>(_ value: UITextSmartInsertDeleteType) -> (_ t: T) -> T {
    return { t in
        t.smartInsertDeleteType = value
        return t
    }
}

public func keyboardType<T: UITextField>(_ value: UIKeyboardType) -> (_ t: T) -> T {
    return { t in
        t.keyboardType = value
        return t
    }
}

public func keyboardAppearance<T: UITextField>(_ value: UIKeyboardAppearance) -> (_ t: T) -> T {
    return { t in
        t.keyboardAppearance = value
        return t
    }
}

public func returnKeyType<T: UITextField>(_ value: UIReturnKeyType) -> (_ t: T) -> T {
    return { t in
        t.returnKeyType = value
        return t
    }
}

public func enablesReturnKeyAutomatically<T: UITextField>(_ t: T) -> T {
    t.enablesReturnKeyAutomatically = true
    return t
}

public func secureTextEntry<T: UITextField>(_ t: T) -> T {
    t.isSecureTextEntry = true
    return t
}
