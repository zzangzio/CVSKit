//
//  UIButton+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public extension UIButton {
    static func autoLayoutView(type: UIButton.ButtonType) -> Self {
        let view = self.init(type: type)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    func setSelectedTitle(_ title: String?) {
        setTitle(title, for: .selected)
        setTitle(title, for: [.selected, .highlighted])
    }

    func setBackgroundImage(_ image: UIImage?) {
        let highlightedImage = image?.with(alpha: 0.7)

        setBackgroundImage(image, for: .normal)
        setBackgroundImage(highlightedImage, for: .highlighted)
    }

    func setImage(_ image: UIImage?) {
        let highlightedImage = image?.with(alpha: 0.7)

        setImage(image, for: .normal)
        setImage(highlightedImage, for: .highlighted)
    }

    func setSelectedImage(_ image: UIImage?) {
        let highlightedImage = image?.with(alpha: 0.7)

        setImage(image, for: .selected)
        setImage(highlightedImage, for: [.selected, .highlighted])
    }

    func setTitleColor(_ color: UIColor?) {
        let highlightedColor = color?.withAlphaComponent(0.7)

        setTitleColor(color, for: .normal)
        setTitleColor(highlightedColor, for: .highlighted)
    }

    var title: String? {
        get {
            return title(for: .normal)
        }

        set {
            setTitle(newValue, for: .normal)
        }
    }
}

public extension UIButton {
    typealias ButtonAction = ((UIButton) -> Void)

    func setAction(_ action: ButtonAction?) {
        removeTarget(self, action: #selector(fireAction), for: .touchUpInside)

        if let action = action {
            actionWrapper = ActionWrapper(action: action)
            addTarget(self, action: #selector(fireAction))
        } else {
            actionWrapper = nil
        }
    }

    @objc private func fireAction() {
        actionWrapper?.action(self)
    }
}

private var ActionWrapperKey: UInt8 = 0
private extension UIButton {
    private struct ActionWrapper {
        let action: ButtonAction
    }

    private var actionWrapper: ActionWrapper? {
        get {
            return objc_getAssociatedObject(self, &ActionWrapperKey) as? ActionWrapper
        }

        set {
            objc_setAssociatedObject(
                self,
                &ActionWrapperKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

public extension UIControl {
    func addTarget(_ target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
}
