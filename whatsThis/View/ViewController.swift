//
//  ViewController.swift
//  whatsThis
//
//  Created by Jiyeon Park on 2021-11-27.
//

import UIKit

class ViewController: UIViewController {
    
    private let gifView = UIImageView()
    
    private let nextButton: UIButton = {
        $0.backgroundColor = .black
        $0.setTitle("START", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        setup()
        loadGifFile()
    }
    
    private func layout() {
        view.addSubview(gifView)
        view.addSubview(nextButton)
        gifView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gifView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gifView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nextButton.topAnchor.constraint(equalTo: gifView.bottomAnchor, constant: 100),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 50),
            nextButton.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -100),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
        ])
    }
    
    private func setup() {
        view.backgroundColor = .white
        nextButton.addTarget(self, action: #selector(isClickNext), for: .touchUpInside)
    }
    
    @objc func isClickNext() {
        self.navigationController?.pushViewController(CameraViewController(), animated: true)
    }
    
    private func loadGifFile() {
        gifView.loadGif(name: "AlVw")
    }
}
