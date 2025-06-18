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
    @AppStorage("username") private var username: String = ""
    @State private var medications = ["이나야", "아포톡신", "페니실린"]
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        ZStack {
            Color(red: 15/255, green: 22/255, blue: 34/255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // 프로필 이미지
                PhotosPicker(selection: $selectedItem, matching: .images) {
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
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            userProfile.profileImage = uiImage
                        }
                    }
                }

                // 이름 입력 필드
                TextField("이름을 입력하세요", text: $username)
                    .font(.title3)
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                // 복용 약 리스트
                List {
                    ForEach(medications, id: \.self) { med in
                        HStack {
                            Text(med)
                            Spacer()
                            Button("설정") {
                                // ModifyView 나중에 호출
                            }
                        }
                    }
                }
                .frame(height: 200)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .padding()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserProfileModel())
}
