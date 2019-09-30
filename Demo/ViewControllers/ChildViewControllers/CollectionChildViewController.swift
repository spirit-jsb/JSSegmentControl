//
//  CollectionChildViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2019/9/24.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class CollectionChildViewController: UIViewController {

    // MARK:
    private let identifier = "com.sibo.jian.segment.collection.child"
    
    weak var childScrollDelegate: ChildScrollViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CollectionChildViewController: UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.red
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension CollectionChildViewController: UICollectionViewDelegate {
    
    // MARK: UICollectionViewDelegate
}

extension CollectionChildViewController: UIScrollViewDelegate {
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.childScrollDelegate?.childScrollViewDidScroll(scrollView)
    }
}
