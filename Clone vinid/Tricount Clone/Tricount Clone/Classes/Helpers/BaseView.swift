//
//  BaseView.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/22/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit

@IBDesignable class EWBaseView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    func updateUI() {
        layer.cornerRadius = cornerRadius
    }
}

