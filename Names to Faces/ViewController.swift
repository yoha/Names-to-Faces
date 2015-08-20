//
//  ViewController.swift
//  Names to Faces
//
//  Created by Yohannes Wijaya on 8/20/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Required UICollectionViewDataSource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let eachCell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCellIdentifier", forIndexPath: indexPath) as! PersonCollectionViewCell
        return eachCell
    }

}

