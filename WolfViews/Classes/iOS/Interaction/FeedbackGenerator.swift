//
//  FeedbackGenerator.swift
//  WolfViews
//
//  Created by Wolf McNally on 2/11/18.
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

import AudioToolbox

public let feedbackGenerator = FeedbackGenerator()

public class FeedbackGenerator {
    //available(iOS, 10.0, *)
    private var selectionGenerator: Any?
    private var heavyGenerator: Any?
    private var mediumGenerator: Any?
    private var lightGenerator: Any?
    private var notificationGenerator: Any?

    public func selectionChanged() {
        if #available(iOS 10.0, *) {
            if selectionGenerator == nil {
                selectionGenerator = UISelectionFeedbackGenerator()
            }

            (selectionGenerator as! UISelectionFeedbackGenerator).selectionChanged()
        }
    }

    public func heavy() {
        if #available(iOS 10.0, *) {
            if heavyGenerator == nil {
                heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
            }

            (heavyGenerator as! UIImpactFeedbackGenerator).impactOccurred()
        }
    }

    public func medium() {
        if #available(iOS 10.0, *) {
            if mediumGenerator == nil {
                mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
            }

            (mediumGenerator as! UIImpactFeedbackGenerator).impactOccurred()
        }
    }

    public func light() {
        if #available(iOS 10.0, *) {
            if lightGenerator == nil {
                lightGenerator = UIImpactFeedbackGenerator(style: .light)
            }

            (lightGenerator as! UIImpactFeedbackGenerator).impactOccurred()
        }
    }

    public func error() {
        if #available(iOS 10.0, *) {
            if notificationGenerator == nil {
                notificationGenerator = UINotificationFeedbackGenerator()
            }

            (notificationGenerator as! UINotificationFeedbackGenerator).notificationOccurred(.error)
        }
    }

    public func success() {
        if #available(iOS 10.0, *) {
            if notificationGenerator == nil {
                notificationGenerator = UINotificationFeedbackGenerator()
            }

            (notificationGenerator as! UINotificationFeedbackGenerator).notificationOccurred(.success)
        }
    }

    public func warning() {
        if #available(iOS 10.0, *) {
            if notificationGenerator == nil {
                notificationGenerator = UINotificationFeedbackGenerator()
            }

            (notificationGenerator as! UINotificationFeedbackGenerator).notificationOccurred(.warning)
        }
    }
}
