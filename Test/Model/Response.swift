//
//  Response.swift
//  Test
//
//  Created by Deepak on 29/06/23.
//

import Foundation

// MARK: - Response
class Response: Codable {
    let facilities: [Facility]
    let exclusions: [[Exclusion]]

    init(facilities: [Facility], exclusions: [[Exclusion]]) {
        self.facilities = facilities
        self.exclusions = exclusions
    }
}

// MARK: - Exclusion
class Exclusion: Codable {
    let facilityID, optionsID: String

    enum CodingKeys: String, CodingKey {
        case facilityID = "facility_id"
        case optionsID = "options_id"
    }

    init(facilityID: String, optionsID: String) {
        self.facilityID = facilityID
        self.optionsID = optionsID
    }
}

// MARK: - Facility
class Facility: Codable {
    let facilityID, name: String
    let options: [Option]

    enum CodingKeys: String, CodingKey {
        case facilityID = "facility_id"
        case name, options
    }

    init(facilityID: String, name: String, options: [Option]) {
        self.facilityID = facilityID
        self.name = name
        self.options = options
    }
}

// MARK: - Option
class Option: Codable {
    let name, icon, id: String

    init(name: String, icon: String, id: String) {
        self.name = name
        self.icon = icon
        self.id = id
    }
}
