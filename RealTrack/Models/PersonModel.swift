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
    @Attribute(.unique) var id: UUID  // Unique identifier
    var firstName: String?           // ✅ Required
    var lastName: String?            // Optional
    var mobilePhone: String?         // Optional
    var workPhone: String?           // Optional

    @Attribute(.unique) var ein: String?  // Optional but must be unique if provided
    @Attribute(.unique) var ssn: String?  // Optional but must be unique if provided

    // Link to PersonTypeModel (many-to-one)
    var personType: PersonTypeModel?

    init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String? = nil,
        mobilePhone: String? = nil,
        workPhone: String? = nil,
        ein: String? = nil,
        ssn: String? = nil,
        personType: PersonTypeModel
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.mobilePhone = mobilePhone
        self.workPhone = workPhone
        self.ein = ein
        self.ssn = ssn
        self.personType = personType
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
