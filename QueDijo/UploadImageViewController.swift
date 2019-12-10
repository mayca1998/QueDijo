//
//  UploadImageViewController.swift
//  QueDijo
//
//  Created by Maria Hernandez on 11/30/19.
//  Copyright © 2019 Maria Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseMLVision



class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var myImage:UIImage?
    var textRecognizer: VisionTextRecognizer!
    
    @IBAction func selectImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        } else {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @IBOutlet weak var UploadImage: UIImageView!
    
    
    
    @IBAction func save(_ sender: Any) {
       // guard let uid = Auth.auth().currentUser?.uid else { return }
        //Implement image download
    }
    
    @IBAction func uploadImage(_ sender: Any) {
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        // Get the image captured by the UIImagePickerController
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Do something with the images (based on your use case)
        UploadImage.image = selectedImage
        myImage = selectedImage
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func translateImage(_ sender: Any) {
        
        let visionImage = VisionImage(image: UploadImage.image!)
        textRecognizer.process(visionImage) { (features, error) in
        }
    }
    
        
        
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vision = Vision.vision()
        textRecognizer =  vision.onDeviceTextRecognizer()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
