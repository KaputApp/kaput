//
//  EditProfileViewController.swift
//  
//
//  Created by Jeremy OUANOUNOU on 22/07/2016.
//
//

import UIKit
import Photos
import UIKit
import Photos
import Firebase
import FirebaseAuth
import FirebaseStorage


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet var pickAvatarButton: UIButton!
    @IBAction func pickAvatar(sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        presentViewController(picker, animated: true, completion:nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion:nil)
        
        var storageRef:FIRStorageReference!
        // if it's a photo from the library, not an image from the camera
        if #available(iOS 8.0, *), let referenceUrl = info[UIImagePickerControllerReferenceURL] {
            let assets = PHAsset.fetchAssetsWithALAssetURLs([referenceUrl as! NSURL], options: nil)
            let asset = assets.firstObject
            asset?.requestContentEditingInputWithOptions(nil, completionHandler: { (contentEditingInput,info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
                let filePath = FIRAuth.auth()!.currentUser!.uid +
                    "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000))/\(imageFile!.lastPathComponent!)"
                // [START uploadimage]
                storageRef.child(filePath)
                    .putFile(imageFile!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading: \(error)")

                            return
                        }
                        self.uploadSuccess(metadata!, storagePath: filePath)
                }
                // [END uploadimage]
            })
//        } else {
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//            let imageData = UIImageJPEGRepresentation(image, 0.8)
//            let imagePath = FIRAuth.auth()!.currentUser!.uid +
//                "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"
//            let metadata = FIRStorageMetadata()
//            metadata.contentType = "image/jpeg"
//            storageRef.child(imagePath)
//                .putData(imageData!, metadata: metadata) { (metadata, error) in
//                    if let error = error {
//                        print("Error uploading: \(error)")
//                        return
//                    }
//                    self.uploadSuccess(metadata!, storagePath: imagePath)
//            }}
        }}
    
    
    
    func uploadSuccess(metadata: FIRStorageMetadata, storagePath: String) {
        print("Upload Succeeded!")
//        self.urlTextView.text = metadata.downloadURL()!.absoluteString
        NSUserDefaults.standardUserDefaults().setObject(storagePath, forKey: "storagePath")
        NSUserDefaults.standardUserDefaults().synchronize()
//        self.downloadPicButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion:nil)
    }
        
        
    
    @IBOutlet var mailField: kaputField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = Colors.init().bgColor
        self.pickAvatarButton.layer.cornerRadius = self.pickAvatarButton.frame.size.width / 2;
        self.pickAvatarButton.layer.borderWidth = 5;
        self.pickAvatarButton.layer.borderColor = UIColor.whiteColor().CGColor;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
