//
//  photoCon.swift
//  whatsThis
//
//  Created by Gunyoung Park on 11/26/21.
//

import UIKit
import AVKit
import Vision

class PhotoViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet var photoView: UIImageView!

    @IBOutlet var photoLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        photoLabel.text = "Waiting..."
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){

        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}

        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
        let request = VNCoreMLRequest(model: model)
        { (finishedReq, err) in

            guard let results = finishedReq.results as? [VNClassificationObservation]
                else { return }

            guard let firstObservation = results.first else { return}

            print(firstObservation.identifier, firstObservation.confidence)

            DispatchQueue.main.async { [weak self] in
                self?.photoLabel.text = "\(firstObservation.identifier) : \(Int(firstObservation.confidence * 100))%"
            }
        }

        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
