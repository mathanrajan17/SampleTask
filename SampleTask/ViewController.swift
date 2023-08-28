//
//  ViewController.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 25/08/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMapView(_ sender: Any) {
        if let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.mapViewController) as? MapViewController {
            self.navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
    @IBAction func openListView(_ sender: Any) {
        if let listViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.profileListViewController) as? ProfileListViewController {
            self.navigationController?.pushViewController(listViewController, animated: true)
        }
    }
}

