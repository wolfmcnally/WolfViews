//
//  KeyboardMovement.swift
//  WolfViews
//
//  Created by Wolf McNally on 6/22/16.
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

#if os(iOS)
import UIKit
import WolfAnimation

public class KeyboardMovement: CustomStringConvertible {
    private let notification: Notification

    public init(notification: Notification) {
        self.notification = notification
    }

    public var frameBegin: CGRect {
        return (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    }

    public var frameEnd: CGRect {
        return (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    }

    public func frameBegin(in view: UIView) -> CGRect {
        return view.convert(frameBegin, from: nil)
    }

    public func frameEnd(in view: UIView) -> CGRect {
        return view.convert(frameEnd, from: nil)
    }

    public var animationDuration: TimeInterval {
        return TimeInterval((notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue)
    }

    public var animationCurve: UIView.AnimationCurve {
        return UIView.AnimationCurve(rawValue: (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
    }

    public var animationCurveOptions: UIView.AnimationOptions {
        return animationOptions(for: animationCurve)
    }

    public var isLocal: Bool {
        return (notification.userInfo![UIResponder.keyboardIsLocalUserInfoKey] as! NSNumber).boolValue
    }

    public var description: String {
        return notification.description
    }
}
#endif
