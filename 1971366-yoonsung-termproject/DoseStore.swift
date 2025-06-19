//
//  DoseStore.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/19/25.
//

import Foundation

class DoseStore: ObservableObject {
    @Published var doses: [Dose] = []

    /// 특정 날짜에 복용할 약 리스트 반환
    func doses(for date: Date) -> [Dose] {
        let calendar = Calendar.current
        return doses.filter { dose in
            // 주기 계산: 시작일부터 해당 날짜까지 일 수 차이
            let startDay = calendar.startOfDay(for: dose.startDate)
            let targetDay = calendar.startOfDay(for: date)
            guard let diff = calendar.dateComponents([.day], from: startDay, to: targetDay).day else {
                return false
            }
            return diff >= 0 && diff % dose.cycle == 0
        }
    }

    /// 해당 날짜에 복용할 약이 하나라도 있는지
    func hasDose(on date: Date) -> Bool {
        return !doses(for: date).isEmpty
    }

    /// 테스트용 더미 데이터 추가
    func addSample() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        doses.append(Dose(
            time: formatter.date(from: "2025-06-20 08:00")!, name: "이너세틴D",
            cycle: 2,
            startDate: formatter.date(from: "2025-06-19 06:00")!
        ))
    }
    func addDose(name: String, cycle: Int, time: Date, startDate: Date) {
        let newDose = Dose(time: time, name: name, cycle: cycle, startDate: startDate)
        doses.append(newDose)
    }
    func delete(dose: Dose) {
            if let index = doses.firstIndex(of: dose) {
                doses.remove(at: index)
            }
        }
    func update(dose: Dose, name: String, cycle: Int, time: Date) {
        if let index = doses.firstIndex(where: { $0.id == dose.id }) {
            let updatedDose = Dose(
                id: dose.id,
                time: time,
                name: name,
                cycle: cycle,
                startDate: dose.startDate
            )
            doses[index] = updatedDose
        }
    }


}
