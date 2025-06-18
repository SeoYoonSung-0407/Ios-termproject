import SwiftUI
import FSCalendar

// FSCalendar 기반 주간 달력 뷰
struct MainView: UIViewRepresentable {
    @Binding var selectedDate: Date

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
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance
 {
        var parent: MainView

        init(_ parent: MainView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            let today = Calendar.current.startOfDay(for: Date())
            let current = Calendar.current.startOfDay(for: date)

            if current == today {
                return .white
            } else if current < today {
                return UIColor.lightGray
            } else {
                return UIColor.white.withAlphaComponent(0.6)
            }
        }
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
            let today = Calendar.current.startOfDay(for: Date())
            let current = Calendar.current.startOfDay(for: date)

            if current == today {
                return UIColor.systemBlue
            } else if current < today {
                return UIColor.white.withAlphaComponent(0.1)
            } else {
                return UIColor.white.withAlphaComponent(0.05)
            }
        }
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
            return UIColor.red
        }




    }
}

struct MainViewWrapper: View {
    @State private var selectedDate = Date()

    var body: some View {
        ZStack {
            Color(red: 15/255, green: 22/255, blue: 34/255)
                .ignoresSafeArea()

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

                // 달력 (주간)
                MainView(selectedDate: $selectedDate)
                    .frame(height: 200)
                    .padding(.horizontal)

                // 약 알림 카드
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 28/255, green: 36/255, blue: 50/255))
                    .frame(height: 150)
                    .overlay(
                        Text("등록된 약이 없습니다")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    )
                    .padding(.horizontal)

                Spacer()

                // 하단 탭
                HStack {
                    Spacer()
                    Image(systemName: "pills.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "bird.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(5)
                        .background(Color(red: 38/255, green: 46/255, blue: 66/255))
                        .clipShape(Circle())
                    Spacer()
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom, 20)
            }
        }
    }

    // "오늘", "어제", "내일" 또는 요일
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
            formatter.dateFormat = "EEEE" // 요일
            return formatter.string(from: date)
        }
    }

    // "수요일, 6월 18일" 또는 "6월 21일"
    func dateSubTitle(for date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selected = calendar.startOfDay(for: date)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        if selected == today || selected == calendar.date(byAdding: .day, value: -1, to: today) || selected == calendar.date(byAdding: .day, value: 1, to: today) {
            formatter.dateFormat = "EEEE, M월 d일"
        } else {
            formatter.dateFormat = "M월 d일"
        }

        return formatter.string(from: date)
    }


}

#Preview {
    MainViewWrapper()
}
