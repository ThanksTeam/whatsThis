//
//  2ndviewCon.swift
//  whatsThis
//
//  Created by Gunyoung Park on 11/26/21.
//

import UIKit
import CoreML
import Vision

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var myPhoto: UIImageView!
    @IBOutlet var lblResult: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        detectImageContent()
    }

    func detectImageContent() {
        lblResult.text = "Thinking..."
        let mlmodel = Resnet50().model
        //Create model instance
        guard let model = try? VNCoreMLModel(for: mlmodel) else {
            fatalError("Failed to load model")
        }

        //vision request
        //Request CoreML and retrieve the results
        //VNClassificationObservation: check the result of the image analyzation
        let request = VNCoreMLRequest(model: model) {[weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
                else {
                    fatalError("Unexpected results")
            }

            // Update the output on the screen
            // show the accuracy
            DispatchQueue.main.async { [weak self] in
                self?.lblResult.text = "\(topResult.identifier) with \(Int(topResult.confidence * 100))% confidence"
            }
        }

        guard let ciImage = CIImage(image: self.myPhoto.image!)
            else { fatalError("Cant create CIImage from UIImage") }

        // Run image analysis on the background
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }

    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func pickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            myPhoto.contentMode = .scaleAspectFit
            myPhoto.image = pickedImage
        }
        else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myPhoto.contentMode = .scaleAspectFit
            myPhoto.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)

        detectImageContent()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
