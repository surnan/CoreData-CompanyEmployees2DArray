//
//  UIColor+Extension.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension UIColor{
    static let teal = UIColor(displayP3Red: 48/255, green: 164/255, blue: 182/255, alpha: 1)
    static let lightRed = UIColor(displayP3Red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
    static let darkBlue = UIColor(displayP3Red: 9/255, green: 45/255, blue: 64/255, alpha: 1)
    static let lightBlue = UIColor(displayP3Red: 218/255, green: 235/255, blue: 243/255, alpha: 1)
    static let mediumBlue = UIColor(displayP3Red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
    static let lightPurple = UIColor(displayP3Red: 245/255, green: 241/255, blue: 250/255, alpha: 1)
    static let mediumPurple = UIColor(displayP3Red: 255/255, green: 125/255, blue: 255/255, alpha: 1)
    static let lightYellow = UIColor(displayP3Red: 250/255, green: 249/255, blue: 210/255, alpha: 1)
    static let oliveGreen = UIColor(displayP3Red: 141/255, green: 218/255, blue: 141/255, alpha: 1)
    static let lightOrange = UIColor(displayP3Red: 255/255, green: 204/255, blue: 153/255, alpha: 1)
    static let lightBrown = UIColor(displayP3Red: 145/255, green: 130/255, blue: 130/255, alpha: 1)
    static let veryLightGrey = UIColor(displayP3Red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
}


//imagePicker has default NavigationController internally.  We can't force it to use CustomNavigationController
//So we use this extension to also change behavior of default UINavigationController
extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


//extension UIView {
//    static func makeCircle(cornerRadius: Double){
//        layer.cornerRadius = CGFloat(cornerRadius)
//        clipsToBounds = true
//        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//    }
//}


