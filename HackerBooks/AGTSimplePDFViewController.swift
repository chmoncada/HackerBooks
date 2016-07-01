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
        
        syncModelWithView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        // Stop the activity view and hide it
        activityView.stopAnimating()
        activityView.hidesWhenStopped = true
    }

}
