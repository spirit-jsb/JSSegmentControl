//
//  Child3ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/20.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class Child3ViewController: UIViewController {

    // MARK:
    @IBOutlet weak var button: UIButton!
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load \(#file)")
    }
    
    // MARK:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will Appear \(#file)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View Did Appear \(#file)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View Will Disappear \(#file)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View Did Disappear \(#file)")
    }
    
    deinit {
        print("Deinit \(#file)")
    }
    
    // MARK:
    @IBAction func buttonPressed(_ sender: UIButton) {
        let show = ShowViewController()
        self.show(show, sender: sender)
    }
}
