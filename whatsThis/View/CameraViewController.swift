//
//  CameraViewController.swift
//  whatsThis
//
//  Created by 김보민 on 2021/11/28.
//

import AVKit
import UIKit
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let cameraView = UIView()
    
    private var outputLabel: UILabel = {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let photoButton: UIButton = {
        $0.backgroundColor = .gray
        $0.setTitle("Take a photo", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        return $0
    }(UIButton())
    
    let captureSession = AVCaptureSession()
    
    let videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        setup()
        captureSessionSetup()
    }
    
    private func layout() {
        view.addSubview(cameraView)
        view.addSubview(outputLabel)
        view.addSubview(photoButton)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.heightAnchor.constraint(equalToConstant: 500),
            
            outputLabel.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 50),
            outputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            outputLabel.heightAnchor.constraint(equalToConstant: 50),
            
            photoButton.topAnchor.constraint(equalTo: outputLabel.bottomAnchor, constant: 50),
            photoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: 50),
        ])
    }
    
    private func setup() {
        view.backgroundColor = .white
        photoButton.addTarget(self, action: #selector(isClickBack), for: .touchUpInside)
    }
    
    @objc func isClickBack() {
        self.navigationController?.pushViewController(PhotoViewController(), animated: true)
    }
    
    private func captureSessionSetup() {
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)

        videoPreviewLayer.session = captureSession
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        
        cameraView.layer.insertSublayer(videoPreviewLayer, at: 0)
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.cameraView.bounds
        }

        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"videoQueue"))
        captureSession.addOutput(dataOutput)
        
        startCaptureSession()
    }
    
    private func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        
            let request = VNCoreMLRequest(model: model) { (req, err) in
                guard let results = req.results as? [VNClassificationObservation] else { return }
                guard let observation = results.first else { return }

                DispatchQueue.main.async { [weak self] in
                    self?.outputLabel.text = "\(observation.identifier) : \(Int(observation.confidence * 100))%"
                }
            }
            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        }
}
