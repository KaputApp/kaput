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
//FIXME: enlever Firebase FirebaseAuth et FirebaseStorage d'ici. Model View Controller

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate  {

    @IBAction func changePassword(sender: AnyObject) {
        
        if reachable == true {
            
            let email = FIRAuth.auth()?.currentUser?.email
            var error = false
            
                let finalemail = email?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                FIRAuth.auth()?.sendPasswordResetWithEmail(email!, completion: nil)
                let  alert = UIAlertController(title: "Password reset!", message: "An email containing information on how to reset your password has been sent to  \(finalemail!)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
        }
    }
    
    @IBOutlet var pickAvatarButton: UIButton!
    @IBAction func pickAvatar(sender: UIButton) {
        
        if reachable == true {
        
        let picker = UIImagePickerController()

        picker.delegate = self
        picker.allowsEditing = true

        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // 2
        let cameraAction = UIAlertAction(title: "Camera Roll", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker, animated: true, completion:nil)
        })
        let libraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
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

        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion:nil)
        

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
            let compressedImage = UIImage(data : imageData!)
                              
//                    self.uploadSuccess(metadata!, storagePath: imagePath)
                 
            FirebaseDataService.storeAvatarInFirebase(compressedImage!)
            myAvatar  = compressedImage!
        
                    self.pickAvatarButton.setBackgroundImage(myAvatar, forState: UIControlState.Normal)
    }
    
    
    


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
        

    
    @IBOutlet var usernameField: kaputField!

    
    @IBAction func saveChangeButton(sender: AnyObject) {
        
        if reachable == true {
        
        Errors.clearErrors(usernameField)

        let username: String? = self.usernameField.text
        
        var error = false
        
        
        if username == "" {
            Errors.errorMessage("REQUIRED",field: self.usernameField)
            error = true
            
        }
        else if username?.characters.count<5 {
            Errors.errorMessage("5 CHAR MIN",field: self.usernameField)
            error = true
        }
        
        if !error{
            print("you can change")
        }
        
        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
            
        }
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        switch textField {
        case usernameField:
            Errors.clearErrors(usernameField)
          
        default: break
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = Colors.init().bgColor
        self.pickAvatarButton.contentMode = .ScaleAspectFill
        self.pickAvatarButton.layer.cornerRadius = self.pickAvatarButton.frame.size.width / 2;
        self.pickAvatarButton.layer.borderWidth = 5;
        self.pickAvatarButton.clipsToBounds = true
        self.pickAvatarButton.layer.shadowColor = KaputStyle.shadowColor.CGColor;
        self.pickAvatarButton.layer.shadowOffset = CGSizeMake(10, 10);
        self.pickAvatarButton.layer.shadowRadius = 0
        self.pickAvatarButton.layer.shadowOpacity = 1;

        self.pickAvatarButton.layer.borderColor = UIColor.whiteColor().CGColor;
        self.usernameField.delegate = self      
        self.pickAvatarButton.setBackgroundImage(myAvatar, forState: UIControlState.Normal)

        
        
        
    
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
