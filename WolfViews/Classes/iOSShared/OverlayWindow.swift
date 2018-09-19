//
//  OverlayWindow.swift
//  WolfViews
//
//  Created by Wolf McNally on 2/9/17.
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

//private var _overlayWindow: OverlayWindow?
//public var overlayWindow: OverlayWindow! {
//    get {
//        if _overlayWindow == nil {
//            _overlayWindow = OverlayWindow()
//        }
//        return _overlayWindow
//    }
//
//    set {
//        _overlayWindow = newValue
//    }
//}
//
//public var overlayView: View {
//    return overlayWindow!.subviews[0] as! View
//}
//
//public func removeOverlayWindow() {
//    overlayWindow = nil
//}
//
//public class OverlayWindow: UIWindow {
//    public init() {
//        super.init(frame: .zero)
//        _setup()
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        _setup()
//    }
//
//    private func _setup() {
//        __setup()
//
//        windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue + 100)
//        frame = UIScreen.main.bounds
//        rootViewController = OverlayViewController()
//        show()
//        setup()
//    }
//
//    open func setup() { }
//
//    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        return isTransparentToTouch(at: point, with: event)
//    }
//}
//
//public class OverlayViewController: ViewController {
//    public override func loadView() {
//        let v = View()
//        v.isTransparentToTouches = true
//        v.translatesAutoresizingMaskIntoConstraints = true
//        view = v
//    }
//
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        view.makeTransparent()
//    }
//}
