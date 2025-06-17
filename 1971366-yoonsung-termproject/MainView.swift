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
        calendar.appearance.weekdayTextColor = .lightGray
        calendar.appearance.selectionColor = .systemBlue
        calendar.appearance.todayColor = .systemRed
        calendar.appearance.titleTodayColor = .white
        

        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.select(selectedDate)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: MainView

        init(_ parent: MainView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
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
                    Text("오늘")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Text(formattedDate(selectedDate))
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

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEEE, M월 d일"
        return formatter.string(from: date)
    }
}

#Preview {
    MainViewWrapper()
}
