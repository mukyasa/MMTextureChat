//
//  MBPhotoPicker.swift
//  MBPhotoPicker
//
//  Created by Marcin Butanowicz on 02/01/16.
//  Copyright © 2016 MBSSoftware. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

open class MBPhotoPicker: NSObject {
  
  // MARK: Localized strings
  open var alertTitle: String? = "Alert title"
  
  open var alertMessage: String? = "Alert message"
  
  open var actionTitleCancel: String = "Action Cancel"
  
  open var actionTitleTakePhoto: String = "Action take photo"
  
  open var actionTitleLastPhoto: String = "Action last photo"
  
  open var actionTitleOther: String = "Action other"
  
  open var actionTitleLibrary: String = "Action Library"
  
  
  // MARK: Photo picker settings
  open var allowDestructive: Bool = false
  
  open var allowEditing: Bool = false
  
  open var disableEntitlements: Bool = false
  
  open var cameraDevice: UIImagePickerControllerCameraDevice = .rear
  
  open var cameraFlashMode: UIImagePickerControllerCameraFlashMode = .auto
  
  open var resizeImage: CGSize?
  
  /**
   Using for iPad devices
   */
  open var presentPhotoLibraryInPopover = false
  
  open var popoverTarget: UIView?
  
  open var popoverRect: CGRect?
  
  open var popoverDirection: UIPopoverArrowDirection = .any
  
  var popoverController: UIPopoverController?
  
  /**
   List of callbacks variables
   */
  open var onPhoto: ((_ image: UIImage?) -> ())?
  
  open var onPresented: (() -> ())?
  
  open var onCancel: (() -> ())?
  
  open var onError: ((_ error: ErrorPhotoPicker) -> ())?
  
  
  // MARK: Error's definition
  @objc public enum ErrorPhotoPicker: Int {
    case cameraNotAvailable
    case libraryNotAvailable
    case accessDeniedToCameraRoll
    case accessDeniedToPhoto
    case entitlementiCloud
    case wrongFileType
    case popoverTarget
    case other
    
    public func name() -> String {
      switch self {
      case .cameraNotAvailable:
        return "Camera not available"
      case .libraryNotAvailable:
        return "Library not available"
      case .accessDeniedToCameraRoll:
        return "Access denied to camera roll"
      case .accessDeniedToPhoto:
        return "Access denied to photo library"
      case .entitlementiCloud:
        return "Missing iCloud Capatability"
      case .wrongFileType:
        return "Wrong file type"
      case .popoverTarget:
        return "Missing property popoverTarget while iPad is run"
      case .other:
        return "Other"
      }
    }
  }
  
  
  // MARK: Public
  open func present() {
    let topController = UIApplication.shared.windows.first?.rootViewController
    present(topController!)
  }
  
  open func present(_ controller: UIViewController!) {
    self.controller = controller
    
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .actionSheet)
    
    let actionTakePhoto = UIAlertAction(title: self.localizeString(actionTitleTakePhoto), style: .default, handler: { (alert: UIAlertAction!) in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        self.presentImagePicker(.camera, topController: controller)
      } else {
        self.onError?(.cameraNotAvailable)
      }
    })
    
    let actionLibrary = UIAlertAction(title: self.localizeString(actionTitleLibrary), style: .default, handler: { (alert: UIAlertAction!) in
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        self.presentImagePicker(.photoLibrary, topController: controller)
      } else {
        self.onError?(.libraryNotAvailable)
      }
    })
    
    let actionLast = UIAlertAction(title: self.localizeString(actionTitleLastPhoto), style: .default, handler: { (alert: UIAlertAction!) in
      self.lastPhotoTaken({ (image) in self.photoHandler(image) },
                          errorHandler: { (error) in self.onError?(error) }
      )
    })
    
    
    let actionCancel = UIAlertAction(title: self.localizeString(actionTitleCancel), style: allowDestructive ? .destructive : .cancel, handler: { (alert: UIAlertAction!) in
      self.onCancel?()
    })
    
    alert.addAction(actionTakePhoto)
    alert.addAction(actionLibrary)
    alert.addAction(actionLast)
    alert.addAction(actionCancel)
    
    if !self.disableEntitlements {
      let actionOther = UIAlertAction(title: self.localizeString(actionTitleOther), style: .default, handler: { (alert: UIAlertAction!) in
        let document = UIDocumentMenuViewController(documentTypes: [kUTTypeImage as String, kUTTypeJPEG as String, kUTTypePNG as String, kUTTypeBMP as String, kUTTypeTIFF as String], in: .import)
        document.delegate = self
        controller.present(document, animated: true, completion: nil)
      })
      alert.addAction(actionOther)
    }
    
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      guard let popover = self.popoverTarget else {
        self.onError?(.popoverTarget)
        return;
      }
      
      if let presenter = alert.popoverPresentationController {
        alert.modalPresentationStyle = .popover
        presenter.sourceView = popover;
        presenter.permittedArrowDirections = self.popoverDirection
        
        if let rect = self.popoverRect {
          presenter.sourceRect = rect
        } else {
          presenter.sourceRect = popover.bounds
        }
      }
    }
    
    controller.present(alert, animated: true) { () in
      self.onPresented?()
    }
  }
  
  // MARK: Private
  internal weak var controller: UIViewController?
  
  var imagePicker: UIImagePickerController!
  func presentImagePicker(_ sourceType: UIImagePickerControllerSourceType, topController: UIViewController!) {
    imagePicker = UIImagePickerController()
    imagePicker.sourceType = sourceType
    imagePicker.delegate = self
    imagePicker.isEditing = self.allowEditing
    if sourceType == .camera {
      imagePicker.cameraDevice = self.cameraDevice
      if UIImagePickerController.isFlashAvailable(for: self.cameraDevice) {
        imagePicker.cameraFlashMode = self.cameraFlashMode
      }
    }
    if UIDevice.current.userInterfaceIdiom == .pad && sourceType == .photoLibrary && self.presentPhotoLibraryInPopover {
      guard let popover = self.popoverTarget else {
        self.onError?(.popoverTarget)
        return;
      }
      
      self.popoverController = UIPopoverController(contentViewController: imagePicker)
      let rect = self.popoverRect ?? CGRect.zero
      self.popoverController?.present(from: rect, in: popover, permittedArrowDirections: self.popoverDirection, animated: true)
    } else {
      topController.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  func photoHandler(_ image: UIImage!) {
    let resizedImage: UIImage = UIImage.resizeImage(image, newSize: self.resizeImage)
    self.onPhoto?(resizedImage)
  }
  
  func localizeString(_ string: String!) -> String! {
    var string = string
    let podBundle = Bundle(for: self.classForCoder)
    if let bundleURL = podBundle.url(forResource: "MBPhotoPicker", withExtension: "bundle") {
      if let bundle = Bundle(url: bundleURL) {
        string = NSLocalizedString(string!, tableName: "Localizable", bundle: bundle, value: "", comment: "")
        
      } else {
        assertionFailure("Could not load the bundle")
      }
    }
    
    return string!
  }
}

extension MBPhotoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true) { () in
      self.onCancel?()
    }
  }
  
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] {
      self.photoHandler(image as! UIImage)
    } else {
      self.onError?(.other)
    }
    picker.dismiss(animated: true, completion: nil)
    self.popoverController = nil
  }
  
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    picker.dismiss(animated: true, completion: nil)
    self.popoverController = nil
  }
}

