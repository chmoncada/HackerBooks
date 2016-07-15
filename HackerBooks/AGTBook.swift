//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Charles Moncada on 27/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import Foundation
import UIKit

let modelDidChange = "Model did change"
let modKey = "key"

class AGTBook {
    
    //MARK: - Stored Properties
    let title: String
    let authors: String
    let tags: String
    let image_url: NSURL
    var image: UIImage = UIImage()
    let pdf_url: NSURL
    var favorite : Bool
    //We take the assumption that all fields are mandatory
    
        
    //MARK: Initialization
    init(title:String, authors:String, tags:String, image_url: NSURL, pdf_url: NSURL, favorite: Bool){
        
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image_url = image_url
        self.pdf_url = pdf_url
        self.favorite = favorite
        //Initially we start putting a static file in imageview
        self.image = UIImage(named: "emptyBook")!
        
        // Async Load of Image
        loadImage(remoteURL: image_url, completion: {(image: UIImage?) in
            self.image = image!
            // Send the notificacion that the model changed
            let nc = NSNotificationCenter.defaultCenter()
            let notif = NSNotification(name: modelDidChange, object: self, userInfo: nil)
            nc.postNotification(notif)
            
        })
        
        
    }
}

extension AGTBook: CustomStringConvertible{
    
    var description: String {
        get{
            return "<\(self.dynamicType): \(title)>"
        }
    }
}