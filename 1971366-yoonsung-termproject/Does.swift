//
//  Does.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/18/25.
//

// Dose.swift
import Foundation

struct Dose: Identifiable {
    let id = UUID()
    let time: String
    let name: String
    var taken: Bool
}
