//
//  AGTLibraryTableViewController.swift
//  HackerBooks
//
//  Created by Charles Moncada on 30/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import UIKit

class AGTLibraryTableViewController: UITableViewController {

    //MARK: - Properties
    // We make it var because the model will change
    var model : AGTLibrary
    
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Number of tags in the library
        return model.tagCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of Books for a specific tag
        let sectionTag = model.tag(atIndex: section)
        return model.bookCount(forTag: sectionTag!)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Get the book
        let sectionTag = model.tag(atIndex: indexPath.section)
        let book = model.book(atIndex: indexPath.row, forTag:sectionTag!)
        
        // Configure the cell...
        let cell:AGTLibraryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AGTLibraryTableViewCell
        //ver el otro metodo
//        if cell == nil{
//            cell = AGTLibraryTableViewCell()
//        }
        
        // Sync book -> cell
//        cell.bookImage.image = book?.image_url
        let data = NSData(contentsOfURL: (book?.image_url)!)
        cell.bookImage.image = UIImage(data: data!)
        cell.bookTitle.text = book?.title
        cell.bookAuthors.text = book?.authors
        
        return cell
    }
     override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.tag(atIndex: section)?.uppercaseString
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Which book
        let sectionTag = model.tag(atIndex: indexPath.section)
        let book = model.book(atIndex: indexPath.row, forTag:sectionTag!)
        // Create the BookVC
        let bookVC = AGTBookViewController(model: book!)
        // Make a push to the NavigationViewControler
        navigationController?.pushViewController(bookVC, animated: true)

    }
    
}
