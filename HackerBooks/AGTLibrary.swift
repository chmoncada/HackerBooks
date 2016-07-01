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
    typealias AGTBooksDictionary    =   [String : AGTBooksArray]

    //MARK: - Properties
    //Books Array
    var books: AGTBooksArray
    //var dict : AGTBooksDictionary
    
    //Tags array
    var libraryCleanandSortedTags: AGTTagsArray = []
    
    init(arrayOfBooks : AGTBooksArray) {
        
        books = arrayOfBooks
        //Creation of tags array
        var libraryTags = AGTTagsArray()
        //Passthrough of all Books
        for eachBook in books {
            let bookTags = eachBook.tags.componentsSeparatedByString(", ")
            libraryTags = libraryTags + bookTags
        }
        // Cleaning duplicates and sorted alphabetically
        libraryCleanandSortedTags = libraryTags.removeDuplicates().sort()
        //print(libraryCleanandSortedTags)
        // PRUEBA DE FUNCION print("HOLA",bookCount(forTag: "asgit"))
        //print(tagCount)
        //print(booksCount)
//        print( books(forTag: "git" )!)
//        print(book(atIndex: 0, forTag: "git"))
//        print(book(atIndex: 1, forTag: "git"))
//        print(book(atIndex: 2, forTag: "git"))
//        print(book(atIndex: -2, forTag: "git"))
//        print(book(atIndex: 2, forTag: "asdgit"))
    }
    
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
    
    func bookCount(forTag tag: String) -> Int{
        // cuantos libros por tag, si no existe devuelve 0
        var counter : Int = 0
        // tal vez deberia convertir cada tag string en un array de strings
        for eachBook in books {
            let tagsInArray = eachBook.tags.componentsSeparatedByString(", ")
            if tagsInArray.contains(tag) {
                //print("encontre en", eachBook)
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
                //print("Añadido al arreglo")
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

    
    
}
