//
//  WindowExtensions.swift
//  WolfViews
//
//  Created by Wolf McNally on 5/18/16.
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
import WolfGraphics
import WolfCore
import WolfAnimation
import WolfNIO

extension UIWindow {
    public func replaceRootViewController(with newController: UIViewController, animated: Bool = true) -> Future<Void> {
        let promise = MainEventLoop.shared.makePromise(of: Void.self)

        let snapshotImageView = UIImageView(image: snapshot())
        self.addSubview(snapshotImageView)

        func onCompletion() {
            snapshotImageView.removeFromSuperview()
            promise.succeed(())
        }

        func animateTransition() {
            rootViewController = newController
            bringSubviewToFront(snapshotImageView)
            if animated {
                animation { snapshotImageView.alpha = 0 }.always { onCompletion() }
            } else {
                onCompletion()
            }
        }

        if let presentedViewController = rootViewController?.presentedViewController {
            presentedViewController.dismiss(animated: false) {
                animateTransition()
            }
        } else {
            animateTransition()
        }

        return promise.futureResult
    }
}

#if !os(tvOS)
    extension UIWindow {
        public func updateForOrientation() {
            let orientation = UIApplication.shared.statusBarOrientation
            transform = transformForOrientation(orientation)

            let screen = UIScreen.main
            let screenRect = screen.nativeBounds
            let scale = screen.nativeScale
            frame = CGRect(x: 0, y: 0, width: screenRect.width / scale, height: screenRect.height / scale)
        }
    }

    public func transformForOrientation(_ orientation: UIInterfaceOrientation) -> CGAffineTransform {
        switch orientation {
        case .landscapeLeft:
            return CGAffineTransform(rotationAngle: -90.0°)
        case .landscapeRight:
            return CGAffineTransform(rotationAngle: 90.0°)
        case .portraitUpsideDown:
            return CGAffineTransform(rotationAngle: 180.0°)
        default:
            return CGAffineTransform(rotationAngle: 0.0°)
        }
    }
#endif

public func printWindows() {
    for window in UIApplication.shared.windows {
        print("\(window), windowLevel: \(window.windowLevel)")
    }
}
