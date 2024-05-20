//
//  CustomContainerView.swift
//  seeu
//
//  Created by 김범석 on 2024/05/20.
//

import UIKit

class CustomContainerView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
}

