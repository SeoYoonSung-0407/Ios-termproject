//
//  MasterView.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 5/26/25.
//

import SwiftUI

struct MasterView: View {
    @EnvironmentObject var userProfile: UserProfileModel
    @State private var selectedTab = 0
    @State private var showAddView = false
    @State private var selectedDate = Date() // ✅ 오늘 날짜 상태 추가

    var body: some View {
        ZStack {
            // 메인 콘텐츠
            switch selectedTab {
            case 0:
                MainViewWrapper(/*selectedDate: $selectedDate*/)
            case 1:
                ProfileView()
            default:
                MainView(selectedDate: $selectedDate)
            }

            // 약 추가 오버레이
            if showAddView {
                AddingView(show: $showAddView)
                    .transition(.move(edge: .bottom))
            }

            // 하단 탭바
            VStack {
                Spacer()
                HStack {
                    Button {
                        selectedTab = 0
                    } label: {
                        Image(systemName: "pills.fill")
                    }

                    Spacer()

                    Button {
                        withAnimation {
                            showAddView = true
                        }
                    } label: {
//                        Image(systemName: "bird.fill")
//                            .resizable()
//                            .frame(width: 60, height: 60)
                        Image(uiImage: userProfile.profileImage ?? UIImage(systemName: "bird.fill")!)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .padding(5)
                                    .background(Color(red: 38/255, green: 46/255, blue: 66/255))
                                    .clipShape(Circle())
                    }

                    Spacer()

                    Button {
                        selectedTab = 1
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                }
                .padding()
                .background(Color.black)
            }
        }
    }
}

#Preview {
    MasterView().environmentObject(UserProfileModel())
}
