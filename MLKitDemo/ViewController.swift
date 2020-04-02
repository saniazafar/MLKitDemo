//
//  ViewController.swift
//  MLKitDemo
//
//  Created by sania zafar on 01/04/2020.
//  Copyright © 2020 sania zafar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let vision = Vision.vision()
    var textRecognizer: VisionTextRecognizer?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.image"]
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = ["public.image"]
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func recognizeText(_ sender: Any) {
        textRecognizer = vision.onDeviceTextRecognizer()
        guard let image = self.imageView.image else {
            
            return
        }
        
        let visionImage = VisionImage(image: image)
        textRecognizer?.process(visionImage) { (recognizedText, error) in
            guard error == nil, let text = recognizedText else {
                print(error?.localizedDescription ?? "Unknown")
                
                return
            }
            
            self.showRecognizedText(text: text.text)
        }
    }
    
    private func showRecognizedText(text: String) {
        let alertController = UIAlertController(title: "Your Text is", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            
            return
        }
        picker.dismiss(animated: true, completion: nil)
        self.imageView.image = image
    }
    
}

