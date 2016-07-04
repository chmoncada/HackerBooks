//
//  AGTLibraryTableViewController.swift
//  HackerBooks
//
//  Created by Charles Moncada on 30/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import UIKit

let BookDidChangeNotification = "Selected Book did change"
let BookKey = "Key"

class AGTLibraryTableViewController: UITableViewController {

    //MARK: - Properties
    // We make it var because the model will change
    var model : AGTLibrary
    var delegate : AGTLibraryTableViewControllerDelegate?
    
    //MARK: - Initialization
    init(model: AGTLibrary) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register custom cell
        let nib = UINib(nibName: "AGTLibraryTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Which book
        let newSection = indexPath.section - 1
        let sectionTag = model.tag(atIndex: newSection)
        let book = model.book(atIndex: indexPath.row, forTag:sectionTag!)
        // Tell the delegate
        delegate?.agtLibraryTableViewController(self, didSelectBook: book!)
        // Send info via notifications
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BookDidChangeNotification, object: self, userInfo: [BookKey:book!])
        nc.postNotification(notif)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Number of tags in the library
        //return model.tagCount
        //PRUEBA
        // con favorites section
        return model.tagCount + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of Books for a specific tag
        //let sectionTag = model.tag(atIndex: section)
        //return model.bookCount(forTag: sectionTag!)
        //PRUEBA CON FAVORITOS
        if section == 0 {
            return 1
        } else {
            // Number of Books for a specific tag
            let newSection = section - 1
            let sectionTag = model.tag(atIndex: (newSection))
            return model.bookCount(forTag: sectionTag!)
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        // Get the book
//        let sectionTag = model.tag(atIndex: indexPath.section)
//        let book = model.book(atIndex: indexPath.row, forTag:sectionTag!)
//        
//        // Configure the cell...
//        let cell:AGTLibraryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AGTLibraryTableViewCell
//
//        //Sync the cell with the data
//        let data = NSData(contentsOfURL: (book?.image_url)!)
//        cell.bookImage.image = UIImage(data: data!)
//        cell.bookTitle.text = book?.title
//        cell.bookAuthors.text = book?.authors
//        //print((book?.title)!," status favorito: ", (book?.favorite)!)
//        cell.bookFavoriteControl.selected = (book?.favorite)!
//        
//        return cell
        
        // PRUEBA CON FAVORITOS
        if indexPath.section == 0 {
            
            // Configure the cell...
            let cell:AGTLibraryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AGTLibraryTableViewCell
            
            //Sync the cell with the data
//            let data = NSData(contentsOfURL: (book?.image_url)!)
            cell.bookImage.image = UIImage(named: "star")
            cell.bookTitle.text = "PRUEBA"
            cell.bookAuthors.text = "PRUEBA"
            cell.bookFavoriteControl.selected = true
            
            return cell

            
        } else {
            // Get the book
            let newSection = indexPath.section - 1
            let sectionTag = model.tag(atIndex: newSection)
            let book = model.book(atIndex: indexPath.row, forTag:sectionTag!)
            
            // Configure the cell...
            let cell:AGTLibraryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AGTLibraryTableViewCell
            
            //Sync the cell with the data
            let data = NSData(contentsOfURL: (book?.image_url)!)
            cell.bookImage.image = UIImage(data: data!)
            cell.bookTitle.text = book?.title
            cell.bookAuthors.text = book?.authors
            //print((book?.title)!," status favorito: ", (book?.favorite)!)
            cell.bookFavoriteControl.selected = (book?.favorite)!
            
            return cell

        }
        
        
    }
     override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //return model.tag(atIndex: section)?.uppercaseString
        
        //PRUEBA
        if section == 0 {
            return "FAVORITOS"
        } else {
            return model.tag(atIndex: section)?.uppercaseString
        }
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
}

protocol AGTLibraryTableViewControllerDelegate {
    func agtLibraryTableViewController(vc : AGTLibraryTableViewController, didSelectBook book: AGTBook)
}


