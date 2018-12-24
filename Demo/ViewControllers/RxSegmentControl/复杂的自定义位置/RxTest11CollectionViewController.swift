//
//  RxTest11CollectionViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/24.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class RxTest11CollectionViewController: UICollectionViewController {
    
    // MARK:
    weak var scrollDelegate: ChildScrollViewDelegate?
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load \(#file)")
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
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
}

extension RxTest11CollectionViewController {
    
    // MARK: UICollectionDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
        cell.contentView.backgroundColor = UIColor.red
        return cell
    }
}

extension RxTest11CollectionViewController {
    
    // MARK: UICollectionDelegate
    
}

extension RxTest11CollectionViewController {
    
    // MARK: UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.childScrollViewDidScroll(scrollView)
    }
}
