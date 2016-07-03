//
//  AGTBookViewController.swift
//  HackerBooks
//
//  Created by Charles Moncada on 28/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import UIKit

class AGTBookViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var bookAuthors: UILabel!
    
    @IBOutlet weak var bookTags: UILabel!
    
    @IBOutlet weak var bookFavorite: UIButton!
    
    var model : AGTBook
    
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
        
        //Titulo del navigation bar
        self.title = model.title
        
        //Book Photo
        // Carga asincrona, arreglar con chequeo de que el fichero ya existe en los recursos!!!
        let data = NSData(contentsOfURL: model.image_url)
        bookImage.image = UIImage(data: data!)
        
        //Book Title
        bookTitle.text = model.title
        
        //Book Authors
        bookAuthors.text = model.authors
        
        //Book Tags
        bookTags.text = model.tags
    }
    
    
    //MARK: - Actions
    // view pdf button
    @IBAction func displayPDF(sender: AnyObject) {
        
        //Creation of PDFViewer
        let pdfVC = AGTSimplePDFViewController(model: model)
        //Make a push of NavigationCOntroller
        navigationController?.pushViewController(pdfVC, animated: true)
    }
    
    //  favorite button
    @IBAction func favIconTapped(sender: AnyObject) {
        print("HOLA")
    
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

