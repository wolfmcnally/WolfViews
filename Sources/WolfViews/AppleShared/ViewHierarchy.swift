//
//  ViewHierarchy.swift
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

public enum ViewRelationship {
    case unrelated
    case same
    case sibling
    case ancestor
    case descendant
    case cousin(OSView)
}

extension OSView {
    public func descendantViews<T>() -> [T] {
        var resultViews = [T]()
        self.forViewsInHierarchy { view -> Bool in
            if let view = view as? T {
                resultViews.append(view)
            }
            return false
        }
        return resultViews
    }

    public func forViewsInHierarchy(operate: ViewBlock) {
        var stack = [self]
        repeat {
            let view = stack.removeLast()
            let stop = operate(view)
            guard !stop else { return }
            view.subviews.forEach { subview in
                stack.append(subview)
            }
        } while !stack.isEmpty
    }

    public func allDescendants() -> [OSView] {
        var descendants = [OSView]()
        forViewsInHierarchy { currentView -> Bool in
            if currentView !== self {
                descendants.append(currentView)
            }
            return false
        }
        return descendants
    }

    public func allAncestors() -> [OSView] {
        var parents = [OSView]()
        var currentParent: OSView? = superview
        while currentParent != nil {
            parents.append(currentParent!)
            currentParent = currentParent!.superview
        }
        return parents
    }

    public func relationship(toView view: OSView) -> ViewRelationship {
        guard self !== view else { return .same }

        if let superview = superview {
            for sibling in superview.subviews {
                guard sibling !== self else { continue }
                if sibling === view { return .sibling }
            }
        }

        let ancestors = allAncestors()

        if ancestors.contains(view) {
            return .descendant
        }

        if let commonAncestor = (ancestors as NSArray).firstObjectCommon(with: view.allAncestors()) as? OSView {
            return .cousin(commonAncestor)
        }

        if allDescendants().contains(view) {
            return .ancestor
        }

        return .unrelated
    }
}
