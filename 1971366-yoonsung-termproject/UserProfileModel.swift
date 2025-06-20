//
//  UserProfileModel.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/19/25.
//

import SwiftUI

class UserProfileModel: ObservableObject {
    @Published var profileImage: UIImage? = nil
    @Published var name: String = "사용자 이름"
}

