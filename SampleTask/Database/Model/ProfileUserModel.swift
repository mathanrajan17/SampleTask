//
//  ProfileUserModel.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 28/08/23.
//

import Foundation
import CoreData

public class ProfileUser: NSManagedObject {
    @NSManaged var profileId: String
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var mobile: String
}
