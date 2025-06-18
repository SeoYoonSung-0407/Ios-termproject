//
//  ProfileView.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/18/25.
//

import SwiftUI
import ImagePickerView

struct ProfileView: View {
    @State private var profileImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var medications = ["이나야", "아포톡신", "페니실린"]

    var body: some View {
        ZStack {
            Color(red: 15/255, green: 22/255, blue: 34/255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // 프로필 이미지
                Button(action: {
                    showImagePicker = true
                }) {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 100)
                            .overlay(Text("이미지"))
                    }
                }

                // 이름 or 이동 버튼
                Text("사용자 이름")
                    .font(.title3)
                    .foregroundColor(.white)

                // 약 리스트
                List {
                    ForEach(medications, id: \.self) { med in
                        HStack {
                            Text(med)
                            Spacer()
                            Button("수정") {
                                // 수정 기능
                            }
                            Button("삭제") {
                                medications.removeAll { $0 == med }
                            }
                        }
                    }
                }
                .frame(height: 200) // 높이 제한 (선택)
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.profileImage = image
            }
        }

        
    }
}



#Preview {
    ProfileView()
}
