//
//  ViewController.swift
//  whatsThis
//
//  Created by Jiyeon Park on 2021-11-27.
//

import AVKit
import UIKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let cameraView = UIView()
    
    private var outputLabel: UILabel = {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    let captureSession = AVCaptureSession()
    
    let videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        captureSessionSetup()
    }
    
    private func layout() {
        view.addSubview(cameraView)
        view.addSubview(outputLabel)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.heightAnchor.constraint(equalToConstant: 600),
            
            outputLabel.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 50),
            outputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            outputLabel.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: 50)
        ])
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
                guard let firstObservation = results.first else { return }

                DispatchQueue.main.async { [weak self] in
                    self?.outputLabel.text = "\(firstObservation.identifier) : \(Int(firstObservation.confidence * 100))%"
                }
            }
            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        }
    
}

