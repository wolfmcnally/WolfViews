//
//  PasteboardUtils.swift
//  
//
//  Created by Wolf McNally on 1/24/20.
//

import MobileCoreServices
import UIKit
import WolfPipe
import WolfFoundation

private var _defaultCopyExpires = false
private var _defaultMessageParentView: UIView? = nil
private var _copyMessageImage: UIImage? = nil

/// Configure in your app delegate or similar:
///    UIPasteboard.defaultCopyExpires = true
///    UIPasteboard.defaultMessageParentView = window
///    UIPasteboard.copyMessageImage = UIImage(systemName: "doc.on.doc")!

@available(iOS 13.0, *)
extension UIPasteboard {
    public static var defaultCopyExpires: Bool {
        get { _defaultCopyExpires }
        set { _defaultCopyExpires = newValue }
    }

    public static var defaultMessageParentView: UIView? {
        get { _defaultMessageParentView }
        set { _defaultMessageParentView = newValue }
    }

    public static var copyMessageImage: UIImage? {
        get { _copyMessageImage }
        set { _copyMessageImage = newValue }
    }

    public static func copy(_ string: String, showsMessage: Bool = true, messageParentView: UIView? = nil, expires: Bool? = nil) {
        let key = kUTTypeUTF8PlainText as String
        let value = string |> toUTF8
        let items = [[key: value]]

        let options: [UIPasteboard.OptionsKey : Any]
        let message: String
        if expires ?? defaultCopyExpires {
            let expiry = Date() |> addMinutes(1)
            options = [.expirationDate : expiry]
            message = "Copied! Clipboard will be erased in one minute."
        } else {
            options = [:]
            message = "Copied!"
        }
        UIPasteboard.general.setItems(items, options: options)

        if showsMessage, let parentView = messageParentView ?? defaultMessageParentView {
            let messageView = MessageOverlayView()
            messageView.image = copyMessageImage
            messageView.message = message
            messageView.show(in: parentView, duration: 2)
        }
    }
}
