//
//  RestService.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 27/08/23.
//

import Foundation

class RestService {
    static var sharedInstance = RestService()
    
    func getPhotosList() async throws -> [ProfileDetails] {
        return try await RestClient.sharedInstance.sendRequest(request: GetProfileListRequest(), type: [ProfileDetails].self)
    }
}

