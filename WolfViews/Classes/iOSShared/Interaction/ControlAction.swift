//
//  ControlAction.swift
//  WolfViews
//
//  Created by Wolf McNally on 7/8/15.
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
import WolfCore

private let controlActionSelector = #selector(ControlAction.controlAction)

open class ControlAction<C: UIControl>: NSObject {
    public typealias ControlType = C
    public typealias ResponseBlock = (ControlType) -> Void

    public var action: ResponseBlock?
    public let control: ControlType
    private let controlEvents: UIControl.Event

    public init(control: ControlType, for controlEvents: UIControl.Event, action: ResponseBlock? = nil) {
        self.control = control
        self.action = action
        self.controlEvents = controlEvents
        super.init()
        control.addTarget(self, action: controlActionSelector, for: controlEvents)
    }

    deinit {
        control.removeTarget(self, action: controlActionSelector, for: controlEvents)
    }

    @objc public func controlAction() {
        action?(control)
    }
}

public func addControlAction<ControlType>(to control: ControlType, for controlEvents: UIControl.Event, action: ControlAction<ControlType>.ResponseBlock? = nil) -> ControlAction<ControlType> {
    return ControlAction(control: control, for: controlEvents, action: action)
}

public func addTouchUpInsideAction<ControlType>(to control: ControlType, action: ControlAction<ControlType>.ResponseBlock? = nil) -> ControlAction<ControlType> {
    return addControlAction(to: control, for: .touchUpInside, action: action)
}

public func addValueChangedAction<ControlType>(to control: ControlType, action: ControlAction<ControlType>.ResponseBlock? = nil) -> ControlAction<ControlType> {
    return addControlAction(to: control, for: .valueChanged, action: action)
}


public typealias RefreshBlock = (_ completion: @escaping (_ endText: AttributedString?) -> Void) -> AttributedString?

// Example RefreshBlock that shows the refresh control for 3:
//
//        onRefresh = { completion in
//            dispatchOnMain(afterDelay: 3.0) {
//                completion("Done"§)
//            }
//            return ("Started..."§)
//        }

#if !os(tvOS)
    @available(iOS 10.0, *)
    public class RefreshControlAction: ControlAction<UIRefreshControl> {
        public let scrollView: UIScrollView
        public init(scrollView: UIScrollView, refreshAction: @escaping RefreshBlock) {
            self.scrollView = scrollView
            guard scrollView.refreshControl == nil else {
                fatalError("Scroll view may not already have a refresh control.")
            }
            scrollView.refreshControl = UIRefreshControl()
            super.init(control: scrollView.refreshControl!, for: .valueChanged) { refreshControl in
                let startTitle = refreshAction { endTitle in
                    dispatchOnMain {
                        refreshControl.attributedTitle = endTitle
                        refreshControl.endRefreshing()
                    }
                }
                refreshControl.attributedTitle = startTitle
            }
        }

        deinit {
            scrollView.refreshControl = nil
        }
    }

    @available(iOS 10.0, *)
    public func addRefreshControlAction(to scrollView: UIScrollView, action: @escaping RefreshBlock) -> RefreshControlAction {
        return RefreshControlAction(scrollView: scrollView, refreshAction: action)
    }

#endif
