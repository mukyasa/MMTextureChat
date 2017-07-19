//
//  MessageNetworkImageBubbleNode.swift
//  MMTextureChat
//
//  Created by Mukesh on 11/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

public class MessageNetworkImageBubbleNode: ASDisplayNode ,ASNetworkImageNodeDelegate {
    private let bubbleImage: UIImage
    private let isOutgoing: Bool
    let messageImageNode: ASNetworkImageNode
    private let textNode: ASTextNode
    private let caption : NSAttributedString
    private let activity : UIActivityIndicatorView
    
    
    public init(img: String, text : NSAttributedString , isOutgoing : Bool, bubbleImage: UIImage) {
        
        self.isOutgoing = isOutgoing
        self.bubbleImage = bubbleImage
        messageImageNode = ASNetworkImageNode()
        textNode = MessageCaptionNode()
        self.caption = text
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        super.init()
        self.backgroundColor =  UIColor(red: 239 / 255, green: 237 / 255, blue: 237 / 255, alpha: 1)
        
        messageImageNode.style.preferredSize = CGSize(width: 210, height: 150)
        
        if let url = URL(string: img){
            messageImageNode.url  = url
            messageImageNode.delegate = self
            messageImageNode.clipsToBounds = true
            messageImageNode.shouldRenderProgressImages = true
        }
        
        
        
        if(text.string != ""){
            textNode.textContainerInset = UIEdgeInsetsMake(8, 12, 8, 8)
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
    
    override public func didLoad() {
        super.didLoad()
        let mask = UIImageView(image: bubbleImage)
        mask.frame.size = calculatedSize
        //        print(calculatedSize)
        view.layer.mask = mask.layer
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
