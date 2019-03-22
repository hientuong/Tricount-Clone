//
//  BaseButton.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/22/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit

@IBDesignable class BaseButton: UIButton {
    //MARK: property corner radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    //MARK: property layer below button
    @IBInspectable var isLayerBelow: Bool = false {
        didSet {
            setLayerBelow()
        }
    }

    //MARK: selected property
    override var isSelected: Bool {
        didSet {
            setLayerBelow()
        }
    }
    var belowLayer: CALayer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayer()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    //MARK: updateUI
    func updateUI() {
        layer.cornerRadius = cornerRadius
    }
    //MARK: set up layer
    func setUpLayer() {
        belowLayer = CALayer()
        belowLayer?.frame = CGRect(x: 0, y: frame.size.height - 2, width: frame.size.width, height: 2)
        
        belowLayer?.backgroundColor = UIColor(red: 0.965, green: 0.541, blue: 0.118, alpha: 1.00).cgColor
        
        layer.insertSublayer(belowLayer!, above: layer)
        belowLayer?.isHidden = true
    }
    
    //MARK: set layer below
    func setLayerBelow() {
        if isSelected  && isLayerBelow {
            belowLayer?.isHidden = false
        }
        else {
            belowLayer?.isHidden = true
        }
        
    }
}
