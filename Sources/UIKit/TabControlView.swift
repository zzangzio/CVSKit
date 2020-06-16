//
//  TabControlView.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 15..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public enum TabControlViewChangedBy {
    case progress
    case tapping
    case programmably
}

public protocol TabControlViewDelegate: AnyObject {
    func tabControlView(
        _ tabControlView: TabControlView,
        didChangeIndex index: Int,
        by: TabControlViewChangedBy
    )
}

open class TabControlView: UIView {
    open weak var delegate: TabControlViewDelegate?

    private var titleButtons: [UIButton] = []

    private let underLine: UIView = {
        let underLine = UIView()
        underLine.backgroundColor = .black
        return underLine
    }()

    private var underLineWidths = [CGFloat]()
    private var underLineOrigins = [CGFloat]()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()

    open var underLineColor: UIColor? {
        set {
            underLine.backgroundColor = newValue
        }
        get {
            return underLine.backgroundColor
        }
    }

    open var underLineHeight: CGFloat = 3
    open var selectedTitleColor: UIColor? = UIColor.black
    open var titleColor: UIColor? = UIColor.gray

    open var titleFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            setNeedsLayout()
        }
    }

    open var selectedTitleFont = UIFont.systemFont(ofSize: 15, weight: .semibold) {
        didSet {
            setNeedsLayout()
        }
    }

    open var sideMargin: CGFloat = 30 {
        didSet {
            setNeedsLayout()
        }
    }

    open var sameButtonSize: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    open var titles: [String] = [] {
        didSet {
            makeTitleButtons(titles)
        }
    }

    // MARK: -

    public required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public convenience init(titles: [String]) {
        self.init(frame: CGRect.zero)

        self.titles = titles
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        configureContent()
    }

    private func configureContent() {
        addSubview(scrollView)
        scrollView.addSubview(underLine)
    }

    private func makeTitleButtons(_ titles: [String]) {
        titleButtons.forEach { $0.removeFromSuperview() }
        titleButtons.removeAll()

        titles.forEachStop { title, index, _ in
            let titleButton = UIButton(type: .custom)
            titleButton.setTitle(title, for: UIControl.State())
            titleButton.tag = index
            titleButton.addTarget(self, action: #selector(didTapTitle(_:)), for: .touchUpInside)
            titleButtons.append(titleButton)
            scrollView.addSubview(titleButton)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        let viewWidth = frame.width
        let viewHeight = frame.height

        scrollView.frame = bounds

        var estimatedWidth: CGFloat = 0
        let sideMargin: CGFloat = self.sideMargin

        var maxTitleWidth: CGFloat = 0
        titleButtons.forEachStop { button, _, _ in
            button.titleLabel?.font = titleFont
            button.sizeToFit()
            let titleWidth = (button.frame.width + sideMargin)
            maxTitleWidth = max(maxTitleWidth, titleWidth)
            estimatedWidth += titleWidth
        }

        if sameButtonSize {
            titleButtons.forEach { button in
                button.frame.size.width = (maxTitleWidth - sideMargin)
            }
            estimatedWidth = maxTitleWidth * CGFloat(titleButtons.count)
        }

        let buttonHeight = viewHeight - underLineHeight
        let margin: CGFloat = estimatedWidth > viewWidth ? {
            scrollView.contentSize = CGSize(width: estimatedWidth, height: viewHeight)
            return 0
        }() : {
            scrollView.contentSize = frame.size
            return (viewWidth - estimatedWidth) / CGFloat(titleButtons.count)
        }()

        underLineOrigins = []
        underLineWidths = []
        var offsetX: CGFloat = 0
        titleButtons.forEachStop { button, _, _ in
            let buttonWidth = button.frame.width + sideMargin + margin
            if UIView.isRightToLeft {
                button.frame = CGRect(
                    x: viewWidth - (offsetX + buttonWidth),
                    y: 0, width: buttonWidth, height: buttonHeight
                )
            } else {
                button.frame = CGRect(x: offsetX, y: 0, width: buttonWidth, height: buttonHeight)
            }
            button.layoutIfNeeded()

            // swiftlint:disable:next force_unwrapping
            let titleFrame = convert(button.titleLabel!.frame, from: button)
            let margin: CGFloat = 2

            underLineOrigins.append(titleFrame.minX - margin)
            underLineWidths.append(titleFrame.width + (margin * 2))

            offsetX += buttonWidth
        }

        layoutButtons(animated: false, adjusted: true)
    }

    private func layoutButtons(animated: Bool, adjusted: Bool) {
        let updateLayout = { [weak self] in
            guard let self = self else { return }

            let progress = self.progress
            let currentIndex = self.currentIndex
            self.titleButtons.forEachStop { button, index, _ in
                let focused = currentIndex == index
                button.titleLabel?.font = focused ? self.selectedTitleFont : self.titleFont
                button.setTitleColor(focused ? self.selectedTitleColor : self.titleColor, for: UIControl.State())
            }

            let underLineWidth: CGFloat
            let underLineOrigin: CGFloat

            if let nearIndex = (progress > 0) ? currentIndex + 1 : ((progress < 0) ? currentIndex - 1 : nil),
                let nearLineWidth = self.underLineWidths[safe: nearIndex],
                let nearLineOrigin = self.underLineOrigins[safe: nearIndex] {
                underLineWidth =
                    (self.underLineWidths[currentIndex] * (1 - abs(progress))) + (nearLineWidth * abs(progress))

                if currentIndex < nearIndex {
                    underLineOrigin = self.underLineOrigins[currentIndex] +
                        (nearLineOrigin - self.underLineOrigins[currentIndex]) * progress
                } else {
                    underLineOrigin = self.underLineOrigins[currentIndex] +
                        (self.underLineOrigins[currentIndex] - nearLineOrigin) * progress
                }
            } else {
                underLineWidth = self.underLineWidths[currentIndex]
                underLineOrigin = self.underLineOrigins[currentIndex]
            }

            self.underLine.frame = CGRect(
                x: underLineOrigin,
                y: self.frame.height - self.underLineHeight,
                width: underLineWidth,
                height: self.underLineHeight
            )

            if adjusted {
                self.adjustContentOffsetWithAnimated(animated)
            }
        }

        if animated {
            UIView.animate(withDuration: 0.2) { updateLayout() }
        } else {
            updateLayout()
        }
    }

    private func adjustContentOffsetWithAnimated(_ animated: Bool) {
        let currentButton = titleButtons[currentIndex]
        if (scrollView.contentOffset.x + scrollView.frame.width) < currentButton.frame.maxX {
            let adjustOffset = CGPoint(x: currentButton.frame.maxX - scrollView.frame.width, y: 0)
            scrollView.setContentOffset(adjustOffset, animated: animated)
        } else if scrollView.contentOffset.x > currentButton.frame.minX {
            let adjustOffset = CGPoint(x: currentButton.frame.minX, y: 0)
            scrollView.setContentOffset(adjustOffset, animated: animated)
        } else if (scrollView.contentOffset.x + scrollView.frame.width) < underLine.frame.maxX {
            let adjustOffset = CGPoint(x: underLine.frame.maxX - scrollView.frame.width, y: 0)
            scrollView.setContentOffset(adjustOffset, animated: animated)
        } else if scrollView.contentOffset.x > underLine.frame.minX {
            let adjustOffset = CGPoint(x: underLine.frame.minX, y: 0)
            scrollView.setContentOffset(adjustOffset, animated: animated)
        }
    }

    private(set) var progress: CGFloat = 0
    open func setProgress(_ progress: CGFloat, animated: Bool) {
        guard self.progress != progress else { return }
        let currentIndex = self.currentIndex
        if progress >= 1 {
            self.progress = progress - progress.rounded(.down)
            if (currentIndex + 1) < count {
                setCurrentIndex(currentIndex + 1, animated: true, by: .progress)
            } else {
                layoutButtons(animated: animated, adjusted: true)
            }
        } else if progress <= -1 {
            self.progress = progress - progress.rounded(.up)
            if (currentIndex - 1) >= 0 {
                setCurrentIndex(currentIndex - 1, animated: true, by: .progress)
            } else {
                layoutButtons(animated: animated, adjusted: true)
            }
        } else {
            self.progress = progress
            layoutButtons(animated: animated, adjusted: true)
        }
    }

    open func setProgressIndex(_ progressIndex: CGFloat, animated: Bool) {
        let index = Int(progressIndex.rounded(.toNearestOrAwayFromZero))
        progress = progressIndex - CGFloat(index)
        setCurrentIndex(index, animated: true, by: .progress)
        layoutButtons(animated: animated, adjusted: false)
    }

    open func setCurrentIndex(_ index: Int, animated: Bool) {
        setCurrentIndex(index, animated: animated, by: .programmably)
    }

    open private(set) var currentIndex: Int = 0
    private func setCurrentIndex(_ index: Int, animated: Bool, by: TabControlViewChangedBy) {
        guard currentIndex != index else { return }
        currentIndex = index
        delegate?.tabControlView(self, didChangeIndex: index, by: by)
        layoutButtons(animated: animated, adjusted: true)
    }

    open var count: Int {
        return titleButtons.count
    }

    // MARK: - handle event

    @objc private func didTapTitle(_ button: UIButton) {
        guard isUserInteractionEnabled else { return }
        setCurrentIndex(button.tag, animated: true, by: .tapping)
    }
}
