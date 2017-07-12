//
//  TextNodeEx.swift
//  MMTextureChat
//
//  Created by Mukesh on 11/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

extension ASTextNode{
    func addLinkDetection(_ text: String, highLightColor: UIColor) {
        self.isUserInteractionEnabled = true
        let types: NSTextCheckingResult.CheckingType = [.link]
        do{
            let detector = try NSDataDetector(types: types.rawValue)
            let range = NSMakeRange(0, (text as NSString).length)
            if let attributedText = self.attributedText {
                let mutableString = NSMutableAttributedString()
                mutableString.append(attributedText)
                detector.enumerateMatches(in: text, range: range) {
                    (result, _, _) in
                    if let fixedRange = result?.range {
                        mutableString.addAttribute(NSUnderlineColorAttributeName, value: highLightColor, range: fixedRange)
                        mutableString.addAttribute(NSLinkAttributeName, value: result?.url as Any , range: fixedRange)
                        mutableString.addAttribute(NSForegroundColorAttributeName, value: highLightColor, range: fixedRange)
                        
                    }
                }
                self.attributedText = mutableString
            }
        }
        catch{
            
        }
        
    }
}
