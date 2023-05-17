//
//  F0XSpringButton.swift
//  F0XButton
//
//  Created by pulei yu on 2023/5/17.
//

import Foundation
import UIKit
open class F0XSpringButton: F0XButton {
    public var maxHeight: CGFloat = 0
    public var maxWidth: CGFloat = 0
    public var contentEdgesInset: UIEdgeInsets = .zero

    override open var isSelected: Bool {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override open var intrinsicContentSize: CGSize {
        var text = title4NormalState ?? ""

        if isSelected && title4SelectedState != nil {
            text = title4SelectedState!
        }

        if isEnabled == false && title4DisabledState != nil {
            text = title4DisabledState!
        }

        var titleSize = CGSize.zero
        if text.isEmpty == false {
            titleSize = (text as NSString).boundingRect(with: .init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                                        options: .usesLineFragmentOrigin,
                                                        attributes: [.font: titleFont],
                                                        context: nil).size
            titleSize = .init(width: ceil(titleSize.width), height: ceil(titleSize.height))
        }

        let gap = iconTitleSpace
        let iconSize = self.iconSize
        var contentSize: CGSize = .zero

        switch iconDirection {
        case .top, .bottom:
            if maxWidth > 0 {
                contentSize = .init(width: maxWidth,
                                    height: iconSize.height + iconTitleSpace + titleSize.height)
            } else {
                contentSize = .init(width: max(iconSize.width, titleSize.width),
                                    height: iconSize.height + iconTitleSpace + titleSize.height)
            }
            contentSize = .init(width: contentSize.width + contentEdgesInset.left + contentEdgesInset.right,
                                height: contentSize.height + contentEdgesInset.top + contentEdgesInset.bottom)
        case .left, .right:
            if maxHeight > 0 {
                contentSize = .init(width: iconSize.width + iconTitleSpace + titleSize.width,
                                    height: maxHeight)
            } else {
                contentSize = .init(width: iconSize.width + iconTitleSpace + titleSize.width,
                                    height: max(iconSize.height, titleSize.height))
            }
            contentSize = .init(width: contentSize.width + contentEdgesInset.left + contentEdgesInset.right,
                                height: contentSize.height + contentEdgesInset.top + contentEdgesInset.bottom)
        }
        return contentSize
    }
}
