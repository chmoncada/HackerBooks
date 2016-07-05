//
//  AGTSimplePDFViewController.swift
//  HackerBooks
//
//  Created by Charles Moncada on 29/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import UIKit

class AGTSimplePDFViewController: UIViewController, UIWebViewDelegate {

    //MARK: - Properties
    var model : AGTBook
    
    @IBOutlet weak var pdfViewer: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    init(model: AGTBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Syncing
    func syncModelWithView(){
        
        pdfViewer.delegate = self
        activityView.startAnimating()
        
        //Load the PDF
        let nameOfPDF = model.pdf_url.pathComponents?.last
        print(nameOfPDF)
        let fileExist = NSFileManager.defaultManager().fileExistsAtPath(sandboxPath(forFile: nameOfPDF!))
        print(sandboxPath(forFile: nameOfPDF!))
        print(fileExist)
        
        if fileExist {
            print("lo saco del sandbox...")
            let loadPath = sandboxURLPath(forFile: nameOfPDF!)
            let data = NSData(contentsOfURL: loadPath)
            pdfViewer.loadData(data!, MIMEType: "application/pdf", textEncodingName: "", baseURL: loadPath.URLByDeletingPathExtension!) // sync load, block the app
        } else {
            print("lo descargo de Internet")
            let data = NSData(contentsOfURL: model.pdf_url)
            pdfViewer.loadData(data!, MIMEType: "application/pdf", textEncodingName: "", baseURL: model.pdf_url.URLByDeletingPathExtension!) // sync load, block the app
            //lo grabo en el sandbox
            saveData(data!, name: nameOfPDF!)
            print("Grabado en el sandbox")
            let fileSaved = NSFileManager.defaultManager().fileExistsAtPath(sandboxPath(forFile: nameOfPDF!))
            print(fileSaved)
            
        }
       
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // put an observer to notifications
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(bookDidChange), name: BookDidChangeNotification, object: nil)
        syncModelWithView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove observer
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }
    
    //MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Utils
    func bookDidChange(notification: NSNotification) {
        // Sacar el userInfo
        let info = notification.userInfo!
        //Sacar el libro
        let book = info[BookKey] as? AGTBook
        //Actualizar el modelo
        model = book!
        //Sync the view
        syncModelWithView()
    }
    
    
    //MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        // Stop the activity view and hide it
        activityView.stopAnimating()
        activityView.hidesWhenStopped = true
    }

}
