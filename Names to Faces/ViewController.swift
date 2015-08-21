//
//  ViewController.swift
//  Names to Faces
//
//  Created by Yohannes Wijaya on 8/20/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewPerson")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Stored Properties
    
    var people = Array<Person>()
    
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
    
    // MARK: - Optional UIImagePickerController Delegate Methods
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage!
        
        if let possibleNewImage = info["UIImagePickerControllerEditedImage"] as? UIImage { newImage = possibleNewImage }
        else if let possibleNewImage = info["UIImagePickerControllerOriginalImage"] as? UIImage { newImage = possibleNewImage }
        else { return }
        
        let imageName = NSUUID().UUIDString
        let imagePath = self.getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        print(imagePath)
        let jpegData = UIImageJPEGRepresentation(newImage, 80.0)
        jpegData?.writeToFile(imagePath, atomically: true)
        
        let newPerson = Person(name: "Unregistered", imageName: imageName)
        self.people.append(newPerson)
        self.collectionView.reloadData()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Custom Methods
    
    func addNewPerson() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as [String]
        print(paths)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

}

