//
//  Dose.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/18/25.
//

import Foundation

struct Dose: Identifiable, Hashable {
    let id: UUID
    var name: String
    var time: Date?
    var cycle: Int?
    var startDate: Date?

    init(id: UUID = UUID(), name: String, time: Date?, cycle: Int?, startDate: Date?) {
        self.id = id
        self.name = name
        self.time = time
        self.cycle = cycle
        self.startDate = startDate
    }
}
