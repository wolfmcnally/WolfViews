//
//  DeepPressGestureRecognizer.swift
//  WolfViews
//
//  Created by Wolf McNally on 1/12/18.
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
import UIKit.UIGestureRecognizerSubclass
import WolfNumerics
import WolfConcurrency

public class DeepPressGestureRecognizer: UIGestureRecognizer {
    public var forceThreshold: Frac = 0.75
    public var timeThreshold: TimeInterval = 0 {
        didSet {
            syncToTimeThreshold()
        }
    }

    private var needsBeginGesture: Asynchronizer?

    enum DeepPressState {
        case notPressing
        case pressingLight
        case pressedHeavy
        case pressedDeep
    }

    private func syncToTimeThreshold() {
        needsBeginGesture = Asynchronizer(delay: timeThreshold) { [unowned self] in
            self.beginGesture()
        }
    }

    private func beginGesture() {
        myState = .pressedDeep
        state = .began
        feedbackGenerator.heavy()
    }

    private func setNeedsBeginGesture() {
        myState = .pressedHeavy
        if let needsBeginGesture = needsBeginGesture {
            feedbackGenerator.light()
            needsBeginGesture.setNeedsSync()
        } else {
            beginGesture()
        }
    }

    private func cancelBeginGesture() {
        myState = .notPressing
        needsBeginGesture?.cancel()
    }

    private var myState: DeepPressState = .notPressing {
        didSet {
            //print(myState)
        }
    }

    public required init(target: AnyObject? = nil, action: Selector? = nil) {
        super.init(target: target, action: action)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch)
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch)
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        switch myState {
        case .pressedDeep:
            state = .ended
        default:
            state = .failed
        }
        cancelBeginGesture()
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)

        state = .ended
        cancelBeginGesture()
    }

    private func handleTouch(_ touch: UITouch) {
        guard touch.force != 0 && touch.maximumPossibleForce != 0 else {
            return
        }

        let force = Frac(touch.force / touch.maximumPossibleForce)
        switch myState {
        case .notPressing:
            myState = .pressingLight
        case .pressingLight:
            if force >= forceThreshold {
                setNeedsBeginGesture()
            }
        case .pressedHeavy:
            break
        case .pressedDeep:
            break
        }
    }
}
