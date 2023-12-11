//
//  UIView.swift
//  GeoFenceTestApp
//
//  Created by Vaibhav on 12/11/23.
//

import Foundation
import UIKit

extension UIView {

  // OUTPUT 1
  func dropShadow() {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = 5
    layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize = CGSize(width: -1, height: 1), radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}


