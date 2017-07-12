//
//  MessageCaptionNode.swift
//  MMTextureChat
//
//  Created by Mukesh on 11/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import AsyncDisplayKit


class MessageCaptionNode: ASTextNode {
    
    override init() {
        super.init()
        placeholderColor = UIColor.gray
        isLayerBacked = true
    }
    
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        let size = super.calculateSizeThatFits(CGSize(width: 210, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: max(size.width, 15), height: size.height)
    }
    
}


