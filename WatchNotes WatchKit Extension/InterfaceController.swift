//
//  InterfaceController.swift
//  HelloAppleWatch WatchKit Extension
//
//  Created by Mohammad AZam on 11/19/14.
//  Copyright (c) 2014 AzamSharp Consulting LLC. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController,NSFilePresenter {
    
    @IBOutlet var tableView :WKInterfaceTable?
    
    var notes :NSMutableArray?
    
    override init(context: AnyObject?) {
        // Initialize variables here.
        super.init(context: context)
        
        NSFileCoordinator.addFilePresenter(self)
        
        updateNotes()
        
    }
    
    var presentedItemURL: NSURL? {
        
        let groupURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.watchnotes")
        let fileURL = groupURL?.URLByAppendingPathComponent("notes.bin")
        
        return fileURL!
        
    }
    
    var presentedItemOperationQueue: NSOperationQueue {
        
        return NSOperationQueue.mainQueue()
    }
    
    private func updateNotes() {
        
        let fileCoordinator = NSFileCoordinator()
        var note :String?
        
        fileCoordinator.coordinateReadingItemAtURL(presentedItemURL!, options: nil, error: nil) { (newURL :NSURL!) -> Void in
            
            let savedData = NSData(contentsOfURL: newURL)
            
            if savedData == nil {
                self.notes = NSMutableArray()
            }
            else
            {
                self.notes = NSKeyedUnarchiver.unarchiveObjectWithData(savedData!) as? NSMutableArray
                
                self.tableView?.setNumberOfRows(self.notes!.count, withRowType: "NotesTableRowController")
                
                for (index,value) in enumerate(self.notes!) {
                    
                    let row = self.tableView?.rowControllerAtIndex(index) as NotesTableRowController
                    
                    row.noteTitleLabel?.setText(value as? String)
                    
                }
                
            }
            
        }
        
        
    }
    
    func presentedItemDidChange() {
        
        updateNotes()
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    
}
