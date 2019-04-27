//
//  ViewController.swift
//  swiftfordeeplearning
//
//  Created by dogukan demirci on 4/25/19.
//  Copyright © 2019 dogukan demirci. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var imageDetails = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    @objc func selectImage()
    {
        let pickerController=UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController,animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        predict(image: imageView.image!)
        textView.text = self.imageDetails
    }
    func predict(image:UIImage)
    {
        self.imageDetails = ""
        do
        {
            let model = try! VNCoreMLModel(for: fashionCNN().model)
            let request = VNCoreMLRequest(model: model)
            {(request,error)in
                
                if var results = request.results as? [VNClassificationObservation]
                {
                    let x = results[0]
                    self.imageDetails += (x.identifier + ("  "+(String(x.confidence*100))))
                    
                }
            }
            request.imageCropAndScaleOption = .centerCrop
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            do
            {
                try handler.perform([request])
            } catch
            {
                print(error)
            }
        }
    }


}

