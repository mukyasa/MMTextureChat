//
//  GalleryZoomViewController.swift
//  MMTextureChat
//
//  Created by Mukesh on 11/07/17.
//  Copyright © 2017 MadAboutApps. All rights reserved.
//


import UIKit
import ionicons

private let reuseIdentifier = "zoom"
private let reusevideoIdentifier = "video"


class GalleryZoomViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var sourceURLArr = [Message]()
    var initialIndex = 0
    
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {

        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.collectionView?.backgroundColor = UIColor.clear
        
        // Register cell classes
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width : view.frame.width, height : view.frame.height )
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        
        self.collectionView?.collectionViewLayout = flowLayout
        self.collectionView?.register(GalleryZoomCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(GalleryVideoCollectionCell.self, forCellWithReuseIdentifier: reusevideoIdentifier)

        self.collectionView?.isPagingEnabled = true
        if(initialIndex != 0){
            self.collectionView?.scrollToItem(at: IndexPath(item: initialIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)

        }
        
       
        
        let closeBut = UIButton(type: .custom)
        closeBut.frame = CGRect(0, 6, 50 , 50)
        closeBut.addTarget(self, action: #selector(GalleryZoomViewController.closeAction), for: .touchUpInside)
        closeBut.setImage(IonIcons.image(withIcon:"\u{f404}", size: 40, color: UIColor.white), for: .normal)
        view.addSubview(closeBut)
        
        

        // Do any additional setup after loading the view.
    }
    
    func closeAction(){
       self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sourceURLArr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let msg = sourceURLArr[indexPath.item]
        if let url = msg.imageUrl{
            if let cell:GalleryZoomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GalleryZoomCollectionViewCell{
                
                cell.configureForURL(url: url)
                return cell
                
            }

        }
        
        if let url = msg.videoUrl{
            if let cell:GalleryVideoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reusevideoIdentifier, for: indexPath) as? GalleryVideoCollectionCell{
                
                cell.configureVideo(url:  url)
                return cell
                
            }
 
        }

        
        
        return UICollectionViewCell()
        
    }


    // MARK: UICollectionViewDelegate
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    


}


class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}
