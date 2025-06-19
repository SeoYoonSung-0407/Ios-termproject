//
//  ProfileView.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/18/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var doseStore: DoseStore

    @State private var showModify = false
    @State private var selectedMed: Dose?
    @State private var showDetail = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 15/255, green: 22/255, blue: 34/255).ignoresSafeArea()

                VStack(spacing: 20) {
                    // 프로필 이미지
                    if let image = userProfile.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 100)
                            .overlay(Text("이미지").foregroundColor(.white))
                    }

                    // 이름
                    Text("사용자 이름")
                        .font(.title3)
                        .foregroundColor(.white)

                    // 약 리스트
                    List {
                        ForEach(doseStore.doses) { dose in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(dose.name)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    Text(timeString(from: dose.time))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Button("설정") {
                                    selectedMed = dose
                                    showModify = true
                                }
                                .foregroundColor(.blue)
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding()
                            .background(Color(red: 28/255, green: 36/255, blue: 50/255)) // ✅ 카드 배경 통일
                            .cornerRadius(12)
                            .listRowSeparator(.hidden) // ✅ 구분선 제거
                            .listRowBackground(Color.clear) // ✅ 리스트 자체 배경 제거
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(height: 300)

                }
                .padding()

                // DetailView로 이동
                NavigationLink(
                    destination: Group {
                        if let med = selectedMed {
                            DetailView(name: med.name, cycle: med.cycle, time: med.time) { newName, newCycle, newTime in
                                doseStore.update(dose: med, name: newName, cycle: newCycle, time: newTime)
                            }
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $showDetail
                ) {
                    EmptyView()
                }
            }
        }
        .sheet(isPresented: $showModify) {
            if let med = selectedMed {
                ModifyView(
                    medicationName: med.name,
                    onEdit: {
                        showModify = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showDetail = true
                        }
                    },
                    onDelete: {
                        doseStore.delete(dose: med)
                        showModify = false
                    },
                    isPresented: $showModify
                )
            }
        }
    }

    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserProfileModel())
        .environmentObject(DoseStore())
}
