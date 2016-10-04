//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Alicia Daza on 03/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit
import CoreData

let dataAlreadyLoaded = "dataIsAlreadyLoaded2"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let model = CoreDataStack(modelName: "Model")!


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Create window
        window = UIWindow(frame: UIScreen.main.bounds)

        // Get json data
        do {
            
            if !isDataLoaded(){
                
                
                // Get JSON
                let json = try getJSON(remoteUrl: "https://t.co/K9ziV0z3SJ")


                for dict in json {
                    do {
                        try decode(jsonDict: dict,
                                          context: model.context)

                    } catch {
                        print("Error processing \(dict)")
                    }
                }
                
                model.save()
                    
                // Set loaded in user defaults
                let defaults = UserDefaults.standard
                defaults.set(Bool(true), forKey: dataAlreadyLoaded)
                
            }

            // Create model
            //let model = AGTLibrary(withBooks: books)
            
            // Create fetchRequest
          /*
            let fr = NSFetchRequest<Book>(entityName: Book.entityName)
            fr.fetchBatchSize = 50 // de 50 en 50
            
            fr.sortDescriptors = [NSSortDescriptor(key: "title",
                                                   ascending: false)]
            
            // Create fetchedResultsCtrl
            let frc = NSFetchedResultsController(fetchRequest: fr,
                                                managedObjectContext: model.context,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
            */
            ////
            
            let fr2 = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
            let primarySortDescriptor = NSSortDescriptor(key: "tag.name", ascending: true)
            let secondarySortDescriptor = NSSortDescriptor(key: "book.title", ascending: true)
            fr2.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
           // fr2.sortDescriptors = [primarySortDescriptor]
            
            let frc2 = NSFetchedResultsController(
                fetchRequest: fr2,
                managedObjectContext: model.context,
                sectionNameKeyPath: "tag.name",
                cacheName: nil)
 
      

            // Create VC
            let lVC = LibraryTableViewController(fetchedResultsController: frc2 as! NSFetchedResultsController<NSFetchRequestResult>,
                                                 style: .plain)

            // Put in nav
            let lNav = UINavigationController(rootViewController: lVC)

            // Create book VC
            //let bookVC = BookViewController(model: model.book(atIndex: 0, forTag: model.tags[0]))
            
            let indx = IndexPath(row: 0, section: 0)

            let aux = frc2.object(at: indx) 
            let book = aux.book!
            let bookVC = BookViewController(model: book)

            // Put in another navigation
            let bookNav = UINavigationController(rootViewController: bookVC)

            // Create split view with two navs
            let splitVC = UISplitViewController()
            splitVC.viewControllers = [lNav, bookNav]

            // Assign nav as rootVC
            window?.rootViewController = splitVC

            // Make book vc delegate of library vc ???
            //lVC.delegate = bookVC

            // Make visible & key to window
            window?.makeKeyAndVisible()
            
            model.autoSave(5)

        } catch {
            fatalError("Error while loading json")
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func isDataLoaded()->Bool{
        let defaults = UserDefaults.standard
        
        if let res = defaults.object(forKey: dataAlreadyLoaded) as? Bool{
        
            return res
        
        } else {
            return false
        }
        
    }
    
   


}

