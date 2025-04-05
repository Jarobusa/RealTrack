//
//  PersonModel.swift
//  RealTrack
//
//  Created by Robert Williams on 3/23/25.
//

import Foundation
import SwiftData

@Model
final class PersonModel {
    @Attribute(.unique) var id: UUID
    var firstName: String?
    var lastName: String?
    var mobilePhone: String?
    var workPhone: String?
    var email: String?
    var timestamp: Date

    @Attribute(.unique) var ein: String?
    @Attribute(.unique) var ssn: String?  
    
    var homeAddress: AddressModel?
    var workAddress: AddressModel?
    var personType: PersonTypeModel?
    
    @Relationship(inverse: \HouseModel.personModel) var houses: [HouseModel] = []
    
    init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String? = nil,
        mobilePhone: String? = nil,
        workPhone: String? = nil,
        email: String? = nil,
        ein: String? = nil,
        ssn: String? = nil,
        personType: PersonTypeModel,
        homeAddress: AddressModel? = nil,
        workAddress: AddressModel? = nil,
        timestamp: Date = .now
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.mobilePhone = mobilePhone
        self.workPhone = workPhone
        self.email = email  
        self.ein = ein
        self.ssn = ssn
        self.personType = personType
        self.homeAddress = homeAddress
        self.workAddress = workAddress
        self.timestamp = timestamp
    }
}

extension PersonModel {
    var isEINValid: Bool {
        guard let ein = ein else { return true }  // Optional is okay
        return ein.matches(#"^\d{2}-\d{7}$"#)
    }

    var isSSNValid: Bool {
        guard let ssn = ssn else { return true }  // Optional is okay
        return ssn.matches(#"^\d{3}-\d{2}-\d{4}$"#)
    }

    var hasValidIdentifiers: Bool {
        return isEINValid && isSSNValid
    }
}
