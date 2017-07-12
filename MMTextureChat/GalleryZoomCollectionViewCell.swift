//
//  GalleryZoomCollectionViewCell.swift
//  MMTextureChat
//
//  Created by Mukesh on 11/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class GalleryZoomCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate,ASNetworkImageNodeDelegate  {
    
    var scroll : UIScrollView!
    var imageView : ASNetworkImageNode!

    var photo : UIImage?  {
        
        set{
            self.imageView.image = newValue
        }
        get{
            if(self.imageView != nil){
                return self.imageView.image
            }
            return nil
        }
    }
    
    var toggle = false
    var indicator : UIActivityIndicatorView!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.scroll = UIScrollView(frame: CGRect.zero)
        self.scroll.clipsToBounds = true
        
        imageView = ASNetworkImageNode()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.delegate = self
        self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.scroll.delegate = self
        self.scroll.addSubview(self.imageView.view)
        
        self.contentView.addSubview(self.scroll)
        
        //Indicator
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.contentView.addSubview(indicator)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GalleryZoomCollectionViewCell.tappedPhoto(sender:)))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    func tappedPhoto(sender : UITapGestureRecognizer){
        
        if let _ = self.imageView.image {
            
            if(self.scroll.zoomScale == 1){
                let point =  sender.location(in: self)
                zooomToPoint(point: point, scale: self.scroll.maximumZoomScale)
//                self.scroll.zoom(to: zoomRectForScrollViewWith(self.scroll.maximumZoomScale, touchPoint: point), animated: true)
                
            }else{
                self.scroll.setZoomScale(1, animated: true)
            }

        }
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTheComponents()
    }
    
    func layoutTheComponents(){
        self.imageView.frame = self.bounds  //very imp line
        self.scroll.frame = self.imageView.frame
        
        self.scroll.contentSize = self.imageView.frame.size
        let minimumScale = scroll.frame.size.width / self.imageView.frame.size.width
        self.scroll.maximumZoomScale = 2.5
        self.scroll.minimumZoomScale = minimumScale
        self.scroll.zoomScale = minimumScale
        
        indicator.center = self.center
        
        
    }
    
    func zooomToPoint(point : CGPoint , scale : CGFloat ){
        
        print(point)
        let w = self.scroll.bounds.size.width / scale
        let h = self.scroll.bounds.size.height / scale
        let x = point.x - (w / 2.0)
        let y = point.y - (h / 2.0)
        
        self.scroll.zoom(to: CGRect(x, y, w, h), animated: true)
        
    }
    
    func zoomRectForScrollViewWith(_ scale: CGFloat, touchPoint: CGPoint) -> CGRect {
        let w = frame.size.width / scale
        let h = frame.size.height / scale
        let x = touchPoint.x - (h / max(UIScreen.main.scale, 2.0))
        let y = touchPoint.y - (w / max(UIScreen.main.scale, 2.0))
        
        return CGRect(x: x, y: y, width: w, height: h)
    }

    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView.view
    }
    
    func configureCell(){
        
        let minimumScale = scroll.frame.size.width / self.imageView.frame.size.width
        self.scroll.zoomScale = minimumScale
        self.imageView.frame = self.bounds  //very imp line
        self.scroll.frame = self.imageView.frame
        self.scroll.contentSize = self.imageView.frame.size
        self.scroll.isUserInteractionEnabled = true
        
    }
    
    func configureForURL(url : String){
        configureCell()
        if let temp = URL(string: url){
            self.imageView.url = temp

        }
    }
    
    //MARK: - Delegate
    func imageNodeDidStartFetchingData(_ imageNode: ASNetworkImageNode) {
        indicator.startAnimating()
    }
    
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        indicator.stopAnimating()
    }
    
    func imageNode(_ imageNode: ASNetworkImageNode, didFailWithError error: Error) {
        indicator.stopAnimating()
    }
    
    
}
