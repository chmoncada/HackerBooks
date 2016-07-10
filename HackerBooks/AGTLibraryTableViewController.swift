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

class AGTLibraryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Properties
    // We make it var because the model will change
    var model : AGTLibrary
    var favoritesArray : [String]
    var delegate : AGTLibraryTableViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sortingSelector: UISegmentedControl!
    
    @IBAction func changeTable(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    var titleTableSelected : Bool {
        get {
            return sortingSelector.selectedSegmentIndex == 0
        }
    }
    
   
    //MARK: - Initialization
    
    init(model: AGTLibrary) {
        self.model = model
        self.favoritesArray = defaults.objectForKey("FavoritesBooks") as? [String] ?? [String]()
        
        super.init(nibName: "AGTLibraryTableViewController", bundle: nil)
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: selector function
    func favChange(notification: NSNotification) {
        self.favoritesArray = defaults.objectForKey("FavoritesBooks") as? [String] ?? [String]()
        self.tableView.reloadData()
    }


    
    //MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let book : AGTBook?
        // Which book
        if titleTableSelected {
            book = model.book(atIndex: indexPath.row)
        } else {
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
        }
        
        // Tell the delegate
        delegate?.agtLibraryTableViewController(self, didSelectBook: book!)
        // Send info via notifications
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BookDidChangeNotification, object: self, userInfo: [BookKey:book!])
        nc.postNotification(notif)
        
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if titleTableSelected {
            return 1
        } else {
            return model.tagCount + 1
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if titleTableSelected {
            return model.booksCount
        } else {
            // Number of Books for a specific tag
            if section == 0 {
                return favoritesArray.count
            } else {
                let newSection = section - 1
                let sectionTag = model.tag(atIndex: (newSection))
                return model.bookCount(forTag: sectionTag!)
            }
        }
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let book: AGTBook?
        
        if titleTableSelected {
            book = model.book(atIndex: indexPath.row)
 
        } else {

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

        }
        
        
        // Configure the cell...
        let cell:AGTLibraryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AGTLibraryTableViewCell
        
        //Sync the cell with the data
        
        //Initially we start putting a static file in imageview
        cell.bookImage.image = UIImage(named: "emptyBook")
        
        // Carga asyncrona
        loadImage(remoteURL: (book?.image_url)!, completion: {(image: UIImage?) in
            cell.bookImage.image = image
        })
        
        cell.bookTitle.text = book?.title
        cell.bookAuthors.text = book?.authors
        cell.bookFavoriteControl.selected = (book?.favorite)!
        
        return cell
        
    }
    
    //MARK: - Table attributes
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if titleTableSelected {
         return nil
        } else {
            if section == 0 {
                guard favoritesArray.count == 0 else {
                    return "Favorites"
                }
                return nil //to avoid any header
            } else {
                let newSection = section - 1
                return model.tag(atIndex: newSection)
            }
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
            return 100
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let title = UILabel()
        title.textColor = UIColor(red: 1.0, green: 0.737, blue: 0.173, alpha: 1.00)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = title.textColor

    }
}


// MARK: Class extension

extension AGTLibraryTableViewController: AGTLibraryTableViewControllerDelegate{
    
    func agtLibraryTableViewController(vc : AGTLibraryTableViewController, didSelectBook book: AGTBook){
        // Update the model
        let bVC = AGTBookViewController(model: book)
        // Make a push
        navigationController?.pushViewController(bVC, animated: true)
    }
    
    
}

// MARK: - Protocol Definition
protocol AGTLibraryTableViewControllerDelegate {
    func agtLibraryTableViewController(vc : AGTLibraryTableViewController, didSelectBook book: AGTBook)
}


