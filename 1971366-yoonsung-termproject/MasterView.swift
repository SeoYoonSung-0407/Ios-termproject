//
//  MasterView.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 5/26/25.
//

import SwiftUI

struct MasterView: View {
    @EnvironmentObject var userProfile: UserProfileModel
    @StateObject var doseStore = DoseStore()

    @State private var selectedTab = 0
    @State private var showAddView = false
    @State private var navigateToDetail = false

    // DetailView로 넘길 값
    @State private var newMedName = ""
    @State private var newMedCycle = 1
    @State private var newMedTime = Date()

    var body: some View {
        NavigationStack {
            ZStack {
                // 메인 콘텐츠
                switch selectedTab {
                case 0:
                    MainViewWrapper()
                case 1:
                    ProfileView()
                default:
                    MainViewWrapper()
                }

                // AddingView가 띄워졌을 때 바깥 터치 감지
                if showAddView {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showAddView = false
                            }
                        }

                    AddingView(
                        show: $showAddView,
                        navigateToDetail: $navigateToDetail,
                        medName: $newMedName,
                        medCycle: $newMedCycle,
                        medTime: $newMedTime
                    )
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
                                .font(.title2)
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Button {
                            withAnimation {
                                showAddView = true
                            }
                        } label: {
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
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.black)
                }

                // NavigationLink: DetailView로 이동
                NavigationLink(
                    destination: DetailView(
                        name: newMedName,
                        cycle: newMedCycle,
                        time: newMedTime
                    ) { name, cycle, time in
                        let today = Date()
                        doseStore.addDose(name: name, cycle: cycle, time: time, startDate: today)
                    },
                    isActive: $navigateToDetail
                ) {
                    EmptyView()
                }
            }
        }
        .environmentObject(doseStore)
    }
}

#Preview {
    MasterView()
        .environmentObject(UserProfileModel())
}
