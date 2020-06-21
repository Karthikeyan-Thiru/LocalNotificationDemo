//
//  CardView.swift
//  LocalNotification
//
//  Created by Karthikeyan T on 07/06/2020.
//  Copyright © 2020 Karthikeyan T. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBInspectable var cornerRadius: CGFloat    = 2
    @IBInspectable var shadowOffsetWidth: Int   = 0
    @IBInspectable var shadowOffsetHeight: Int  = 3
    @IBInspectable var shadowColor: UIColor     = .black
    @IBInspectable var shadowOpacity: Float     = 0.5

    override func layoutSubviews() {
        layer.cornerRadius  = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor   = shadowColor.cgColor
        layer.shadowOffset  = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        
        let shadowPath      = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath    = shadowPath.cgPath
    }
}
