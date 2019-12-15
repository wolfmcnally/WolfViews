//
//  StackView.swift
//  WolfViews
//
//  Created by Wolf McNally on 5/26/16.
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

import CoreGraphics
import WolfAnimation
import WolfApp
import WolfPipe
import WolfOSBridge

#if canImport(UIKit)

import UIKit
public typealias OSStackView = UIStackView

extension UIStackView {
    public typealias Axis = NSLayoutConstraint.Axis
}

#elseif canImport(AppKit)

import AppKit
public typealias OSStackView = NSStackView

extension NSStackView {
    public typealias Axis = NSUserInterfaceLayoutOrientation
    public typealias Alignment = NSLayoutConstraint.Attribute

    public var axis: Axis {
        get { return orientation }
        set { orientation = newValue }
    }
}

#endif

open class StackView: OSStackView, Editable {
    public var isTransparentToTouches = false
    public var isEditing = false

    public convenience init() {
        self.init(frame: .zero)
    }

//    public convenience init(arrangedSubviews views: [OSView]) {
//        self.init(arrangedSubviews: views)
//        _setup()
//    }

    public func setEditing(_ isEditing: Bool, animated: Bool) {
        self.isEditing = isEditing
        syncToEditing(animated: animated)
    }

    public func syncToEditing(animated: Bool) {
        for view in arrangedSubviews {
            if let editableView = view as? Editable {
                editableView.setEditing(isEditing, animated: animated)
            }
        }
        adjustToContentHeightChanges(animated: animated)
    }

    public func adjustToContentHeightChanges(animated: Bool) {
        //setNeedsLayout()
        guard arrangedSubviews.count > 0 else { return }
        WolfAnimation.animation(animated) {
            // KLUDGE: As long as at least one arranged subview changes it's hidden status,
            // the stack view will pick up and properly animated size changes of its other subviews.
            // So here we simply toggle the first arranged subview's hidden status twice.
            let view = self.arrangedSubviews[0]
            view.isHidden = !view.isHidden
            view.isHidden = !view.isHidden

            self.layoutIfNeeded()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    #if os(macOS)
    public required init?(coder: NSCoder) {
    super.init(coder: coder)
    _setup()
    }
    #else
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        _setup()
    }
    #endif

    private func _setup() {
        __setup()
        setup()
    }

    #if !os(macOS)
    open override func point(inside point: CGPoint, with event: OSEvent?) -> Bool {
        if isTransparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
    #endif

    open func setup() { }
}

public func axis<V: OSStackView>(_ axis: OSStackView.Axis) -> (_ view: V) -> V {
    return { view in
        view.axis = axis
        return view
    }
}

public func horizontal<V: OSStackView>(_ view: V) -> V {
    return view |> axis(.horizontal)
}

public func vertical<V: OSStackView>(_ view: V) -> V {
    return view |> axis(.vertical)
}

public func spacing<V: OSStackView>(_ spacing: CGFloat) -> (_ view: V) -> V {
    return { view in
        view.spacing = spacing
        return view
    }
}

public func distribution<V: OSStackView>(_ distribution: OSStackView.Distribution) -> (_ view: V) -> V {
    return { view in
        view.distribution = distribution
        return view
    }
}

public func alignment<V: OSStackView>(_ alignment: OSStackView.Alignment) -> (_ view: V) -> V {
    return { view in
        view.alignment = alignment
        return view
    }
}

public func addArrangedSubviews<V: OSStackView>(_ views: [OSView]) -> (_ view: V) -> V {
    return { view in
        views.forEach {
            view.addArrangedSubview($0)
        }
        return view
    }
}
