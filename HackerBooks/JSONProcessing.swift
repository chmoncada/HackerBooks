//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Charles Moncada on 27/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import Foundation
import UIKit


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

//JSON Local file loading
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

//JSON Remote loading
func loadJSONFromRemoteFile(atURL inputUrl: String) throws -> JSONArray{
    if let url = NSURL(string: inputUrl),
        data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray {
        saveData(data, name: "books_readable.json")
        return array
    } else {
        throw HackerBooksError.jsonParsingError
    }
}

func loadPDF(remoteURL url: NSURL, webViewer: UIWebView) throws {
    //Load the PDF
    let nameOfPDF = url.pathComponents?.last
    let fileExist = NSFileManager.defaultManager().fileExistsAtPath(sandboxPath(forFile: nameOfPDF!))
    
    if fileExist {
        
        loadLocalPDF(remoteURL: url, webViewer: webViewer)
        
    } else {
        do{
         try loadRemotePDF(remoteURL: url, webViewer: webViewer)
        } catch {
            throw HackerBooksError.ResourcePointedByURLNotReachable
        }
    }
}

func loadLocalPDF(remoteURL url: NSURL, webViewer: UIWebView) {
    
    let nameOfPDF = url.pathComponents?.last
    let loadPath = sandboxURLPath(forFile: nameOfPDF!)
    let data = NSData(contentsOfURL: loadPath)
    webViewer.loadData(data!, MIMEType: "application/pdf", textEncodingName: "", baseURL: loadPath.URLByDeletingPathExtension!) // sync load, block the app
}

func loadRemotePDF(remoteURL url: NSURL, webViewer: UIWebView) throws {
    
    let nameOfPDF = url.pathComponents?.last
    guard let data = NSData(contentsOfURL: url) else {
        throw HackerBooksError.ResourcePointedByURLNotReachable
    }
    webViewer.loadData(data, MIMEType: "application/pdf", textEncodingName: "", baseURL: url.URLByDeletingPathExtension!) // sync load, block the app
    // save the pdf in the sandbox
    saveData(data, name: nameOfPDF!)
    
}

func loadImage(remoteURL url: NSURL) -> UIImage {
    //Load the PDF
    let nameOfImage = url.pathComponents?.last
    let fileExist = NSFileManager.defaultManager().fileExistsAtPath(sandboxPath(forFile: nameOfImage!))
    var imageView = UIImage()
    
    if fileExist {
        
        let loadPath = sandboxURLPath(forFile: nameOfImage!)
        let data = NSData(contentsOfURL: loadPath)
        imageView = UIImage(data: data!)!
        
    } else {
        
        let data = NSData(contentsOfURL: url)
        imageView = UIImage(data: data!)!
        // save image in the sandbox
        saveData(data!, name: nameOfImage!)

    }
    return imageView
}




// Sandbox utils

func saveData(data: NSData, name: String){
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let writePath = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent(name)
    data.writeToURL(writePath, atomically: false)
}



//MARK: - Local path utils
func sandboxPath(forFile file:String) -> String{
    // Get the Sandbox path, every time the app starts, it changes
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let filePath = "/" + file
    let localPath = documents.stringByAppendingString(filePath)
    
    return localPath
}

func sandboxURLPath(forFile file:String) -> NSURL{
    // Get the Sandbox path, every time the app starts, it changes
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let localPath = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent(file)
    
    return localPath
}

