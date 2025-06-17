//
//  AddingView.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 5/26/25.
//

import SwiftUI

struct AddingView: View {
    @Binding var show: Bool
    @State private var offsetY: CGFloat = 0

    var body: some View {
        VStack {
            Capsule()
                .fill(Color.gray)
                .frame(width: 40, height: 6)
                .padding(.top, 8)

            Text("무엇을 도와드릴까요?")
                .font(.headline)
                .padding()

            Button("💊 약 추가할게요") { /* 액션 */ }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)

            Button("💊 필요할 때 투여") { /* 액션 */ }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(red: 28/255, green: 36/255, blue: 50/255))
        .cornerRadius(30)
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
    }
}

#Preview {
    @State var show = true
    return AddingView(show: $show)
}
