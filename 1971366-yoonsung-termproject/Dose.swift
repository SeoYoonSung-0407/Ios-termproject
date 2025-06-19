//
//  Dose.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/18/25.
//

import Foundation

struct Dose: Identifiable, Hashable {
    let id: UUID
    var time: Date
    var name: String
    var cycle: Int
    var startDate: Date

    init(id: UUID = UUID(), time: Date, name: String, cycle: Int, startDate: Date) {
        self.id = id
        self.time = time
        self.name = name
        self.cycle = cycle
        self.startDate = startDate
    }
}
