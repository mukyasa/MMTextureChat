//
//  MessageNetworkWhatsappImageBubbleNode.swift
//  MMTextureChat
//
//  Created by Mukesh on 19/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class MessageNetworkWhatsappImageBubbleNode: ASDisplayNode ,ASNetworkImageNodeDelegate {
    private let isOutgoing: Bool
    let messageImageNode: ASNetworkImageNode
    private let textNode: ASTextNode
    private let caption : NSAttributedString
    private let activity : UIActivityIndicatorView
    
    
    public init(img: String, text : NSAttributedString , isOutgoing : Bool) {
        
        self.isOutgoing = isOutgoing
        messageImageNode = ASNetworkImageNode()
        messageImageNode.cornerRadius = 6
        messageImageNode.clipsToBounds = true
        
        textNode = MessageCaptionNode()
        self.caption = text
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        super.init()
        self.backgroundColor =  UIColor.clear
        
        messageImageNode.style.preferredSize = CGSize(width: 210, height: 150)
        
        if let url = URL(string: img){
            messageImageNode.url  = url
            messageImageNode.delegate = self
            messageImageNode.shouldRenderProgressImages = true
        }
        
        
        
        if(text.string != ""){
            textNode.textContainerInset = UIEdgeInsetsMake(6, 6, 0, 8)
            textNode.attributedText = text
            textNode.backgroundColor = UIColor.clear
            textNode.placeholderEnabled = false
            addSubnode(textNode)
        }
        
        
        
        addSubnode(messageImageNode)
        
        
    }
    
    
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let verticalSpec = ASStackLayoutSpec()
        verticalSpec.direction = .vertical
        verticalSpec.spacing = 0
        verticalSpec.justifyContent = .start
        verticalSpec.alignItems = isOutgoing == true ? .end : .start
        
        verticalSpec.setChild(messageImageNode, at: 0)
        if(self.caption.string != ""){
            textNode.style.alignSelf = .start //(isOutgoing ? .start : .end)
            verticalSpec.setChild(textNode, at: 1)
            
        }
        
        let insets = UIEdgeInsetsMake(0, 0, 0, 0)
        let insetSpec = ASInsetLayoutSpec(insets: insets, child: verticalSpec)
        return insetSpec
        
        
        
        
    }
    
    //MARK:- Network delegates
    public func imageNodeDidStartFetchingData(_ imageNode: ASNetworkImageNode) {
        
        self.view.addSubview(activity)
        activity.center = messageImageNode.frame.center
        activity.startAnimating()
        
    }
    
    
    public func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        activity.stopAnimating()
        
    }
    public func imageNode(_ imageNode: ASNetworkImageNode, didFailWithError error: Error) {
        activity.stopAnimating()
        
    }
}

