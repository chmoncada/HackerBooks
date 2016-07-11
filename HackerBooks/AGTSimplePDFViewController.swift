//
//  AGTSimplePDFViewController.swift
//  HackerBooks
//
//  Created by Charles Moncada on 29/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import UIKit

class AGTSimplePDFViewController: UIViewController {

    //MARK: - Properties
    var model : AGTBook
    var download: Download
    
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let fileManager = NSFileManager.defaultManager()
    
    lazy var downloadsSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    @IBOutlet weak var pdfViewer: UIWebView!
    @IBOutlet weak var warningAdvice: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    
    init(model: AGTBook) {
        self.model = model
        self.download = Download(url: model.pdf_url, title: model.title)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Syncing
    func syncModelWithView(){
        
        self.title = "PDF view"

        // Hides the progress bar and label if the file exist locally
        let newDir = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent(model.title)
        let filePath = newDir.URLByAppendingPathComponent((download.url.pathComponents?.last)!)
        if fileManager.fileExistsAtPath(filePath.path!) {
            progressBar.hidden = true
            progressLabel.hidden = true
        }
        
        // Load the PDF
        loadPDF(download, webViewer: pdfViewer, session: downloadsSession)

        
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
        download = Download(url: model.pdf_url, title: model.title)
        progressBar.hidden = false
        progressLabel.hidden = false
        //Sync the view
        syncModelWithView()
    }

}

extension AGTSimplePDFViewController: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        // Update network indicator
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.progressBar.hidden = true
            self.progressLabel.hidden = true
            
        })

        // Move the file from temporal location to sandbox
        if (downloadTask.originalRequest?.URL?.absoluteString) != nil {
            let nameOfPDF = downloadTask.originalRequest?.URL!.pathComponents?.last
            // We create a new folder for each PDF to avoid same PDF names
            let newDir = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent(model.title)
            do {
                try fileManager.createDirectoryAtURL(newDir, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("Could not create Folder: \(error)")
            }
            
            let writePath = newDir.URLByAppendingPathComponent(nameOfPDF!)
            do {
                try fileManager.copyItemAtURL(location, toURL: writePath)
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        // Load the PDF from sandbox
        loadLocalPDF(remoteURL: model.pdf_url, title: model.title, webViewer: pdfViewer)
        
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // Calculate the progress
        download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        // Put total size of file in MB
        let totalSize = NSByteCountFormatter.stringFromByteCount(totalBytesExpectedToWrite, countStyle: NSByteCountFormatterCountStyle.Binary)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.progressBar.progress = self.download.progress
            self.progressLabel.text = String(format: "%.1f%% of %@",  self.download.progress * 100, totalSize)
            
        })

        
    }
    
}


