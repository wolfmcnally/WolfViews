//
//  GestureRecognizerAction.swift
//  WolfViews
//
//  Created by Wolf McNally on 6/25/17.
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

import Foundation
import WolfOSBridge

private let gestureActionSelector = #selector(GestureRecognizerAction.gestureAction)

public typealias GestureBlock = (OSGestureRecognizer) -> Void

public class GestureRecognizerAction: NSObject, OSGestureRecognizerDelegate {
    public var action: GestureBlock?
    public let gestureRecognizer: OSGestureRecognizer
    public var shouldReceiveTouch: ((OSTouch) -> Bool)?
    public var shouldBegin: (() -> Bool)?

    public init(gestureRecognizer: OSGestureRecognizer, action: GestureBlock? = nil) {
        self.gestureRecognizer = gestureRecognizer
        self.action = action
        super.init()
        #if os(iOS) || os(tvOS)
            gestureRecognizer.addTarget(self, action: gestureActionSelector)
        #else
            gestureRecognizer.target = self
            gestureRecognizer.action = gestureActionSelector
        #endif
        gestureRecognizer.delegate = self
    }

    deinit {
        #if os(iOS) || os(tvOS)
            gestureRecognizer.removeTarget(self, action: gestureActionSelector)
        #else
            gestureRecognizer.target = nil
            gestureRecognizer.action = nil
        #endif
    }

    @objc public func gestureAction() {
        action?(gestureRecognizer)
    }

    public func gestureRecognizer(_ gestureRecognizer: OSGestureRecognizer, shouldReceive touch: OSTouch) -> Bool {
        return shouldReceiveTouch?(touch) ?? true
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: OSGestureRecognizer) -> Bool {
        return shouldBegin?() ?? true
    }
}

extension OSView {
    public func addAction<G: OSGestureRecognizer>(for gestureRecognizer: G, action: @escaping (G) -> Void) -> GestureRecognizerAction {
        self.addGestureRecognizer(gestureRecognizer)
        return GestureRecognizerAction(gestureRecognizer: gestureRecognizer as OSGestureRecognizer, action: { recognizer in
            action(recognizer as! G)
        }
        )
    }
}
