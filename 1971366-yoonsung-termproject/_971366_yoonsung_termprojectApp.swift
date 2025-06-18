//
//  _971366_yoonsung_termprojectApp.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 5/26/25.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

@main
struct _971366_yoonsung_termprojectApp: App {
    init(){
// firebase 연결
            FirebaseApp.configure()
 
// firestore에 저장
    Firestore.firestore().collection("test").document("name").setData(["name": "YOONSUNG"])

// storage에 이미지 저장
        let image = UIImage(named: "Seoul")!
        let imageData = image.jpegData(compressionQuality: 1.0)
        let reference = Storage.storage().reference().child("test").child("Hansung")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        reference.putData(imageData!, metadata: metaData) { _ in }
    }

    var body: some Scene {
        WindowGroup {
            MasterView()
        }
    }
}
