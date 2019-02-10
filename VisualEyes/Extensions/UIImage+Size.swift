//
//  UIImage+Size.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-10.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//
import UIKit

extension UIImage {
    
    //aspect height calculated base on the width and height of the device
    //currently ipad pro 11
    var aspectHeight: CGFloat {
        let heightRatio = size.height / 1112
        let widthRatio = size.width / 834
        let aspectRatio = fmax(heightRatio, widthRatio)
        return size.height / aspectRatio
    }
}
