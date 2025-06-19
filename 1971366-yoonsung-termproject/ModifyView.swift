//
//  ModifyView.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/19/25.
//

import SwiftUI

struct ModifyView: View {
    var medicationName: String
    var onEdit: () -> Void
    var onDelete: () -> Void
    @Binding var isPresented: Bool

    @State private var offsetY: CGFloat = 0

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.gray)
                .frame(width: 40, height: 6)
                .padding(.top, 8)

            Image(systemName: "pills.fill")
                .font(.largeTitle)
                .foregroundColor(.white)

            Text(medicationName)
                .font(.title2)
                .foregroundColor(.white)

            Text("매일 알림을 받습니다")
                .foregroundColor(.gray)

            Button(action: {
                withAnimation {
                    isPresented = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onEdit()
                }
            }) {
                Label("수정할게요", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }

            Button(action: {
                withAnimation {
                    isPresented = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onDelete()
                }
            }) {
                Label("삭제할게요", systemImage: "trash")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
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
                            isPresented = false
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
    @State var isPresented = true
    return ModifyView(
        medicationName: "이나야",
        onEdit: {},
        onDelete: {},
        isPresented: $isPresented
    )
}
