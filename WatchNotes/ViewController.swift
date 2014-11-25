//
//  ViewController.swift
//  HelloAppleWatch
//
//  Created by Mohammad AZam on 11/19/14.
//  Copyright (c) 2014 AzamSharp Consulting LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController,NSFilePresenter {
    
    @IBOutlet var noteTextField :UITextField?
    var notes :NSMutableArray?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSFileCoordinator.addFilePresenter(self)
        
    }
    
    var presentedItemURL: NSURL? {
        
        let groupURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.watchnotes")
        let fileURL = groupURL?.URLByAppendingPathComponent("notes.bin")
        
        return fileURL!
        
    }
    
    var presentedItemOperationQueue: NSOperationQueue {
        
        return NSOperationQueue.mainQueue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeData(sender :AnyObject) {
        
        let fileCoordinator = NSFileCoordinator()
        
        fileCoordinator.coordinateWritingItemAtURL(presentedItemURL!, options: nil, error: nil) { ( newURL :NSURL!) -> Void in
            
            self.notes = NSMutableArray() // writing an empty array
            
            let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.notes!)
            let success = saveData.writeToURL(newURL, atomically: true)
        }
        
        
    }
    
    @IBAction func saveData(sender :AnyObject) {
        
        let fileCoordinator = NSFileCoordinator()
        let note = self.noteTextField?.text
        
        // get the notes array
        fileCoordinator.coordinateReadingItemAtURL(presentedItemURL!, options: nil, error: nil) { (newURL :NSURL!) -> Void in
            
            let savedData = NSData(contentsOfURL: newURL)
            
            if savedData == nil {
                self.notes = NSMutableArray()
            }
            else {
                
                self.notes = NSKeyedUnarchiver.unarchiveObjectWithData(savedData!) as? NSMutableArray
            }
            
        }
        
        
        // write note into the notes array
        fileCoordinator.coordinateWritingItemAtURL(presentedItemURL!, options: nil, error: nil) { ( newURL :NSURL!) -> Void in
            
            self.notes?.addObject(note!)
            
            let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.notes!)
            let success = saveData.writeToURL(newURL, atomically: true)
        }
        
    }
    
}