extension MBPhotoPicker: UIDocumentPickerDelegate {
  public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
    var error: NSError?
    let filerCordinator = NSFileCoordinator()
    filerCordinator.coordinate(readingItemAt: url, options: .withoutChanges, error: &error, byAccessor: { (url: URL) in
      if let data: Data = try? Data(contentsOf: url) {
        if data.isSupportedImageType() {
          if let image: UIImage = UIImage(data: data) {
            self.photoHandler(image)
          } else {
            self.onError?(.other)
          }
        } else {
          self.onError?(.wrongFileType)
        }
      } else {
        self.onError?(.other)
      }
    })
  }
  
  public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    self.onCancel?()
  }
}

extension MBPhotoPicker: UIDocumentMenuDelegate {
  public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
    documentPicker.delegate = self
    self.controller?.present(documentPicker, animated: true, completion: nil)
  }
  
  public func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController) {
    self.onCancel?()
  }
}


extension MBPhotoPicker {
  internal func lastPhotoTaken (_ completionHandler: @escaping (_ image: UIImage?) -> (), errorHandler: @escaping (_ error: ErrorPhotoPicker) -> ()) {
    
    PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) -> () in
      if (status == PHAuthorizationStatus.authorized) {
        let manager = PHImageManager.default()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        let asset: PHAsset? = fetchResult.lastObject
        
        let initialRequestOptions = PHImageRequestOptions()
        initialRequestOptions.isSynchronous = true
        initialRequestOptions.resizeMode = .fast
        initialRequestOptions.deliveryMode = .fastFormat
        
        manager.requestImageData(for: asset!, options: initialRequestOptions) { (data: Data?, title: String?, orientation: UIImageOrientation, info: [AnyHashable: Any]?) -> () in
          guard let dataImage = data else {
            errorHandler(.other)
            return
          }
          
          let image:UIImage = UIImage(data: dataImage)!
          
          DispatchQueue.main.async(execute: { () in
            completionHandler(image)
          })
        }
      } else {
        errorHandler(.accessDeniedToPhoto)
      }
    }
  }
}

extension UIImage {
  static public func resizeImage(_ image: UIImage!, newSize: CGSize?) -> UIImage! {
    guard var size = newSize else { return image }
    
    let widthRatio = size.width/image.size.width
    let heightRatio = size.height/image.size.height
    
    let ratio = min(widthRatio, heightRatio)
    size = CGSize(width: image.size.width*ratio, height: image.size.height*ratio)
    
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    image.draw(in: CGRect(origin: CGPoint.zero, size: size))
    
    let scaledImage: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
  }
}

extension Data {
  public func isSupportedImageType() -> Bool {
    var c = [UInt32](repeating: 0, count: 1)
    (self as NSData).getBytes(&c, length: 1)
    switch (c[0]) {
    case 0xFF, 0x89, 0x00, 0x4D, 0x49, 0x47, 0x42:
      return true
    default:
      return false
    }
  }
}

