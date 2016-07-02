//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Charles Moncada on 27/06/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // crear instancia de modelo
        do{
            let json  = try loadFromLocalFile(fileName: "books_readable.json")//de ahi vemos como lo grabamos en disco
            //print(json)
            
            var books = [AGTBook]()
            for dict in json{
                do{
                    let book = try decode(agtBook: dict)
                    //print(book)
                    books.append(book)
                }catch{
                    print("Error al procesar \(dict)")
                }
            }
            
            let model = AGTLibrary(arrayOfBooks: books)

        
//            let model1: AGTBook = AGTBook.init(title: "Pro Git",
//                                              authors: "Scott Chacon, Ben Straub",
//                                              tags: "version control, git",
//                                              image_url: NSURL(string: "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg")!,
//                                              pdf_url: NSURL(string: "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf")!)
        
                    
            // Create a window
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            // Creation of View Controller
            let lVC = AGTLibraryTableViewController(model: model)
            // Put the VC inside a NavigationController
            let nav = UINavigationController(rootViewController: lVC)
            // make the NavigationController as rootViewController
            window?.rootViewController = nav
            // Make the windows visible & key
            window!.makeKeyAndVisible()
        
            return true
            
        }catch{
            fatalError("Error while loading JSON")
        }

    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}