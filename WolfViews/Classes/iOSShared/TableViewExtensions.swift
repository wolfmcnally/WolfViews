//
//  TableViewExtensions.swift
//  WolfViews
//
//  Created by Wolf McNally on 7/27/16.
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
import WolfConcurrency
import WolfAnimation
import WolfPipe
import WolfConcurrency

extension UITableView {
    public func register(nibName name: String, in bundle: Bundle? = nil, forCellReuseIdentifier identifier: String) {
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: identifier)
    }

    public func setupDynamicRowHeights(withEstimatedRowHeight estimatedRowHeight: CGFloat) {
        rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = estimatedRowHeight
    }

    public func syncDynamicContent(of cell: UITableViewCell, animated: Bool = true, scrollingToVisibleAt indexPath: IndexPath? = nil, with updates: @escaping Block) {
        animation(animated) {
            updates()
        }
        animation(animated) {
            self.beginUpdates()
            cell.updateConstraintsIfNeeded()
            cell.layoutIfNeeded()
            self.endUpdates()
            guard let indexPath = indexPath else { return }
            let cellFrame = self.rectForRow(at: indexPath)
            self.scrollRectToVisible(cellFrame, animated: animated)
        }
    }

    public func performUpdates(using block: Block) {
        beginUpdates()
        block()
        endUpdates()
    }

    public func deselectAll(animated: Bool) {
        guard let indexPaths = indexPathsForSelectedRows else { return }
        for indexPath in indexPaths {
            deselectRow(at: indexPath, animated: animated)
        }
    }
}
