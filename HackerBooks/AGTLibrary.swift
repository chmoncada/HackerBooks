//
//  AGTLibrary.swift
//  HackerBooks
//
//  Created by Charles Moncada on 27/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import Foundation

class AGTLibrary {
    
    //MARK: Utility types
    typealias AGTBooksArray         =   [AGTBook]
    typealias AGTTagsArray          =   [String]
    //typealias AGTBooksDictionary    =   [String : AGTBooksArray]

    //MARK: - Properties
    //Books Array
    var books: AGTBooksArray
    var favoritesArray : [String]
    
    //Tags array
    var libraryCleanandSortedTags: AGTTagsArray = []
    
    //MARK: - Initialization
    init(arrayOfBooks : AGTBooksArray) {
        
        books = arrayOfBooks
        let defaults = NSUserDefaults.standardUserDefaults()
        favoritesArray = defaults.objectForKey("FavoritesBooks") as? [String] ?? [String]()
        //Creation of tags array
        var libraryTags = AGTTagsArray()
        //Passthrough of all Books
        for eachBook in books {
            let bookTags = eachBook.tags.componentsSeparatedByString(", ")
            libraryTags = libraryTags + bookTags
            // change fav status with favArray values
            if favoritesArray.contains(eachBook.title){
                eachBook.favorite = true
            }
        }
        // Cleaning duplicates and sorted alphabetically
        libraryCleanandSortedTags = libraryTags.removeDuplicates().sort()
        
    }
    
    //MARK: - Computed Properties
    var tagCount : Int {
        get{
            //Indica cuantos tags hay
            return libraryCleanandSortedTags.count
        }
    }
    
    var booksCount: Int{
        get{
            let count: Int = self.books.count
            return count
        }
    }
    
    //MARK: - Instance functions
    
    func tag(atIndex indexTag: Int) -> String?{
        guard indexTag < libraryCleanandSortedTags.count && indexTag>=0 else{
            return nil
        }
        return libraryCleanandSortedTags[indexTag]
    }
    
    func bookCount(forTag tag: String) -> Int{
        // cuantos libros por tag, si no existe devuelve 0
        var counter : Int = 0
        for eachBook in books {
            let tagsInArray = eachBook.tags.componentsSeparatedByString(", ")
            if tagsInArray.contains(tag) {
                counter += 1
            }
        }
        
        return counter
    }
    
    func books(forTag tag: String) -> AGTBooksArray?{
        //devuelve array de libros en tag
        var booksForTag = AGTBooksArray()
        for eachBook in books {
            let tagsInArray = eachBook.tags.componentsSeparatedByString(", ")
            
            if tagsInArray.contains(tag) {
                booksForTag.append(eachBook)
                //falta ordenar
                booksForTag = booksForTag.sort { $0.0.title.lowercaseString < $0.1.title.lowercaseString }
            }
        }
        return booksForTag
    }
    
    func book(atIndex index: Int, forTag tag: String) -> AGTBook?{
        guard let collection = self.books(forTag: tag) else{
            return nil
        }
        guard index < collection.count && index >= 0 else {
            return nil
        }
        // el libro en el index en el tag
        return collection[index]
    }

    func book(forTitle title: String) -> AGTBook? {
        let coincidence = books.filter { $0.title == title }
        return coincidence[0]
    }
    
}
