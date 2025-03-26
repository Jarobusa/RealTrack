//
//  Formatters.swift
//  RealTrack
//
//  Created by Robert Williams on 3/24/25.
//

func formatPhone(_ text: String) -> String {
    let digits = text.filter { $0.isNumber }.prefix(10)
    var result = ""

    let area = digits.prefix(3)
    let middle = digits.dropFirst(3).prefix(3)
    let last = digits.dropFirst(6)

    if !area.isEmpty { result += "(\(area))" }
    if !middle.isEmpty { result += middle }
    if !last.isEmpty { result += "-\(last.prefix(4))" }

    return result
}

func formatSSN(_ text: String) -> String {
    let digits = text.filter { $0.isNumber }
    var result = ""

    let part1 = digits.prefix(3)
    let part2 = digits.dropFirst(3).prefix(2)
    let part3 = digits.dropFirst(5).prefix(4)

    if !part1.isEmpty { result += "\(part1)" }
    if !part2.isEmpty { result += "-\(part2)" }
    if !part3.isEmpty { result += "-\(part3)" }

    return result
}

func formatEIN(_ text: String) -> String {
    let digits = text.filter { $0.isNumber }
    guard digits.count <= 9 else { return text }
    let part1 = digits.prefix(2)
    let part2 = digits.dropFirst(2)

    var result = ""
    if !part1.isEmpty { result += "\(part1)" }
    if !part2.isEmpty { result += "-\(part2)" }

    return result
}
