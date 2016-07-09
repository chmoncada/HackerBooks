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
    let tintColor = UIColor.blackColor()
    let backButtonColor = UIColor(red: 1.0, green: 0.737, blue: 0.173, alpha: 1.00)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // MARK: Maquillaje
        customizeAppearance()
        
        // Creation of model instance
        var books = [AGTBook]()
        var jsonParsed = JSONArray()
        
        // Define some values
        let jsonFileName = "books_readable.json"
        let jsonURLString = "https://t.co/K9ziV0z3SJ"
        
        
        // Check if the app is launched at first time and if the JSON is saved locally
        let firstLaunch = !NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        let fileExist = NSFileManager.defaultManager().fileExistsAtPath(sandboxPath(forFile: jsonFileName))
        
        // Loading conditional remote or locally
        if firstLaunch || !fileExist {
            // Remote loading of JSON and saving in sandbox
            do {
                jsonParsed = try loadJSONFromRemoteFile(atURL: jsonURLString)
            } catch {
                fatalError("Error while loading JSON")
            }
            
            //Change NSUsersDefault key
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")

        } else {
            // Loading locally
            do {
                jsonParsed = try loadJSONLocally()
            } catch{
                fatalError("Error while loading JSON")
            }
        }
        
        // creation of array of AGTBooks
        for dict in jsonParsed{
            do{
                let book = try decode(agtBook: dict)
                //print(book)
                books.append(book)
            }catch{
                print("Error al procesar \(dict)")
            }
        }
        
        // Model Creation
        let model = AGTLibrary(arrayOfBooks: books)
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiom.Phone) {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            // Creation of libraryVC
            let lVC = AGTLibraryTableViewController(model: model)
            // Put the libraryVC inside a NavigationController
            let lNav = UINavigationController(rootViewController: lVC)
            lNav.navigationBar.topItem?.title = "HackerBooks"
            // make the NavigationController as rootViewController
            window?.rootViewController = lNav
            // Designate the delegates
            lVC.delegate = lVC

        } else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiom.Pad){
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

        }
        
        // Make the windows visible & key
        window!.makeKeyAndVisible()
        
        return true
        
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

    //MARK: - Color Customization
    
    private func customizeAppearance() {
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        // Navigation Bar Appearance
        UINavigationBar.appearance().titleTextAttributes=[NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().barTintColor = tintColor
        UINavigationBar.appearance().translucent = false
        // Back Button Appearance
        UINavigationBar.appearance().tintColor = backButtonColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:backButtonColor]
        // UITableViewHeader appearance
        UITableViewHeaderFooterView.appearance().tintColor = tintColor

    }

}