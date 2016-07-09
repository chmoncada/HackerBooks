//
//  AGTBookViewController.swift
//  HackerBooks
//
//  Created by Charles Moncada on 28/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import UIKit

let favoriteArrayDidChange = "Favorites Array did change"
let favKey = "key"

class AGTBookViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var bookAuthors: UILabel!
    
    @IBOutlet weak var bookTags: UILabel!
    
    @IBOutlet weak var bookFavoriteControl: AGTStar!
    
    var model : AGTBook
    
    var isFavorite = false
    
    //MARK: - Initialization
    init(model: AGTBook){
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
            }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Syncing
    func syncModelWithView(){
        
        //Navigation Bar title
        self.title = "Book details"
        
        //Book Photo
        loadImage(remoteURL: model.image_url, completion: {(image: UIImage?) in
            self.bookImage.image = image
        })
        //Book Title
        bookTitle.text = model.title
        
        //Book Authors
        bookAuthors.text = model.authors
        
        //Book Tags
        bookTags.text = model.tags
        
        //Status of Favorite Button (change the button status and the value of favorite var)
        isFavorite = model.favorite
        bookFavoriteControl.selected = model.favorite
        
    }
    
    
    //MARK: - Actions
    
    // view pdf button
    @IBAction func displayPDF(sender: AnyObject) {
        
        //Creation of PDFViewer
        let pdfVC = AGTSimplePDFViewController(model: model)
        //Make a push of NavigationCOntroller
        navigationController?.pushViewController(pdfVC, animated: true)
    }
    
    // Favorite button pressed
    @IBAction func favButtonPressed(sender: AnyObject) {
        // Change favorite status of the Book
        isFavorite = !isFavorite
        bookFavoriteControl.selected = isFavorite
        model.favorite = isFavorite

        // Save the name of the book in NSUserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        // Recover the value
        let valueInDefaults = defaults.objectForKey("FavoritesBooks") as? [String] ?? [String]()
        var favoriteArray = [String]()
        // Modification conditional
        if valueInDefaults.contains(model.title) {
            // Erased from array
            favoriteArray = valueInDefaults.filter({$0 != model.title})
        } else {
            // Saved in array
            favoriteArray = valueInDefaults + [model.title]
        }
        // Sorted before saved
        favoriteArray.sortInPlace()
        // Saving the array back to NSUserDefaults
        defaults.setObject(favoriteArray, forKey: "FavoritesBooks")        
        
        // Send the info via notificacion
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: favoriteArrayDidChange, object: self, userInfo: nil)
        nc.postNotification(notif)
        
    }
    
        
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Justo antes de montrarse (después de viewDidLoad)
        // Posiblemente más de una vez
        syncModelWithView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AGTBookViewController: AGTLibraryTableViewControllerDelegate{
    
    func agtLibraryTableViewController(vc : AGTLibraryTableViewController, didSelectBook book: AGTBook){
        // Update the model
        model = book
        //Sync
        syncModelWithView()
    }
    
    
}

