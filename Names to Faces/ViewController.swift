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
        self.collectionView.backgroundColor = UIColor.orangeColor()
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
        return self.people.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCellIdentifier", forIndexPath: indexPath) as! PersonCollectionViewCell
        
        let person = self.people[indexPath.item]
        
        cell.nameLabel.text = person.name
        
        let infoPath = self.getDocumentsDirectory().stringByAppendingPathComponent(person.imageName)
        cell.imageView.image = UIImage(named: infoPath)
        
        cell.imageView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3).CGColor
        cell.imageView.layer.borderWidth = 2.0
        cell.imageView.layer.cornerRadius = 3.0
        cell.layer.cornerRadius = 7.0
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedPerson = self.people[indexPath.item]
        
        let alertController = UIAlertController(title: "Let's give this person a name!", message: "What do you have in mind?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            
            // option 1:1 to disable save button while text field is empty [observing notification way]
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTextFieldTextDidChangeNotification:", name: UITextFieldTextDidChangeNotification, object: textField)
            
            // option 2:1 to disable save button while text field is empty [target -> action way]
            //textField.addTarget(self, action: "alertTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { [unowned self, alertController] _ -> Void in
            let newName = alertController.textFields![0] as UITextField
            selectedPerson.name = newName.text!
            
            self.collectionView.reloadData()
        }))
        
        alertController.actions[1].enabled = false
        self.presentViewController(alertController, animated: true, completion: nil)
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
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    // option 1 to disable save button while text field is empty
    func alertTextFieldDidChange(sender: UITextField) {
        if let alertController = self.presentedViewController as? UIAlertController {
            let nameTextField = alertController.textFields
            let saveAlertAction = alertController.actions
            saveAlertAction[1].enabled = !nameTextField![0].text!.isEmpty
        }
    }
    
    // option 2 to disable save button while text field is empty
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        if let alertController = self.presentedViewController as? UIAlertController {
            let saveAlertAction = alertController.actions
            saveAlertAction[1].enabled = !textField.text!.isEmpty
        }
    }
}

