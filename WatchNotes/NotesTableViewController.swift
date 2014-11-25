//
//  NotesTableViewController.swift
//  WatchNotes
//
//  Created by Mohammad AZam on 11/22/14.
//  Copyright (c) 2014 AzamSharp Consulting LLC. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController,UITextFieldDelegate,NSFilePresenter {

    var notes :NSMutableArray = NSMutableArray()
    var fileCoordinator = NSFileCoordinator()
    
    override func viewDidLoad() {

        super.viewDidLoad()

        
        // delete all existing notes 
        deleteAllNotes()
        
        // populate the notes and update the tableView
        populateNotes()
        
    }
    
    private func deleteAllNotes() {
        
        fileCoordinator.coordinateWritingItemAtURL(presentedItemURL!, options: nil, error: nil) { ( newURL :NSURL!) -> Void in
            
            self.notes = NSMutableArray() // writing an empty array
            
            let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.notes)
            let success = saveData.writeToURL(newURL, atomically: true)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    var presentedItemURL: NSURL? {
        
        let groupURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.watchnotes")
        let fileURL = groupURL?.URLByAppendingPathComponent("notes.bin")
        
        return fileURL!
        
    }
    
    var presentedItemOperationQueue: NSOperationQueue {
        
        return NSOperationQueue.mainQueue()
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.notes.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 44))
        headerView.layer.borderWidth = 0.5
        headerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let newNoteTextField = UITextField(frame: CGRectMake(10, 0, self.view.bounds.width, 44))
        newNoteTextField.placeholder = "Enter new note"
        newNoteTextField.delegate = self
        newNoteTextField.backgroundColor = UIColor.whiteColor()
       
        newNoteTextField.returnKeyType = UIReturnKeyType.Done
        
        headerView.addSubview(newNoteTextField)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as UITableViewCell
        
        var note = self.notes[indexPath.row] as String
        
        cell.textLabel?.text = note
        
        return cell
        
    }
    
    private func populateNotes() {
        
        // get the notes array
        fileCoordinator.coordinateReadingItemAtURL(presentedItemURL!, options: nil, error: nil) { (newURL :NSURL!) -> Void in
            
            let savedData = NSData(contentsOfURL: newURL)
            
            if savedData == nil {
                self.notes = NSMutableArray()
            }
            else {
                
                self.notes = NSKeyedUnarchiver.unarchiveObjectWithData(savedData!) as NSMutableArray
            }
            
        }
    }
    
    private func saveNote(note :String) {
        
        // write note into the notes array
        fileCoordinator.coordinateWritingItemAtURL(presentedItemURL!, options: nil, error: nil) { ( newURL :NSURL!) -> Void in
            
            self.notes.addObject(note)
            
            let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.notes)
            let success = saveData.writeToURL(newURL, atomically: true)
        }
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
    
        saveNote(textField.text)
        
        // reload table 
        self.tableView.reloadData()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    

   
}
