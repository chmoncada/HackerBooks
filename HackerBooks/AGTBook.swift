//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Charles Moncada on 27/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import Foundation

class AGTBook {
    
    //MARK: - Stored Properties
    let title: String
    let authors: String
    let tags: String
    let image_url: NSURL
    let pdf_url: NSURL
    var favorite : Bool
    //We take the assumption that all fields are mandatory
    
    //falta anadir el link de favoritos
    
    //MARK: Initialization
    init(title:String, authors:String, tags:String, image_url: NSURL, pdf_url: NSURL, favorite: Bool){
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image_url = image_url
        self.pdf_url = pdf_url
        self.favorite = favorite
    }
}

extension AGTBook: CustomStringConvertible{
    
    var description: String {
        get{
            return "<\(self.dynamicType): \(title)>"
        }
    }
}