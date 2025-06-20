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

    @State private var isEditingName = false
    @FocusState private var isNameFocused: Bool
    @State private var tempName = ""

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var offsetY: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 15/255, green: 22/255, blue: 34/255)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isNameFocused = false
                    }

                VStack(spacing: 20) {
                    // 프로필 이미지
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
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
                    }
                    .onChange(of: selectedPhoto) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                userProfile.profileImage = uiImage
                            }
                        }
                    }

                    // 이름
                    HStack {
                        if isEditingName {
                            TextField("이름 입력", text: $tempName)
                                .foregroundColor(.black)
                                .focused($isNameFocused)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                        } else {
                            Text(userProfile.name)
                                .font(.title3)
                                .foregroundColor(.white)
                        }

                        Button(isEditingName ? "저장" : "수정") {
                            if isEditingName {
                                userProfile.name = tempName
                                isNameFocused = false
                            } else {
                                tempName = userProfile.name
                                isNameFocused = true
                            }
                            isEditingName.toggle()
                        }
                        .foregroundColor(.blue)
                    }

                    // 약 리스트
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(doseStore.doses) { dose in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(dose.name)
                                            .foregroundColor(.white)
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
                                .background(Color(red: 28/255, green: 36/255, blue: 50/255))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()

                // NavigationLink for 수정
                NavigationLink(
                    destination: Group {
                        if let med = selectedMed {
                            DetailView(name: med.name,
                                       cycle: med.cycle ?? 1,
                                       time: med.time ?? Date()) { newName, newCycle, newTime in
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

                // ModifyView overlay
                if showModify {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showModify = false
                            }
                        }

                    ModifyView(
                        medicationName: selectedMed?.name ?? "",
                        onEdit: {
                            showModify = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showDetail = true
                            }
                        },
                        onDelete: {
                            if let med = selectedMed {
                                doseStore.delete(dose: med)
                            }
                            showModify = false
                        },
                        isPresented: $showModify
                    )
                    .transition(.move(edge: .bottom))
                }
            }
        }
    }

    func timeString(from date: Date?) -> String {
        guard let date = date else { return "시간 없음" }
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
