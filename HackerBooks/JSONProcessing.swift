//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Charles Moncada on 27/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import Foundation
import UIKit

/*
 {
 "authors": "Scott Chacon, Ben Straub",
 "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
 "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
 "tags": "version control, git",
 "title": "Pro Git"
 }
 */

//MARK: Aliases

typealias JSONObject        = AnyObject
typealias JSONDictionary    = [String : JSONObject]
typealias JSONArray         = [JSONDictionary]


//MARK: Decodification

func decode(agtBook json: JSONDictionary) throws -> AGTBook {
    
    //We dont need to split the String in an Array for this stage, perhaps as future functionality
    guard let authors = json["authors"] as? String else{
        throw HackerBooksError.WrongJSONFormat
    }
    
    guard let imageURLString = json["image_url"] as? String,
        image_url = NSURL(string: imageURLString) else {
        throw HackerBooksError.WrongURLFormatForJSONResource
    }
    
    guard let pdfURLString = json["pdf_url"] as? String,
        pdf_url = NSURL(string: pdfURLString) else {
            throw HackerBooksError.WrongURLFormatForJSONResource
    }

    guard let tags = json["tags"] as? String else{
        throw HackerBooksError.WrongJSONFormat
    }
    
    guard let title = json["title"] as? String else {
        throw HackerBooksError.WrongJSONFormat
    }
    
    let favorite = false
    
    return AGTBook(title: title, authors: authors, tags: tags, image_url: image_url, pdf_url: pdf_url, favorite: favorite)
    
}

//decode function with optional
func decode(agtBook json: JSONDictionary?) throws -> AGTBook {
    if case .Some(let jsonDict) = json {
        return try decode(agtBook: jsonDict)
    } else {
        throw HackerBooksError.nilJSONObject
    }
}

//MARK: Loading and Saving Utils

//Local file loading
func loadJSONLocally() throws -> JSONArray{
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let writePath = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent("books_readable.json")
    if let data = NSData(contentsOfURL: writePath),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        return array
    } else {
        throw HackerBooksError.jsonParsingError
    }
}

// Remote loading
func loadJSONFromRemoteFile(atURL inputUrl: String) throws -> JSONArray{
    if let url = NSURL(string: inputUrl),
        data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray {
        saveData(data)
        return array
    } else {
        throw HackerBooksError.jsonParsingError
    }
}

// Sandbox saving

// falta hacerlo mas generico
func saveData(data: NSData){
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let writePath = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent("books_readable.json")
    data.writeToURL(writePath, atomically: false)
}


//MARK: - Local path utils
func sandboxPath(forFile file:String) -> String{
    // Get the Sandbox path, every time the app starts, it changes
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let filePath = "/" + file
    let writePath = documents.stringByAppendingString(filePath)
    
    return writePath
}

