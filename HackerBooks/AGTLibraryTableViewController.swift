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
let defaults = NSUserDefaults.standardUserDefaults()

class AGTLibraryTableViewController: UITableViewController {

    //MARK: - Properties
    // We make it var because the model will change
    var model : AGTLibrary
    var favoritesArray : [String]
    var delegate : AGTLibraryTableViewControllerDelegate?
    
    //MARK: - Initialization
    init(model: AGTLibrary) {
        self.model = model
        self.favoritesArray = defaults.objectForKey("FavoritesBooks") as? [String] ?? [String]()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Register custom cell
        let nib = UINib(nibName: "AGTLibraryTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(favChange), name: favoriteArrayDidChange, object: nil)
        
    }
    
    func favChange(notification: NSNotification) {
        self.favoritesArray = defaults.objectForKey("FavoritesBooks") as? [String] ?? [String]()
        self.tableView.reloadData()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Which book
        let book : AGTBook?
        if indexPath.section == 0 {
            
            // Get the book
            let BookTitle = favoritesArray[indexPath.row]
            book = model.book(forTitle: BookTitle)
            
        } else {
            
            // Get the book
            let newSection = indexPath.section - 1
            let sectionTag = model.tag(atIndex: newSection)
            book = model.book(atIndex: indexPath.row, forTag:sectionTag!)
            
        }
        
        // Tell the delegate
        delegate?.agtLibraryTableViewController(self, didSelectBook: book!)
        // Send info via notifications
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BookDidChangeNotification, object: self, userInfo: [BookKey:book!])
        nc.postNotification(notif)
        
        
        
        // iPhone test
//        if let bVC = self.delegate as? AGTBookViewController {
//            splitViewController?.showDetailViewController(bVC, sender: nil)
//        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return model.tagCount + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Number of Books for a specific tag
        if section == 0 {
            return favoritesArray.count
        } else {
            // Number of Books for a specific tag
            let newSection = section - 1
            let sectionTag = model.tag(atIndex: (newSection))
            return model.bookCount(forTag: sectionTag!)
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let book: AGTBook?
        if indexPath.section == 0 {
            
            // Get the book
            let BookTitle = favoritesArray[indexPath.row]
            book = model.book(forTitle: BookTitle)

        } else {
            
            // Get the book
            let newSection = indexPath.section - 1
            let sectionTag = model.tag(atIndex: newSection)
            book = model.book(atIndex: indexPath.row, forTag:sectionTag!)

        }
        
        // Configure the cell...
        let cell:AGTLibraryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AGTLibraryTableViewCell
        
        //Sync the cell with the data
        
        //let data = NSData(contentsOfURL: (book?.image_url)!)
        //cell.bookImage.image = UIImage(data: data!)
        cell.bookImage.image = loadImage(remoteURL: (book?.image_url)!)
        cell.bookTitle.text = book?.title
        cell.bookAuthors.text = book?.authors
        cell.bookFavoriteControl.selected = (book?.favorite)!
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            guard favoritesArray.count == 0 else {
                return "FAVORITES"
            }
            return nil //Retornar nil si queremos que no aparezca el titulo
        } else {
            let newSection = section - 1
            return model.tag(atIndex: newSection)?.uppercaseString
        }
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
            return 60
    }

}

extension AGTLibraryTableViewController: AGTLibraryTableViewControllerDelegate{
    
    func agtLibraryTableViewController(vc : AGTLibraryTableViewController, didSelectBook book: AGTBook){
        // Update the model
        let bVC = AGTBookViewController(model: book)
        // Make a push
        navigationController?.pushViewController(bVC, animated: true)
    }
    
    
}


protocol AGTLibraryTableViewControllerDelegate {
    func agtLibraryTableViewController(vc : AGTLibraryTableViewController, didSelectBook book: AGTBook)
}


