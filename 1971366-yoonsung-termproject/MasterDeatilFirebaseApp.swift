//
//  MasterDeatilFirebaseApp.swift
//  1971366-yoonsung-termproject
//
//  Created by test on 6/2/25.
//

import UIKit

@main
struct MasterDetailFirebaseApp: App {
    init(){
        // firebase 연결
        FirebaseApp.configure()
        
        // firestore에 저장
        Firestore.firestore().collection("test").document("name").setData(["name": "Jae Moon Kim"])

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
            ContentView()
        }
    }
}
