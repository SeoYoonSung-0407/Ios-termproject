//
//  DoseStore.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/19/25.
//

import Foundation
import UserNotifications

class DoseStore: ObservableObject {
    @Published var doses: [Dose] = []

    /// 특정 날짜에 복용할 약 리스트 반환
    func doses(for date: Date) -> [Dose] {
        let calendar = Calendar.current
        return doses.filter { dose in
            guard
                let startDate = dose.startDate,
                let cycle = dose.cycle
            else {
                return false
            }

            let startDay = calendar.startOfDay(for: startDate)
            let targetDay = calendar.startOfDay(for: date)

            guard let diff = calendar.dateComponents([.day], from: startDay, to: targetDay).day else {
                return false
            }

            return diff >= 0 && diff % cycle == 0
        }
    }

    /// 해당 날짜에 복용할 약이 하나라도 있는지
    func hasDose(on date: Date) -> Bool {
        return !doses(for: date).isEmpty
    }

    /// 더미 데이터 (테스트용)
    func addSample() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let sample = Dose(
            name: "이너세틴D",
            time: formatter.date(from: "2025-06-20 08:00"),
            cycle: 2,
            startDate: formatter.date(from: "2025-06-19 06:00")
        )

        doses.append(sample)
        scheduleDoseNotification(for: sample)
    }

    /// 일반 약 추가
    func addDose(name: String, cycle: Int, time: Date, startDate: Date) {
        let newDose = Dose(name: name, time: time, cycle: cycle, startDate: startDate)
        doses.append(newDose)
        scheduleDoseNotification(for: newDose)
    }

    /// 약 삭제
    func delete(dose: Dose) {
        if let index = doses.firstIndex(of: dose) {
            doses.remove(at: index)
            removeNotification(for: dose)
        }
    }

    /// 약 수정
    func update(dose: Dose, name: String, cycle: Int, time: Date) {
        if let index = doses.firstIndex(where: { $0.id == dose.id }) {
            let updatedDose = Dose(
                id: dose.id,
                name: name,
                time: time,
                cycle: cycle,
                startDate: dose.startDate
            )
            doses[index] = updatedDose

            removeNotification(for: dose)
            scheduleDoseNotification(for: updatedDose)
        }
    }

    /// 알림 예약
    func scheduleDoseNotification(for dose: Dose) {
        guard let time = dose.time else { return }

        let content = UNMutableNotificationContent()
        content.title = "약 복용 시간이에요 💊"
        content.body = "\(dose.name) 복용할 시간이에요!"
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: dose.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ 알림 등록 실패: \(error.localizedDescription)")
            } else {
                print("✅ 알림 등록됨: \(dose.name)")
            }
        }
    }

    /// 알림 제거
    func removeNotification(for dose: Dose) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dose.id.uuidString])
        print("🗑️ 알림 제거됨: \(dose.name)")
    }
}
