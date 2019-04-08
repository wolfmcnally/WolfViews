//
//  ImageView.swift
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
import WolfImage
import WolfCache
import WolfNIO

public var sharedImageCache: Cache<UIImage>! = Cache<UIImage>(filename: "sharedImageCache", sizeLimit: 100000, includeHTTP: true)
public var sharedDataCache: Cache<Data>! = Cache<Data>(filename: "sharedDataCache", sizeLimit: 100000, includeHTTP: true)

public typealias ImageViewBlock = (ImageView) -> Void
public typealias ImageProcessingBlock = (UIImage) -> UIImage

open class ImageView: UIImageView {
    public var isTransparentToTouches = false
    private var retrieveID: UUID?
    public var onRetrieveStart: ImageViewBlock?
    public var onRetrieveSuccess: ImageViewBlock?
    public var onRetrieveFailure: ImageViewBlock?
    public var onRetrieveFinally: ImageViewBlock?
    public var onPostprocessImage: ImageProcessingBlock?

    open override var image: UIImage? {
        get {
            return super.image
        }

        set {
            if let image = newValue, let onPostprocessImage = onPostprocessImage {
                super.image = onPostprocessImage(image)
            } else {
                super.image = newValue
            }
        }
    }

    public var pdfTintColor: UIColor? {
        didSet {
            //updatePDFImage()
            setNeedsLayout()
        }
    }

    public var pdf: PDF? {
        didSet {
            //updatePDFImage()
            setNeedsLayout()
        }
    }

    public var url: URL? {
        didSet {
            retrieveID = nil
            pdf = nil
            image = nil
            guard let url = self.url else { return }
            let myRetrieveID = UUID()
            retrieveID = myRetrieveID
            self.onRetrieveStart?(self)
            if url.absoluteString.hasSuffix("pdf") {
                let futureData = sharedDataCache.retrieveObject(for: url)
                futureData.whenSuccess { data in
                    guard self.retrieveID == myRetrieveID else { return }
                    self.pdf = PDF(data: data)
                    self.onRetrieveSuccess?(self)
                }
                futureData.whenFailure { error in
                    guard self.retrieveID == myRetrieveID else { return }
                    self.onRetrieveFailure?(self)
                }
                futureData.whenComplete { _ in
                    guard self.retrieveID == myRetrieveID else { return }
                    self.onRetrieveFinally?(self)
                    self.retrieveID = nil
                }
            } else {
                let futureImage = sharedImageCache.retrieveObject(for: url)
                futureImage.whenSuccess { image in
                    guard self.retrieveID == myRetrieveID else { return }
                    self.image = image
                    self.onRetrieveSuccess?(self)
                }
                futureImage.whenFailure { error in
                    guard self.retrieveID == myRetrieveID else { return }
                    self.onRetrieveFailure?(self)
                }
                futureImage.whenComplete { _ in
                    guard self.retrieveID == myRetrieveID else { return }
                    self.onRetrieveFinally?(self)
                    self.retrieveID = nil
                }
            }
        }
    }

    private var lastFittingSize: CGSize?
    private weak var lastPDF: PDF?

    private func updatePDFImage() {
        guard let pdf = pdf else { return }

        let fittingSize = bounds.size
        if lastFittingSize != fittingSize || lastPDF !== pdf {
            var newImage = pdf.getImage(fittingSize: fittingSize)
            if let pdfTintColor = pdfTintColor {
                newImage = newImage?.tinted(with: pdfTintColor)
            }
            self.image = newImage
            lastFittingSize = fittingSize
            lastPDF = pdf
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updatePDFImage()
    }

    //    open override func layoutSubviews() {
    //        updatePDFCanceler?.cancel()
    //        lastFittingSize = nil
    //        if pdf != nil {
    //            updatePDFCanceler = dispatchOnMain(afterDelay: 0.1) {
    //                self.updatePDFImage()
    //            }
    //        }
    //        super.layoutSubviews()
    //    }

    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        lastFittingSize = nil
    }

    //    open override var intrinsicContentSize: CGSize {
    //        let size: CGSize
    //        if let pdf = pdf {
    //            size = pdf.getSize()
    //        } else {
    //            size = super.intrinsicContentSize
    //        }
    //        return size
    //    }

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public override init(image: UIImage?) {
        super.init(image: image)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        __setup()
        setup()
    }

    open func setup() { }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isTransparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
}
