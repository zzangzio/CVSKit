//
//  HorizontalPagingView.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 15..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public protocol HorizontalPagingViewDelegate: UIScrollViewDelegate {
    func horizontalPagingView(_ pagingView: HorizontalPagingView, didChangePage pageIndex: Int)
}

open class HorizontalPagingView: UIScrollView {
    open weak var pagingDelegate: HorizontalPagingViewDelegate?
    open override var delegate: UIScrollViewDelegate? {
        set {
            guard newValue == nil else {
                fatalError("CVSKit.HorizontalPagingView: Use pagingDelegate instead of delegate.")
            }
        }
        get { return nil }
    }

    open var pages: [UIView] = [UIView]() {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            pages.forEach {
                self.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = true
            }

            layoutIfNeeded()
        }
    }

    private var scrollStartPage: Int = 0

    open func setPage(at index: Int, animated: Bool = true) {
        guard index < pages.count, index >= 0 else {
            fatalError("CVSKit.HorizontalPagingView: Set invalid index :\(index) / \(pages.count)")
        }

        let contentOffset = CGPoint(x: CGFloat(index) * width, y: 0)
        setContentOffset(contentOffset, animated: animated)
        pagingDelegate?.horizontalPagingView(self, didChangePage: index)
    }

    open var pageIndex: Int {
        get {
            guard width > 0 else { return 0 }
            return Int(contentOffset.x / width)
        }
    }

    // MARK: -
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.bounces = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.scrollsToTop = false
        super.delegate = self
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        var offsetX: CGFloat = 0
        let pageSize = CGSize(width: width, height: height)
        pages.forEach { page in
            page.frame = CGRect(origin: CGPoint(x: offsetX, y: 0), size: pageSize)
            offsetX += pageSize.width
        }

        contentSize = CGSize(width: offsetX, height: pageSize.height)
    }
}

// MARK: - UIScrollViewDelegate
extension HorizontalPagingView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollStartPage = pageIndex

        pagingDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = self.pageIndex
        if scrollStartPage != pageIndex {
            setPage(at: pageIndex, animated: false)
        }

        pagingDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            let pageIndex = self.pageIndex
            if scrollStartPage != pageIndex {
                setPage(at: pageIndex, animated: false)
            }
        }

        pagingDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    // by pass
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pagingDelegate?.scrollViewDidScroll?(scrollView)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        pagingDelegate?.scrollViewDidZoom?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pagingDelegate?.scrollViewWillEndDragging?(scrollView,
                                                   withVelocity: velocity,
                                                   targetContentOffset: targetContentOffset)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        pagingDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pagingDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pagingDelegate?.viewForZooming?(in: scrollView) ?? nil
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        pagingDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        pagingDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return pagingDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? false
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        pagingDelegate?.scrollViewDidScrollToTop?(scrollView)
    }

    @available(iOS 11.0, *)
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        pagingDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}
