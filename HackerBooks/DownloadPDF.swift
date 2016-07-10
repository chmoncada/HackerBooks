//
//  DownloadPDF.swift
//  HackerBooks
//
//  Created by Charles Moncada on 10/07/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import Foundation

class Download: NSObject {
    var url: NSURL
    //var isDownloading = false - Future implementation
    var progress: Float = 0.0
    
    var downloadTask: NSURLSessionDownloadTask?
    //var resumeData: NSData? - Future implementation
    
    init(url: NSURL) {
        self.url = url
    }

}
