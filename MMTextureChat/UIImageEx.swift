//
//  UIImageEx.swift
//  MMTextureChat
//
//  Created by Mukesh on 11/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit

extension UIImage {
    func makeCircularImageWithSize(_ size: CGSize) -> UIImage {
        let circleRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0.0)
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width/2.0)
        circle.addClip()
        self.draw(in: circleRect)
        circle.lineWidth = 1
        UIColor.darkGray.set()
        circle.stroke()
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
    func imageMaskedWith(_ color: UIColor) -> UIImage {
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -(imageRect.size.height))
        
        context?.clip(to: imageRect, mask: cgImage!)
        context?.setFillColor(color.cgColor)
        context?.fill(imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
