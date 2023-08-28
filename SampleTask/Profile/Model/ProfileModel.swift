//
//  ProfileModel.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 27/08/23.
//

import Foundation
import CoreData

struct ProfileDetails : Codable {
    var profileId : String?
    var name : String?
    var email : String?
    var mobile : String?
    
    enum CodingKeys: String, CodingKey {
        case profileId = "_id"
        case name = "name"
        case email = "email"
        case mobile = "mobile"
    }
    
    static var database = DatabaseHandler()
    
    func add() -> ProfileUser? {
        guard let user = ProfileDetails.database.add(type: ProfileUser.self) else { return nil }
        user.name = name ?? ""
        user.profileId = profileId ?? ""
        user.email = email ?? ""
        user.mobile = mobile ?? ""
        ProfileDetails.database.save()
        return user
    }
}


