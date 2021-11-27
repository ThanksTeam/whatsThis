//
//  viewCon.swift
//  whatsThis
//
//  Created by Gunyoung Park on 11/26/21.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet var gifview: UIImageView!

    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gifview.loadGif(name: "40")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
