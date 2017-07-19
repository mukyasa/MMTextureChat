//
//  MessageWhatsappBubbleNode.swift
//  MMTextureChat
//
//  Created by Mukesh on 19/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

//Whatsapp
class MessageWhatsappBubbleNode: ASCellNode,ASVideoNodeDelegate{
    
    private let isOutgoing: Bool
    private let bubbleImageNode: ASImageNode
    private let timeNode: ASTextNode
    private let sectionNode: ASTextNode
    private let nameNode: ASTextNode
    private var bubbleNode: ASDisplayNode
    let message : Message
    weak var delegate : ChatDelegate!
    
    
    
    
    func didTap(_ videoNode: ASVideoNode) {
        print("test video")
        if(delegate != nil){
            self.delegate.openImageGallery(message: message)
        }
        
    }
    
    
    func handleZoomTap() {
        
        if(delegate != nil){
            self.delegate.openImageGallery(message: message)
        }
        
    }
    
    
    func handleUserTap() {
        
        if(delegate != nil){
            self.delegate.openuserProfile(message: message)
            
        }
    }
    
    
    
    
    init(msg : Message, isOutgoing: Bool, bubbleImage: UIImage) {
        self.isOutgoing = isOutgoing
        self.message = msg
        bubbleImageNode = ASImageNode()
        bubbleImageNode.image = bubbleImage
        
        
        timeNode = ASTextNode()
        nameNode = ASTextNode()
        bubbleNode = ASDisplayNode()
        sectionNode = ASTextNode()
        
        super.init()
        
        if let url = msg.videoUrl{
            
            bubbleNode = MessageWhatsappVideoNode(url: url, isOutgoing: isOutgoing)
            
        }
        
        if let url = msg.imageUrl{
            let caption = message.text == nil ? NSAttributedString(string : "") : message.text!
            bubbleNode = MessageNetworkWhatsappImageBubbleNode(img: url, text: caption, isOutgoing: isOutgoing)
            
        }else{
            if let text = msg.text{
                bubbleNode = MessageWhatsappTextNode(text: text, isOutgoing: isOutgoing)
                
            }
            
        }
        
        addSubnode(bubbleImageNode)
        addSubnode(bubbleNode)
        
        if let time = msg.timestamp{
            timeNode.attributedText = NSAttributedString(string: time , attributes : kAMMessageCellNodeBottomTextAttributes)
            addSubnode(timeNode)
            
        }
        if let name = msg.name{
            nameNode.textContainerInset = UIEdgeInsetsMake(0, (isOutgoing ? 0 : 6), 0, (isOutgoing ? 6 : 0))
            nameNode.attributedText = NSAttributedString(string: name, attributes: kAMMessageCellNodeTopTextAttributes)
            addSubnode(nameNode)
            
            
        }
        
        if let section = msg.sectionStamp{
            addSubnode(sectionNode)
            sectionNode.style.alignSelf = .center
            sectionNode.textContainerInset = UIEdgeInsetsMake(5, 20, 5, 20)
            sectionNode.backgroundColor = UIColor.lightText
            sectionNode.cornerRadius = 12
            sectionNode.clipsToBounds = true
            sectionNode.style.descender = 10
            sectionNode.attributedText = NSAttributedString(string: section, attributes: kAMMessageCellNodeTopTextAttributes)
        }
        
        
        
    }
    
    
    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let stack = ASStackLayoutSpec()
        stack.direction = .vertical
        stack.style.flexShrink = 1.0
        stack.style.flexGrow = 1.0
        stack.spacing = 5
        
        if let _ = message.name{
            nameNode.addTarget(self, action: #selector(handleUserTap), forControlEvents: ASControlNodeEvent.touchUpInside)
            stack.setChild(nameNode, at: 0)
            
        }
        stack.setChild(bubbleNode, at: 1)
        
        let textNodeVerticalOffset = CGFloat(6)
        timeNode.style.alignSelf = .end
        
        
        
        let verticalSpec = ASBackgroundLayoutSpec()
        verticalSpec.background = bubbleImageNode
        
        
        if let _ = bubbleNode  as? MessageWhatsappTextNode{
            if let namecount = message.text{
                if(namecount.string.characters.count <= 20){
                    
                    let horizon = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: ASStackLayoutAlignItems.start, children: [stack , timeNode])
                    verticalSpec.child = ASInsetLayoutSpec(
                        insets: UIEdgeInsetsMake(8,12 + (isOutgoing ? 0 : textNodeVerticalOffset),8,12 + (isOutgoing ? textNodeVerticalOffset : 0)),child: horizon)
                    
                    
                }else{
                    stack.setChild(timeNode, at: 2)
                    verticalSpec.child = ASInsetLayoutSpec(
                        insets: UIEdgeInsetsMake(8,12 + (isOutgoing ? 0 : textNodeVerticalOffset),8,12 + (isOutgoing ? textNodeVerticalOffset : 0)),child: stack)
                    
                }
                
            }
            
            
        }
        
        
        if let imgnode = bubbleNode as? MessageNetworkWhatsappImageBubbleNode{
            imgnode.messageImageNode.addTarget(self, action: #selector(handleZoomTap), forControlEvents: ASControlNodeEvent.touchUpInside)
            if let _ = message.text{
                
                stack.setChild(timeNode, at: 2)
                verticalSpec.child = ASInsetLayoutSpec(
                    insets:UIEdgeInsetsMake(8,(isOutgoing ? 8 : 16),8,(isOutgoing ? 16 : 8)),child: stack)
                
                
            }else{
                let insets = UIEdgeInsets(top: CGFloat.infinity, left: CGFloat.infinity, bottom: 10, right: 14)
                let textInsetSpec = ASInsetLayoutSpec(insets: insets, child: timeNode)
                
                let check = ASOverlayLayoutSpec(child: bubbleImageNode, overlay: textInsetSpec)
                
                verticalSpec.child = ASInsetLayoutSpec(
                    insets: UIEdgeInsetsMake(8,(isOutgoing ? 8 : 16),8,(isOutgoing ? 16 : 8)),child: stack)
                verticalSpec.background = check
                
            }
        }
        
        if let  vid = bubbleNode as? MessageWhatsappVideoNode{
            vid.videoNode.delegate = self
            let insets = UIEdgeInsets(top: CGFloat.infinity, left: CGFloat.infinity, bottom: 10, right: 14)
            let textInsetSpec = ASInsetLayoutSpec(insets: insets, child: timeNode)
            
            let check = ASOverlayLayoutSpec(child: bubbleImageNode, overlay: textInsetSpec)
            
            verticalSpec.child = ASInsetLayoutSpec(
                insets: UIEdgeInsetsMake(8,(isOutgoing ? 8 : 16),8,(isOutgoing ? 16 : 8)),child: stack)
            verticalSpec.background = check
        }
        
        
        //space it
        let insetSpec = ASInsetLayoutSpec(insets: isOutgoing ? UIEdgeInsetsMake(1, 32, 5, 4) : UIEdgeInsetsMake(1, 4, 5, 32), child: verticalSpec)
        
        
        let stackSpec = ASStackLayoutSpec()
        stackSpec.direction = .vertical
        stackSpec.justifyContent = .spaceAround
        stackSpec.alignItems = isOutgoing ? .end : .start
        
        if let _ = message.sectionStamp {
            stackSpec.spacing = 10
            stackSpec.children = [sectionNode,insetSpec]
            
        }else{
            stackSpec.spacing = 0
            stackSpec.children = [insetSpec]
            
        }
        
        return stackSpec
        
    }
    
}


