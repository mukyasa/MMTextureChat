
//
//  GalleryVideoCollectionCell.swift
//  MMTextureChat
//
//  Created by Mukesh on 12/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import  AsyncDisplayKit

class GalleryVideoCollectionCell: UICollectionViewCell,ASVideoPlayerNodeDelegate{
    
    var videoView : ASVideoPlayerNode!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        videoView = ASVideoPlayerNode()
        videoView.frame = self.bounds
        videoView.controlsDisabled = false
        videoView.shouldAutoPlay = false
        videoView.delegate = self
        
        self.contentView.addSubview(videoView.view)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configureVideo(url : String){
        if let temp = URL(string: url){
            videoView.asset = AVAsset(url: temp)
            videoView.shouldAutoPlay = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.videoView.frame = self.bounds
    }
    


    
}
