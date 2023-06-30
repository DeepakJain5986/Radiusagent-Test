//
//  ApiService.swift
//  Test
//
//  Created by Deepak on 29/06/23.
//

import Foundation

class ApiService {
    func getData(completion: @escaping (Bool, Response?, String?) -> ()) {
        
        HttpRequestHelper().GET(url: "https://my-json-server.typicode.com/iranjith4/ad-assignment/db") { success, data in
            if success {
                do {
                    
                    let response = try? JSONDecoder().decode(Response.self, from: data!)
                    completion(true, response, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Products to model")
                }
            } else {
                completion(false, nil, "Error: Products GET Request failed")
            }
        }
    }
    
}
