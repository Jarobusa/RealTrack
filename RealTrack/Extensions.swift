//
//  Extenions.swift
//  RealTrack
//
//  Created by Robert Williams on 3/24/25.
//

// MARK: Format phone number

extension String {
    var formattedAsPhone: String {
        let digits = self.filter { $0.isNumber }
        guard digits.count == 10 else { return self }  // Fallback if not 10 digits

        let area = digits.prefix(3)
        let middle = digits.dropFirst(3).prefix(3)
        let last = digits.suffix(4)

        return "(\(area))\(middle)-\(last)"
    }
}

// MARK: Matches by regex

extension String {
    func matches(_ regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
}
