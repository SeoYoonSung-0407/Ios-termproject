import SwiftUI
import FSCalendar

// FSCalendar 기반 주간 달력 뷰
struct MainView: UIViewRepresentable {
    @Binding var selectedDate: Date
    @EnvironmentObject var doseStore: DoseStore

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.scope = .week
        calendar.scrollDirection = .horizontal
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.selectionColor = .systemBlue
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 20)
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 20)
        calendar.appearance.todayColor = .systemRed
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.titleDefaultColor = .white
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.select(selectedDate)
        uiView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: MainView

        init(_ parent: MainView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }

        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            return parent.doseStore.hasDose(on: date) ? 1 : 0
        }
    }
}

struct MainViewWrapper: View {
    @EnvironmentObject var doseStore: DoseStore
    @State private var selectedDate = Date()
    @State private var taken: Set<UUID> = []

    var body: some View {
        ZStack {
            Color(red: 15/255, green: 22/255, blue: 34/255).ignoresSafeArea()

            VStack(spacing: 20) {
                // 상단 날짜
                VStack(alignment: .leading, spacing: 4) {
                    Text(dateTitle(for: selectedDate))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Text(dateSubTitle(for: selectedDate))
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // 달력
                MainView(selectedDate: $selectedDate)
                    .frame(height: 200)
                    .padding(.horizontal)

                // 약 복용 리스트
                if doseStore.doses(for: selectedDate).isEmpty {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 28/255, green: 36/255, blue: 50/255))
                        .frame(height: 150)
                        .overlay(
                            Text("등록된 약이 없습니다")
                                .foregroundColor(.white)
                        )
                        .padding(.horizontal)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(doseStore.doses(for: selectedDate)) { dose in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(timeString(from: dose.time))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(dose.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    Button(action: {
                                        if taken.contains(dose.id) {
                                            taken.remove(dose.id)
                                        } else {
                                            taken.insert(dose.id)
                                        }
                                    }) {
                                        Image(systemName: taken.contains(dose.id) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(taken.contains(dose.id) ? .green : .gray)
                                            .font(.title2)
                                    }
                                }
                                .padding()
                                .background(Color(red: 28/255, green: 36/255, blue: 50/255))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
        }
    }

    func dateTitle(for date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selected = calendar.startOfDay(for: date)

        if selected == today {
            return "오늘"
        } else if selected == calendar.date(byAdding: .day, value: -1, to: today) {
            return "어제"
        } else if selected == calendar.date(byAdding: .day, value: 1, to: today) {
            return "내일"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
    }

    func dateSubTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        let today = Calendar.current.startOfDay(for: Date())

        if Calendar.current.isDate(date, inSameDayAs: today) ||
            Calendar.current.isDate(date, inSameDayAs: Calendar.current.date(byAdding: .day, value: -1, to: today)!) ||
            Calendar.current.isDate(date, inSameDayAs: Calendar.current.date(byAdding: .day, value: 1, to: today)!) {
            formatter.dateFormat = "EEEE, M월 d일"
        } else {
            formatter.dateFormat = "M월 d일"
        }
        return formatter.string(from: date)
    }

    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

#Preview {
    MainViewWrapper()
        .environmentObject(DoseStore())
}
