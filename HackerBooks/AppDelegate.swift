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
        //do{

            var books1 = [AGTBook]()
            let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let writePath = documents.stringByAppendingString("/books_readable.json")
            print(writePath)
            let firstLaunch = !NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
            let fileExist = NSFileManager.defaultManager().fileExistsAtPath(writePath)
            print("first launch = ",firstLaunch)
            print("file exists = ", fileExist)
            if firstLaunch {
                // Check case if the url is wrong!
                if let url = NSURL(string: "https://t.co/K9ziV0z3SJ"),
                    data = NSData(contentsOfURL: url),
                    maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers) as? JSONArray,
                    array = maybeArray {
                    
                    
                    let writePath1 = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent("/books_readable.json")
                    data.writeToURL(writePath1, atomically: false)
                    //saveData(data)
                    // books JSON parsing and put it in an Array
                    for dict in array{
                        do{
                            let book = try decode(agtBook: dict)
                            //print(book)
                            books1.append(book)
                        }catch{
                            print("Error al procesar \(dict)")
                        }
                    }
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstLaunch")
                    }
            } else if fileExist {
                //result = try loadJSONLocally()
            }else{
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstLaunch")
            }
            //print(books1)
            
//            let json  = try loadFromLocalFile(fileName: "books_readable.json")//de ahi vemos como lo grabamos en disco
//            //print(json)
//            
//            var books = [AGTBook]()
//            // books JSON parsing and put it in an Array
//            for dict in json{
//                do{
//                    let book = try decode(agtBook: dict)
//                    //print(book)
//                    books.append(book)
//                }catch{
//                    print("Error al procesar \(dict)")
//                }
//            }
//            print(books)
            
            // Model Creation
            let model = AGTLibrary(arrayOfBooks: books1)

            // Create a window
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            // Creation of libraryVC
            let lVC = AGTLibraryTableViewController(model: model)
            // Put the libraryVC inside a NavigationController
            let lNav = UINavigationController(rootViewController: lVC)
            lNav.navigationBar.topItem?.title = "HackerBooks"
            // Creation of BookVC
            let bVC = AGTBookViewController(model: model.book(atIndex: 0, forTag: model.tag(atIndex: 0)!)!)
            // Put the BookVC inside Navigation Controller
            let bNav = UINavigationController(rootViewController: bVC)
            //Creation of SplitView and put the 2 VCs
            let splitVC = UISplitViewController()
            splitVC.viewControllers = [lNav, bNav]
            // make the NavigationController as rootViewController
            window?.rootViewController = splitVC
            // Designate the delegates
            lVC.delegate = bVC
            // Make the windows visible & key
            window!.makeKeyAndVisible()
        
            return true
            
//        }catch{
//            fatalError("Error while loading JSON")
//        }

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