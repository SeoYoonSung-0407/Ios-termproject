//
//  AddingView.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 5/26/25.
//

import SwiftUI

struct AddingView: View {
    @EnvironmentObject var doseStore: DoseStore
    
    @Binding var show: Bool
    @Binding var navigateToDetail: Bool
    @Binding var medName: String
    @Binding var medCycle: Int
    @Binding var medTime: Date
    @State private var offsetY: CGFloat = 0

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.gray)
                .frame(width: 40, height: 6)
                .padding(.top, 8)

            Text("무엇을 도와드릴까요?")
                .font(.headline)
                .foregroundColor(.white)

            Button(action: {
                show = false
                navigateToDetail = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("약 추가할게요")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(16)
                .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color(red: 28/255, green: 70/255, blue: 50/255))
        .cornerRadius(20)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .offset(y: offsetY)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        offsetY = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height > 100 {
                        withAnimation {
                            show = false
                        }
                    }
                    offsetY = 0
                }
        )
        .transition(.move(edge: .bottom))
        .animation(.easeInOut, value: offsetY)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 100)
    }
}

#Preview {
    @State var show = true
    @State var nav = false
    @State var name = "타이레놀"
    @State var cycle = 2
    @State var time = Date()

    return AddingView(show: $show, navigateToDetail: $nav, medName: $name, medCycle: $cycle, medTime: $time)
        .environmentObject(DoseStore())
}
