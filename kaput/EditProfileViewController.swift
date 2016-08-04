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


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate  {

 
    @IBOutlet var pickAvatarButton: UIButton!
    @IBAction func pickAvatar(sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true

        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // 2
        let cameraAction = UIAlertAction(title: "Camera Roll", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(picker, animated: true, completion:nil)

        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in

        })
        
        

        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cancelAction)
        

        self.presentViewController(optionMenu, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion:nil)
        
        var storageRef = FIRStorage.storage().reference()

        // if it's a photo from the library, not an image from the camera
//        if #available(iOS 8.0, *), let referenceUrl = info[UIImagePickerControllerReferenceURL] {
//            let assets = PHAsset.fetchAssetsWithALAssetURLs([referenceUrl as! NSURL], options: nil)
//            let asset = assets.firstObject
//            asset?.requestContentEditingInputWithOptions(nil, completionHandler: { (contentEditingInput,info) in
//                let imageFile = contentEditingInput?.fullSizeImageURL
//                let filePath = FIRAuth.auth()!.currentUser!.uid +
//                    "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000))/\(imageFile!.lastPathComponent!)"
//                // [START uploadimage]
//                storageRef.child(filePath)
//                    .putFile(imageFile!, metadata: nil) { (metadata, error) in
//                        if let error = error {
//                            print("Error uploading: \(error)")
//
//                            return
//                        }
//                        self.uploadSuccess(metadata!, storagePath: filePath)
//                }
//                // [END uploadimage]
//            })
//        } else {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            let imagePath = "Image" +
                "/\(FIRAuth.auth()!.currentUser!.uid)" + "/avatar.jpg"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            print(imagePath)
            print(metadata)
            print(storageRef)
            storageRef.child(imagePath)
                .putData(imageData!, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
//                    self.uploadSuccess(metadata!, storagePath: imagePath)
                    self.pickAvatarButton.setBackgroundImage(UIImage(named: "avatar.jpg"), forState: UIControlState.Normal)
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
    @IBOutlet var usernameField: kaputField!

    
    @IBAction func saveChangeButton(sender: AnyObject) {
        
        Errors.clearErrors(mailField)
        Errors.clearErrors(usernameField)

        let username: String? = self.usernameField.text
        let email = self.mailField.text
        
        var error = false
        
        
        if username == "" {
            Errors.errorMessage("REQUIRED",field: self.usernameField)
            error = true
            
        }
        else if username?.characters.count<5 {
            Errors.errorMessage("5 CHAR MIN",field: self.usernameField)
            error = true
        }
        if email == "" {
            Errors.errorMessage("REQUIRED",field: self.mailField)
            error = true
            
            
        }else if Errors.validateEmail(email!) == false {
            Errors.errorMessage("INVALID MAIL",field: self.mailField)
            error = true
            
        }

        
        if !error{
            print("you can change")
        }
        
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        switch textField {
        case usernameField:
            Errors.clearErrors(usernameField)
            
        case mailField:
            Errors.clearErrors(mailField)
     
        default: break
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = Colors.init().bgColor
        self.pickAvatarButton.layer.cornerRadius = self.pickAvatarButton.frame.size.width / 2;
        self.pickAvatarButton.layer.borderWidth = 5;
        self.pickAvatarButton.layer.borderColor = UIColor.whiteColor().CGColor;
        self.mailField.delegate = self
        self.usernameField.delegate = self
        // dans firebase data service, aller chercher l'avatar sur internet, et le mettre en background
//        self.pickAvatarButton.setBackgroundImage(KaputStyle.imageOfBolt, forState: UIControlState.Normal)
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
