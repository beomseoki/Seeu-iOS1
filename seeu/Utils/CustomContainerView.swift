//
//  CustomContainerView.swift
//  seeu
//
//  Created by 김범석 on 2024/05/20.
//

import UIKit


protocol CustomContainerViewDelegate: AnyObject {
    func heightForTextField() -> CGFloat
}

class CustomContainerView: UIView {
    weak var delegate: CustomContainerViewDelegate?

    override var intrinsicContentSize: CGSize {
        let height = delegate?.heightForTextField() ?? 50
        return CGSize(width: UIView.noIntrinsicMetric, height: height + 16)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}






