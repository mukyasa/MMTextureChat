//
//  Message.swift
//  gameofchats
//
//  Created by Brian Voong on 7/7/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

//Message model
class Message: NSObject {

    var fromId: String?
    var text: NSAttributedString?
    var timestamp: String?
    var toId: String?
    var imageUrl: String?
    var videoUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    var name : String?
    var sectionStamp : String?
    var userImgURL : String?

    
    init(image : String){
        super.init()
        self.imageUrl = image
        setdemotimeStamp(time: "06.00 AM", stamp: "", name: "Mukesh")
    }
    
    
    init(image : String , caption : String){
        super.init()

        self.imageUrl = image
        self.text = NSAttributedString(string : caption ,attributes : kAMMessageCellNodeBubbleAttributes)
        setdemotimeStamp(time: "06.30 AM", stamp: "Monday Jun", name: "Mandy")

    }
    
    
    init(msg : String){
        super.init()

        self.text = NSAttributedString(string : msg , attributes : kAMMessageCellNodeBubbleAttributes)
        setdemotimeStamp(time: "06.40 AM", stamp: "", name: "Muks")


    }
    
    
    init(videourl : String){
        super.init()

        self.videoUrl = videourl
        setdemotimeStamp(time: "06.55 AM", stamp: "Today", name: "Honey")

    }
    
    
    func setdemotimeStamp(time : String , stamp : String , name : String){
        self.timestamp = time
        if(stamp != ""){
            self.sectionStamp = stamp

        }
        self.name = name
        self.userImgURL = "https://static.tvtropes.org/pmwiki/pub/images/hero_ironman01.png"
    }
    

    
}
