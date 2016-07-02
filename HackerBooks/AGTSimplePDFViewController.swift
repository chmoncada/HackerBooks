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
        pdfViewer.loadData(NSData(contentsOfURL: model.pdf_url)!, MIMEType: "application/pdf", textEncodingName: "", baseURL: model.pdf_url.URLByDeletingPathExtension!) // sync load, block the app
        
//        if let pdfURL = NSBundle.mainBundle().URLForResource("c21_01_01_cover3", withExtension: "pdf", subdirectory: nil, localization: nil),data = NSData(contentsOfURL: pdfURL), baseURL = pdfURL.URLByDeletingLastPathComponent  {
//            let webView = UIWebView(frame: CGRectMake(20,20,self.view.frame.size.width-40,self.view.frame.size.height-40))
//            webView.loadData(data, MIMEType: "application/pdf", textEncodingName:"", baseURL: baseURL)
//            self.view.addSubview(webView)
//        }
//        
        
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
