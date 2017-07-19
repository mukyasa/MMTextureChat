//
//  MessageBubbleImageProvider.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 8/5/14, inspired by JSQMessagesBubbleImageFactory
//  Copyright (c) 2014 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit

private struct MessageProperties: Hashable {
    let isOutgoing: Bool
    let hasTail: Bool
    let color: UIColor
    
    var hashValue: Int {
        return (31 &* isOutgoing.hashValue) &+ hasTail.hashValue &+ (17 &* color.hashValue)
    }
}

private func ==(lhs: MessageProperties, rhs: MessageProperties) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

private let kDefaultIncomingColor = UIColor(red: 239 / 255, green: 237 / 255, blue: 237 / 255, alpha: 1)
private let kDefaultOutgoingColor = UIColor(red: 17 / 255, green: 107 / 255, blue: 254 / 255, alpha: 1)

public class MessageBubbleImageProvider {
    
    private let outgoingColor: UIColor
    private let incomingColor: UIColor
    private var imageCache = [MessageProperties: UIImage]()
    
    public init(incomingColor: UIColor = kDefaultIncomingColor, outgoingColor: UIColor = kDefaultOutgoingColor) {
        self.incomingColor = incomingColor
        self.outgoingColor = outgoingColor
    }
    
    public func bubbleImage(_ isOutgoing: Bool, hasTail: Bool, color: UIColor? = nil) -> UIImage {
        
        var chosenColor =  isOutgoing ? outgoingColor : incomingColor
        
        if let color = color {
            chosenColor = color
        }
        
        let properties = MessageProperties(isOutgoing: isOutgoing, hasTail: hasTail, color: chosenColor)
        return bubbleImage(properties)
    }
    
    private func bubbleImage(_ properties: MessageProperties) -> UIImage {
        if let image = imageCache[properties] {
            return image
        }
        
        let image = buildBubbleImage(properties)
        imageCache[properties] = image
        return image
    }
    
    private func buildBubbleImage(_ properties: MessageProperties) -> UIImage {
        let imageName = "bubble" + (properties.isOutgoing ? "_outgoing" : "_incoming") + (properties.hasTail ? "" : "_tailless")
//        let imageName = properties.isOutgoing ? "bubbleMine" : "bubbleSomeone"//"bubble" + (properties.isOutgoing ? "_outgoing" : "_incoming") + (properties.hasTail ? "" : "_tailless")

       
        guard let bubble = UIImage(named : imageName) else {
            return UIImage()
        }
        
        //   var normalBubble = bubble.imageMaskedWith(properties.isOutgoing ? outgoingColor : incomingColor)
        var normalBubble = bubble.imageMaskedWith(properties.color)
        
         print(bubble.size)
        // make image stretchable from center point
        let center = CGPoint(x: bubble.size.width / 2.0, y: bubble.size.height / 2.0)
        let capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
        
        normalBubble = MessageBubbleImageProvider.stretchableImage(normalBubble, capInsets: capInsets)
        return normalBubble
    }
    
    private class func stretchableImage(_ source: UIImage, capInsets: UIEdgeInsets) -> UIImage {
        return source.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
    
}


