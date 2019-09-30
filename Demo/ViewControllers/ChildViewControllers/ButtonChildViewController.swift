//
//  ButtonChildViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2019/9/24.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class ButtonChildViewController: UIViewController {
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:
    @IBAction func pushChildViewControllerTrigger(_ sender: UIButton) {
        let childViewController = UIStoryboard(name: "Child", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController")
        self.navigationController?.pushViewController(childViewController, animated: true)
    }
}
