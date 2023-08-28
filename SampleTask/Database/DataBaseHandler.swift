//
//  DataBaseHandler.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 27/08/23.
//

import Foundation
import CoreData
import UIKit

class DatabaseHandler {
    var viewContext: NSManagedObjectContext!
    static let instance = DatabaseHandler()
    
    init() {
        viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func add<T: NSManagedObject>(type: T.Type) -> T? {
        guard let entityName = T.entity().name else { return nil }
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext) else { return nil }
        let object = T(entity: entity, insertInto: viewContext)
        return object
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func fetch<T: NSManagedObject>(type: T.Type) -> [T] {
        let request = T.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result as! [T]
        } catch {
            print(error)
        }
        return []
    }
    
    func updateUserDetails(details: ProfileUser) {
        let request = ProfileUser.fetchRequest()
        request.predicate = NSPredicate(format: "profileId = %@", details.profileId)
        do {
            let results = try viewContext.fetch(request)
            if results.count > 0 {
                let user: ProfileUser!
                user = results.first as! ProfileUser
                user.mobile = details.mobile
                user.email = details.email
                user.name = details.name
                save()
            }
        } catch {
            print(error)
        }
    }
    
    
}
