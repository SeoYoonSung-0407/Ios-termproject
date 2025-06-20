//
//  DetailView.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 5/26/25.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss

    @State private var name: String
    @State private var cycle: Int
    @State private var time: Date

    @FocusState private var isNameFocused: Bool

    var onSave: (String, Int, Date) -> Void

    init(name: String, cycle: Int, time: Date, onSave: @escaping (String, Int, Date) -> Void) {
        _name = State(initialValue: name)
        _cycle = State(initialValue: cycle)
        _time = State(initialValue: time)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .onTapGesture {
                        hideKeyboard()
                    }

                Form {
                    Section(header: Text("약 이름")) {
                        TextField("예: 타이레놀", text: $name)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .focused($isNameFocused)
                    }

                    Section(header: Text("복용 주기 (일 단위)")) {
                        Stepper(value: $cycle, in: 1...30) {
                            Text("\(cycle)일마다 복용")
                        }
                    }

                    Section(header: Text("알림 시간")) {
                        DatePicker("시간 선택", selection: $time, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle("약 정보 입력")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        onSave(name, cycle, time)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("취소", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                // 약 이름 입력 필드 자동 포커싱
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isNameFocused = true
                }
            }
        }
    }

    // 키보드 숨김 함수
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    DetailView(name: "타이레놀", cycle: 1, time: Date()) { name, cycle, time in
        print("Saved: \(name), \(cycle), \(time)")
    }
}
