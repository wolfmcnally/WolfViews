//
//  GestureActions.swift
//  WolfViews
//
//  Created by Wolf McNally on 4/5/16.
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

#if canImport(AppKit)
    import AppKit
#else
    import UIKit
#endif

import WolfApp
import WolfCore

public class GestureActions {
    unowned let view: OSView
    var gestureRecognizerActions = [String: GestureRecognizerAction]()

    public init(view: OSView) {
        self.view = view
    }

    func getAction(for name: String) -> GestureBlock? {
        return gestureRecognizerActions[name]?.action
    }

    func setAction(named name: String, gestureRecognizer: OSGestureRecognizer, action: @escaping GestureBlock) {
        gestureRecognizerActions[name] = view.addAction(for: gestureRecognizer) { recognizer in
            action(recognizer)
        }
    }

    #if !os(macOS)
    func setSwipeAction(named name: String, direction: UISwipeGestureRecognizer.Direction, action: GestureBlock?) {
        if let action = action {
            let recognizer = UISwipeGestureRecognizer()
            recognizer.direction = direction
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }

    func setPressAction(named name: String, press: UIPress.PressType, action: GestureBlock?) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            recognizer.allowedPressTypes = [NSNumber(value: press.rawValue)]
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }

    func setTapAction(named name: String, action: GestureBlock?) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }

    func setLongPressAction(named name: String, action: GestureBlock?) {
        if let action = action {
            let recognizer = UILongPressGestureRecognizer()
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }
    #endif

    #if os(iOS)
    func setDeepPressAction(named name: String, action: GestureBlock?) {
        if let action = action {
            let recognizer = DeepPressGestureRecognizer()
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }

    func setLongOrDeepPressAction(named name: String, action: GestureBlock?) {
        if let action = action {
            if hasForceTouch {
                let recognizer = DeepPressGestureRecognizer()
                setAction(named: name, gestureRecognizer: recognizer, action: action)
            } else {
                let recognizer = UILongPressGestureRecognizer()
                setAction(named: name, gestureRecognizer: recognizer, action: action)
            }
        } else {
            removeAction(for: name)
        }
    }
    #endif

    func removeAction(for name: String) {
        gestureRecognizerActions.removeValue(forKey: name)
    }
}
