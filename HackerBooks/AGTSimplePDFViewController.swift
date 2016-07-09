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
    @IBOutlet weak var warningAdvice: UILabel!
    
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
        self.title = "PDF view"
        activityView.startAnimating()
        // Call a loadPDF function
        do {
            try loadPDF(remoteURL: model.pdf_url, webViewer: pdfViewer)
        } catch {
            activityView.stopAnimating()
            activityView.hidesWhenStopped = true
            warningAdvice.text = "PDF file not exist anymore!!"
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
        // Get the userInfo
        let info = notification.userInfo!
        // Get the book
        let book = info[BookKey] as? AGTBook
        // Update the model
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
