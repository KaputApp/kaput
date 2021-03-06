//
//  EditProfileViewController.swift
//  
//
//  Created by OPE50 Team on 22/07/2016.
//
//

import UIKit
import Photos
import UIKit
import Photos
import Firebase
import FirebaseAuth
import FirebaseStorage
import FBSDKLoginKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

//FIXME: enlever Firebase FirebaseAuth et FirebaseStorage d'ici. Model View Controller

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate  {

    @IBAction func changePassword(_ sender: AnyObject) {
        
        if reachable == true {
            
            let email = FIRAuth.auth()?.currentUser?.email
            
                let finalemail = email?.trimmingCharacters(in: CharacterSet.whitespaces)
                FIRAuth.auth()?.sendPasswordReset(withEmail: email!, completion: nil)
                let  alert = UIAlertController(title: "Password reset!", message: "An email containing information on how to reset your password has been sent to  \(finalemail!)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
        }
    }
    
    @IBOutlet var pickAvatarButton: UIButton!
    @IBAction func pickAvatar(_ sender: UIButton) {
        
        if reachable == true {
        
        let picker = UIImagePickerController()

        picker.delegate = self
        picker.allowsEditing = true

        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion:nil)
        })
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion:nil)

        })
            
            let fbAction = UIAlertAction(title: "Facebook Profile Picture", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
 
                FirebaseDataService.getAvatarFromFB({(image) in
                    FirebaseDataService.storeAvatarInFirebase(image)
                    let imageData = UIImageJPEGRepresentation(image, 0.8)
                    let compressedImageFB = UIImage(data : imageData!)
                    self.pickAvatarButton.setBackgroundImage(compressedImageFB, for: UIControlState())
                    myAvatar = compressedImageFB!
                })
                
                
            })
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in

        })
        
        

        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(fbAction)
        optionMenu.addAction(cancelAction)
        

        self.present(optionMenu, animated: true, completion: nil)

        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        

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
        
        
                    self.pickAvatarButton.setBackgroundImage(myAvatar, for: UIControlState())
        
    }
    
    
    


    func uploadSuccess(_ metadata: FIRStorageMetadata, storagePath: String) {
        print("Upload Succeeded!")
//        self.urlTextView.text = metadata.downloadURL()!.absoluteString
        UserDefaults.standard.set(storagePath, forKey: "storagePath")
        UserDefaults.standard.synchronize()
//        self.downloadPicButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
        

    
    @IBOutlet var usernameField: kaputField!
    
    @IBOutlet weak var saveChangesButton: kaputPrimaryButton!

    
    @IBAction func saveChangeButton(_ sender: AnyObject) {
        
        if reachable == true {
        
        Errors.clearErrors(usernameField)

        let username: String? = self.usernameField.text
        
        var error = false
        
            FirebaseDataService.getUidWithUsername(username!,response: {(uid,exists)->() in

     
        if username == "" {
            Errors.errorMessage("REQUIRED",field: self.usernameField)
            error = true
            
        }
        else if username?.rangeOfCharacter(from: letters.inverted) != nil {
            Errors.errorMessage("ONLY ALPHA NUMERIC",field: self.usernameField)
            error = true
            
        }
        else if username?.characters.count<4 {
            Errors.errorMessage("4 CHAR MIN",field: self.usernameField)
            error = true
        }
        else if exists && username != ""{
            Errors.errorMessage("ALREADY TAKEN",field: self.usernameField)
            error = true}
        
        if !error{
            print("you can change")
           // ref.child("Users").child(userID).updateChildValues(["name": username!])
            FirebaseDataService.updateUsername(myUsername, newUsername:username!)
            myUsername = username!
            
            self.saveChangesButton.titleLabel?.text = "NAME CHANGED"
            self.saveChangesButton.backgroundColor = KaputStyle.fullGreen
            
            delay(delay: 1.5) {
                self.saveChangesButton.titleLabel?.text = "SAVE CHANGES"
                self.saveChangesButton.backgroundColor = Colors.init().primaryColor
            }
                }
            })
        }else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
            
        }
    }
        
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case usernameField:
            Errors.clearErrors(usernameField)
          
        default: break
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
             print("here is ok 0")
        super.viewDidLoad()
        
        
        
        view.backgroundColor = Colors.init().bgColor
        self.pickAvatarButton.imageView?.contentMode = .scaleAspectFill
        self.pickAvatarButton.layer.cornerRadius = self.pickAvatarButton.frame.size.width / 2;
        self.pickAvatarButton.layer.borderWidth = 5;
        self.pickAvatarButton.clipsToBounds = true
        
        self.pickAvatarButton.layer.borderColor = UIColor.white.cgColor;
        self.usernameField.delegate = self      

        print("here is ok 1")
        let image = myAvatar?.alpha(0.2)
        print("here is ok 2")
        self.pickAvatarButton.setBackgroundImage(image, for: UIControlState())
        
        
         print("here is ok 3")
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
