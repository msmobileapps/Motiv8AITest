//
//  VIewHelper.swift
//  Motiv8AI
//
//  Created by MSApps on 21/01/2021.
//

import Foundation
import UIKit

class ViewHelper: UIView {
    @IBInspectable var radiusCorner: CGFloat {
        get{
            return layer.cornerRadius
        }
        set(newValue){
            if(newValue == 0){
                layer.cornerRadius = frame.width / 2
            }else{
                layer.cornerRadius = newValue
            }
            layer.masksToBounds = true;
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(newValue) {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set(newValue) {
            layer.borderColor = newValue?.cgColor
        }
    }
}
