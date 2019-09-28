//
//  GridView.swift
//  WolfViews
//
//  Created by Wolf McNally on 5/28/19.
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

import WolfFoundation
import WolfAutolayout
import UIKit

open class GridView: View {
    public var arrangedSubviews: [[UIView]]! {
        willSet { removeArrangedSubviews() }
        didSet { addArrangedSubviews() }
    }

    public var minColumnWidth: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    public var minRowHeight: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    public var rowSpacing: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    public var columnSpacing: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    public var contentInsets: UIEdgeInsets = .zero {
        didSet { setNeedsLayout() }
    }

    private let viewMatrix = Matrix<UIView>()
    private let constraintsMatrix = Matrix<Constraints>()

    private func removeArrangedSubviews() {
        (0 ..< viewMatrix.rowsCount).forEach { row in
            (0 ..< viewMatrix.columnsCount).forEach { column in
                if let view = viewMatrix[column, row] {
                    view.removeFromSuperview()
                }
            }
        }
        viewMatrix.removeAll()
        constraintsMatrix.removeAll()
    }

    private func addArrangedSubviews() {
        viewMatrix.fill(from: arrangedSubviews)
        (0 ..< viewMatrix.rowsCount).forEach { row in
            (0 ..< viewMatrix.columnsCount).forEach { column in
                if let view = viewMatrix[column, row] {
                    addSubview(view)
                    let constraints = Constraints(
                        view.leadingAnchor == leadingAnchor,
                        view.topAnchor == topAnchor,
                        view.widthAnchor == 50,
                        view.heightAnchor == 50
                    )
                    constraintsMatrix[column, row] = constraints
                }
            }
        }
        setNeedsLayout()
    }

    private func maxWidth(column: Int) -> CGFloat {
        var result: CGFloat = 0
        for row in 0 ..< viewMatrix.rowsCount {
            let size = viewMatrix[column, row]?.intrinsicContentSize.width ?? 0
            result = max(result, size)
        }
        return result
    }

    private func maxHeight(row: Int) -> CGFloat {
        var result: CGFloat = 0
        for column in 0 ..< viewMatrix.columnsCount {
            let size = viewMatrix[column, row]?.intrinsicContentSize.height ?? 0
            result = max(result, size)
        }
        return result
    }

    private struct Layout {
        let rowHeights: [CGFloat]
        let rowYPositions: [CGFloat]
        let columnWidths: [CGFloat]
        let columnXPositions: [CGFloat]
        let size: CGSize
    }

    private var layout: Layout!

    open override func setNeedsLayout() {
        layout = nil
        super.setNeedsLayout()
    }

    private func calculateLayout() {
        let rowHeights = (0 ..< viewMatrix.rowsCount).map { maxHeight(row: $0) }

        func heightForRow(_ row: Int) -> CGFloat {
            let h = rowHeights[row]
            if h == 0 {
                return 0
            } else if row == viewMatrix.rowsCount - 1 {
                return h
            } else {
                return h + rowSpacing
            }
        }

        var rowYPositions = [CGFloat](repeating: 0, count: viewMatrix.rowsCount)

        var height = contentInsets.top
        (0 ..< viewMatrix.rowsCount).forEach { row in
            height += heightForRow(row)
            if row == 0 {
                rowYPositions[row] = contentInsets.top
            } else {
                rowYPositions[row] = rowYPositions[row - 1] + heightForRow(row - 1)
            }
        }
        height += contentInsets.bottom

        let columnWidths = (0 ..< viewMatrix.columnsCount).map { maxWidth(column: $0) }

        func widthForColumn(_ column: Int) -> CGFloat {
            let w = columnWidths[column]
            if w == 0 {
                return 0
            } else if column == viewMatrix.columnsCount - 1 {
                return w
            } else {
                return w + columnSpacing
            }
        }

        var columnXPositions = [CGFloat](repeating: 0, count: viewMatrix.columnsCount)

        var width = contentInsets.left
        (0 ..< viewMatrix.columnsCount).forEach { column in
            width += widthForColumn(column)
            if column == 0 {
                columnXPositions[column] = contentInsets.left
            } else {
                let previousColumnWidth = widthForColumn(column - 1)
                columnXPositions[column] = columnXPositions[column - 1] + previousColumnWidth
            }
        }
        width += contentInsets.right

        let size = CGSize(width: width, height: height)

        layout = Layout(rowHeights: rowHeights, rowYPositions: rowYPositions, columnWidths: columnWidths, columnXPositions: columnXPositions, size: size)
    }

    private func calculateLayoutIfNeeeded() {
        guard layout == nil else { return }
        calculateLayout()
    }

    private var sizeConstraint: Constraints?

    open override func layoutSubviews() {
        calculateLayoutIfNeeeded()

        (0 ..< viewMatrix.rowsCount).forEach { row in
            (0 ..< viewMatrix.columnsCount).forEach { column in
                if let constraints = constraintsMatrix[column, row] {
                    constraints[0].constant = layout.columnXPositions[column]
                    constraints[1].constant = layout.rowYPositions[row]
                    constraints[2].constant = layout.columnWidths[column]
                    constraints[3].constant = layout.rowHeights[row]
                }
            }
        }

        sizeConstraint ◊= constrainSize(to: layout.size)

        super.layoutSubviews()
    }
}
