//
//  Validators.swift
//  RealTrack
//
//  Created by Robert Williams on 3/28/25.
//

public func isValidEmail(_ email: String) -> Bool {
    let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return email.range(of: regex, options: .regularExpression) != nil
}
