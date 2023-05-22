//
//  F0XButton.swift
//  F0XButton
//
//  Created by pulei yu on 2023/5/17.
//

import Foundation
import UIKit

public extension F0XButton {
    enum Direction {
        case top
        case bottom
        case left
        case right
    }
}

open class F0XButton: UIControl {
    public var icon4NormalState: UIImage?{
        didSet{
            iconImageView.image = icon4NormalState
        }
    }
    public var icon4SelectedState: UIImage?
    public var icon4DisabledState: UIImage?
    public var title4NormalState: String? {
        didSet {
            titleLabel.text = title4NormalState
            setNeedsLayout()
        }
    }

    public var title4SelectedState: String?
    public var title4DisabledState: String?
    public var titleColor4NormalState: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor4NormalState
        }
    }

    public var titleColor4SelectedState: UIColor?
    public var titleColor4DisabledState: UIColor?

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = titleFont
        return label
    }()

    public lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    public var titleFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            titleLabel.font = titleFont
            setNeedsLayout()
        }
    }

    public var iconDirection: Direction = .top {
        didSet {
            setNeedsLayout()
        }
    }

    public var iconTitleSpace: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    public var iconSize: CGSize = .zero {
        didSet {
            setNeedsLayout()
        }
    }

    override open var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.text = title4SelectedState == nil ? title4NormalState : title4SelectedState
                titleLabel.textColor = titleColor4SelectedState == nil ? titleColor4NormalState : titleColor4SelectedState
                iconImageView.image = icon4SelectedState == nil ? icon4NormalState : icon4SelectedState
            } else {
                iconImageView.image = icon4NormalState
                titleLabel.text = title4NormalState
                titleLabel.textColor = titleColor4NormalState
            }
            setNeedsLayout()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            if isEnabled == false {
                titleLabel.text = title4DisabledState == nil ? title4NormalState : title4DisabledState
                titleLabel.textColor = titleColor4DisabledState == nil ? titleColor4NormalState : titleColor4DisabledState
                iconImageView.image = icon4DisabledState == nil ? icon4NormalState : icon4DisabledState
            } else {
                iconImageView.image = icon4NormalState
                titleLabel.text = title4NormalState
                titleLabel.textColor = titleColor4NormalState
            }
            setNeedsLayout()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(iconImageView)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        calTitleSize(bounds)
        calIconSize(bounds)
        calTextOrigin(bounds)
        calIconOrigin(bounds)
    }
}

extension F0XButton {
    public func calTitleSize(_ rect: CGRect) {
        var rectWidth: CGFloat = 0

        switch iconDirection {
        case .top, .bottom: rectWidth = rect.width
        case .left, .right: rectWidth = rect.width - iconTitleSpace - iconSize.width
        }

        let text = titleLabel.text ?? ""
        var textSize: CGSize = CGSize.zero

        if text.isEmpty == false {
            textSize = (text as NSString).boundingRect(with: .init(width: rectWidth, height: CGFloat.greatestFiniteMagnitude),
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: [.font: titleFont],
                                                       context: nil).size
            textSize = CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
        }

        titleLabel.frame.size = textSize
    }

    public func calIconSize(_ rect: CGRect) {
        iconImageView.frame.size = iconSize
    }

    public func calTextOrigin(_ rect: CGRect) {
        var x: CGFloat = 0, y: CGFloat = 0
        switch iconDirection {
        case .top:
            x = (rect.width - titleLabel.frame.size.width) / 2
            y = (rect.height - iconSize.height - iconTitleSpace - titleLabel.frame.height) / 2 + iconSize.height + iconTitleSpace
        case .bottom:
            x = (rect.width - titleLabel.frame.size.width) / 2
            y = (rect.height - iconSize.height - iconTitleSpace - titleLabel.frame.height) / 2
        case .left:
            x = (rect.width - titleLabel.frame.size.width - iconSize.width - iconTitleSpace) / 2 + iconSize.width + iconTitleSpace
            y = (rect.height - titleLabel.frame.size.height) / 2
        case .right:
            x = (rect.width - titleLabel.frame.size.width - iconSize.width - iconTitleSpace) / 2
            y = (rect.height - titleLabel.frame.size.height) / 2
        }

        titleLabel.frame.origin = CGPoint(x: x, y: y)
    }

    public func calIconOrigin(_ rect: CGRect) {
        var x: CGFloat = 0, y: CGFloat = 0
        switch iconDirection {
        case .top:
            x = (rect.width - iconSize.width) / 2
            y = (rect.height - iconSize.height - iconTitleSpace - titleLabel.frame.height) / 2
        case .bottom:
            x = (rect.width - iconSize.width) / 2
            y = (rect.height - iconSize.height - iconTitleSpace - titleLabel.frame.height) / 2 + iconTitleSpace + titleLabel.frame.size.height
        case .left:
            x = (rect.width - titleLabel.frame.size.width - iconSize.width - iconTitleSpace) / 2
            y = (rect.height - iconSize.height) / 2
        case .right:
            x = (rect.width - titleLabel.frame.size.width - iconSize.width - iconTitleSpace) / 2 + titleLabel.frame.size.width + iconTitleSpace
            y = (rect.height - iconSize.height) / 2
        }

        iconImageView.frame.origin = CGPoint(x: x, y: y)
    }
}
