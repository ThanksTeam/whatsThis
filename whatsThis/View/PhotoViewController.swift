//
//  PhotoViewController.swift
//  whatsThis
//
//  Created by 김보민 on 2021/11/28.
//

import UIKit
import CoreML
import Vision

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let photoView: UIImageView = {
        $0.image = UIImage(named: "cat")
        return $0
    }(UIImageView())
    
    private var outputLabel: UILabel = {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let photoButton: UIButton = {
        $0.backgroundColor = .gray
        $0.setTitle("photo", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        return $0
    }(UIButton())
    
    private let albumButton: UIButton = {
        $0.backgroundColor = .gray
        $0.setTitle("album", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        return $0
    }(UIButton())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        setup()
        detectImageContent()
    }
    
    private func layout() {
        view.addSubview(photoView)
        view.addSubview(photoButton)
        view.addSubview(albumButton)
        view.addSubview(outputLabel)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        albumButton.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 300),
            
            outputLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 50),
            outputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            outputLabel.heightAnchor.constraint(equalToConstant: 50),
            
            photoButton.topAnchor.constraint(equalTo: outputLabel.bottomAnchor, constant: 100),
            photoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoButton.heightAnchor.constraint(equalToConstant: 50),
            
            albumButton.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 100),
            albumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumButton.heightAnchor.constraint(equalToConstant: 50),
            ])
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        photoButton.addTarget(self, action: #selector(isClickPhoto), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(isClickAlbum), for: .touchUpInside)
    }
    
    @objc func isClickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func isClickAlbum() {
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
            photoView.contentMode = .scaleAspectFit
            photoView.image = pickedImage
        }
        else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoView.contentMode = .scaleAspectFit
            photoView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)

        detectImageContent()
    }
    
    func detectImageContent() {
        outputLabel.text = "Thinking..."
        let mlmodel = Resnet50().model
        guard let model = try? VNCoreMLModel(for: mlmodel) else { return }

        let request = VNCoreMLRequest(model: model) {[weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first
                else { fatalError("Unexpected results") }

            DispatchQueue.main.async { [weak self] in
                self?.outputLabel.text = "\(topResult.identifier) : \(Int(topResult.confidence * 100))%"
            }
        }

        guard let ciImage = CIImage(image: self.photoView.image!)
            else { fatalError("Cant create CIImage from UIImage") }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
}
