//
//  MessageTextBubbleNode.swift
//  MMTextureChat
//
//  Created by Mukesh on 11/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

public class MessageTextBubbleNode: ASDisplayNode , ASTextNodeDelegate{
    
    let isOutgoing: Bool
    let bubbleImageNode: ASImageNode
    let textNode: ASTextNode
    
    public init(text: NSAttributedString, isOutgoing: Bool, bubbleImage: UIImage) {
        self.isOutgoing = isOutgoing
        
        bubbleImageNode = ASImageNode()
        bubbleImageNode.image = bubbleImage
        
        
        textNode = MessageTextNode()
        
        let attr = NSMutableAttributedString(attributedString: text)
        
        
        textNode.attributedText = attr
        
        super.init()
        
        addSubnode(bubbleImageNode)
        addSubnode(textNode)
        
        //target delegate
        textNode.isUserInteractionEnabled = true
        textNode.delegate = self
        let linkcolor = isOutgoing ? UIColor.white : UIColor.blue
        textNode.addLinkDetection(attr.string, highLightColor: linkcolor)
        textNode.addUserMention(highLightColor: linkcolor)
        
    }
    

    
    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textNodeVerticalOffset = CGFloat(6)
        
        return ASBackgroundLayoutSpec(
            child: ASInsetLayoutSpec(
                insets: UIEdgeInsetsMake(
                    8,
                    12 + (isOutgoing ? 0 : textNodeVerticalOffset),
                    8,
                    12 + (isOutgoing ? textNodeVerticalOffset : 0)),
                child: textNode),
            background: bubbleImageNode)
    }
    
    
    //MARK: - Text Delegate
    
    public func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
        return true
    }
    
    public func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        print("link tap")

    }
}










